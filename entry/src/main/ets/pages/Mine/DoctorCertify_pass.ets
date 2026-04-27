import router from '@ohos.router';
import { http } from '@kit.NetworkKit';

// 显式定义认证信息类型
interface CertifyInfo {
  avatar: Resource;
  idCardFront: Resource;
  idCardBack: Resource;
  certImage: Resource;
  status: number;
}

// 定义后端返回的状态类型
interface CertifyStatus {
  status: number;
}

@Entry
@Component
struct DoctorCertify_pass {
  // ✅ 修复：显式指定 @State 变量类型
  @State certifyInfo: CertifyInfo = {
    avatar: $r('app.media.img11'),
    idCardFront: $r('app.media.person'),
    idCardBack: $r('app.media.nation'),
    certImage: $r('app.media.ic_upload'),
    status: 1
  };

  onPageShow() {
    this.loadCertifyInfo();
  }

  async loadCertifyInfo() {
    const httpTask = http.createHttp();
    try {
      const response = await httpTask.request(
        "http://localhost:8888/certifyInfo",
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const result: CertifyStatus = JSON.parse(response.result.toString());
        let status = result.status ?? 1;

        // ======================
        // 自动跳转正确页面
        // ======================
        if (status === 0) {
          router.replaceUrl({ url: "pages/Mine/DoctorCertify_review" });
          return;
        }
        if (status === 2) {
          router.replaceUrl({ url: "pages/Mine/DoctorCertify_fail" });
          return;
        }

        this.certifyInfo.status = status;
        console.log("✅ 成功页面：认证状态加载成功");
      }
    } catch (err) {
      console.error("⚠️ 认证信息请求失败，使用本地数据");
    } finally {
      httpTask.destroy();
    }
  }

  build() {
    Column() {
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

      Column() { }.width('100%').height(10).backgroundColor("#F5F5F5")

      List() {
        ListItem() {
          Column() {
            Text("医生头像")
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)

            Image(this.certifyInfo.avatar)
              .width(120)
              .height(120)
              .backgroundColor("#F7F9FC")
              .borderRadius(10)
              .margin({ top: 12 })
              .objectFit(ImageFit.Cover)
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }

        ListItem() {
          Column() { }.width('100%').height(10).backgroundColor("#F5F5F5")
        }

        ListItem() {
          Column() {
            Text("身份证件（正反面均需上传）")
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)

            Row({ space: 12 }) {
              Image(this.certifyInfo.idCardFront)
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
                .objectFit(ImageFit.Cover)

              Image(this.certifyInfo.idCardBack)
                .width(120)
                .height(120)
                .backgroundColor("#F7F9FC")
                .borderRadius(10)
                .objectFit(ImageFit.Cover)
            }
            .margin({ top: 12 })
          }
          .width('100%')
          .padding(20)
          .alignItems(HorizontalAlign.Start)
        }

        ListItem() {
          Column() { }.width('100%').height(10).backgroundColor("#F5F5F5")
        }

        ListItem() {
          Column() {
            Text("胸牌/执业证/资格证/职称证，至少上传一项")
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Start)

            Image(this.certifyInfo.certImage)
              .width(120)
              .height(120)
              .backgroundColor("#F7F9FC")
              .borderRadius(10)
              .margin({ top: 12 })
              .objectFit(ImageFit.Cover)

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