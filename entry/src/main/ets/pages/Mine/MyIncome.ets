import router from '@ohos.router';
import { http } from '@kit.NetworkKit';

// 收入接口模型
interface IncomeInfo {
  monthText: string;
  monthIncome: string;
  totalOrderCount: number;
  totalIncome: string;
  settlementList: SettlementItem[];
}

interface SettlementItem {
  year: number;
  month: number;
  income: string;
  orderCount: number;
  settleTime: string;
}

@Entry
@Component
struct MyIncome {
  @State monthText: string = "三月";
  @State monthIncome: string = "2900.00";
  @State totalOrderCount: number = 240;
  @State totalIncome: string = "2900.00";

  @State settleList: SettlementItem[] = [
    { year: 2020, month: 2, income: "2900.00", orderCount: 120, settleTime: "03-05" },
    { year: 2020, month: 1, income: "2900.00", orderCount: 120, settleTime: "03-05" },
    { year: 2019, month: 12, income: "2900.00", orderCount: 120, settleTime: "03-05" },
    { year: 2019, month: 11, income: "2900.00", orderCount: 120, settleTime: "" }
  ];

  aboutToAppear() {
    this.getIncomeData();
  }

  // 后端请求：医生收入统计
  async getIncomeData() {
    let httpTask = http.createHttp();
    try {
      let url = "http://localhost:8888/doctorIncome";//改为正确的后端接口
      let res = await httpTask.request(url, {
        method: http.RequestMethod.GET
      });

      // ✅ 关键修复：只有状态码 200 才用后端数据，否则保留本地数据
      if (res.responseCode === 200) {
        let data: IncomeInfo = JSON.parse(res.result.toString());
        if (data) {
          this.monthText = data.monthText;
          this.monthIncome = data.monthIncome;
          this.totalOrderCount = data.totalOrderCount;
          this.totalIncome = data.totalIncome;
          this.settleList = data.settlementList;
          console.log("✅ 收入接口请求成功，使用后端数据");
        }
      } else {
        // ✅ 状态码不是200 → 不修改！保留本地默认数据
        console.log("⚠️ 后端返回异常码，使用本地默认数据");
      }

    } catch (e) {
      // ✅ 报错 → 不修改！保留本地默认数据
      console.log("⚠️ 后端请求失败，使用本地默认数据");
    } finally {
      httpTask.destroy();
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .onClick(() => router.back())

        Text("我的收入")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text("订单明细")
          .fontSize(16)
          .fontColor("#1677FF")
          .onClick(() => router.pushUrl({ url: 'pages/Mine/OrderDetail'  }))
      }
      .width('100%')
      .height(56)
      .backgroundColor("#fff")
      .alignItems(VerticalAlign.Center)
      .padding({ left: 15, right: 15 })

      Column() {
        Text(`${this.monthText}收入（税前）`)
          .fontSize(16)
          .fontColor("#fff")
          .margin({ bottom: 12 })

        Text(`¥${this.monthIncome}`)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor("#fff")
      }
      .width('100%')
      .height(180)
      .backgroundColor("#FF5757")
      .justifyContent(FlexAlign.Center)

      Row() {
        Column() {}.width(4).height(18).backgroundColor("#1677FF")
        Text("累计数据")
          .fontSize(16)
          .fontColor("#333")
          .margin({ left: 8 })
      }
      .width('100%')
      .padding({ left: 20, top: 15, bottom: 15 })
      .backgroundColor("#F5F5F5")

      Row() {
        Column() {
          Text("总订单数")
            .fontSize(14)
            .fontColor("#999")
            .margin({ bottom: 8 })
          Text(`${this.totalOrderCount}`)
            .fontSize(22)
            .fontColor("#333")
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {}.width(1).height(60).backgroundColor("#E5E5E5")

        Column() {
          Text("总收入")
            .fontSize(14)
            .fontColor("#999")
            .margin({ bottom: 8 })
          Text(`¥${this.totalIncome}`)
            .fontSize(22)
            .fontColor("#333")
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .backgroundColor("#fff")

      Row() {
        Column() {}.width(4).height(18).backgroundColor("#1677FF")
        Text("结算记录")
          .fontSize(16)
          .fontColor("#333")
          .margin({ left: 8 })
      }
      .width('100%')
      .padding({ left: 20, top: 15, bottom: 15 })
      .backgroundColor("#F5F5F5")

      List() {
        ForEach(this.settleList, (item:SettlementItem) => {
          ListItem() {
            Row() {
              Column() {
                Text(`${item.month}月`)
                  .fontSize(26)
                  .fontWeight(FontWeight.Bold)
                  .fontColor("#1677FF")
                Text(`${item.year}年`)
                  .fontSize(14)
                  .fontColor("#1677FF")
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Start)

              Blank().layoutWeight(1)

              Column() {
                Text(`收入¥${item.income}`)
                  .fontSize(18)
                  .fontColor("#333")
                  .margin({ bottom: 6 })
                Text(`订单数 ${item.orderCount}`)
                  .fontSize(13)
                  .fontColor("#999")
                  .margin({ bottom: 4 })
                if(item.settleTime) {
                  Text(`结算时间 ${item.settleTime}`)
                    .fontSize(13)
                    .fontColor("#999")
                }
              }
              .alignItems(HorizontalAlign.End)
            }
            .width('100%')
            .padding(20)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#fff")
      .divider({ strokeWidth: 1, color: "#E5E5E5" })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#fff")
  }
}