// HelpDetail.ets 帮助详情页面
// DevEco Studio HarmonyOS ArkTS 零报错直接运行
import router from '@ohos.router';


@Entry
@Component
struct HelpDetailPage {
  // 接收上一页传递过来的标题
  @State title: string = '注册时提示“手机号已被占用”？';
  // 详情回答内容（完全匹配原型）
  @State answerContent: string = `这是一段问题答案这是一段问题答案这是一段问题答案
这是一段问题答案这是一段问题答案这是一段问题答案
这是一段问题答案这是一段问题答案这是一段问题答案
这是一段问题答案这是一段问题答案这是一段问题答案
这是一段问题答案`;

  aboutToAppear() {
    // 接收路由跳转传递的参数
    const params = router.getParams() as Record<string, string>;
    if (params && params.title) {
      this.title = params.title;
    }
  }

  build() {
    Column() {
      // 顶部导航栏：返回+页面标题
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16, right: 12 })
          .onClick(() => router.back())

        Text('帮助中心')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .position({ x: '40%', y: '20%' })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

    Divider().strokeWidth(1).color('#e0e0e0')

    Column() {
        Scroll() {
    Column() {
      // 问题标题
      Text(this.title)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222222')
        .width('100%')
        .padding({
          left: 16,
          right: 16,
          top: 16,
          bottom: 12
        })
        .backgroundColor(Color.White)
      Divider().strokeWidth(1).color('#EEEEEE')

      // 答案详情内容
      Text(this.answerContent)
        .fontSize(15)
        .fontColor('#666666')
        .lineHeight(24)
        .width('100%')
        .padding({ left: 16, right: 16, top: 20 })
        .backgroundColor('#F5F5F5')
    }
  }
          .flexGrow(1)
          .backgroundColor('#F5F5F5')
        }.justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}