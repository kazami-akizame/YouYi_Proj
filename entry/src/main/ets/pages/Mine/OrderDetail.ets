import router from '@ohos.router';

// ====================== 接口声明 ======================
interface OrderItemParams {
  time: string;
  name: string;
  serviceType: string;
  status: string;
  price: string;
  serviceColor: string;
}

@Entry
@Component
struct OrderDetail {
  @State currentTab: number = 0;
  @State filteredOrders: OrderItemParams[] = [];
  private tabs: string[] = ['全部', '图文问诊', '极速问诊', '开药问诊', '私人医生'];

  // ===== 时间选择器状态 =====
  @State showTimePicker: boolean = false;
  @State selectYear: number = 2020;
  @State selectMonth: number = 3;
  @State showTimeText: string = "2020-03";

  // 年份、月份数组
  private yearList: number[] = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025];
  private monthList: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  // 订单原始数据
  private allOrders: OrderItemParams[] = [
    { time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "极速问诊", status: "已完成", price: "¥29.00", serviceColor: "#FFA500" },
    { time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "图文问诊", status: "已关闭", price: "¥29.00", serviceColor: "#007AFF" },
    { time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "开药问诊", status: "已完成", price: "¥29.00", serviceColor: "#34C759" },
    { time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "私人医生", status: "已关闭", price: "¥29.00", serviceColor: "#9D4EDD" }
  ];

  aboutToAppear() {
    this.filteredOrders = this.allOrders;
  }

  // Tab切换筛选逻辑
  private updateFilteredOrders(index: number) {
    this.currentTab = index;
    if (index === 0) {
      this.filteredOrders = this.allOrders;
    } else {
      this.filteredOrders = this.allOrders.filter(order => order.serviceType === this.tabs[index]);
    }
  }

  // 弹窗取消
  private cancelPickTime() {
    this.showTimePicker = false;
  }

  // 弹窗确认选择年月
  private confirmPickTime() {
    this.showTimeText = `${this.selectYear}-${this.selectMonth.toString().padStart(2, '0')}`;
    this.showTimePicker = false;
  }

  build() {
    // ====================== 【唯一根节点 Stack】 ======================
    Stack() {
      // 1. 底层：订单页面主体（所有原有内容原样保留）
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.u695'))
            .width(24)
            .height(24)
            .onClick(() => router.pushUrl({ url: 'pages/MyIncome' }))

          Text("订单明细")
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
            .textAlign(TextAlign.Center)

          Blank().width(24)
        }
        .width('100%')
        .height(56)
        .backgroundColor("#fff")
        .alignItems(VerticalAlign.Center)
        .padding({ left: 15, right: 15 })

        // 横向Tab栏
        Scroll()
        {
          Row() {
            ForEach(this.tabs, (item: string, index: number) => {
              Column() {
                Text(item)
                  .fontSize(16)
                  .fontColor(this.currentTab === index ? "#1677FF" : "#999")
                  .fontWeight(this.currentTab === index ? FontWeight.Medium : FontWeight.Normal)

                if (this.currentTab === index) {
                  Column()
                    .width(20)
                    .height(3)
                    .backgroundColor("#1677FF")
                    .margin({ top: 4 })
                }
              }
              .padding({ left: 10, right: 10 })
              .onClick(() => {
                this.updateFilteredOrders(index);
              })
            })
          }
        }.width('100%')
        .padding({ left: 15, right: 15, top: 10, bottom: 10 })
        .backgroundColor("#F5F5F5")

        // 可点击时间筛选栏
        Row() {
          Text(this.showTimeText)
            .fontSize(16)
            .fontColor("#333")

          Image($r('app.media.u6241'))
            .width(12)
            .height(12)
            .margin({ left: 6 })
        }
        .width('100%')
        .padding({ left: 15, top: 12, bottom: 12 })
        .backgroundColor("#F5F5F5")
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          this.showTimePicker = true;
        })

        // 订单列表主体
        List()
        {
          ForEach(this.filteredOrders, (order: OrderItemParams) => {
            ListItem() {
              Column() {
                this.OrderCardItem(order)
              }
              // 不同订单跳转不同详情页
              .onClick(() => {
                if (order.serviceType === "图文问诊") {
                  router.pushUrl({ url: 'pages/OrderInfoDetail2' });
                } else if (order.serviceType === "极速问诊") {
                  router.pushUrl({ url: 'pages/OrderInfoDetail1' });
                } else if (order.serviceType === "开药问诊") {
                  router.pushUrl({ url: 'pages/OrderInfoDetail1' });
                } else if (order.serviceType === "私人医生") {
                  router.pushUrl({ url: 'pages/OrderInfoDetail3' });
                }
              })
            }
          }, (order: OrderItemParams) => order.time + order.serviceType)

          ListItem() {
            Text("没有更多了～")
              .fontSize(14)
              .fontColor("#999")
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20, bottom: 30 })
          }
        }.width('100%')
        .layoutWeight(1)
        .padding({ left: 15, right: 15, top: 15 })
        .backgroundColor("#F5F5F5")
        .divider({ strokeWidth: 0 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor("#F5F5F5")
      .opacity(this.showTimePicker ? 0.5 : 1)

      // ====================== 弹窗最终美化版 ======================
      if (this.showTimePicker) {
        Column() {
          // 白色底部面板（限制高度，不再铺满全屏）
          Column() {
            // 顶部取消+完成栏
            Row() {
              Text("取消")
                .fontSize(16)
                .fontColor("#007AFF")
                .padding(15)
                .onClick(() => this.cancelPickTime())

              Blank()

              Text("完成")
                .fontSize(16)
                .fontColor("#007AFF")
                .padding(15)
                .onClick(() => this.confirmPickTime())
            }
            .width('100%')
            .border({ width: { bottom: 1 }, color: "#EEEEEE" })

            // 年月双列选择容器
            Row() {
              // 年份列表
              List() {
                ForEach(this.yearList, (year: number) => {
                  ListItem() {
                    Text(year + "年")
                      .fontSize(18)
                      .fontColor(this.selectYear === year ? "#000000" : "#CCCCCC")
                      .width('100%')
                      .textAlign(TextAlign.Center)
                      .padding(15)
                      .onClick(() => this.selectYear = year)
                  }
                })
              }.width('50%')
              .layoutWeight(1)

              // 月份列表
              List() {
                ForEach(this.monthList, (month: number) => {
                  ListItem() {
                    Text(month + "月")
                      .fontSize(18)
                      .fontColor(this.selectMonth === month ? "#000000" : "#CCCCCC")
                      .width('100%')
                      .textAlign(TextAlign.Center)
                      .padding(15)
                      .onClick(() => this.selectMonth = month)
                  }
                })
              }.width('50%')
              .layoutWeight(1)
            }
            .height(380) // 限制弹窗面板高度，只占屏幕下半部分
            .padding({ bottom: 50 }) // 适配手机底部安全区
          }
          .width('100%')
          .backgroundColor("#FFFFFF")
          .borderRadius({ topLeft: 16, topRight: 16 })
        }
        // 遮罩层
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .justifyContent(FlexAlign.End) // 固定贴屏幕底部
        .onClick(() => this.cancelPickTime())
      }
    }
    .width('100%')
    .height('100%')
  }

  // ====================== 通用订单卡片组件 ======================
  @Builder
  OrderCardItem(params: OrderItemParams) {
    Column() {
      Row() {
        Text(params.time)
          .fontSize(14)
          .fontColor("#999")
        Text(params.status)
          .fontSize(14)
          .fontColor("#999")
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 12 })

      Row() {
        Text(params.name)
          .fontSize(18)
          .fontColor("#333")
          .layoutWeight(1)
        Text(params.serviceType)
          .fontSize(16)
          .fontColor(params.serviceColor)
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(params.price)
        .fontSize(20)
        .fontColor("#FF4D4F")
        .width('100%')
    }
    .width('100%')
    .padding(15)
    .backgroundColor("#fff")
    .borderRadius(12)
  }
}