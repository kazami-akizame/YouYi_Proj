import { GroupItem } from './PatientModels'

@Component
export struct PatientMainPage {
  @Link activePage: string;
  @Link searchReturnPage: string;
  @State private searchText: string = '';

  private readonly groups: GroupItem[] = [
    new GroupItem('默认分组', '20人'),
    new GroupItem('发热门诊', '2人'),
    new GroupItem('流行性感冒', '10人'),
    new GroupItem('病毒性感冒', '2人'),
    new GroupItem('咽炎', '6人')
  ];

  build() {
    Column() {
      Row() {
        Text('患者').fontSize(26).fontWeight(FontWeight.Medium)
        Blank()
        Text('群发消息').fontSize(18).fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = '新建群发';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })

      Row({ space: 8 }) {
        Image($r('app.media.u2201'))
          .width(18)
          .height(18)
          .opacity(0.6)
        TextInput({ text: this.searchText, placeholder: '请输入患者相关信息' })
          .layoutWeight(1)
          .height(40)
          .padding(0)
          .fontSize(16)
          .fontColor('#333333')
          .placeholderColor('#B4B9C2')
          .backgroundColor(Color.Transparent)
          .border({ width: 0 })
          .onChange((value: string) => {
            this.searchText = value;
          })
          .onClick(() => {
            this.searchReturnPage = '患者';
            this.activePage = '搜索患者';
          })
      }
      .width('92%')
      .height(42)
      .margin({ bottom: 10 })
      .padding({ left: 12, right: 12 })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#F4F5F7')
      .borderRadius(21)
      .onClick(() => {
        this.searchReturnPage = '患者';
        this.activePage = '搜索患者';
      })

      Row() {
        Row({ space: 8 }) {
          Image($r('app.media.u4788'))
            .width(20)
            .height(20)
          Text('患者分组').fontSize(20).fontWeight(FontWeight.Medium)
        }
        Blank()
        Row({ space: 6 }) {
          Image($r('app.media.u1024'))
            .width(18)
            .height(18)
          Text('管理分组').fontSize(18).fontColor('#4A74F5')
        }
          .onClick(() => {
            this.activePage = '管理分组';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })

      List() {
        ForEach(this.groups, (item: GroupItem, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Blank()
                  .width(28)
                Text(item.name)
                  .fontSize(20)
                  .fontWeight(FontWeight.Medium)
                Blank()
                Text(item.count)
                  .fontSize(16)
                  .fontColor('#999999')
                Image($r('app.media.u4795'))
                  .width(10)
                  .height(16)
                  .margin({ left: 8 })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14, bottom: 14 })
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                this.activePage = '默认分组';
              })

              if (index < this.groups.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (item: GroupItem) => item.name)
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}
