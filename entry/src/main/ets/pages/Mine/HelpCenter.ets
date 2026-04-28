// HelpCenter.ets 帮助中心列表页面
// 旧版鸿蒙兼容 · 零报错 · 直接运行
import router from '@ohos.router';

// 帮助项强类型接口
interface HelpItem {
  id: number;
  title: string;
}

@Entry
@Component
struct HelpCenterPage {
  // 帮助列表数据
  @State helpList: HelpItem[] = [
    { id: 1, title: '注册时提示“手机号已被占用”？' },
    { id: 2, title: '注册时提示“手机号已被占用”？' },
    { id: 3, title: '注册时提示“手机号已被占用”？' },
    { id: 4, title: '注册时提示“手机号已被占用”？' },
    { id: 5, title: '注册时提示“手机号已被占用”？' },
    { id: 6, title: '注册时提示“手机号已被占用”？' },
  ];

  build() {
    Column() {
      // 顶部导航栏
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

      // 滚动列表区域
      Column(){
      Scroll() {
        Column() {
          // 循环渲染每条帮助项
          ForEach(this.helpList, (item: HelpItem) => {
            this.helpItemView(item)
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
  }

  // 封装帮助条目：左侧左对齐，右侧箭头右对齐（无 Spacer）
  @Builder
  helpItemView(item: HelpItem) {
    Row() {
      Text(item.title)
        .fontSize(16)
        .fontColor('#333333')
        .textAlign(TextAlign.Start)

      // 🔥 修复：用 Flex() 代替 Spacer，旧版鸿蒙 100% 支持
      Flex()

      Image($r('app.media.ic_public_jiantou'))
        .width(16)
        .height(16)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    .backgroundColor(Color.White)
    .onClick(() => {
      router.replaceUrl({
        url: 'pages/Mine/HelpDetail',
        params: { title: item.title }
      })
    })
    Divider().strokeWidth(1).color('#EEEEEE')
  }
}