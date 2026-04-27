import { MePage } from './MePage'

@Entry
@Component
struct doctab {
  @State currentIndex: number = 2;

  build() {
    Tabs({ index: this.currentIndex }) {  // 必写！
      // 首页
      TabContent() {
        Column() {
          Text("首页页面")
        }.width('100%').height('100%').backgroundColor("#f5f5f5")
      }
      .tabBar(this.TabBuilder(0, "首页", $r('app.media.u1070'), $r('app.media.u1073')))

      // 患者
      TabContent() {
        Column() {
          Text("患者页面")
        }.width('100%').height('100%').backgroundColor("#f5f5f5")
      }
      .tabBar(this.TabBuilder(1, "患者", $r('app.media.u1071'), $r('app.media.u1074')))

      // 我的
      TabContent() {
        MePage()
      }
      .tabBar(this.TabBuilder(2, "我的", $r('app.media.u1072'), $r('app.media.u1075')))
    }
    .barPosition(BarPosition.End)
    .onChange(index => {
      this.currentIndex = index;
    })
    .width('100%')
    .height('100%')
  }

  // Tab底部按钮通用封装
  @Builder
  TabBuilder(index: number, title: string, defaultIcon: Resource, activeIcon: Resource) {
    Column({ space: 4 }) {
      if (this.currentIndex === index) {
        Image(activeIcon).width(20).height(20).objectFit(ImageFit.Fill)
        Text(title).fontColor("#1A73E8").fontSize(12)
      } else {
        Image(defaultIcon).width(20).height(20).objectFit(ImageFit.Fill)
        Text(title).fontColor("#999").fontSize(12)
      }
    }
    .justifyContent(FlexAlign.Center)
  }
}