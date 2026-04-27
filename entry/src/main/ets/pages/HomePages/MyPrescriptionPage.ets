// pages/MyPharmacyPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

// 模拟处方数据
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
struct MyPharmacyPage {
  @State currentTab: number = 0; // 0:常用处方 1:历史处方
  @State commonPrescriptions: Prescription[] = [
    {
      id: '1',
      diagnosis: '感冒',
      medicineCount: 5,
      medicineList: ['板蓝根颗粒10包/盒 *1盒', '感冒灵颗粒10包/盒 *1盒', '维C银翘片 *1盒']
    },
    {
      id: '2',
      diagnosis: '感冒',
      medicineCount: 5,
      medicineList: ['板蓝根颗粒10包/盒 *1盒', '感冒灵颗粒10包/盒 *1盒', '维C银翘片 *1盒']
    },
    {
      id: '3',
      diagnosis: '感冒',
      medicineCount: 5,
      medicineList: ['板蓝根颗粒10包/盒 *1盒', '感冒灵颗粒10包/盒 *1盒', '维C银翘片 *1盒']
    }
  ];

  @State historyPrescriptions: Prescription[] = [
    {
      id: '4',
      patientName: '吴珊珊',
      patientGender: '女',
      patientAge: 23,
      diagnosis: '感冒',
      medicineCount: 5,
      medicineList: ['板蓝根颗粒10包/盒 *1盒', '感冒灵颗粒10包/盒 *1盒', '维C银翘片 *1盒']
    },
    {
      id: '5',
      patientName: '吴珊珊',
      patientGender: '女',
      patientAge: 23,
      diagnosis: '感冒',
      medicineCount: 5,
      medicineList: ['板蓝根颗粒10包/盒 *1盒', '感冒灵颗粒10包/盒 *1盒', '维C银翘片 *1盒']
    },
    {
      id: '6',
      patientName: '吴珊珊',
      patientGender: '女',
      patientAge: 23,
      diagnosis: '感冒',
      medicineCount: 5,
      medicineList: ['板蓝根颗粒10包/盒 *1盒', '感冒灵颗粒10包/盒 *1盒', '维C银翘片 *1盒']
    }
  ];

  onPageShow() {
    this.commonPrescriptions = AppStorage.Get<Prescription[]>('commonPrescriptions') || this.commonPrescriptions;
  }

  usePrescription(prescription: Prescription) {
    router.pushUrl({
      url: 'pages/PrescriptionEditPage',
      params: {
        prescriptionJson: JSON.stringify(prescription)
      }
    });
  }


  @Builder PrescriptionCard(prescription: Prescription, tabIndex: number) {
    Column() {
      Row() {
        Text('Rp')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
        Text(`共${prescription.medicineCount}种药品`)
          .fontSize(14)
          .fontColor('#999')
      }
      .width('100%')

      if (prescription.patientName && prescription.patientGender && prescription.patientAge) {
        Text(`${prescription.patientName} ${prescription.patientGender} ${prescription.patientAge}岁`)
          .fontSize(16)
          .fontColor('#333')
          .width('100%')
          .margin({ top: 12, bottom: 8 })
      }

      Row() {
        Text(`临床诊断：${prescription.diagnosis}`)
          .fontSize(16)
          .fontColor('#333')
          .layoutWeight(1)
        Image($r("app.media.right"))
          .width(8)
          .height(15)
          .fillColor('#999')
      }
      .width('100%')
      .margin({ top:10, bottom: 8 })
      .onClick(() => {
        // 根据当前Tab判断跳转哪个详情页
        const url = tabIndex === 0
          ? 'pages/CommonPrescriptionDetailPage'
          : 'pages/HistoryPrescriptionDetailPage';
        router.pushUrl({
          url: url,
          params: { prescriptionJson: JSON.stringify(prescription) }
        });
      })

      ForEach(prescription.medicineList.slice(0, 2), (med: string) => {
        Text(med)
          .fontSize(14)
          .fontColor('#999')
          .width('100%')
          .margin({ bottom: 4 })
      })
      if (prescription.medicineList.length > 2) {
        Text(`${prescription.medicineList[2]}...`)
          .fontSize(14)
          .fontColor('#999')
          .width('100%')
      }

      Row() {
        Blank()
        Button('使用该处方')
          .fontSize(14)
          .fontColor('#007AFF')
          .backgroundColor('#F0F8FF')
          .border({ width: 1, color: '#007AFF', radius: 20 })
          .padding({ left: 16, right: 16, top: 6, bottom: 6 })
          .onClick(() => this.usePrescription(prescription))
      }
      .width('100%')
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }

  build() {
    Column() {
      Row() {
        Image($r("app.media.left"))
          .width(14)
          .onClick(() => router.back())
        Blank()
        Text('我的药房')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text('新建处方')
          .fontSize(16)
          .fontColor('#007AFF')
          .onClick(() => {
            router.pushUrl({ url: 'pages/PrescriptionEditPage' });
          })
      }
      .width('100%')
      .height(56)
      .padding({ left: 20, right: 16 })
      .backgroundColor('#FFFFFF')

      Tabs({ barPosition: BarPosition.Start }) {
        TabContent() {
          Column() {
            Row() {
              Image($r("app.media.blue"))
                .width(6)
                .height(26)
                .margin({ left: 10, right: 12 })
              Text('常用处方列表 (3)')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')
            .margin({ top: 16, bottom: 16, left: 16 })

            List() {
              ForEach(this.commonPrescriptions, (prescription: Prescription) => {
                ListItem() {
                  this.PrescriptionCard(prescription, 0)
                }
              })
              ListItem() {
                Text('没有更多了~')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20 })
              }
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: 16, right: 16 })
          }
          .width('100%')
          .backgroundColor('#F5F5F5')
        }.tabBar('常用处方')

        TabContent() {
          Column() {
            Row() {
              Image($r("app.media.blue"))
                .width(6)
                .height(26)
                .margin({ left: 10, right: 12 })
              Text('历史处方列表 (3)')
                .fontSize(18)
                .fontWeight(FontWeight.Medium)
            }
            .width('100%')
            .margin({ top: 16, bottom: 16, left: 16 })

            List() {
              ForEach(this.historyPrescriptions, (prescription: Prescription) => {
                ListItem() {
                  this.PrescriptionCard(prescription, 1)
                }
              })
              ListItem() {
                Text('没有更多了~')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20 })
              }
            }
            .width('100%')
            .layoutWeight(1)
            .padding({ left: 16, right: 16 })
          }
          .width('100%')
          .backgroundColor('#F5F5F5')
        }.tabBar('历史处方')
      }
      .barMode(BarMode.Fixed)
      .barWidth('100%')
      .barHeight(48)
      .barBackgroundColor('#FFFFFF')
      .layoutWeight(1)
      .onChange((index: number) => {
        this.currentTab = index;
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}