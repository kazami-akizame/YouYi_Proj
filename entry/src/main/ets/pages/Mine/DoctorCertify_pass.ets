import router from '@ohos.router';

interface CertifyInfo {
  avatar: string;
  idCardFront: string;
  idCardBack: string;
  certImage: string;
  status: number;
}

@Entry
@Component
struct DoctorCertify_pass {
  @State certifyInfo: CertifyInfo = {
    avatar: '',
    idCardFront: '',
    idCardBack: '',
    certImage: '',
    status: 1
  };

  onPageShow() {
    this.loadUploadedImages();
  }

  // 只从 AppStorage 读上传的图片，读不到就留空
  loadUploadedImages() {
    this.certifyInfo.avatar = AppStorage.get<string>('avatarUri') || '';
    this.certifyInfo.idCardFront = AppStorage.get<string>('idCardFrontUri') || '';
    this.certifyInfo.idCardBack = AppStorage.get<string>('idCardBackUri') || '';
    this.certifyInfo.certImage = AppStorage.get<string>('certUri') || '';
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .onClick(() => router.back())
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
      .padding({ left: 15, right: 15 })

      // 成功提示
      Column() {
        Image($r('app.media.u6010'))
          .width(48)
          .height(48)
        Text("医师认证成功")
          .fontSize(18)
          .fontColor("#333")
          .margin({ top: 10 })
      }
      .width('100%')
      .backgroundColor("#fff")
      .padding({ top: 20, bottom: 20 })

      Column()
        .width('100%')
        .height(10)
        .backgroundColor("#F5F5F5")

      // 图片列表
      List() {
        ListItem() {
          Column() {
            Text("医生头像")
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)
            // ✅ 正确兜底写法：用条件渲染
            if (this.certifyInfo.avatar) {
              Image(this.certifyInfo.avatar)
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
                .margin({ top: 12 })
                .objectFit(ImageFit.Cover)
            } else {
              // 没上传就显示默认图
              Image($r('app.media.img11'))
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
                .margin({ top: 12 })
                .objectFit(ImageFit.Cover)
            }
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }

        ListItem() {
          Column()
            .width('100%')
            .height(10)
            .backgroundColor("#F5F5F5")
        }

        ListItem() {
          Column() {
            Text("身份证件（正反面均需上传）")
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)
            Row({ space: 12 }) {
              if (this.certifyInfo.idCardFront) {
                Image(this.certifyInfo.idCardFront)
                  .width(120)
                  .height(120)
                  .backgroundColor("#F7F9FC")
                  .borderRadius(10)
                  .objectFit(ImageFit.Cover)
              } else {
                Image($r('app.media.nation'))
                  .width(120)
                  .height(120)
                  .backgroundColor("#F7F9FC")
                  .borderRadius(10)
                  .objectFit(ImageFit.Cover)
              }

              if (this.certifyInfo.idCardBack) {
                Image(this.certifyInfo.idCardBack)
                  .width(120)
                  .height(120)
                  .backgroundColor("#F7F9FC")
                  .borderRadius(10)
                  .objectFit(ImageFit.Cover)
              } else {
                Image($r('app.media.person'))
                  .width(120)
                  .height(120)
                  .backgroundColor("#F7F9FC")
                  .borderRadius(10)
                  .objectFit(ImageFit.Cover)
              }
            }
            .margin({ top: 12 })
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }

        ListItem() {
          Column()
            .width('100%')
            .height(10)
            .backgroundColor("#F5F5F5")
        }

        ListItem() {
          Column() {
            Text("胸牌/执业证/资格证/职称证，至少上传一项")
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)
            if (this.certifyInfo.certImage) {
              Image(this.certifyInfo.certImage)
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
                .margin({ top: 12 })
                .objectFit(ImageFit.Cover)
            } else {
              Image($r('app.media.ic_upload'))
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
                .margin({ top: 12 })
                .objectFit(ImageFit.Cover)
            }
            Text("照片仅用作认证，平台会保护您的隐私，不会泄漏给第三方")
              .fontSize(12)
              .fontColor("#999")
              .margin({ top: 12 })
              .width('100%')
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#fff")
      .divider({ strokeWidth: 0 })

      // 修改认证按钮
      Button("修改认证")
        .width('90%')
        .height(48)
        .backgroundColor("#1677FF")
        .fontColor("#fff")
        .fontSize(16)
        .borderRadius(24)
        .margin({ top: 10, bottom: 30 })
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/DoctorCertificationUpload"
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#fff")
  }
}