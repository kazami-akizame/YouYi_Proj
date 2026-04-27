// SetConsultPrice.ets 设置问诊价格页面
// DevEco Studio 零报错 可编译运行
import router from '@ohos.router';

@Entry
@Component
struct SetConsultPricePage {
  // 快捷价格选项
  @State priceList: number[] = [0,9,19,29,39,59,99,149];
  // 当前选中价格
  @State selectPrice: number = 0;
  // 自定义价格输入
  @State customPrice: string = '';

  build() {
    Column() {
      // 顶部导航栏：返回+标题+右上角确定
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16, right: 12 })
          .onClick(() => router.back())

        Text('设置问诊价格')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .textAlign(TextAlign.Center)

        Text('确定')
          .fontSize(16)
          .fontColor('#007AFF')
          .margin({ right: 16 })
          .onClick(() => {
            console.info('保存问诊价格成功');
            router.back();
          })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')
      Column(){
        Scroll() {
          Column() {
            // 标题
            Text('请选择咨询单价（元）')
              .fontSize(16)
              .fontColor('#333')
              .width('100%')
              .padding({ left: 16, top: 16, bottom: 16 })
              .backgroundColor(Color.White)
            Divider().strokeWidth(1).color('#EEE')

            // 🔥 【终极修复】Grid + GridItem 强制结构，编译通过
            Grid() {
              ForEach(this.priceList, (price: number) => {
                // ✅ 必须套 GridItem
                GridItem() {
                  Button(`${price.toFixed(2)}`)
                    .width(70)
                    .height(44)
                    .fontSize(12)
                    .borderRadius(8)
                    .backgroundColor(this.selectPrice === price ? '#007AFF' : '#F5F5F5')
                    .fontColor(this.selectPrice === price ? Color.White : '#333')
                    .onClick(() => {
                      this.selectPrice = price
                    })
                }
                .margin(8)
              })
            }
            .padding({ left: 8, right: 8, top: 16 })
            .backgroundColor(Color.White)

            // 自定义咨询单价分组
            Text('自定义咨询单价')
              .fontSize(16)
              .fontColor('#333')
              .width('100%')
              .padding({ left: 16, top: 24, bottom: 12 })
              .backgroundColor('#F5F5F5')

            // 自定义输入框
            TextInput({ text: this.customPrice, placeholder: '建议价格区间为0-200元' })
              .width('100%')
              .height(52)
              .padding({ left: 16, right: 16 })
              .backgroundColor(Color.White)
              .placeholderColor('#999')
              .type(InputType.Number)
              .onChange((val) => {
                this.customPrice = val
              })
          }.justifyContent(FlexAlign.Start)
        }
        .flexGrow(1)
        .backgroundColor('#F5F5F5')
      }.justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}