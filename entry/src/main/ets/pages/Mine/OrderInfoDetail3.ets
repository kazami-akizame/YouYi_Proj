import router from '@ohos.router';

@Entry
@Component
struct OrderInfoDetail3 {
  build() {
    Column() {
      // ====================== 顶部导航栏 ======================
      Row() {
        // 左侧返回箭头 → 跳转回订单明细列表页面 OrderDetail
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .onClick(() => router.pushUrl({ url: 'pages/OrderDetail' }))

        // 页面居中标题
        Text("订单详情")
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

      // ====================== 页面主体内容容器 ======================
      Column() {
        // ====================== 模块1：患者信息卡片 ======================
        Column() {
          // 模块标题
          Text("患者信息")
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor("#333")
            .width('100%')

          // 标题下方分割线
          Column()
            .width('100%')
            .height(1)
            .backgroundColor("#EEEEEE")
            .margin({ top: 12, bottom: 15 })

          // 患者信息列表行
          this.InfoItem("姓名", "吴珊珊")
          this.InfoItem("性别", "女")
          this.InfoItem("年龄", "23岁")
          this.InfoItem("手机", "188****8766")
        }
        .width('100%')
        .padding(20)
        .backgroundColor("#fff")
        .borderRadius(12)
        .margin({ bottom: 15 })

        // ====================== 模块2：订单信息卡片 ======================
        Column() {
          // 模块标题
          Text("订单信息")
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor("#333")
            .width('100%')

          // 标题下方分割线
          Column()
            .width('100%')
            .height(1)
            .backgroundColor("#EEEEEE")
            .margin({ top: 12, bottom: 15 })

          // 私人医生服务专属信息
          this.InfoItem("服务名称", "私人医生服务")
          this.InfoItem("服务时长", "半年")
          this.InfoItem("服务价格", "¥7200.00")
          this.InfoItem("优惠券", "-¥10.00")
          this.InfoItem("应付款", "-¥7190.00")

          // 金额区域底部分割线
          Column()
            .width('100%')
            .height(1)
            .backgroundColor("#EEEEEE")
            .margin({ top: 15, bottom: 15 })

          // 订单底层信息
          this.InfoItem("订单编号", "202002039089")
          this.InfoItem("创建时间", "2020-02-03 09:19")
          this.InfoItem("取消方式", "支付超时，订单关闭")
        }
        .width('100%')
        .padding(20)
        .backgroundColor("#fff")
        .borderRadius(12)
      }
      .width('100%')
      .padding(15)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F5F5F5")
  }

  // ====================== 项目全局统一通用信息行组件 ======================
  @Builder
  InfoItem(label: string, value: string) {
    Row() {
      Text(label)
        .fontSize(16)
        .fontColor("#333")

      Text(value)
        .fontSize(16)
        .fontColor("#999")
        .margin({ left: 12 })
    }
    .width('100%')
    .margin({ bottom: 16 })
  }
}