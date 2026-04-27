import router from '@ohos.router';

@Entry
@Component
struct DoctorCertify_review {
  build() {
    Column() {
      // ====================== 顶部导航栏 ======================
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .onClick(() => router.pushUrl({ url: 'pages/MePage' }))

        Text("医师认证")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(24)
      }
      .width('100%')
      .height(56)
      .backgroundColor("#fff")
      .alignItems(VerticalAlign.Center)
      .padding({ left:15, right:15 })

      // ====================== 头部审核中区域（已根据新图片修改） ======================
      Column() {
        // 黄色时钟图标
        Image($r('app.media.u6061')) // 请替换为你的黄色时钟图标资源
          .width(48)
          .height(48)

        // 审核中标题
        Text("医师认证审核中")
          .fontSize(18)
          .fontColor("#333")
          .margin({ top:10 })

        // 下方提示文字
        Text("我们会在1-2个工作日内给予审核结果，请耐心等待")
          .fontSize(14)
          .fontColor("#999")
          .margin({ top: 8 })
      }
      .width('100%')
      .backgroundColor("#fff")
      .padding({ top:20, bottom:20 })

      // 灰色分割框
      Column(){}.width('100%').height(10).backgroundColor("#F5F5F5")

      // ====================== 列表内容（与之前保持一致） ======================
      List()
      {
        // 医生头像
        ListItem() {
          Column() {
            Text("医生头像")
              .fontSize(16)
              .width('100%')

            Image($r('app.media.img'))
              .width(120)
              .height(120)
              .backgroundColor("#F7F9FC")
              .borderRadius(10)
              .margin({ top:12 })
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }

        // 灰色间隔
        ListItem() {
          Column(){}.width('100%').height(10).backgroundColor("#F5F5F5")
        }

        // 身份证
        ListItem() {
          Column() {
            Text("身份证件（正反面均需上传）")
              .fontSize(16)
              .width('100%')

            Row({ space: 12 }) {
              Image($r('app.media.img'))
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)

              Image($r('app.media.img'))
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
            }
            .margin({ top:12 })
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }

        // 灰色间隔
        ListItem() {
          Column(){}.width('100%').height(10).backgroundColor("#F5F5F5")
        }

        // 资质证书
        ListItem() {
          Column() {
            Text("胸牌/执业证/资格证/职称证，至少上传一项")
              .fontSize(16)
              .width('100%')

            Image($r('app.media.img'))
              .width(120)
              .height(120)
              .backgroundColor("#F7F9FC")
              .borderRadius(10)
              .margin({ top:12 })

            Text("照片仅用作认证，平台会保护您的隐私，不会泄漏给第三方")
              .fontSize(12)
              .fontColor("#999")
              .margin({ top:12 })
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }
      }.width('100%')
      .layoutWeight(1)
      .backgroundColor("#fff")
      .divider({ strokeWidth: 0 })

      // ====================== 底部按钮 ======================
      Button("修改认证")
        .width('90%')
        .height(48)
        .backgroundColor("#1677FF")
        .fontColor("#fff")
        .fontSize(16)
        .borderRadius(24)
        .margin({ top:10, bottom:30 })//审核阶段禁止重新上传

    }
    .width('100%')
    .height('100%')
    .backgroundColor("#fff")
  }
}