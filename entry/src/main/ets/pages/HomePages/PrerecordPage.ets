// pages/HomePages/HistoryPrescriptionDetailPage.ets
import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';
import { Prescription, PrescriptionItem } from './MypharmacyPage';

@Entry
@Component
struct HistoryPrescriptionDetailPage {
  @State showImagePreview: boolean = false;
  @State prescription: Prescription | null = null;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['prescription']) {
      this.prescription = JSON.parse(params['prescription']) as Prescription;
    }
  }

  // 添加到常用处方
  async addToCommonPrescriptions() {
    if (!this.prescription) {
      return;
    }

    // 创建新的常用处方对象（不包含患者信息）
    const newCommonPrescription: Prescription = {
      id: Date.now().toString(),
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: this.prescription.clinicalDiagnosis,
      medicineCount: this.prescription.medicineCount,
      medicines: this.copyMedicines(this.prescription.medicines),
      createDate: new Date().toISOString().split('T')[0],
      isCommon: true
    };

    try {
      let httpRequest = http.createHttp();
      let response = await httpRequest.request(
        "http://10.0.2.2:8080/commonPrescriptions",
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify(newCommonPrescription)
        }
      );
      httpRequest.destroy();

      if (response.responseCode === 200 || response.responseCode === 201) {
        promptAction.showToast({ message: '已添加到常用处方' });
      } else {
        promptAction.showToast({ message: '添加失败' });
      }
    } catch (err) {
      console.error('添加常用处方失败', JSON.stringify(err));
      promptAction.showToast({ message: '添加失败' });
    }
  }

  // 复制药品列表
  copyMedicines(medicines: PrescriptionItem[]): PrescriptionItem[] {
    const newMedicines: PrescriptionItem[] = [];
    for (let i = 0; i < medicines.length; i++) {
      newMedicines.push({
        name: medicines[i].name,
        specification: medicines[i].specification,
        quantity: medicines[i].quantity,
        usageMethod: medicines[i].usageMethod,
        frequency: medicines[i].frequency,
        singleDose: medicines[i].singleDose,
        remark: medicines[i].remark
      });
    }
    return newMedicines;
  }

  build() {
    Stack() {
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.u695'))
            .width(10)
            .height(15)
            .margin({ left: 16 })
            .onClick(() => {
              router.back();
            })

          Text('历史处方详情')
            .fontSize(18)
            .layoutWeight(1)
            .margin({ left: 50 })
            .textAlign(TextAlign.Center)

          Text('查看原始处方')
            .fontSize(14)
            .fontColor('#3677F2')
            .margin({ right: 16 })
            .onClick(() => {
              this.showImagePreview = true;
            })
        }
        .width('100%')
        .height(56)
        .backgroundColor('#fff')

        // 主体内容区域
        Scroll() {
          Column() {
            if (this.prescription) {
              // 处方信息卡片
              Column() {
                // 处方编号和日期
                Row() {
                  Text(`NO: ${this.prescription.id}`)
                    .fontSize(14)
                    .fontColor('#666')

                  Text(this.prescription.createDate)
                    .fontSize(14)
                    .fontColor('#666')
                }
                .width('90%')
                .padding({ top: 16, bottom: 8 })
                .justifyContent(FlexAlign.SpaceBetween)

                // 医院名称
                Text('*****医院处方笺')
                  .fontSize(20)
                  .fontColor('#333')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 12, bottom: 16 })

                Divider().color('#fff').width('100%').height(1)

                // 患者信息
                Column() {
                  Row() {
                    Text('患者姓名')
                      .fontSize(14)
                      .fontColor('#333')
                      .width(80)

                    Text(this.prescription.patientName)
                      .fontSize(14)
                      .fontColor('#3677F2')
                      .layoutWeight(1)
                  }
                  .width('100%')
                  .margin({ top: 16, bottom: 16 })

                  Divider().color('#ddd').width('100%').height(1)

                  Row() {
                    Text('患者年龄')
                      .fontSize(14)
                      .fontColor('#333')
                      .width(80)

                    Text(`${this.prescription.patientAge}岁`)
                      .fontSize(14)
                      .fontColor('#3677F2')
                      .layoutWeight(1)
                  }
                  .width('100%')
                  .margin({ top: 16, bottom: 16 })

                  Divider().color('#aaa').width('100%').height(1)

                  Row() {
                    Text('患者性别')
                      .fontSize(14)
                      .fontColor('#333')
                      .width(80)

                    Text(this.prescription.patientGender)
                      .fontSize(14)
                      .fontColor('#3677F2')
                      .layoutWeight(1)
                  }
                  .width('100%')
                  .margin({ top: 16, bottom: 8 })
                }
                .width('100%')
                .padding({ left: 16, right: 16 })
              }
              .width('92%')
              .backgroundColor('#fff')
              .borderRadius(12)
              .margin({ top: 16 })

              // 诊断卡片
              Column() {
                Text('诊断')
                  .fontSize(14)
                  .fontColor('#333')
                  .width('100%')
                  .margin({ bottom: 12 })

                Text(this.prescription.clinicalDiagnosis)
                  .fontSize(16)
                  .fontColor('#3677F2')
                  .width('100%')
              }
              .width('92%')
              .backgroundColor('#fff')
              .borderRadius(12)
              .padding({ left: 16, right: 16, top: 16, bottom: 16 })
              .margin({ top: 16 })

              // 药品Rp卡片
              Column() {
                Text('Rp')
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333')
                  .margin({ bottom: 20 })
                  .width('100%')

                ForEach(this.prescription.medicines, (medicine: PrescriptionItem) => {
                  Column() {
                    Text(`${medicine.name} ×${medicine.quantity}`)
                      .fontSize(16)
                      .fontColor('#333')
                      .margin({ bottom: 8 })
                      .width('100%')

                    Text(`规格：${medicine.specification}`)
                      .fontSize(13)
                      .fontColor('#666')
                      .margin({ bottom: 4 })
                      .width('100%')

                    if (medicine.usageMethod || medicine.frequency || medicine.singleDose) {
                      Text(`用法用量：${medicine.usageMethod || ''} ${medicine.frequency || ''} ${medicine.singleDose ? medicine.singleDose + '片/次' : ''}`)
                        .fontSize(13)
                        .fontColor('#666')
                        .margin({ bottom: 4 })
                        .width('100%')
                    }

                    if (medicine.remark) {
                      Text(`备注：${medicine.remark}`)
                        .fontSize(13)
                        .fontColor('#999')
                        .width('100%')
                    }

                    if (this.prescription && this.prescription.medicines.indexOf(medicine) < this.prescription.medicines.length - 1) {
                      Divider().color('#eee').margin({ top: 12, bottom: 12 })
                    }
                  }
                  .width('100%')
                })
              }
              .width('92%')
              .backgroundColor('#fff')
              .borderRadius(12)
              .padding({ left: 16, right: 16, top: 16, bottom: 16 })
              .margin({ top: 16 })
            }

            Blank().height(20)
          }
          .width('100%')
        }
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')

        // 底部按钮栏
        Row() {
          Button('设为常用处方')
            .fontSize(14)
            .fontColor('#3677F2')
            .backgroundColor('#fff')
            .border({ width: 1, color: '#3677F2' })
            .borderRadius(22)
            .height(40)
            .layoutWeight(1)
            .onClick(() => {
              this.addToCommonPrescriptions();
            })

          Button('续处方')
            .fontSize(14)
            .fontColor('#fff')
            .backgroundColor('#3677F2')
            .borderRadius(22)
            .height(40)
            .layoutWeight(1)
            .margin({ left: 12 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HomePages/PrescriptionEditPage',
                params: { prescription: JSON.stringify(this.prescription) }
              });
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 20 })
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f5f5f5')

      // 图片预览遮罩层
      if (this.showImagePreview) {
        Column() {
          Row() {
            Blank()
            Text('✕')
              .fontSize(28)
              .fontColor('#fff')
              .width(44)
              .height(44)
              .textAlign(TextAlign.Center)
              .margin({ right: 16, top: 40 })
              .onClick(() => {
                this.showImagePreview = false;
              })
          }
          .width('100%')
          .height(80)

          Column() {
            Image($r('app.media.__80px_u1116'))
              .width('90%')
              .height('70%')
              .objectFit(ImageFit.Contain)
              .borderRadius(8)
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          Text('点击关闭')
            .fontSize(14)
            .fontColor('rgba(255,255,255,0.6)')
            .margin({ bottom: 40 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.9)')
        .position({ x: 0, y: 0 })
        .zIndex(100)
        .onClick(() => {
          this.showImagePreview = false;
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}