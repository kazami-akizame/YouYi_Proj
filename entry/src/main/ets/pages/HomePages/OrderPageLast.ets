import { router } from '@kit.ArkUI';
import { promptAction } from '@kit.ArkUI';

interface MedicineItem {
  name: string;
  spec: string;
  price: number;
  count: number;
  usage: string;
}

@Entry
@Component
struct OrderPageLast {
  @State userName: string = '李晓明';
  @State gender: string = '女';
  @State age: number = 23;
  @State publishTime: string = '5分钟前';
  @State department: string = '内科-消化内科';
  @State consultType: string = '开药问诊';
  @State totalPrice: number = 29.00;

  @State disease: string = '急性肠胃炎';
  @State liverFunc: string = '正常';
  @State kidneyFunc: string = '正常';
  @State allergy: string = '无';
  @State birthPlan: string = '无';

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
      this.buildNavBar()
      Scroll() { this.buildOrderCard() }
      .layoutWeight(1)
      this.buildBottomActionBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildNavBar() {
    Row() {
      Image($r('app.media.u695'))
        .width(18)
        .height(18)
        .onClick(() => router.back())
      Blank()
      Text('抢单中心').fontSize(18).fontWeight(FontWeight.Medium)
      Blank()
      Text('').width(18)
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  buildOrderCard() {
    Column({ space: 14 }) {
      Row() {
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

        Text(this.publishTime)
          .fontSize(14)
          .fontColor('#999999')
      }

      Row() {
        Text(this.department).fontSize(15).fontColor('#007AFF')
        Text(this.consultType)
          .fontSize(13)
          .fontColor('#009955')
          .backgroundColor('#E6F9F0')
          .padding(6)
          .borderRadius(4)
          .margin({ left: 10 })
        Blank()
        Text(`¥${this.totalPrice.toFixed(2)}`)
          .fontSize(18)
          .fontColor('#FF3B30')
          .fontWeight(FontWeight.Bold)
      }

      Column({ space: 6 }) {
        Text(`所患疾病：${this.disease}`).fontSize(15)
        Text(`肝功能：${this.liverFunc}`).fontSize(15)
        Text(`肾功能：${this.kidneyFunc}`).fontSize(15)
        Text(`过敏史：${this.allergy}`).fontSize(15)
        Text(`生育状态及计划：${this.birthPlan}`).fontSize(15)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)

      Divider()
      Text('处方凭证').fontSize(16).fontWeight(FontWeight.Medium).width('100%')
      Row() {
        Image($r('app.media.u1288'))
          .width(140)
          .height(110)
          .backgroundColor('#E8F3FF')
          .borderRadius(6)
      }
      .justifyContent(FlexAlign.Start)

      Divider()
      Text('已选药品及用药情况').fontSize(16).fontWeight(FontWeight.Medium).width('100%')

      ForEach(this.medicineList, (item: MedicineItem) => {
        Column() {
          Row() {
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
                .padding(4)
                .position({ y: 52 })
            }

            Column() {
              Text(item.name).fontSize(15)
              Text(item.spec).fontSize(13).fontColor('#666')
              Text(`¥${item.price.toFixed(2)}`).fontColor('#FF3B30')
            }
            .layoutWeight(1)
            .margin({ left: 12 })

            Text(`x${item.count}`)
          }

          if (item.usage) {
            Text(`用药情况：${item.usage}`)
              .fontSize(14)
              .lineHeight(22)
              .width('100%')
          }
        }
        .margin({ bottom: 12 })
      })
    }
    .width('92%')
    .padding(18)
    .backgroundColor(Color.White)
    .borderRadius(10)
    .margin({ top: 12 })
  }

  @Builder
  buildBottomActionBar() {
    Row() {
      Text('上一条')
        .fontSize(16)
        .fontColor('#666')
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/GrabOrderPage' })
            .catch(() => promptAction.showToast({ message: '跳转失败' }));
        })

      Blank()

      Button('抢单')
        .width(100)
        .height(100)
        .backgroundColor('#007AFF')
        .fontColor(Color.White)
        .borderRadius(50)
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/ChatPage' });
        })

      Blank()

      Text('下一条')
        .fontSize(16)
        .fontColor('#666')
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/GrabOrderPage' })
            .catch(() => promptAction.showToast({ message: '跳转失败' }));
        })
    }
    .width('100%')
    .height(110)
    .padding({ left: 30, right: 30 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }
}

export default OrderPageLast;