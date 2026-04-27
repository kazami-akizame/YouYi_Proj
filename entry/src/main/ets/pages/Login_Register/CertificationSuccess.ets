import router from '@ohos.router';
const TAG: string = 'CertificationSuccess';

@Entry
@Component
struct CertificationSuccess {
  build() {
    Column() {
      // 导航栏（iOS 标准统一样式）
      Stack({ alignContent: Alignment.Center }) {
        Row() {
          Image($r('app.media.img_4'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .padding({ left: 20 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          console.log(`${TAG}: 点击返回，跳转到首页`);
          router.replaceUrl({ url: 'pages/Index' });
        })

        Text("医师认证")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .shadow({ radius: 0.5, color: "#00000010", offsetX: 0, offsetY: 1 })

      // 成功内容区域
      Column() {
        // 成功图标
        Image($r('app.media.img1'))
          .width(130)
          .height(130)
          .objectFit(ImageFit.Contain)
          .margin({ top: 70, bottom: 28 })

        // 成功标题
        Text("提交成功")
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor("#1C1C1E")
          .margin({ bottom: 8 })

        // 状态提示
        Text("待审核")
          .fontSize(17)
          .fontColor("#007AFF")
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 44 })

        // 说明卡片
        Column({ space: 8 }) {
          Text("您的认证资料已提交成功")
            .fontSize(15)
            .fontColor("#8E8E93")
          Text("我们将在1-3个工作日内完成审核")
            .fontSize(15)
            .fontColor("#8E8E93")
          Text("审核结果将通过短信通知您")
            .fontSize(15)
            .fontColor("#8E8E93")
        }
        .width('85%')
        .padding({ top: 24, bottom: 24, left: 20, right: 20 })
        .backgroundColor(Color.White)
        .borderRadius(16)
        .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })

        // 返回按钮
        Button("返回首页")
          .width('85%')
          .height(54)
          .backgroundColor("#007AFF")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor("#FFFFFF")
          .borderRadius(14)
          .shadow({ radius: 3, color: "#007AFF30", offsetX: 0, offsetY: 2 })
          .margin({ top: 60 })
          .onClick(() => {

            //👈👈 -----修改成真的跳转位置
            router.pushUrl({ url: 'pages/Index' });
            //👈 👈
          })
      }
      .width('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F2F2F7")
  }
}