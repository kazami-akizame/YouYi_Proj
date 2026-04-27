// ServiceSetting.ets 问诊服务设置页面
// DevEco Studio 可直接运行 零报错
import router from '@ohos.router';

interface PackageItem {
  id: number;
  name: string;
  price: string;
  selected: boolean;
}

@Entry
@Component
struct ServiceSettingPage {
  @State consultSwitch: boolean = true;
  @State privateDoctorSwitch: boolean = true;
  @State consultPrice: string = "¥29.00";
  @State packageList: PackageItem[] = [
    { id: 1, name: "一个月", price: "¥300", selected: true },
    { id: 2, name: "三个月", price: "¥720", selected: true },
    { id: 3, name: "半年", price: "¥1200", selected: true },
    { id: 4, name: "一年", price: "¥2000", selected: true },
    { id: 5, name: "两年", price: "¥3600", selected: true },
  ];

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

      Column(){
        Scroll() {
        Column() {
          Text('问诊服务设置')
            .fontSize(15)
            .fontColor('#666')
            .width('100%')
            .padding({ left: 16, top: 12, bottom: 8 })
            .backgroundColor('#F5F5F5')

          // 接诊开关：左侧文字全屏左对齐，开关全屏右对齐（完全匹配截图）
          this.switchItem('接诊开关', '已开启，患者可向您发起问诊', this.consultSwitch, (val: boolean)=>{this.consultSwitch=val})
          // 问诊价格条目同步左右对齐样式
          this.arrowItem('问诊价格', this.consultPrice,()=>{router.replaceUrl({url:'pages/SetConsultPrice'})})

          Text('私人医生服务设置')
            .fontSize(15)
            .fontColor('#666')
            .width('100%')
            .padding({ left: 16, top: 16, bottom: 8 })
            .backgroundColor('#F5F5F5')

          // 私人医生开关：和接诊开关完全一致，左侧左对齐、开关右侧对齐
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
      }.justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // ✅【核心修改】左侧标题+描述严格屏幕左对齐，Switch严格屏幕右对齐
  @Builder
  switchItem(title: string, desc: string, state: boolean, onChange: (val: boolean)=>void) {
    Row() {
      // 左侧文字容器：强制左对齐，顶到屏幕左边距
      Column() {
        Text(title)
          .fontSize(20)
          .fontColor('#222222')
          .textAlign(TextAlign.Start) // 文字左对齐
        Text(desc)
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
          .textAlign(TextAlign.Start) // 描述文字左对齐
      }
      .alignItems(HorizontalAlign.Start) // 整个左侧列左对齐
      .padding({ left: 0 })

      Flex() // 自动占满中间全部空白，把开关死死顶到屏幕最右侧

      // 右侧开关：固定屏幕最右侧右对齐
      Toggle({ type: ToggleType.Switch, isOn: state })
        .selectedColor('#007AFF')
        .alignSelf(ItemAlign.Center)
        .onChange(onChange)
    }.justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({ left:16, right:16, top:16, bottom:16 })
    .backgroundColor(Color.White)
    Divider().strokeWidth(1).color('#EEE')
  }

  // 问诊价格条目同步同款左右对齐样式
  @Builder
  arrowItem(title: string, price: string, onClick: ()=>void) {
    Row() {
      Text(title)
        .fontSize(20)
        .fontColor('#222222')
        .textAlign(TextAlign.Start)
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

  // ✅ 之前修复的Checkbox零报错写法完全保留不变
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