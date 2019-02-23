## 框架

**MicroKernel**的架构思想至此就阐述完了，架构自然不会限制实现。但从另一个角度讲，**MicroKernel**也可以作为框架来看待和使用。**MicroKernel**提供了Swift语言的实现，并帮助使用者全方位、立体化的理解架构。

### 概念体

概念体是使用框架时直接接触的概念。

- **MicroApplication**：业务概念体。
- **MainApplication**：App架构注册、配置，以及外部渠道对接的概念体。
- **MicroApplicationContext**：管理**MicroApplication**的上下文。
- **MainApplicationContext**：管理**MainApplication**的上下文。
- **Dependency**：依赖概念体。
- **MicroApplicationCoordinator**：业务协调器概念体。
- **MicroApplicationService**：业务服务概念体。
- **MicroKernelService**：基础能力服务概念体。

### 实体

实体是框架背后各种机制的实现。

- **Driver**：内核驱动器，启动**MainApplication**、管理**MicroApplication**。
- **DriverAspect**：驱动切面机制，针对驱动与平台或其他因素的切面编程。比如，**NavigationDriverAspect**提供与页面导航的联动。
- **DependencyContainer**：依赖注入容器，**MainApplication**和每个**MicroApplication**都有自己的容器。
- **EventBus**：事件驱动通信机制。
- **Router**：路由器，规范化、动态化跳转。
- **RouterInterceptor**：路由拦截器，多级拦截跳转。
- **PlatformMainApplication：**App架构注册、配置，以及外部渠道对接的实体。

