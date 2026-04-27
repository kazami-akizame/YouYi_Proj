import router from '@ohos.router';
import { http } from '@kit.NetworkKit';

// 显式定义类型
interface CertifyInfo {
  avatar: Resource;
  idCardFront: Resource;
  idCardBack: Resource;
  certImage: Resource;
  status: number;
}

interface CertifyStatus {
  status: number;
}

@Entry
@Component
struct DoctorCertify_review {
  // ✅ 修复：指定类型
  @State certifyInfo: CertifyInfo = {
    avatar: $r('app.media.img11'),
    idCardFront: $r('app.media.person'),
    idCardBack: $r('app.media.nation'),
    certImage: $r('app.media.ic_upload'),
    status: 0
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
        let status = result.status ?? 0;

        // ======================
        // 自动跳转正确页面
        // ======================
        if (status === 1) {
          router.replaceUrl({ url: "pages/Mine/DoctorCertify_pass" });
          return;
        }
        if (status === 2) {
          router.replaceUrl({ url: "pages/Mine/DoctorCertify_fail" });
          return;
        }

        this.certifyInfo.status = status;
        console.log("✅ 审核页面：认证状态加载成功");
      }
    } catch (err) {
      console.error("⚠️ 加载失败，使用本地数据");
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
        Image($r('app.media.u6061'))
          .width(48)
          .height(48)

        Text("医师认证审核中")
          .fontSize(18)
          .fontColor("#333")
          .margin({ top: 10 })

        Text("我们会在1-2个工作日内给予审核结果，请耐心等待")
          .fontSize(14)
          .fontColor("#999")
          .margin({ top: 8 })
      }
      .width('100%')
      .backgroundColor("#fff")
      .padding({ top: 20, bottom: 20 })

      Column(){}.width('100%').height(10).backgroundColor("#F5F5F5")

      List() {
        ListItem() {
          Column() {
            Text("医生头像").fontSize(16).width('100%')
            Image(this.certifyInfo.avatar)
              .width(120)
              .height(120)
              .backgroundColor("#F7F9FC")
              .borderRadius(10)
              .margin({ top: 12 })
              .align(Alignment.TopStart)
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
        }

        ListItem() {
          Column(){}.width('100%').height(10).backgroundColor("#F5F5F5")
        }

        ListItem() {
          Column() {
            Text("身份证件（正反面均需上传）").fontSize(16).width('100%')
            Row({ space: 12 }) {
              Image(this.certifyInfo.idCardFront)
                .width(120)
                .height(120)
                .borderRadius(10)
              Image(this.certifyInfo.idCardBack)
                .width(120)
                .height(120)
                .borderRadius(10)
            }
            .margin({ top: 12 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
        }

        ListItem() {
          Column(){}.width('100%').height(10).backgroundColor("#F5F5F5")
        }

        ListItem() {
          Column() {
            Text("胸牌/执业证/资格证/职称证，至少上传一项").fontSize(16).width('100%')
            Image(this.certifyInfo.certImage)
              .width(120)
              .height(120)
              .borderRadius(10)
              .margin({ top: 12 })

            Text("照片仅用作认证，平台会保护您的隐私，不会泄漏给第三方")
              .fontSize(12)
              .fontColor("#999")
              .margin({ top: 12 })
              .width('100%')
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
          .padding(20)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#fff")
      .divider({ strokeWidth: 0 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#fff")
  }
}