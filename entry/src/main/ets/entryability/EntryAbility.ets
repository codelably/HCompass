import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import common from "@ohos.app.ability.common";
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { getContainer, CoreServiceKeys } from "@core/di";
import { ContextUtil } from '@core/util';
import { IBestUIInitializer } from "@core/ibestui";
import { AxiosHttpClient, NetworkConfig } from "@core/network";
import { getModuleRegistry, destroyModules } from '@core/module';
import { IBestORMInit } from '@core/database';
import { LogInterceptor, AuthInterceptor } from './AppInterceptors';

// 功能包
import { createMainModule } from '@package/main';
import { createAuthModule } from '@package/auth';
import { createUserModule } from '@package/user';
import { createDemoModule } from '@package/demo';

const DOMAIN = 0x0000;

/**
 * @file 入口 Ability
 * @description 负责初始化应用、设置路由、处理生命周期事件
 * @author Joker.X
 */
export default class EntryAbility extends UIAbility {
  /**
   * 应用创建时调用
   * 初始化应用上下文、设置颜色模式、注册路由
   * @param want 启动意图
   * @param launchParam 启动参数
   */
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
      // 初始化框架
      this.InitializerFramework(this.context);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to set colorMode. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  /**
   * 窗口创建时调用
   * 加载入口页面、初始化UI基础样式
   * @param windowStage 窗口阶段
   */
  async onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
    windowStage.loadContent('view/EntryPage', (_) => {
      IBestUIInitializer.initIBestUI(windowStage, this.context);
    });
  }

  /**
   * 应用销毁时调用
   * 释放应用上下文、注销路由
   */
  onDestroy(): void {
    // 销毁所有模块
    try {
      destroyModules();
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', 'Failed to destroy modules. Cause: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  /**
   * 窗口销毁时调用
   * 释放窗口资源
   */
  onWindowStageDestroy(): void {}

  /**
   * 应用进入前台时调用
   * 刷新应用状态、重新注册路由
   */
  onForeground(): void {}

  /**
   * 应用进入后台时调用
   * 暂停应用状态、注销路由
   */
  onBackground(): void {}

  /**
   * 应用被重复拉起时调用
   * 响应三方登录状态
   */
  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {}

  /**
   * 初始化新框架
   * 包括配置、DI 容器、模块注册等
   */
  InitializerFramework(context: common.UIAbilityContext) {
    try {
      // 初始化上下文工具
      ContextUtil.init(context);

      // 初始化数据库
      IBestORMInit(context, { name: "app.db" });

      // 获取 DI 容器
      const container = getContainer();

      // 注入初始化配置
      const NetConf: NetworkConfig = {
        baseUrl: "https://mall.dusksnow.top/app/",
        timeout: 10000,
        responseParser: {
          successCode: 1000,
          dataField: 'data',
          messageField: 'message',
          codeField: 'code'
        },
        headers: {
          'Content-Type': 'application/json'
        },
        enableLog: true
      };
      container.register<NetworkConfig>(CoreServiceKeys.ConfigManager, () => NetConf);

      // 注入 HTTP 客户端
      container.register<AxiosHttpClient>(CoreServiceKeys.HttpClient, () => {
        const client = new AxiosHttpClient(NetConf);
        // 注册拦截器
        client.addInterceptor(new LogInterceptor());
        client.addInterceptor(new AuthInterceptor());
        return client;
      })

      // 获取模块注册器
      const module = getModuleRegistry();

      // 注册模块
      module.register(createMainModule());
      module.register(createAuthModule());
      module.register(createUserModule());
      module.register(createDemoModule());
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', '[Framework] Framework init error: %{public}s', JSON.stringify(err));
    }
  }
}