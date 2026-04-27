import router from '@ohos.router';

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

        Text('常用处方详情')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('编辑').fontColor('#3677F2').fontSize(17).margin({right:16}).onClick(() => {
          router.pushUrl({
            url: 'pages/',
            //params: { diseaseName: drug.name }
          });
        })


      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff').justifyContent(FlexAlign.SpaceBetween)

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
        .width('90%')
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
}