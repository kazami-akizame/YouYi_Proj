// pages/CommonPrescriptionDetailPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

interface Prescription {
  id: string;
  patientName?: string;
  patientGender?: string;
  patientAge?: number;
  diagnosis: string;
  medicineCount: number;
  medicineList: string[];
}

@Entry
@Component
struct CommonPrescriptionDetailPage {
  @State prescription: Prescription | null = null;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params?.prescriptionJson) {
      try {
        this.prescription = JSON.parse(params.prescriptionJson) as Prescription;
      } catch (e) {
        promptAction.showToast({ message: '数据加载失败' });
        router.back();
      }
    }
  }

  usePrescription() {
    if (!this.prescription) return;
    router.pushUrl({
      url: 'pages/PrescriptionEditPage',
      params: {
        prescriptionJson: JSON.stringify(this.prescription)
      }
    });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r("app.media.left"))
          .width(14)
          .onClick(() => router.back())
        Text('常用处方详情')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)
        Blank().width(34)
      }
      .width('100%')
      .height(56)
      .padding({ left: 20, right: 16 })
      .backgroundColor('#FFFFFF')

      if (!this.prescription) {
        Text('加载中...')
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
      } else {
        Column() {
          // 诊断模块
          Column() {
            Text('诊断')
              .fontSize(16)
              .fontColor('#333')
              .width('100%')
              .margin({ bottom: 8 })
            Text(this.prescription.diagnosis)
              .fontSize(16)
              .fontColor('#007AFF')
              .width('100%')
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ top: 16, bottom: 16, left: 16, right: 16 })

          // 药品模块
          Column() {
            Text('Rp')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 16 })

            ForEach(this.prescription.medicineList, (med: string) => {
              Column() {
                Text(med)
                  .fontSize(16)
                  .fontColor('#333')
                  .width('100%')
                  .margin({ bottom: 8 })
                Text('用法用量：2次/天，每次1片，温水送服')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .margin({ bottom: 16 })
              }
              .width('100%')
            })
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16 })

          Blank()

          // 底部按钮
          Column() {
            Button('使用该处方')
              .width('90%')
              .height(50)
              .fontSize(16)
              .backgroundColor('#007AFF')
              .borderRadius(25)
              .onClick(() => this.usePrescription())
          }
          .width('100%')
          .padding({ top: 16, bottom: 50 })
          .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}