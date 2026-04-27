interface Patient {
  id: string;
  name: string;
  gender: string;
  age: number;
  status: number; // 0-进行中，1-已结束
  hasNewMsg: boolean;
  serviceDuration: string;
  startDate: string;
  endDate: string;
}

@Entry
@Component
struct NewPage {
  //@State：状态变量，变化时自动刷新UI
  @State currentTabIndex: number = 0;
  @State patientList: Patient[] = [
    {
      id: '001',
      name: '吴珊珊',
      gender: '女',
      age: 23,
      status: 0,
      hasNewMsg: true,
      serviceDuration: '半年',
      startDate: '2020-02-06',
      endDate: '2020-08-06'
    },
    {
      id: '002',
      name: '吴珊珊',
      gender: '女',
      age: 23,
      status: 1,
      hasNewMsg: false,
      serviceDuration: '半年',
      startDate: '2020-02-06',
      endDate: '2020-08-06'
    },

  ];

  // 患者列表项
  @Builder
  PatientItem(item: Patient) {
    Column() {
      // 头部：头像 + 姓名 + 状态
      Row() {
        // 左侧：头像 + 姓名
        Row() {
          Stack() {
            Image($r('app.media.__80px_u1116'))
              .width(40)
              .height(40)
              .borderRadius(25)


            if (item.hasNewMsg) {
              Circle()
                .width(10)
                .height(10)
                .fill('#ff4d4f')
                .align(Alignment.TopStart)
                .position({ x: 30, y: 2 })
            }
          }

          Blank().width(5)

          Text(item.name)
            .fontSize(16)

          Blank().width(5)

          Row() {
            Text(`${item.gender} ${item.age}岁`)
              .fontSize(14)
              .fontColor('#666')

            if (item.hasNewMsg) {
              Text('新消息')
                .fontSize(12)
                .fontColor('#ff9800')
                .backgroundColor('#fff7e6')
                .borderRadius(4)
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .margin({ left: 8 })
            }
          }
          .margin({ top: 4 })

        }
        .alignItems(VerticalAlign.Center)

        // 右侧：状态
        Text(item.status === 0 ? '进行中' : '已结束')
          .fontSize(14)
          .fontColor(item.status === 0 ? '#36c671' : '#999')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      // 服务信息
      Column({ space: 8 }) {
        Text(`服务时长：${item.serviceDuration}`)
          .fontSize(14)
          .fontColor('#666')
        Text(`开始日期：${item.startDate}`)
          .fontSize(14)
          .fontColor('#666')
        Text(`结束日期：${item.endDate}`)
          .fontSize(14)
          .fontColor('#666')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ top: 16 })

      // 分割线
      Divider()
        .width('100%')
        .strokeWidth(1)
        .color('#eee')
        .margin({ top: 16 })

      // 按钮
      Row({ space: 16 }) {
        Button('患者资料')
          .width(85)
          .height(30)
          .backgroundColor('#fff')
          .fontColor('#333')
          .border({ width: 1, color: '#ccc' })
          .borderRadius(16)
          .onClick(() => {
            console.log('查看患者资料', item.name);
          })

        if (item.status === 0) {
          Button('联系患者')
            .width(85)
            .height(30)
            .backgroundColor('#fff')
            .fontColor('#007DFF')
            .border({ width: 1, color: '#007DFF' })
            .borderRadius(16)
            .onClick(() => {
              console.log('联系患者', item.name);
            })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .margin({ top: 16 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#fff')
    .borderRadius(12)
    .margin({ top:12,bottom: 4 })
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .margin({ left: 16 })
          .onClick(() => {
            console.log('返回');
          })

        Text('我的私人医生服务')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(24)
          .margin({ right: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      Divider()
        .height(1)
        .color('#ddd')

      // 使用 Tabs 组件
      Tabs({
        barPosition: BarPosition.Start,
        index: this.currentTabIndex
      }) {
        TabContent() {
          this.AllTabContent()
        }
        .tabBar('全部')

        TabContent() {
          this.InProgressTabContent()
        }
        .tabBar('进行中')

        TabContent() {
          this.CompletedTabContent()
        }
        .tabBar('已结束')
      }
      .vertical(false)
      .scrollable(true)
      .barHeight(46)
      .onChange((index: number) => {
        this.currentTabIndex = index;
      })
      .layoutWeight(1)
      .backgroundColor('#fff')

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }

  // 全部 Tab 内容
  @Builder
  AllTabContent() {
    if (this.patientList.length === 0) {
      Column() {
        Text('暂无数据')
          .fontSize(14)
          .fontColor('#999')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List() {
        ForEach(
          this.patientList,
          (item: Patient) => {
            ListItem() {
              this.PatientItem(item)
            }
            .width('100%')
            .padding({ left: 15, right: 15 })
          },
          (item: Patient) => item.id
        )

        ListItem() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor('#999')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 20, bottom: 20 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f5f5f5')
      .scrollBar(BarState.Auto)
    }
  }

  // 进行中 Tab 内容
  @Builder
  InProgressTabContent() {
    if (this.patientList.filter(item => item.status === 0).length === 0) {
      Column() {
        Text('暂无进行中的患者')
          .fontSize(14)
          .fontColor('#999')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List() {
        ForEach(
          this.patientList.filter(item => item.status === 0),
          (item: Patient) => {
            ListItem() {
              this.PatientItem(item)
            }
            .width('100%')
            .padding({ left: 15, right: 15 })
          },
          (item: Patient) => item.id
        )

        ListItem() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor('#999')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 20, bottom: 20 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f5f5f5')
      .scrollBar(BarState.Auto)
    }
  }

  // 已结束 Tab 内容
  @Builder
  CompletedTabContent() {
    if (this.patientList.filter(item => item.status === 1).length === 0) {
      Column() {
        Text('暂无已结束的患者')
          .fontSize(14)
          .fontColor('#999')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List() {
        ForEach(
          this.patientList.filter(item => item.status === 1),
          (item: Patient) => {
            ListItem() {
              this.PatientItem(item)
            }
            .width('100%')
            .padding({ left: 15, right: 15 })
          },
          (item: Patient) => item.id
        )

        ListItem() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor('#999')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 20, bottom: 20 })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f5f5f5')
      .scrollBar(BarState.Auto)
    }
  }
}