// MessageDetailPage.ets
import router from '@ohos.router';

// 消息数据模型
interface MessageDetailItem {
  time: string;
  content: string;
}

@Entry
@Component
struct MessageDetailPage {

  // 模拟消息列表数据
  @State msgList: MessageDetailItem[] = [
    {
      time: '2019-09-08 10:09',
      content: '医生端已升级到2.0.1版本，请点击我的-设置-版本更新进行升级'
    },
    {
      time: '2019-09-08 10:09',
      content: '医生端已升级到2.0.1版本，请点击我的-设置-版本更新进行升级'
    }
  ]

  build() {
    Column() {
      // 顶部导航栏
      this.buildNavBar()

      // 消息内容列表
      List() {
        ForEach(this.msgList, (item: MessageDetailItem) => {
          ListItem() {
            Column() {
              // 时间文本
              Text(item.time)
                .fontSize(13)
                .fontColor('#999999')
                .width('100%')

              // 消息正文
              Text(item.content)
                .fontSize(15)
                .fontColor('#333333')
                .lineHeight(22)
                .margin({ top: 8 })
                .width('100%')
            }
            .width('100%')
            .padding(16)
            .alignItems(HorizontalAlign.Start)
          }
        })
      }
      .layoutWeight(1)
      .width('100%')
      .divider({
        strokeWidth: 1,
        color: '#EEEEEE'
      })
      .backgroundColor(Color.White)

      Blank()
        .backgroundColor('#F2F2F2')
        .layoutWeight(1)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F2')
  }

  // 顶部导航栏组件
  @Builder
  buildNavBar() {
    Row() {
      // 返回按钮
      Image($r('app.media.u695'))
        .width(18)
        .height(18)
        .margin({ left: 16 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/MessageCenterPage' })
        })

      // 页面标题
      Text('消息详情')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 右侧占位 保证标题居中
      Text('')
        .width(24)
        .margin({ right:16 })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

}