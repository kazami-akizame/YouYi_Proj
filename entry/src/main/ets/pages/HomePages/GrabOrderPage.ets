// GrabOrderPage.ets
import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';
import { ConsultationItem, ConsultationType, ConsultationStatus } from '../common/ConsultationData';
import { saveSingleItemToServer } from '../common/ConsultationData';

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

@Entry
@Component
struct GrabOrderPage {
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
    images: 6
  };

  build() {
    Column() {
      this.buildNavBar()

      Scroll() {
        this.buildOrderCard()
      }
      .layoutWeight(1)

      this.buildBottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildNavBar() {
    Row() {
      Image($r('app.media.u695'))
        .width(16)
        .height(16)
        .margin(16)
        .onClick(() => router.pushUrl({ url: 'pages/HomePages/HomePage' }))

      Text('抢单中心')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Text('').width(24).margin(16)
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  buildOrderCard() {
    Column() {
      Row() {
        Image($r('app.media.u1288'))
          .width(48)
          .height(48)
          .fillColor('#007AFF')
          .backgroundColor('#E8F3FF')
          .borderRadius(24)

        Column() {
          Text(`${this.order.name} ${this.order.gender} ${this.order.age}岁`)
            .fontSize(17)
            .fontColor('#333333')
        }
        .layoutWeight(1)
        .margin({ left: 12 })

        Text(this.order.time)
          .fontSize(14)
          .fontColor('#999999')
      }
      .width('100%')
      .margin({ bottom: 12 })

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
          .padding(4)
          .borderRadius(4)
          .margin({ left: 8 })

        Blank()

        Text(`¥${this.order.price.toFixed(2)}`)
          .fontSize(17)
          .fontColor('#FF3B30')
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(this.order.description)
        .fontSize(14)
        .lineHeight(22)
        .margin({ bottom: 12 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Text(`患病时长：${this.order.duration}`)
        .fontSize(14)
        .margin({ bottom: 8 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Text(`就诊情况：${this.order.visited}`)
        .fontSize(14)
        .margin({ bottom: 16 })
        .width('100%')
        .textAlign(TextAlign.Start)

      Grid() {
        ForEach([1, 2, 3, 4, 5, 6], () => {
          GridItem() {
            Image($r('app.media.u1288'))
              .width('100%')
              .height('100%')
              .backgroundColor('#F5F8FF')
              .fillColor('#007AFF')
              .borderRadius(4)
          }
        })
      }
      .columnsTemplate('1fr 1fr 1fr')
      .rowsTemplate('1fr 1fr')
      .columnsGap(12)
      .rowsGap(12)
      .width('100%')
      .height(180)
    }
    .width('94%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin(12)
  }

  // ----------------- ✅ 核心：抢单逻辑（已写好）-----------------
  async onGrabOrder() {
    try {
      // 1. 把你写死的订单 → 转成 ChatPage 能用的 ConsultationItem
      const chatItem = new ConsultationItem(
        'grab_' + Date.now(), // 唯一ID
        this.order.name, // 姓名
        this.order.gender, // 性别
        this.order.age, // 年龄
        ConsultationType.GRAPHIC,
        ConsultationStatus.IN_PROGRESS, // 抢单后直接变成问诊中
        this.order.description, // 病情描述
        new Date().toLocaleString(), // 创建时间
        '',
        []
      );

      // 2. 保存到数据文件
      await saveSingleItemToServer(chatItem);

      // 3. 跳转到聊天页，并把患者数据带过去！
      await router.pushUrl({
        url: 'pages/HomePages/ChatPage',
        params: {
          item: JSON.stringify(chatItem)
        }
      });
    }catch (err) {
      console.error('抢单失败：', JSON.stringify(err));
      promptAction.showToast({ message: '抢单失败，请重试' });
    }
  }

  @Builder
  buildBottomBar() {
    Row() {
      Text('上一条')
        .fontSize(16)
        .fontColor('#666666')
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/OrderPageLast' })
            .catch((err: Error) => {
              console.error('跳转失败：', err.message);
              promptAction.showToast({
                message: '页面不存在，请检查配置',
                duration: 2000
              });
            });
        })

      Blank()

      Button('抢单')
        .width(80)
        .height(80)
        .backgroundColor('#007AFF')
        .fontColor(Color.White)
        .borderRadius(40)
        .onClick(() => this.onGrabOrder())

      Blank()

      Text('下一条')
        .fontSize(16)
        .fontColor('#666666')
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/OrderPageLast' })
            .catch((err: Error) => {
              console.error('跳转失败：', err.message);
              promptAction.showToast({
                message: '页面不存在，请检查配置',
                duration: 2000
              });
            });
        })
    }
    .width('100%')
    .height(50)
    .padding({ left: 30, right: 30 })
    .backgroundColor(Color.White)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }
}

export default GrabOrderPage;