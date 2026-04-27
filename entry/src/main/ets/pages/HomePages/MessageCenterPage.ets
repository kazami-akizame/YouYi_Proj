// MessageCenterPage.ets
import router from '@ohos.router';

// 消息分类数据模型
interface MessageTypeItem {
  title: string;
  desc: string;
  iconColor: string;
  iconBgColor: string;
  iconSymbol: Resource;
}

@Entry
@Component
struct MessageCenterPage {

  // 消息分类列表数据
  @State messageList: MessageTypeItem[] = [
    {
      title: '系统通知',
      desc: '版本升级通知',
      iconColor: '#F7B500',
      iconBgColor: '#FFF8E0',
      iconSymbol: $r('app.media.u4742')
    },
    {
      title: '交易通知',
      desc: '您有一条新的问诊消息',
      iconColor: '#34C785',
      iconBgColor: '#E6F9F0',
      iconSymbol: $r('app.media.u4750')
    },
    {
      title: '活动消息',
      desc: '您真的知道如何预防流感吗?',
      iconColor: '#FF6B6B',
      iconBgColor: '#FFEEEE',
      iconSymbol: $r('app.media.u4755')
    }
  ]

  build() {
    Column() {
      // 顶部导航栏
      this.buildNavBar()

      // 消息分类列表
      List() {
        ForEach(this.messageList, (item: MessageTypeItem) => {
          ListItem() {
            Row() {
              // 左侧圆形彩色图标
              Stack({ alignContent: Alignment.Center }) {
                Circle()
                  .width(48)
                  .height(48)
                  .fill(item.iconBgColor)
                  .stroke(item.iconColor)
                  .strokeWidth(1.5)

                Image(item.iconSymbol)
                  .width(22)
                  .height(22)
                  .fillColor(item.iconColor)
              }
              .margin({ left: 16 })

              // 中间文字区域
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontColor('#222222')
                  .fontWeight(FontWeight.Medium)
                Text(item.desc)
                  .fontSize(13)
                  .fontColor('#888888')
                  .margin({ top: 6 })
              }
              .layoutWeight(1)
              .margin({ left: 14 })
              .alignItems(HorizontalAlign.Start)

              // 右侧箭头
              Image($r('app.media.u1158'))
                .width(14)
                .height(16)
                .fillColor('#CCCCCC')
                .margin({ right: 16 })

            }
            .width('100%')
            .height(80)
            .alignItems(VerticalAlign.Center)
            .onClick(() => {
              // 点击进入对应消息详情页
                // 跳转到上一页我们写的 AddTopicPage 话题选择页
                router.pushUrl({ url: 'pages/MessageDetailPage' })

              console.log('进入:' + item.title + ' 详情')
            })
          }
        })
      }
      .layoutWeight(1)
      .width('100%')
      .divider({
        strokeWidth: 1,
        color: '#F2F2F2',
        startMargin: 80,
        endMargin: 0
      })
      .backgroundColor(Color.White)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 顶部导航栏组件
  @Builder
  buildNavBar() {
    Row() {
      // 返回箭头
      Image($r('app.media.u695'))
        .width(16)
        .height(16)
        .margin({ left: 16 })
        .onClick(() => {
          router.back()
              // 跳转到上一页我们写的 AddTopicPage 话题选择页
              router.pushUrl({ url: 'pages/AddTopicPage' })
        })

      // 页面标题
      Text('消息中心')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 右侧占位，标题完美居中
      Text('')
        .width(24)
        .margin({ right: 16 })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

}