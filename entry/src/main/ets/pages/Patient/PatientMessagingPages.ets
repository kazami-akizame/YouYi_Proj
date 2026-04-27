import { GroupItem } from './PatientModels'

@Component
export struct CreateBroadcastPage {
  @Link activePage: string;
  /** 接收人列表（示例 7 人：一屏约显示 5 个头像，更多可横向滑动） */
  private readonly recipientKeys: number[] = [1, 2, 3, 4, 5, 6, 7];

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .onClick(() => {
            this.activePage = '患者';
          })
          .margin({ right: 8 })
        Text('新建群发').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text('群发历史')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = '群发历史';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })

      Text('群发内容').fontSize(20).fontWeight(FontWeight.Medium).width('100%').padding({ left: 16, right: 16 })
      TextArea({ placeholder: '可将就诊通知/文章等消息发送给患者' })
        .width('100%')
        .height(180)
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      Column({ space: 8 }) {
        Row() {
          Text(`接收人（已选择${this.recipientKeys.length}人）`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
          Image($r('app.media.u4795'))
            .width(16)
            .height(16)
            .syncLoad(true)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.activePage = '选择患者';
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Scroll() {
          Row({ space: 16 }) {
            ForEach(this.recipientKeys, (item: number) => {
              Column({ space: 4 }) {
                Image($r('app.media.__80px_u1228'))
                  .width(50)
                  .height(44)
                  .syncLoad(true)
                  .borderRadius(22)
                  .objectFit(ImageFit.Cover)
                Text('吴珊珊').fontSize(14)
              }
            }, (item: number) => item.toString())
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .padding({ right: 4 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height(72)
        .align(Alignment.Start)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF')

      Text('每日发送上限为10条，今日还可发送6条')
        .fontSize(14)
        .fontColor('#909090')
        .width('100%')
        .padding({ left: 16, right: 16 })

      Blank()
      Button('确认发送').width('92%').height(48).margin({ bottom: 14 }).backgroundColor('#3F74F5')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct BroadcastHistoryPage {
  @Link activePage: string;

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = '新建群发';
          })
        Blank()
        Text('群发历史').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      TextInput({ placeholder: '请输入群发消息关键字' })
        .width('92%')
        .height(42)
        .backgroundColor('#F4F5F7')
        .onClick(() => {
          this.activePage = '搜索消息';
        })

      List() {
        ForEach([1, 2, 3, 4, 5], (item: number, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Column({ space: 6 }) {
                  Text('低热、咳嗽超过7天，应排除肺结核、支原体...').fontSize(18)
                  Text('2020-01-09 12:09').fontSize(14).fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Image($r('app.media.u4795'))
                  .width(16)
                  .height(16)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                this.activePage = '消息详情';
              })

              if (index < 4) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (item: number) => item.toString())
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct SearchMessagePage {
  @Link activePage: string;

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '请输入群发消息关键字' })
          .layoutWeight(1)
          .height(42)
          .backgroundColor('#F4F5F7')
        Text('取消')
          .fontSize(18)
          .fontColor('#7A7A7A')
          .margin({ left: 10 })
          .onClick(() => {
            this.activePage = '群发历史';
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

@Component
export struct MessageDetailPage {
  @Link activePage: string;
  private readonly recipientKeys: number[] = [1, 2, 3, 4, 5, 6, 7];

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = '群发历史';
          })
        Blank()
        Text('消息详情').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      Column({ space: 10 }) {
        Text('群发内容').fontSize(20).fontWeight(FontWeight.Medium)
        Text('2020-01-09 12:09').fontSize(14).fontColor('#999999')
        Text('低热、咳嗽超过7天，应排除肺结核、支原体肺炎。突然寒战、高热，伴有呼吸道症状...')
          .fontSize(16)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Start)

      Column({ space: 8 }) {
        Text(`接收人（${this.recipientKeys.length}人）`).fontSize(18).fontWeight(FontWeight.Medium)
        Scroll() {
          Row({ space: 16 }) {
            ForEach(this.recipientKeys, (item: number) => {
              Column({ space: 4 }) {
                Image($r('app.media.__80px_u1228'))
                  .width(50)
                  .height(44)
                  .syncLoad(true)
                  .borderRadius(22)
                  .objectFit(ImageFit.Cover)
                Text('吴珊珊').fontSize(14)
              }
            }, (item: number) => item.toString())
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .padding({ right: 4 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height(72)
        .align(Alignment.Start)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF')

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct SelectPatientPage {
  @Link activePage: string;
  @Link searchReturnPage: string;
  /** 与 groups 下标对应：第 0 行「所有患者」的勾选表示下方分组是否已全选 */
  @State private rowSelected: boolean[] = [false, false, false, false, false, false];

  private readonly groups: GroupItem[] = [
    new GroupItem('所有患者', '38人'),
    new GroupItem('默认分组', '20人'),
    new GroupItem('发热门诊', '2人'),
    new GroupItem('流行性感冒', '10人'),
    new GroupItem('病毒性感冒', '2人'),
    new GroupItem('咽炎', '6人')
  ];

  private allBelowSelected(): boolean {
    for (let k = 1; k < this.rowSelected.length; k++) {
      if (!this.rowSelected[k]) {
        return false;
      }
    }
    return true;
  }

  private selectedBelowCount(): number {
    let n = 0;
    for (let k = 1; k < this.rowSelected.length; k++) {
      if (this.rowSelected[k]) {
        n++;
      }
    }
    return n;
  }

  /** 左侧勾选图标是否显示「已选」：第 0 行与下方全选一致；其余行看 rowSelected */
  private isLeftChecked(index: number): boolean {
    if (index === 0) {
      return this.allBelowSelected();
    }
    return this.rowSelected[index];
  }

  private toggleRow(index: number): void {
    let len = this.rowSelected.length;
    let next: boolean[] = [];
    for (let k = 0; k < len; k++) {
      next.push(this.rowSelected[k]);
    }
    if (index === 0) {
      let turnOff = this.allBelowSelected();
      for (let k = 1; k < len; k++) {
        next[k] = !turnOff;
      }
    } else {
      next[index] = !next[index];
    }
    this.rowSelected = next;
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
            this.activePage = '新建群发';
          })
        Blank()
        Text('选择患者').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      TextInput({ placeholder: '请输入患者相关信息' })
        .width('92%')
        .height(42)
        .margin({ bottom: 8 })
        .backgroundColor('#F4F5F7')
        .onClick(() => {
          this.searchReturnPage = '选择患者';
          this.activePage = '搜索患者';
        })
      List() {
        ForEach(this.groups, (item: GroupItem, index: number) => {
          ListItem() {
            Column() {
              Row() {
                if (this.isLeftChecked(index)) {
                  Image($r('app.media.u3078'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 10 })
                    .onClick(() => {
                      this.toggleRow(index);
                    })
                } else {
                  Image($r('app.media.u3077'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .opacity(0.9)
                    .margin({ right: 10 })
                    .onClick(() => {
                      this.toggleRow(index);
                    })
                }
                Row() {
                  Text(item.name).fontSize(20)
                  Blank()
                  Text(item.count).fontSize(16).fontColor('#999999')
                  Image($r('app.media.u4795'))
                    .width(16)
                    .height(16)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                }
                .layoutWeight(1)
                .width('100%')
                .alignItems(VerticalAlign.Center)
                .onClick(() => {
                  this.activePage = '我的患者';
                })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14, bottom: 14 })
              .alignItems(VerticalAlign.Center)
              .backgroundColor('#FFFFFF')

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

      Row() {
        Text('已选择' + this.selectedBelowCount().toString() + '项分组')
          .fontSize(16)
          .fontColor('#888888')
        Blank()
        Text('确定')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            if (this.selectedBelowCount() > 0) {
              this.activePage = '新建群发';
            }
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 14 })
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct MyPatientsPage {
  @Link activePage: string;
  @Link searchReturnPage: string;
  @State private rowSelected: boolean[] = [false, false, false, false, false];

  private allPatientsSelected(): boolean {
    for (let k = 0; k < this.rowSelected.length; k++) {
      if (!this.rowSelected[k]) {
        return false;
      }
    }
    return true;
  }

  private selectedPatientCount(): number {
    let n = 0;
    for (let k = 0; k < this.rowSelected.length; k++) {
      if (this.rowSelected[k]) {
        n++;
      }
    }
    return n;
  }

  private toggleSelectAll(): void {
    let turnOff = this.allPatientsSelected();
    let next: boolean[] = [];
    for (let k = 0; k < 5; k++) {
      next.push(!turnOff);
    }
    this.rowSelected = next;
  }

  private togglePatientRow(index: number): void {
    let next: boolean[] = [];
    for (let k = 0; k < 5; k++) {
      next.push(this.rowSelected[k]);
    }
    next[index] = !next[index];
    this.rowSelected = next;
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
            this.activePage = '选择患者';
          })
        Blank()
        Text('我的患者').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      TextInput({ placeholder: '请输入患者相关信息' })
        .width('92%')
        .height(42)
        .margin({ bottom: 8 })
        .backgroundColor('#F4F5F7')
        .onClick(() => {
          this.searchReturnPage = '我的患者';
          this.activePage = '搜索患者';
        })

      List() {
        ListItem() {
          Column() {
            Row() {
              if (this.allPatientsSelected()) {
                Image($r('app.media.u3078'))
                  .width(22)
                  .height(22)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.toggleSelectAll();
                  })
              } else {
                Image($r('app.media.u3077'))
                  .width(22)
                  .height(22)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
                  .opacity(0.9)
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.toggleSelectAll();
                  })
              }
              Text('全选')
                .fontSize(20)
                .textAlign(TextAlign.Start)
              Blank()
              Text('5人').fontSize(16).fontColor('#999999')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            Divider()
              .strokeWidth(0.5)
              .color('#E8E8E8')
              .margin({ left: 16, right: 16 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }

        ForEach([0, 1, 2, 3, 4], (index: number) => {
          ListItem() {
            Column() {
              Row() {
                if (this.rowSelected[index]) {
                  Image($r('app.media.u3078'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 8 })
                    .onClick(() => {
                      this.togglePatientRow(index);
                    })
                } else {
                  Image($r('app.media.u3077'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .opacity(0.9)
                    .margin({ right: 8 })
                    .onClick(() => {
                      this.togglePatientRow(index);
                    })
                }
                Image($r('app.media.__80px_u1228'))
                  .width(48)
                  .height(48)
                  .syncLoad(true)
                  .borderRadius(24)
                  .objectFit(ImageFit.Cover)
                  .margin({ right: 12 })
                Column({ space: 5 }) {
                  Text('吴珊珊 女 23岁').fontSize(18)
                  Text('添加时间：2020-01-09').fontSize(14).fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Blank()
                Text('专家问诊')
                  .fontSize(12)
                  .fontColor('#CFAF3A')
                  .backgroundColor('#FFF4C9')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(10)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .alignItems(VerticalAlign.Center)

              if (index < 4) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (index: number) => 'p' + index.toString())
      }
      .layoutWeight(1)
      .width('100%')

      Row() {
        Text('已选择' + this.selectedPatientCount().toString() + '人')
          .fontSize(16)
          .fontColor('#888888')
        Blank()
        Button('确定')
          .type(ButtonType.Normal)
          .fontSize(18)
          .fontColor('#4A74F5')
          .backgroundColor(Color.Transparent)
          .stateEffect(false)
          .padding({ left: 8, right: 8, top: 6, bottom: 6 })
          .onClick(() => {
            this.activePage = '选择患者';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 14 })
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}
