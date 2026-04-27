// pages/HistoryPrescriptionDetailPage.ets
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
struct HistoryPrescriptionDetailPage {
  @State prescription: Prescription | null = null;
  // 控制原始处方图片弹窗显示/隐藏
  @State showOriginalPrescription: boolean = false;

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
    // ✅ 用 Stack 作为根容器，保证弹窗能覆盖在详情页上面
    Stack() {
      // --- 第一层：详情页内容 ---
      Column() {
        // 顶部导航栏
        Row() {
          Image($r("app.media.left"))
            .width(14)
            .onClick(() => router.back())
          Text('历史处方详情')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
          Text('查看原始处方')
            .fontSize(16)
            .fontColor('#007AFF')
            .onClick(() => this.showOriginalPrescription = true)
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
            // 处方信息模块
            Column() {
              Row() {
                Text('NO：2020280000')
                  .fontSize(14)
                  .fontColor('#999')
                Blank()
                Text('2020-02-23')
                  .fontSize(14)
                  .fontColor('#999')
              }
              .width('100%')
              .margin({ bottom: 20 })

              Text('*****医院处方笺')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
                .width('100%')
                .textAlign(TextAlign.Center)
                .margin({ bottom: 20 })

              if (this.prescription.patientName) {
                Row() {
                  Text('患者姓名')
                    .fontSize(16)
                    .fontColor('#333')
                  Blank()
                  Text(this.prescription.patientName)
                    .fontSize(16)
                    .fontColor('#007AFF')
                }
                .width('100%')
                .margin({ bottom: 12 })
              }

              if (this.prescription.patientAge) {
                Row() {
                  Text('患者年龄')
                    .fontSize(16)
                    .fontColor('#333')
                  Blank()
                  Text(`${this.prescription.patientAge}岁`)
                    .fontSize(16)
                    .fontColor('#007AFF')
                }
                .width('100%')
                .margin({ bottom: 12 })
              }

              if (this.prescription.patientGender) {
                Row() {
                  Text('患者性别')
                    .fontSize(16)
                    .fontColor('#333')
                  Blank()
                  Text(this.prescription.patientGender)
                    .fontSize(16)
                    .fontColor('#007AFF')
                }
                .width('100%')
              }
            }
            .width('90%')
            .padding(20)
            .backgroundColor('#FFFFFF')
            .borderRadius(12)
            .margin({
              top: 16,
              bottom: 16,
              left: 16,
              right: 16
            })

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
            .margin({ bottom: 16, left: 16, right: 16 })

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
            .layoutWeight(1)

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

      // --- 第二层：原始处方弹窗 ---
      if (this.showOriginalPrescription) {
        Column() {
          // 关闭按钮
          Row() {
            Text('×')
              .fontSize(32)
              .fontColor('#fff')
              .onClick(() => this.showOriginalPrescription = false)
            Blank()
          }
          .width('100%')
          .padding({ top: 40, left: 20, right: 20 })

          // 处方图片
          Image($r("app.media.original"))
            .width('100%')
            .layoutWeight(1)
            .objectFit(ImageFit.Contain)

          // 底部按钮
          Button('使用该处方')
            .width('90%')
            .height(50)
            .fontSize(16)
            .backgroundColor('#007AFF')
            .borderRadius(25)
            .margin({ bottom: 50 })
            .onClick(() => this.usePrescription())
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#000000')
      }
    }
    .width('100%')
    .height('100%')
  }
}