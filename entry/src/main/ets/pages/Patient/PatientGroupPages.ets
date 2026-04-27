import { GroupItem } from './PatientModels'

@Component
export struct ManageGroupPage {
  @Link activePage: string;
  private readonly groups: string[] = ['默认分组', '流行性感冒', '病毒性感冒', '咽炎'];

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = '患者';
          })
        Blank()
        Text('管理分组').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(28)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 10 })
      List() {
        ForEach(this.groups, (item: string) => {
          ListItem() {
            Row() {
              Image($r('app.media.u4850'))
                .width(22)
                .height(22)
                .syncLoad(true)
                .objectFit(ImageFit.Contain)
                .margin({ right: 12 })
              Text(item)
                .fontSize(20)
                .layoutWeight(1)
                .textAlign(TextAlign.Start)
              Image($r('app.media.u4848'))
                .width(22)
                .height(22)
                .syncLoad(true)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 14, bottom: 14 })
          }
        }, (item: string) => item)
      }
      .layoutWeight(1)
      .width('100%')

      Button('+ 新增分组')
        .width('92%')
        .height(48)
        .margin({ bottom: 14 })
        .backgroundColor('#3F74F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct ModifyGroupPage {
  @Link activePage: string;
  /** 左上角返回时回到的页面（进入前由患者资料页写入） */
  @Prop cancelReturnPage: string = '患者资料';

  /** 已选中的分组名（多选），与患者资料页「分组」展示共用 */
  @Link patientGroupSelection: string[];

  private readonly groups: GroupItem[] = [
    new GroupItem('默认分组', '20人'),
    new GroupItem('发热门诊', '2人'),
    new GroupItem('流行性感冒', '10人'),
    new GroupItem('病毒性感冒', '2人'),
    new GroupItem('咽炎', '6人')
  ];

  private isGroupSelected(name: string): boolean {
    return this.patientGroupSelection.indexOf(name) >= 0;
  }

  private toggleGroupSelection(name: string): void {
    if (this.isGroupSelected(name)) {
      this.patientGroupSelection = this.patientGroupSelection.filter((n: string) => n !== name);
    } else {
      this.patientGroupSelection = this.patientGroupSelection.concat([name]);
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
        Blank()
        Text('修改分组').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text('保存')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      .backgroundColor('#FFFFFF')

      Text('请选择患者吴珊珊所属的分组（可多选）')
        .fontSize(16)
        .fontColor('#666666')
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 6 })

      List() {
        ForEach(this.groups, (item: GroupItem) => {
          ListItem() {
            Row() {
              if (this.isGroupSelected(item.name)) {
                Image($r('app.media.u3078'))
                  .width(22)
                  .height(22)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 10 })
              } else {
                Text('○')
                  .fontSize(22)
                  .fontColor('#C8C8C8')
                  .margin({ right: 10 })
              }
              Text(item.name).fontSize(20)
              Blank()
              Text(item.count).fontSize(16).fontColor('#999999')
            }
            .padding({ left: 16, right: 16, top: 14, bottom: 14 })
            .onClick(() => {
              this.toggleGroupSelection(item.name);
            })
          }
        }, (item: GroupItem) => item.name)
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}
