import router from '@ohos.router';

@Entry
@Component
struct PrivacyPolicy {
  build() {
    Column() {
      // 顶部导航栏 + 返回按钮
      Row() {
        Button("返回")
          .backgroundColor(Color.Transparent)
          .fontColor("#000")
          .fontSize(12)
          .onClick(() => {
            router.back(); // 返回上一页
          })

        Text("隐私政策")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding(15)
      .backgroundColor(Color.White)

      // 滚动文本区域（存放长文本）
      Scroll() {
        Column() {
          // 标题
          Text("有道医生在线问诊 隐私政策")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 20, top: 10 })

          // 隐私政策正文（你可以随便替换成你的完整文本）
          Text(`
            一、我们如何收集和使用您的个人信息
            我们会按照合法、正当、必要的原则，收集您在使用本应用时主动提供的、以及基于您使用服务产生的信息，包括但不限于手机号、登录信息、问诊记录等，用于为您提供账号登录、在线问诊等核心服务。

            二、信息共享与披露
            我们不会与第三方共享您的个人信息，除非获得您的明确授权，或根据法律法规、行政机关等有权机关的要求进行披露。

            三、信息安全
            我们采用符合行业标准的安全技术和程序来保护您的个人信息，防止数据遭到未授权访问、使用或泄露。

            四、您的权利
            您可以随时查询、更正、删除您的个人信息，也可以注销账号。我们会在合理期限内响应您的请求。

            五、本政策如何更新
            我们可能会适时修订本政策，更新后的政策将在本应用内公示。如您继续使用本应用，即视为同意更新后的政策。

            六、联系我们
            如您对本隐私政策有任何疑问或建议，请通过客服渠道联系我们。
          `)
            .fontSize(15)
            .fontColor("#333")
            .lineHeight(24)
            .width('100%')
        }
        .width('90%')
        .margin({ bottom: 30 })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }
}