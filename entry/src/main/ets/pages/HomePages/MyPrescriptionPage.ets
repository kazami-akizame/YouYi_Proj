// pages/MyPharmacyPage.ets (第一个代码)
import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import { ConsultationItem } from '../common/ConsultationData';
import { MedicineDetail } from '../HomePages/PrescriptionEditPage'

// 在文件开头，import 语句之后定义接口
interface RawPrescription {
  id: string;
  patientName?: string;
  patientGender?: string;
  patientAge?: number;
  clinicalDiagnosis?: string;
  diagnosis?: string;
  medicineCount: number;
  medicineList?: string[];
  medicines?: RawMedicineItem[];
  createDate?: string;
  isCommon?: boolean;
}

interface RawMedicineItem {
  name: string;
  specification: string;
  quantity: number;
  usageMethod?: string;
  frequency?: string;
  singleDose?: string;
  remark?: string;
}


// 模拟处方数据
interface Prescription {
  id: string;
  patientName?: string;
  patientGender?: string;
  patientAge?: number;
  diagnosis: string;
  medicineCount: number;
  medicineList: Object[];
}

interface RouterParams {
  item?: ConsultationItem;
}

@Entry
@Component
struct MyPharmacyPage {
  @State currentTab: number = 0; // 0:常用处方 1:历史处方
  @State commonPrescriptions: Prescription[] = [];
  @State historyPrescriptions: Prescription[] = [];
  @State consultationItem: ConsultationItem | null = null;

  async onPageShow() {
    await this.loadPrescriptions();
  }

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;

    if (typeof params.item === 'string') {
      const raw: ConsultationItem = JSON.parse(params.item);
      this.consultationItem = new ConsultationItem(
        raw.id,
        raw.patientName,
        raw.patientGender,
        raw.patientAge,
        raw.type,
        raw.status,
        raw.description,
        raw.createTime,
        raw.rejectReason,
        raw.chatMessages
      );
    }
  }

  //只同步历史处方
  async loadPrescriptions() {
    try {
      let httpRequest = http.createHttp();

      // 常用处方请求 - 保持原样，不做转换
      let commonResponse = await httpRequest.request(
        "http://127.0.0.1:8888/commonPrescriptions1",
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        }
      );
      this.commonPrescriptions = JSON.parse(commonResponse.result as string);

      // 历史处方请求 - 转换格式
      let historyResponse = await httpRequest.request(
        "http://127.0.0.1:8888/historyPrescriptions",
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        }
      );
      let historyRawData: RawPrescription[] = JSON.parse(historyResponse.result as string);

      // 只转换历史处方数据格式
      this.historyPrescriptions = historyRawData.map((item: RawPrescription) => {
        let prescription: Prescription = {
          id: item.id,
          patientName: item.patientName || '',
          patientGender: item.patientGender || '',
          patientAge: item.patientAge || 0,
          diagnosis: item.clinicalDiagnosis || '',
          medicineCount: item.medicineCount,
          medicineList: []
        };

        if (item.medicineList) {
          prescription.medicineList = item.medicineList;
        } else if (item.medicines) {
          prescription.medicineList = item.medicines.map((med: RawMedicineItem) =>
          `${med.name} ${med.specification} ×${med.quantity}盒`
          );
        }

        return prescription;
      });

      httpRequest.destroy();
    } catch (err) {
      console.error('加载处方失败', JSON.stringify(err));
    }
  }

  usePrescription(prescription: Prescription) {
    router.pushUrl({
      url: 'pages/HomePages/PrescriptionEditPage',
      params: {
        prescriptionJson: JSON.stringify(prescription),
        item: this.consultationItem
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
        const url = tabIndex === 0
          ? 'pages/HomePages/CommonPrescriptionDetailPage'
          : 'pages/HomePages/HistoryPrescriptionDetailPage';
        router.pushUrl({
          url: url,
          params: { prescriptionJson: JSON.stringify(prescription) }
        });
      })

      ForEach(prescription.medicineList.slice(0, 2), (med: Object) => {
        if (typeof med === 'string') {
          Text(med).fontSize(14).fontColor('#999')
        } else {
          Text(`· ${(med as MedicineDetail).name} ${(med as MedicineDetail).specification} ×${(med as MedicineDetail).quantity}`)
            .fontSize(14).fontColor('#999')
        }
      })
      if (prescription.medicineList.length > 2) {
        Text(`...等${prescription.medicineList.length}种药品`)
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
          .onClick(() => {
            // 直接替换当前页面为问诊列表，清除所有中间栈
            router.replaceUrl({
              url: 'pages/HomePages/OnlineConsultationPage'
            });
          })
        Blank()
        Text('我的药房')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text('新建处方')
          .fontSize(16)
          .fontColor('#007AFF')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/HomePages/PrescriptionEditPage',
              params: {
                item: this.consultationItem
              }
            });
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
              Text(`常用处方列表 (${this.commonPrescriptions.length})`)
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
              Text(`历史处方列表 (${this.historyPrescriptions.length})`)
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