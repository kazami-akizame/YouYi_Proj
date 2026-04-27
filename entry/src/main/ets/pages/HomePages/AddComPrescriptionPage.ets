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

        Text('新增常用处方')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
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

          // 多行输入框
          TextArea({ placeholder: '请输入诊断' })
            .width('100%')
            .height(64)
            .backgroundColor('#fff')
            .borderRadius(8)
            .padding({ left:1, top: 8 })
            .maxLines(4)  // 最大4行
            .onChange((value: string) => {
              this.diagnosis = value;
            })

        }.backgroundColor('#fff')
        .width('90%')
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13)


        // Rp
        Column() {
          Row() {
            Text('Rp')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')


          Blank().height(15)

          // +新增药品
          Row() {
            Text('+新增药品')
              .fontSize(18)
              .fontColor('#3677F2')//.borderWidth(1).width('90%')
          }.borderWidth(1).borderStyle(BorderStyle.Dashed).borderRadius(24).borderColor('#3677F2')
          .width('100%').height(50).justifyContent(FlexAlign.Center)
          .padding({
            top: 1,
          })
          .onClick(() => {  // 👈 添加这行：点击跳转
            router.pushUrl({
              url: 'pages/HomePages/ACPSDCPPage',
              //params: { diseaseName: drug.name }
            });
          })
        }
        .backgroundColor('#fff')
        .width('90%')
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13)

        Blank()
      }.backgroundColor('#f5f5f5').height('85%').width('100%')
      Blank().height(10)
        // 保存常用处方按钮
        Button('保存常用处方')
          .width('90%')
          .height(48)
          .fontSize(16)
          .fontColor('#fff')
          .backgroundColor('#3677F2')
          .borderRadius(24)
          .margin({ bottom: 1 })
          .onClick(() => {
            console.log('保存常用处方');
            router.back();
          })

    }
    .width('100%')
    .height('100%')
    //.backgroundColor('#fff')
  }
}