import router from '@ohos.router';
import type { Prescription, PrescriptionItem } from './MypharmacyPage';

// 正确的路由参数类型（对象，不是 string）
interface RouterParams {
  prescription: Prescription;
}

@Entry
@Component
struct PresciptionPage {
  @State prescription: Prescription | null = null;

  aboutToAppear() {
    // ✅ 正确断言为自定义对象类型，无 any、无 unknown
    const params = router.getParams() as RouterParams;

    // ✅ 正确接收对象
    if (params) {
      this.prescription = params.prescription;
      console.log("✅ 成功收到处方数据:", JSON.stringify(this.prescription));
    }
  }

  build() {
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

        Text('常用处方详情')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('编辑')
          .fontColor('#3677F2')
          .fontSize(17)
          .margin({ right: 16 })
          .onClick(() => {
            if (this.prescription) {
              router.pushUrl({
                url: 'pages/HomePages/EditComPrePage',
                params: { prescription: this.prescription }
              });
            }
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')
      .justifyContent(FlexAlign.SpaceBetween)

      Divider().height(1).color('#ddd')
      Blank().height(15)

      if (this.prescription) {
        Column({ space: 16 }) {
          // 诊断
          Column() {
            Text('诊断')
              .fontSize(16)
              .fontColor('#333')
              .width('100%')
            Text(this.prescription.clinicalDiagnosis)
              .fontSize(16)
              .fontColor('#3677F2')
              .margin({ top: 8 })
              .width('100%')
          }
          .width('90%')
          .padding(16)
          .backgroundColor('#fff')
          .borderRadius(13)

          // 药品列表
          Column() {
            Text('Rp')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            ForEach(this.prescription.medicines, (med: PrescriptionItem) => {
              Column({ space: 4 }) {
                Text(`${med.name} ×${med.quantity}盒`)
                  .fontSize(17)
                Text(`规格：${med.specification}`)
                  .fontSize(14)
                  .fontColor('#999')

                if (med.usageMethod || med.frequency || med.singleDose) {
                  Text(`用法：${med.usageMethod || ''} ${med.frequency || ''} ${med.singleDose ? med.singleDose + '片/次' : ''}`)
                    .fontSize(14)
                    .fontColor('#666')
                    .margin({ top: 4, bottom: 4 })
                }

                if (med.remark) {
                  Text(`备注：${med.remark}`)
                    .fontSize(14)
                    .fontColor('#666')
                    .margin({ bottom: 4 })
                }


              }
              .width('100%')
              .margin({ bottom: 12 })
              .alignItems(HorizontalAlign.Start)
            })
          }
          .width('90%')
          .padding(16)
          .backgroundColor('#fff')
          .borderRadius(13)
          .alignItems(HorizontalAlign.Start)
        }
        .width('100%')
      } else {
        Column() {
          Text('暂无处方数据')
            .fontSize(14)
            .fontColor('#999')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}


