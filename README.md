

## 前言

当谈起客户端架构在谈什么？MVC、MVVM、VIPER等是最普遍的架构认知，而这些可以认为是代码架构，而不是一个完整的应用架构。亦或响应式架构、Flux等，这些是融入范式的开发模式，也不是一个完整的应用架构。绝大多数客户端的架构是由Router、Service、Module组成的，这解决了部分问题，但在工程中的实践效果仍不理想。

- Service定位含糊不清，导致对架构容易有误解。
- 架构对跨模块访问限制不足，容易只形成引用解耦而逻辑上没解耦。
- 跨模块访问手段不够全面。
- 没有针对基础组件的设计。

本文/仓库提出的**MicroKernel**就是一个更完整的、更彻底的应用架构。



## MicroKernel

**MicroKernel**是一个客户端微内核架构。从另一个角度来看，**MicroKernel**提供了最佳实践，也就是说，**MicroKernel**也是实现了其架构思想的框架。

![microkernel_icon_white](https://github.com/mrriddler/MicroKernel/raw/master/resources/microkernel_icon_white.png)



## 文档

- 技术愿景
- 哲学
- 边界与层次
- 原则
- 没有银弹
- [框架](https://github.com/mrriddler/MicroKernel/blob/master/resources/Framework.md)
- [教学](https://github.com/mrriddler/MicroKernelDemo)
- [接入](https://github.com/mrriddler/MicroKernelDemo/blob/master/resources/Access.md)



## 技术愿景

客户端架构与任何架构一样，应当将系统当做有机体，让系统“健康成长”，适应未来的变化。

在App的成长过程中，客户端面临的挑战是：

- 业务会不断地追随趋势/切换方向，并在老业务中推广。
- 在公司级别快速建立新App抢占市场，并在新App中复用已有业务、基础。
- 基础不断地升级/更换方案，且与业务没有明显分界。

这些难题用技术的行话翻译一下就是要求系统具有足够的可伸缩性和基础能力的可移植性、替换性，这意味着要求不同模块隔离(解耦)、依赖管理。

如今，服务端最流行的架构就是微服务架构，微服务架构从**物理级别隔离服务**，并给服务以**自治性**，其中包括技术栈、部署、扩容等。微服务做到了服务的完全隔离，服务之间通讯需要经过网络传输，以这种方式来给予系统可伸缩性，并以自治性使系统更加适应未来的变化。

反观，客户端来说。首先，无法做到完全隔离，原因有两点：

1. 客户端并不能形成多进程架构，而一个进程中因为没有完全能限制跨模块的方法，很少有人能做到完全隔离。
2. 客户端是以界面驱动业务，界面设计很容易使业务耦合，并最终导致完全隔离的成本很大。

既然无法做到完全隔离，那么架构上就要提供充足的限制和规范。

其次，虽然自治性不会给客户端带来太大的收益，但自治性是期望系统能够适应基础技术的不断升级/更换方案，这点对于客户端同样是有意义的。

不同于服务端，客户端应通过**微内核**来提供系统可伸缩性，通过模仿RPC形式的CMPC(Cross Module Procedure Call)和EventBus(MessageQueue)来跨模块访问。RPC是Request-Response的最终形式，而CMPC则是对其形式的模仿，CMPC存在的目的是给跨模块调用给予架构上的限制。而EventBus提供了另一种跨模块访问的选择。

CMPC与EventBus的不同就在于是否中心化。在影响到多方的场景下，CMPC会有个中心节点承担安排动作，而EventBus则没有。CMPC与EventBus之间是编排和协调的关系。

对于**微内核**还有一个关键问题要回答，是否要像传统**微内核**架构一样，需要将插件动态化。在Apple和Google两大阵营在用户安全摔跟头的大环境下，客户端黑科技日薄西山，将插件都实现动态化反而是件费力不讨好的事情了。



## 哲学

**MicroKernel**的哲学便是**把业务和基础都视作插件，形成一个插件化微内核架构。对于业务，一切其他模块的业务和基础都是注入的依赖。**

**MicroKernel**遵守了整洁架构(clean arichtecture)、六边形架构(hexagonal architecture)等架构的主旨，架构以代码变更的原因和频率形成边界和层次，并使依赖从外层(底层)向内层(高层)。

**MicroKernel**不仅仅有高内聚、低耦合、组件化等开发上的优势。**MicroKernel**更适合现在互联网公司的发展趋势，**MicroKernel将App作为业务和基础的容器。**



## 边界与层次

![microkernel](https://github.com/mrriddler/MicroKernel/raw/master/resources/microkernel.jpeg)

- **MicroKernel：**整个App的驱动，提供**MicroApplication**管理、通信机制、依赖注入、路由等。
- **MicroKernelService：**贯穿App的基础能力服务，提供基础能力的领域抽象，不包括具体的技术选型，不必拘泥于依赖注入形式。
- **MicroApplicationService：**贯穿App的业务服务，从复用角度聚合，包括其整体业务方案，比如，分享、登录、支付等。
- **MicroApplicationCoordinator：**解开**MicroApplication**之间耦合的协调器。通过模仿RPC形式的CMPC(Cross Module Procedure Call)和EventBus(MessageQueue)来跨模块访问。
- **MicroApplication：**独立的业务，从功能角度聚合，在架构中称作应用。App的运行形式化为应用的不断切换。其形式包括Native、H5、Hybrid、小程序等。
- **MainApplication：**整个App的架构注册、配置，以及外部渠道的对接。

层层嵌套与外层依赖内层是稳定架构的关键因素。



## 原则

架构中隐含了一些原则：

- 从不直接引入第三方库，不让第三方库充斥业务代码，只通过依赖注入的形式引入。
- 尽量不耦合其他业务，通过协调器跨模块访问，协调器通过依赖注入的形式引入。
- 尽量不在单独的基础能力SDK中做适配，通过基础能力服务层提供多元化的基础能力。
- 从不重复业务服务能力，从复用角度聚合，通过依赖注入的形式引入。

架构得当的话，**MicroApplication**应表现为业务实体外加其他业务协调器、业务服务的依赖注入。



## 没有银弹

天下没有白吃的午餐，也没有能杀死人狼的银弹。**MicroKernel**会将工程衍生出大量的组件和应用，增大了管理组件和应用的复杂度，你需要面临很多协同开发的问题。伴随大量的组件，你需要在持续集成、壳工程方面做更多的工作。

在应用边界还不稳定的情况下，过早构建**MicroKernel**也不是好的选择。不断变化的应用边界会导致跨应用修改，这种修改的成本是非常高的。很多时候，将一个已有的App构建为**MicroKernel**，要比从头开始就构建**MicroKernel**简单得多。



