import { router } from '@kit.ArkUI';

// 药品数据模型
interface MedicineItem {
  name: string;
  spec: string;
  price: number;
  count: number;
  usage: string;
}

@Entry
@Component
struct GrabOrderPage {
  // 用户基础信息
  @State userName: string = '李晓明';
  @State gender: string = '女';
  @State age: number = 23;
  @State publishTime: string = '5分钟前';
  @State department: string = '内科-消化内科';
  @State consultType: string = '开药问诊';
  @State totalPrice: number = 29.00;

  // 病情基础信息
  @State disease: string = '急性肠胃炎';
  @State liverFunc: string = '正常';
  @State kidneyFunc: string = '正常';
  @State allergy: string = '无';
  @State birthPlan: string = '无';

  // 药品列表
  @State medicineList: MedicineItem[] = [
    {
      name: '优赛明 维生素E乳',
      spec: '85ml',
      price: 25.00,
      count: 1,
      usage: '正在使用；口服，每次1袋，每天3次，用药3天'
    },
    {
      name: '优赛明 维生素E乳',
      spec: '85ml',
      price: 25.00,
      count: 1,
      usage: ''
    }
  ]

  build() {
    Column() {
      // 顶部导航栏
      this.buildNavBar()

      // 主体滚动内容
      Scroll() {
        Column({ space: 16 }) {
          // 订单主卡片
          this.buildOrderCard()
        }
        .width('100%')
        .padding({ top: 12, bottom: 20 })
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')

      // 底部操作栏
      this.buildBottomActionBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 顶部导航栏
  @Builder
  buildNavBar() {
    Row() {
      // 返回按钮
      Image($r('app.media.u695'))
        .width(18)
        .height(18)
        .onClick(() => router.back())

      Blank()

      Text('抢单中心')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)

      Blank()

      // 占位对齐
      Text('').width(18)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // 订单详情卡片
  @Builder
  buildOrderCard() {
    Column({ space: 14 }) {
      // 头部：头像+姓名+时间
      Row() {
        // 头像+红点标记
        Stack() {
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E6%8A%A2%E5%8D%95%E4%B8%AD%E5%BF%83/__80px_u4645.png')
            .width(65)
            .height(55)
            .borderRadius(25)
          Circle()
            .width(10)
            .height(10)
            .fill(Color.Red)
            .position({ x: 45, y: 0 })
        }

        Column() {
          Text(`${this.userName} ${this.gender} ${this.age}岁`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
        }
        .layoutWeight(1)
        .margin({ left: 10 })
        .alignItems(HorizontalAlign.Start)

        Text(this.publishTime)
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 科室+问诊类型+价格
      Row() {
        Text(this.department)
          .fontSize(15)
          .fontColor('#007AFF')

        Text(this.consultType)
          .fontSize(13)
          .fontColor('#009955')
          .backgroundColor('#E6F9F0')
          .padding({ left: 8, right: 8, top: 3, bottom: 3 })
          .borderRadius(4)
          .margin({ left: 10 })

        Blank()

        Text(`¥${this.totalPrice.toFixed(2)}`)
          .fontSize(18)
          .fontColor('#FF3B30')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')

      // 病情信息列表
      Column({ space: 6 }) {
        Text(`所患疾病：${this.disease}`)
          .fontSize(15)
          .fontColor('#333333')
        Text(`肝功能：${this.liverFunc}`)
          .fontSize(15)
          .fontColor('#333333')
        Text(`肾功能：${this.kidneyFunc}`)
          .fontSize(15)
          .fontColor('#333333')
        Text(`过敏史：${this.allergy}`)
          .fontSize(15)
          .fontColor('#333333')
        Text(`生育状态及计划：${this.birthPlan}`)
          .fontSize(15)
          .fontColor('#333333')
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      Divider().width('100%').color('#EEEEEE')

      // 处方凭证模块
      Text('处方凭证')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#222222')
        .width('100%')

      // ====================== ✅ 已修改：处方凭证图片 左对齐 ======================
      Row() {
        Image($r('app.media.u1288'))
          .width(140)
          .height(110)
          .backgroundColor('#E8F3FF')
          .borderRadius(6)
          .objectFit(ImageFit.Cover)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)

      Divider().width('100%').color('#EEEEEE')

      // 药品列表标题
      Text('已选药品及用药情况')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .fontColor('#222222')
        .width('100%')

      // 循环渲染药品
      ForEach(this.medicineList, (item: MedicineItem) => {
        Column({ space: 8 }) {
          Row() {
            // 药品图片
            Stack() {
              Image($r('app.media.u1288'))
                .width(70)
                .height(70)
                .backgroundColor('#E8F3FF')
                .borderRadius(6)
              Text('处方药')
                .fontSize(11)
                .fontColor(Color.White)
                .backgroundColor('#FFCC00')
                .padding({ left: 6, right: 6, top: 2, bottom: 2 })
                .borderRadius(2)
                .position({ x: 0, y: 52 })
            }

            Column() {
              Text(item.name)
                .fontSize(15)
                .fontColor('#333333')
              Text(item.spec)
                .fontSize(13)
                .fontColor('#666666')
                .margin({ top: 4 })
              Text(`¥${item.price.toFixed(2)}`)
                .fontSize(15)
                .fontColor('#FF3B30')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 4 })
            }
            .layoutWeight(1)
            .margin({ left: 12 })
            .alignItems(HorizontalAlign.Start)

            Text(`x${item.count}`)
              .fontSize(15)
              .fontColor('#333333')
          }
          .width('100%')
          .alignItems(VerticalAlign.Top)

          // 用药说明
          if (item.usage.length > 0) {
            Text(`用药情况：${item.usage}`)
              .fontSize(14)
              .fontColor('#444444')
              .lineHeight(22)
              .width('100%')
          }
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .margin({ bottom: 12 })
      })

    }
    .width('92%')
    .padding(18)
    .backgroundColor(Color.White)
    .borderRadius(10)
  }

  // 底部固定操作栏
  @Builder
  buildBottomActionBar() {
    Row() {
      Text('上一条')
        .fontSize(16)
        .fontColor('#666666')
        .onClick(() => {
          // 切换上一条订单逻辑
          router.pushUrl({ url: 'pages/GrabOrderPage' })
        })

      Blank()

      // 圆形抢单大按钮
      Button('抢单')
        .width(100)
        .height(100)
        .fontSize(19)
        .fontColor(Color.White)
        .backgroundColor('#007AFF')
        .borderRadius(50)
        .shadow({ radius: 10, color: 'rgba(0,122,255,0.35)', offsetY: 5 })
        .onClick(() => {
          // 抢单业务逻辑
          router.pushUrl({ url: 'pages/GrabOrderPage' })
        })

      Blank()

      Text('下一条')
        .fontSize(16)
        .fontColor('#666666')
        .onClick(() => {
          // 切换下一条订单逻辑
          router.pushUrl({ url: 'pages/GrabOrderPage' })
        })
    }
    .width('100%')
    .height(110)
    .padding({ left: 30, right: 30 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }
}