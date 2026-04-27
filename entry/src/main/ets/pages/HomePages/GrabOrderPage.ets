import { router } from '@kit.ArkUI';

// GrabOrderPage.ets
@Entry
@Component
struct GrabOrderPage {
  // 模拟订单数据
  @State order: OrderData = {
    name: '吴珊珊',
    gender: '女',
    age: 23,
    time: '5分钟前',
    department: '内科-呼吸内科',
    type: '极速问诊',
    price: 29.00,
    description: '病情描述：孩子从出生后睡眠就不好，入睡困难，易醒，烦躁不安。近三个月症状加重，尤其夜里辗转难眠，情绪烦躁伴随哭闹，并模糊描述“不舒服”“腿疼”“脚疼”，偶尔会用头往床上撞。到凌晨五点左右才能稍微安稳睡一会，每晚睡眠时间不足3小时。白天清醒时表现正常。',
    duration: '一周内',
    visited: '就诊过',
    images: 6 // 模拟6张图片
  };

  build() {
    Column() {
      // 顶部导航栏
      this.buildNavBar()

      // 订单卡片
      Scroll() {
        this.buildOrderCard()
      }
      .layoutWeight(1)

      // 底部操作栏
      this.buildBottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 顶部导航栏
  @Builder
  buildNavBar() {
    Row() {
      Image($r('app.media.u695'))
        .width(16)
        .height(16)
        .margin({ left: 16, right: 16 })
        .onClick(() => {
          // router.back()
          router.pushUrl({ url: 'pages/HomePage' })
        })

      Text('抢单中心')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 右侧占位，保证标题居中
      Text('')
        .width(24)
        .height(24)
        .margin({ right: 16 })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // 订单卡片
  @Builder
  buildOrderCard() {
    Column() {
      // 头部信息：用户 + 科室 + 价格
      Row() {
        // 头像
        Image($r('app.media.u1288'))
          .width(48)
          .height(48)
          .fillColor('#007AFF')
          .backgroundColor('#E8F3FF')
          .borderRadius(24)

        // 姓名/性别/年龄
        Column() {
          Text(`${this.order.name} ${this.order.gender} ${this.order.age}岁`)
            .fontSize(17)
            .fontColor('#333333')
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        // 时间
        Text(this.order.time)
          .fontSize(14)
          .fontColor('#999999')
          .margin({ right: 8 })
      }
      .width('100%')
      .margin({ bottom: 12 })
      .alignItems(VerticalAlign.Center)

      // 科室 + 类型 + 价格
      Row() {
        Row() {
          Image($r('app.media.u1288'))
            .width(18)
            .height(18)
            .fillColor('#007AFF')
          Text(this.order.department)
            .fontSize(15)
            .fontColor('#007AFF')
            .margin({ left: 4 })
        }

        Text(this.order.type)
          .fontSize(12)
          .fontColor('#FF9500')
          .backgroundColor('#FFF5E6')
          .padding({ left: 8, right: 8, top: 2, bottom: 2 })
          .borderRadius(4)
          .margin({ left: 8 })

        Blank()

        Text(`¥${this.order.price.toFixed(2)}`)
          .fontSize(17)
          .fontColor('#FF3B30')
          .fontWeight(FontWeight.Bold)
          .margin({ right: 8 })
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 病情描述
      Text(this.order.description)
        .fontSize(14)
        .fontColor('#333333')
        .lineHeight(22)
        .margin({ bottom: 12 })
        .padding({ right: 8 })

      // 患病时长
      Text(`患病时长：${this.order.duration}`)
        .fontSize(14)
        .fontColor('#333333')
        .margin({ bottom: 8 })
        .padding({ right: 8 })

      // 就诊情况
      Text(`就诊情况：${this.order.visited}`)
        .fontSize(14)
        .fontColor('#333333')
        .margin({ bottom: 16 })
        .padding({ right: 8 })

      // 图片网格（6张）
      Grid() {
        GridItem() {
          Image($r('app.media.u1288'))
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F8FF')
            .fillColor('#007AFF')
            .borderRadius(4)
            .objectFit(ImageFit.Contain)
        }
        GridItem() {
          Image($r('app.media.u1288'))
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F8FF')
            .fillColor('#007AFF')
            .borderRadius(4)
            .objectFit(ImageFit.Contain)
        }
        GridItem() {
          Image($r('app.media.u1288'))
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F8FF')
            .fillColor('#007AFF')
            .borderRadius(4)
            .objectFit(ImageFit.Contain)
        }
        GridItem() {
          Image($r('app.media.u1288'))
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F8FF')
            .fillColor('#007AFF')
            .borderRadius(4)
            .objectFit(ImageFit.Contain)
        }
        GridItem() {
          Image($r('app.media.u1288'))
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F8FF')
            .fillColor('#007AFF')
            .borderRadius(4)
            .objectFit(ImageFit.Contain)
        }
        GridItem() {
          Image($r('app.media.u1288'))
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F8FF')
            .fillColor('#007AFF')
            .borderRadius(4)
            .objectFit(ImageFit.Contain)
        }
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr') // 修正行高比例
      .columnsGap(12) // 调整列间距
      .rowsGap(12) // 调整行间距
      .width('100%')
      .height(180) // 调整网格高度
      .padding({ right: 8 })
    }
    .width('94%') // 调整卡片宽度
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8) // 调整圆角大小
    .margin({ top: 12, left: '3%', right: '3%' }) // 调整外边距
  }

  // 底部操作栏
  @Builder
  buildBottomBar() {
    Row() {
      // 上一条
      Text('上一条')
        .fontSize(16)
        .fontColor('#666666') // 调整文字颜色
        .margin({ left: 40 }) // 调整左边距
        .onClick(() => {
          // 上一条订单逻辑
        })

      Blank()

      // 抢单按钮
      Button('抢单')
        .width(80)
        .height(80) // 调整按钮大小
        .fontSize(18)
        .fontColor(Color.White)
        .backgroundColor('#007AFF')
        .borderRadius(40)
        .shadow({ radius: 8, color: 'rgba(0,122,255,0.3)', offsetY: 6 }) // 调整阴影
        .onClick(() => {
          router.pushUrl({url:'pages/HomePages/OrderPageLast'})
        })

      Blank()

      // 下一条
      Text('下一条')
        .fontSize(16)
        .fontColor('#666666') // 调整文字颜色
        .margin({ right: 40 }) // 调整右边距
        .onClick(() => {
          // 下一条订单逻辑
        })
    }
    .width('100%')
    .height(50) // 调整底部栏高度
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }
}

// 订单数据模型
interface OrderData {
  name: string;
  gender: string;
  age: number;
  time: string;
  department: string;
  type: string;
  price: number;
  description: string;
  duration: string;
  visited: string;
  images: number;
}