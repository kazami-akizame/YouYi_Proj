// ServiceSetting.ets 问诊服务设置页面（最终修复版 + 实时显示价格）
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

interface PackageItem {
  id: number;
  name: string;
  price: string;
  selected: boolean;
}

@Component
struct PriceSelectDialog {
  private priceList: number[] = [0, 9, 19, 29, 39, 59, 99, 149];
  @Link @Watch('onPriceChange') selectPrice: number;
  @State customPrice: string = '';

  onClose: () => void = () => {};
  onConfirm: (price: number) => void = () => {};

  onPriceChange() {
    this.customPrice = '';
  }

  build() {
    Column() {
      Row() {
        Text('设置问诊价格')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .padding({ top: 16, bottom: 16 })
      .justifyContent(FlexAlign.Center)

      Divider().strokeWidth(1).color('#EEE')

      Scroll() {
        Column() {
          // ✅【新增】实时显示当前问诊价格
          Text(`当前价格：¥${this.selectPrice.toFixed(2)}`)
            .fontSize(16)
            .fontColor('#007AFF')
            .width('100%')
            .padding({ left: 16, top: 8, bottom: 8 })
            .backgroundColor('#F5F5F5')

          Text('请选择咨询单价（元）')
            .fontSize(16)
            .fontColor('#333')
            .width('100%')
            .padding({ left: 16, top: 16, bottom: 16 })

          Grid() {
            ForEach(this.priceList, (price: number) => {
              GridItem() {
                Button(`${price.toFixed(2)}`)
                  .width(70)
                  .height(44)
                  .fontSize(10)
                  .borderRadius(8)
                  .backgroundColor(this.selectPrice === price && this.customPrice === '' ? '#007AFF' : '#F5F5F5')
                  .fontColor(this.selectPrice === price && this.customPrice === '' ? Color.White : '#333')
                  .onClick(() => {
                    this.selectPrice = price;
                  })
              }
              .margin(8)
            })
          }
          .padding({ left: 8, right: 8 })
          .columnsTemplate('1fr 1fr 1fr 1fr')
          .rowsGap(8)
          .columnsGap(8)

          Text('自定义咨询单价')
            .fontSize(16)
            .fontColor('#333')
            .width('100%')
            .padding({ left: 16, top: 24, bottom: 12 })

          TextInput({ text: this.customPrice, placeholder: '建议价格区间为0-200元' })
            .width('90%')
            .height(52)
            .padding({ left: 16, right: 16 })
            .backgroundColor('#F5F5F5')
            .placeholderColor('#999')
            .type(InputType.Number)
            .borderRadius(8)
            .onChange((val) => {
              this.customPrice = val;
            })
            .margin({ bottom: 24 })
        }
      }
      .flexGrow(1)

      Row() {
        Button('取消')
          .width('45%')
          .height(44)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .fontColor('#333')
          .borderRadius(8)
          .onClick(() => {
            this.onClose();
          })

        Button('确定')
          .width('45%')
          .height(44)
          .fontSize(16)
          .backgroundColor('#007AFF')
          .fontColor(Color.White)
          .borderRadius(8)
          .onClick(() => {
            let finalPrice: number;
            if (this.customPrice.trim() !== '') {
              finalPrice = parseFloat(this.customPrice);
              if (isNaN(finalPrice) || finalPrice < 0 || finalPrice > 200) {
                promptAction.showToast({ message: '请输入0-200之间的有效价格', duration: 2000 });
                return;
              }
            } else {
              finalPrice = this.selectPrice;
            }
            this.onConfirm(finalPrice);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .padding({ bottom: 24, top: 16 })
    }
    .width('95%')
    .backgroundColor(Color.White)
    .borderRadius(12)
  }
}

@Entry
@Component
struct ServiceSettingPage {
  @State consultSwitch: boolean = true;
  @State privateDoctorSwitch: boolean = true;
  @State consultPriceNum: number = 29;
  @State isPriceDialogOpen: boolean = false;
  @State packageList: PackageItem[] = [
    { id: 1, name: "一个月", price: "¥300", selected: true },
    { id: 2, name: "三个月", price: "¥720", selected: true },
    { id: 3, name: "半年", price: "¥1200", selected: true },
    { id: 4, name: "一年", price: "¥2000", selected: true },
    { id: 5, name: "两年", price: "¥3600", selected: true },
  ];

  get consultPriceText(): string {
    return `¥${this.consultPriceNum.toFixed(2)}`;
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16, right: 12 })
          .onClick(() => router.back())

        Text('问诊服务设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .textAlign(TextAlign.Center)

        Text('确定')
          .fontSize(16)
          .fontColor('#007AFF')
          .margin({ right: 16 })
          .onClick(() => router.back())
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')

      Scroll() {
        Column() {
          Text('问诊服务设置')
            .fontSize(15)
            .fontColor('#666')
            .width('100%')
            .padding({ left: 16, top: 12, bottom: 8 })
            .backgroundColor('#F5F5F5')

          this.switchItem('接诊开关', '已开启，患者可向您发起问诊', this.consultSwitch, (val: boolean)=>{this.consultSwitch=val})

          // ✅ 主页面实时显示价格（原有逻辑，已生效）
          this.arrowItem('问诊价格', this.consultPriceText, ()=>{
            this.isPriceDialogOpen = true;
          })

          // Text(`当前价格：¥${this.selectPrice.toFixed(2)}`)
          //   .fontSize(16)
          //   .fontColor('#007AFF')
          //   .width('100%')
          // .padding({ left: 16, top: 8, bottom: 8 })
          //   .backgroundColor('#F5F5F5')

          Text('私人医生服务设置')
            .fontSize(15)
            .fontColor('#666')
            .width('100%')
            .padding({ left: 16, top: 16, bottom: 8 })
            .backgroundColor('#F5F5F5')

          this.switchItem('私人医生开关', '已开启，患者可购买套餐', this.privateDoctorSwitch, (val: boolean)=>{this.privateDoctorSwitch=val})

          Text('选择套餐类型（可多选）')
            .fontSize(15)
            .fontColor('#333')
            .width('100%')
            .padding({ left: 16, top: 16, bottom: 12 })
            .backgroundColor(Color.White)

          ForEach(this.packageList, (item: PackageItem, index: number)=>{
            this.checkItem(item, index)
          })
        }
      }
      .flexGrow(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .bindSheet($$this.isPriceDialogOpen, this.PriceDialogBuilder(), {
      height: 550,
      backgroundColor: '#F5F5F5'
    })
  }

  @Builder
  PriceDialogBuilder() {
    PriceSelectDialog({
      selectPrice: $consultPriceNum,
      onClose: () => {
        this.isPriceDialogOpen = false;
      },
      onConfirm: (price: number) => {
        this.consultPriceNum = price;
        this.isPriceDialogOpen = false;
        promptAction.showToast({ message: `价格已设置为¥${price.toFixed(2)}` });
      }
    })
  }

  @Builder
  switchItem(title: string, desc: string, state: boolean, onChange: (val: boolean)=>void) {
    Row() {
      Column() {
        Text(title)
          .fontSize(20)
          .fontColor('#222222')
        Text(desc)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Start)
      Flex()
      Toggle({ type: ToggleType.Switch, isOn: state })
        .selectedColor('#007AFF')
        .alignSelf(ItemAlign.Center)
        .onChange(onChange)
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left:16, right:16, top:16, bottom:16 })
    .backgroundColor(Color.White)
    Divider().strokeWidth(1).color('#EEE')
  }

  @Builder
  arrowItem(title: string, price: string, onClick: ()=>void) {
    Row() {
      Text(title)
        .fontSize(20)
        .fontColor('#222222')
      Flex()
      Text(price).fontSize(20).fontColor('#FF9500')
      Image($r('app.media.ic_public_jiantou')).width(16).height(16).margin({left:6})
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left:16, right:16, top:16, bottom:16 })
    .backgroundColor(Color.White)
    .onClick(onClick)
    Divider().strokeWidth(1).color('#EEE')
  }

  @Builder
  checkItem(item: PackageItem, index: number) {
    Row() {
      Checkbox()
        .select(item.selected)
        .selectedColor('#007AFF')
        .onChange((val: boolean) => {
          this.packageList[index].selected = val;
        })
      Text(item.name).fontSize(16).fontColor('#333').margin({ left:10 })
      Flex()
      Text(item.price).fontSize(16).fontColor('#FF9500')
    }
    .width('100%')
    .padding({ left:16, right:16, top:12, bottom:12 })
    .backgroundColor(Color.White)
    Divider().strokeWidth(1).color('#EEE')
  }
}