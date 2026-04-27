/*import router from '@ohos.router';

@Entry
@Component
struct AddPrescriptionPage {
  @State diagnosis: string = '';



  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();// 返回逻辑
          })

        Text('常用处方')
          .fontSize(18)
          //.layoutWeight(1)
          .textAlign(TextAlign.Center).width('80%')

      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      Divider()
        .height(1)
        .color('#ddd')

      Column() {
        // 诊断
        Column() {
          Text('诊断')
            .fontSize(16)
            .fontColor('#333')
            .margin({ bottom: 8 })
            .width('100%')

          Text('感冒').fontSize(16)
            .fontColor('#3677F2')
            .margin({ bottom: 8 })
            .width('100%')
        }.backgroundColor('#fff')
        .width('90%')
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13)


        // Rp
        Column() {
          Text('Rp')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)

          Blank().height(20)

          Text('钙铁锌咀嚼片 *1') .fontSize(17)
          Text('用法用量：2次/天，每次1片，温水送服').fontSize(14).fontColor('#999')



        }
        .backgroundColor('#fff')
        .width('90%').height(200)
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13).alignItems(HorizontalAlign.Start)

        Blank()
      }.backgroundColor('#f5f5f5').height('100%').width('100%')
      Blank().height(10)
      // 保存常用处方按钮


    }
    .width('100%')
    .height('100%')
  }
}*/


import router from '@ohos.router';

interface Medicine {
  id: string;
  name: string;
  dosage: string;
}

@Entry
@Component
struct AddPrescriptionPage {
  @State diagnosis: string = '感冒';
  @State medicineList: Medicine[] = [
    {
      id: '1',
      name: '钙铁锌咀嚼片 *1',
      dosage: '用法用量：2次/天，每次1片，温水送服'
    }
  ];

  deleteMedicine(id: string) {
    this.medicineList = this.medicineList.filter(item => item.id !== id);
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

        Text('常用处方')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      Divider().height(1).color('#ddd')

      // 内容区域
      Column() {
        // 诊断卡片
        Column() {
          Text('诊断')
            .fontSize(16)
            .fontColor('#333')
            .margin({ bottom: 8 })
            .width('100%')

          Text(this.diagnosis)
            .fontSize(16)
            .fontColor('#3677F2')
            .width('100%')
        }
        .backgroundColor('#fff')
        .width('90%')
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13)

        // 药品列表
        ForEach(this.medicineList, (item: Medicine) => {
          Column() {
            Text('Rp')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 16 })

            Text(item.name)
              .fontSize(17)
              .margin({ bottom: 8 })

            Text(item.dosage)
              .fontSize(14)
              .fontColor('#999')
              .margin({ bottom: 20 })

            Row() {
              Button('删除')
                .fontSize(14)
                .fontColor('#999')
                .backgroundColor('#fff')
                .border({ width: 1, color: '#ddd' })
                .borderRadius(16)
                .width(70)
                .height(32)
                .onClick(() => {
                  this.deleteMedicine(item.id);
                })

              Button('编辑用量')
                .fontSize(14)
                .fontColor('#3677F2')
                .backgroundColor('#fff')
                .border({ width: 1, color: '#3677F2' })
                .borderRadius(16)
                .width(90)
                .height(32)
                .margin({ left: 12 })
                .onClick(() => {
                  console.log('编辑用量', item.id);
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.End)
          }
          .backgroundColor('#fff')
          .width('90%')
          .padding(16)
          .margin({ top: 16 })
          .borderRadius(13)
          .alignItems(HorizontalAlign.Start)
        })

        // +新增药品按钮
        Button('+ 新增药品')
          .width('90%')
          .height(44)
          .fontSize(16)
          .fontColor('#3677F2')
          .backgroundColor('#fff')
          .border({ width: 1, color: '#3677F2' })
          .borderRadius(22)
          .margin({ top: 16 })
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ACPSDCPPage',
              //params: { diseaseName: drug.name }
            });
          })
      }
      .backgroundColor('#f5f5f5')
      .width('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Center)

      // 保存常用处方按钮
      Button('保存常用处方')
        .width('90%')
        .height(48)
        .fontSize(16)
        .fontColor('#fff')
        .backgroundColor('#3677F2')
        .borderRadius(24)
        .margin({ bottom: 20, top: 10 })
        .onClick(() => {
          console.log('保存常用处方');
          router.back();
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}