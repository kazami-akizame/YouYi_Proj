// NoticeSetting.ets 通知设置页面
// 旧版鸿蒙兼容 · 零报错 · 直接运行
import router from '@ohos.router';

@Entry
@Component
struct NoticeSettingPage {
  @State chatNotice: boolean = true;
  @State systemNotice: boolean = true;

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left:16, right:12 })
          .onClick(()=>router.back())
        Text('设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .position({ x: '45%', y: '20%' })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')

      Column() {
        Scroll() {
    Column() {
      // 会话消息通知开关
      this.switchItem('会话消息通知', this.chatNotice, (val) => {
        this.chatNotice = val
      })
      // 系统消息通知开关
      this.switchItem('系统消息通知', this.systemNotice, (val) => {
        this.systemNotice = val
      })
    }
  }
          .flexGrow(1)
          .backgroundColor('#F5F5F5')
          }.justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
  }

  // 开关条目：左文字、右开关，Flex占位两端对齐
  @Builder
  switchItem(title: string, state: boolean, onChange: (val:boolean)=>void) {
    Row() {
      Text(title).fontSize(16).fontColor('#333')
      Flex()
      Toggle({type:ToggleType.Switch, isOn:state})
        .selectedColor('#007AFF')
        .onChange(onChange)

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({left:16,right:16,top:16,bottom:16})
    .backgroundColor(Color.White)
    Divider().strokeWidth(1).color('#EEE')
  }
}