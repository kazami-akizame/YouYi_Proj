import router from '@ohos.router';

// 路由返回数据类型
interface RouterBackResult {
  key: string;
  value: string;
}

const titles = ['主任医师', '副主任医师', '主治医师', '住院医师'];

@Entry
@Component
struct SelectTitlePage {
  @State fieldKey: string = '';
  @State title: string = '';

  aboutToAppear() {
    interface RouterParams {
      key?: string;
      title?: string;
    }
    const params = router.getParams() as RouterParams;
    this.fieldKey = params.key ?? '';
    this.title = params.title ?? '';
  }
  build() {
    Column() {
      // 导航栏
      Stack({ alignContent: Alignment.Center }) {
        // 返回按钮
        Row() {
          Image($r('app.media.img_4'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .padding({ left: 20 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => router.back())

        // 标题
        Text("医生职称")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .shadow({ radius: 0.5, color: "#00000010", offsetX: 0, offsetY: 1 })

      // 提示卡片（iOS 温馨提示风格）
      Text('请如实选择，平台将进行严格审核您上传的资料和职称是否对应')
        .width('100%')
        .backgroundColor("#FFF8E6")
        .padding({ top: 14, bottom: 14, left: 20, right: 20 })
        .fontSize(14)
        .fontColor("#D4A147")
        .margin({ bottom: 6 })

      // 职称列表（iOS 列表样式）
      List() {
        ForEach(titles, (title: string) => {
          ListItem() {
            Text(title)
              .width('100%')
              .padding({ top: 18, bottom: 18, left: 20, right: 20 })
              .fontSize(16)
              .fontColor("#1C1C1E")
              .backgroundColor(Color.White)
              .onClick(() => {
                AppStorage.set<RouterBackResult>('routerBackResult', {
                  key: this.fieldKey,
                  value: title
                });
                router.back();
              })
          }
        })
      }
      .layoutWeight(1)
      .backgroundColor("#F2F2F7")
      .divider({ strokeWidth: 0.5, color: "#00000010" })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F2F2F7")
  }
}