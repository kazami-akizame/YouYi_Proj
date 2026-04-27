// 文件名：MedicineSearchPage.ets
import router from '@ohos.router'; // 加在文件最顶部
@Entry
@Component
struct MedicineSearchPage {
  // 绑定搜索框输入值
  //一个会自动刷新页面、专门存搜索框文字、默认是空的变量。
  @State searchText: string = ''
  build() {
    Column() {
      // 1. 顶部状态栏占位（模拟系统状态栏高度）
      Row()
        .width('100%')
        .height(40) // 模拟状态栏高度
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: 20, right: 20 })
      // 2. 搜索栏区域
      Row() {
        // 搜索框
        Stack() {
          Row() {
            Image($r('app.media.u2201'))
              .width(18)
              .height(18)
              .margin({ right: 8 })
              .opacity(0.6)
            TextInput({
              placeholder: '请输入药品信息',
              text: this.searchText
            })
              .placeholderColor('#999999')
              .fontSize(15)
              .backgroundColor(Color.Transparent)
              .layoutWeight(1)
          }
          .width('100%')
          .height(36)
          .padding({ left: 12, right: 12 })
          .backgroundColor('#F5F5F5')
          .borderRadius(18)
        }
        .layoutWeight(1)
        .margin({ right: 12 })

        // 取消按钮
        Text('取消')
          .fontSize(15)
          .fontColor('#666666')
          .onClick(() => {
            this.searchText = ''
            router.pushUrl({ url: 'pages/HomePages/MedicineListPage' }) // 新增
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 12 })
      // 3. 主体空白区域（后续可添加搜索结果列表）
      Stack() {
        // 这里是空白，和参考图一致
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor(Color.White)
      // 4. 底部安全区域适配
      Row()
        .width('100%')
        .height(34) // 适配底部安全区高度
        .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}