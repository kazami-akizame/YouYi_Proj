import router from '@ohos.router';

@Entry
@Component
struct MyIncome {
  build() {
    Column() {
      // ====================== 顶部导航栏 ======================
      Row() {
        // 左侧返回箭头
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .onClick(() => router.pushUrl({ url: 'pages/MePage' }))

        // 页面居中标题
        Text("我的收入")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 右上角 订单明细文字按钮
        Text("订单明细")
          .fontSize(16)
          .fontColor("#1677FF")
          .onClick(() => router.pushUrl({ url: 'pages/OrderDetail' }))
      }
      .width('100%')
      .height(56)
      .backgroundColor("#fff")
      .alignItems(VerticalAlign.Center)
      .padding({ left: 15, right: 15 })

      // ====================== 顶部红色收入卡片 ======================
      Column() {
        Text("三月收入（税前）")
          .fontSize(16)
          .fontColor("#fff")
          .margin({ bottom: 12 })

        Text("¥2900.00")
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
          .fontColor("#fff")
      }
      .width('100%')
      .height(180)
      .backgroundColor("#FF5757")
      .justifyContent(FlexAlign.Center)

      // ====================== 累计数据模块 ======================
      // 模块标题
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

      // 左右双栏数据
      Row() {
        // 左侧：总订单数
        Column() {
          Text("总订单数")
            .fontSize(14)
            .fontColor("#999")
            .margin({ bottom: 8 })
          Text("240")
            .fontSize(22)
            .fontColor("#333")
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        // 中间竖分割线
        Column() {}.width(1).height(60).backgroundColor("#E5E5E5")

        // 右侧：总收入
        Column() {
          Text("总收入")
            .fontSize(14)
            .fontColor("#999")
            .margin({ bottom: 8 })
          Text("¥2900.00")
            .fontSize(22)
            .fontColor("#333")
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }
      .width('100%')
      .backgroundColor("#fff")

      // ====================== 结算记录列表 ======================
      // 模块标题
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

      // 结算记录List列表（自动滚动）
      List()

      {
        // 02月条目
        ListItem() {
          Row() {
            // 左侧年月信息
            Column() {
              Text("02月")
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor("#1677FF")
              Text("2020年")
                .fontSize(14)
                .fontColor("#1677FF")
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)

            Blank().layoutWeight(1)

            // 右侧收入详情
            Column() {
              Text("收入¥2900.00")
                .fontSize(18)
                .fontColor("#333")
                .margin({ bottom: 6 })
              Text("订单数 120")
                .fontSize(13)
                .fontColor("#999")
                .margin({ bottom: 4 })
              Text("结算时间 03-05")
                .fontSize(13)
                .fontColor("#999")
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .padding(20)
        }

        // 01月条目
        ListItem() {
          Row() {
            Column() {
              Text("01月")
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor("#1677FF")
              Text("2020年")
                .fontSize(14)
                .fontColor("#1677FF")
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)

            Blank().layoutWeight(1)

            Column() {
              Text("收入¥2900.00")
                .fontSize(18)
                .fontColor("#333")
                .margin({ bottom: 6 })
              Text("订单数 120")
                .fontSize(13)
                .fontColor("#999")
                .margin({ bottom: 4 })
              Text("结算时间 03-05")
                .fontSize(13)
                .fontColor("#999")
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .padding(20)
        }

        // 12月条目
        ListItem() {
          Row() {
            Column() {
              Text("12月")
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor("#1677FF")
              Text("2019年")
                .fontSize(14)
                .fontColor("#1677FF")
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)

            Blank().layoutWeight(1)

            Column() {
              Text("收入¥2900.00")
                .fontSize(18)
                .fontColor("#333")
                .margin({ bottom: 6 })
              Text("订单数 120")
                .fontSize(13)
                .fontColor("#999")
                .margin({ bottom: 4 })
              Text("结算时间 03-05")
                .fontSize(13)
                .fontColor("#999")
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .padding(20)
        }

        // 11月占位条目（截图底部截断的条目）
        ListItem() {
          Row() {
            Column() {
              Text("11月")
                .fontSize(26)
                .fontWeight(FontWeight.Bold)
                .fontColor("#1677FF")
              Text("2019年")
                .fontSize(14)
                .fontColor("#1677FF")
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)

            Blank().layoutWeight(1)

            Column() {
              Text("收入¥2900.00")
                .fontSize(18)
                .fontColor("#333")
            }
            .alignItems(HorizontalAlign.End)
          }
          .width('100%')
          .padding(20)
        }
      }.width('100%')
      .layoutWeight(1)
      .backgroundColor("#fff")
      .divider({ strokeWidth: 1, color: "#E5E5E5" })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#fff")
  }
}