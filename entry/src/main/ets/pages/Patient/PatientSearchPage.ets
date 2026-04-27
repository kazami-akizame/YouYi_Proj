@Component
export struct SearchPatientPage {
  @Link activePage: string;
  /** 取消时回到的页面标识，由进入搜索页面前的页面写入（如「患者」「选择患者」） */
  @Prop cancelReturnPage: string = '患者';

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '请输入患者信息' })
          .layoutWeight(1)
          .height(42)
          .backgroundColor('#F4F5F7')
        Text('取消')
          .fontSize(18)
          .fontColor('#7A7A7A')
          .margin({ left: 10 })
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}
