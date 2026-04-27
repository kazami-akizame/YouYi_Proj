import router from '@ohos.router';
import { http } from '@kit.NetworkKit';

interface OrderItemParams {
  id: number;
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

  @State showTimePicker: boolean = false;
  @State selectYear: number = 2020;
  @State selectMonth: number = 3;
  @State showTimeText: string = "2020-03";

  private yearList: number[] = [2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025];
  private monthList: number[] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];

  // 本地兜底数据
  private localOrders: OrderItemParams[] = [
    { id:1,time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "极速问诊", status: "已完成", price: "¥29.00", serviceColor: "#FFA500" },
    { id:2,time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "图文问诊", status: "已关闭", price: "¥29.00", serviceColor: "#007AFF" },
    { id:3,time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "开药问诊", status: "已完成", price: "¥29.00", serviceColor: "#34C759" },
    { id:4,time: "2020-02-06 08:09", name: "吴珊珊 女 23岁", serviceType: "私人医生", status: "已关闭", price: "¥29.00", serviceColor: "#9D4EDD" }
  ];

  aboutToAppear() {
    this.getOrderList();
  }

  async getOrderList() {
    let httpTask = http.createHttp();
    // 获取当前选中的Tab名称，例如 "图文问诊"
    let typeName = this.tabs[this.currentTab];

    let url = `http://localhost:8888/doctorOrder`;

    try {
      let res = await httpTask.request(url, { method: http.RequestMethod.GET });

      if (res.responseCode === 200) {
        let data: OrderItemParams[] = JSON.parse(res.result.toString());
        if (data && data.length > 0) {
          // ==========================
          // 🔥 核心修改：在这里进行数据过滤
          // ==========================
          if (this.currentTab === 0) {
            // 如果点击的是“全部”，直接显示所有数据
            this.filteredOrders = data;
          } else {
            // 如果点击的是具体分类，筛选 serviceType 等于当前 Tab 名称的数据
            this.filteredOrders = data.filter(item => item.serviceType === typeName);
          }
          return;
        }
      }
      // 如果后端数据为空或异常，使用本地数据
      this.useLocalData();

    } catch (err) {
      console.error("请求失败", err);
      this.useLocalData();
    } finally {
      httpTask.destroy();
    }
  }

  // 本地数据也需要做同样的过滤逻辑，保持一致性
  private useLocalData() {
    if (this.currentTab === 0) {
      this.filteredOrders = this.localOrders;
    } else {
      this.filteredOrders = this.localOrders.filter(item => item.serviceType === this.tabs[this.currentTab]);
    }
  }

  private updateFilteredOrders(index: number) {
    this.currentTab = index;
    this.getOrderList();
  }

  private cancelPickTime() {
    this.showTimePicker = false;
  }

  private confirmPickTime() {
    this.showTimeText = `${this.selectYear}-${this.selectMonth.toString().padStart(2, '0')}`;
    this.showTimePicker = false;
    this.getOrderList();
  }

  build() {
    Stack() {
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.u695'))
            .width(24)
            .height(24)
            .onClick(() => router.back())

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

        // 顶部 Tab 切换
        Scroll() {
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
              .onClick(() => this.updateFilteredOrders(index))
            })
          }
        }
        .width('100%')
        .padding({ left: 15, right: 15, top: 10, bottom: 10 })
        .backgroundColor("#F5F5F5")

        // 时间筛选栏
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
        .onClick(() => this.showTimePicker = true)

        // 订单列表
        List() {
          ForEach(this.filteredOrders, (order: OrderItemParams) => {
            ListItem() {
              Column() {
                this.OrderCardItem(order)
              }
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Mine/OrderInfoDetail',
                  params: { id: order.id }
                })
              })
            }
          })

          ListItem() {
            Text("没有更多了～")
              .fontSize(14)
              .fontColor("#999")
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 20, bottom: 30 })
          }
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ left: 15, right: 15, top: 15 })
        .backgroundColor("#F5F5F5")
        .divider({ strokeWidth: 0 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor("#F5F5F5")
      .opacity(this.showTimePicker ? 0.5 : 1)

      // 时间选择弹窗
      if (this.showTimePicker) {
        Column() {
          Column() {
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

            Row() {
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
              }.width('50%').layoutWeight(1)

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
              }.width('50%').layoutWeight(1)
            }
            .height(380)
            .padding({ bottom: 50 })
          }
          .width('100%')
          .backgroundColor("#FFFFFF")
          .borderRadius({ topLeft: 16, topRight: 16 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0, 0, 0, 0.5)')
        .justifyContent(FlexAlign.End)
        .onClick(() => this.cancelPickTime())
      }
    }
    .width('100%')
    .height('100%')
  }

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