import router from '@ohos.router'

// 药品数据结构
interface Medicine {
  id: number;
  name: string;
  spec: string;
  factory: string;
  price: number;
}

@Entry
@Component
struct DrugListPage {
  @State diseaseName: string = '药品';  // 使用 @State
  @State medicineList: Medicine[] = [
    {
      id: 1,
      name: '钙铁锌咀嚼片',
      spec: '1.2g*60片',
      factory: '特一药业集团股份有限公司',
      price: 25.00
    },
    {
      id: 2,
      name: '钙铁锌咀嚼片',
      spec: '1.2g*60片',
      factory: '特一药业集团股份有限公司',
      price: 25.00
    },
    {
      id: 3,
      name: '钙铁锌咀嚼片',
      spec: '1.2g*60片',
      factory: '特一药业集团股份有限公司',
      price: 25.00
    },
    {
      id: 4,
      name: '钙铁锌咀嚼片',
      spec: '1.2g*60片',
      factory: '特一药业集团股份有限公司',
      price: 25.00
    },
    {
      id: 5,
      name: '钙铁锌咀嚼片',
      spec: '1.2g*60片',
      factory: '特一药业集团股份有限公司',
      price: 25.00
    },
    {
      id: 6,
      name: '钙铁锌咀嚼片',
      spec: '1.2g*60片',
      factory: '特一药业集团股份有限公司',
      price: 25.00
    }
  ];

  // 在页面加载时获取路由参数
  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['diseaseName']) {
      this.diseaseName = params['diseaseName'];
    }
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
            router.back();
          })

        Text(`${this.diseaseName}药品`)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      // 搜索框
      TextInput({ placeholder: '请输入药品信息' })
        .width('90%')
        .height(40)
        .margin({ top: 16, bottom: 16 })
        .backgroundColor('#f5f5f5')
        .borderRadius(20)
        .placeholderColor('#999')
        .fontSize(14)

      // 药品列表 - divider 放在 List 上
      List() {
        ForEach(this.medicineList, (item: Medicine, index: number) => {
          ListItem() {
            Row() {
              // 左侧药品图标（使用文字替代图片）
              Column() {
                Text('💊')
                  .fontSize(36)
              }
              .width(80)
              .height(80)
              .backgroundColor('#e8f0fe')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .margin({ right: 12 })

              // 中间药品信息
              Column() {
                Text(`${item.name} ${item.spec}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 4 })

                Text(item.factory)
                  .fontSize(14)
                  .fontColor('#999')
                  .margin({ bottom: 8 })

                Text(`¥${item.price.toFixed(2)}`)
                  .fontSize(16)
                  .fontColor('#ff4d4f')
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              // 右侧按钮
              Button('加入常用药品')
                .width(120)
                .height(32)
                .fontSize(14)
                .backgroundColor('#fff')
                .fontColor('#3677F2')
                .border({ width: 1, color: '#3677F2' })
                .borderRadius(16)
                .onClick(() => {
                  router.pushUrl({
                    url: 'pages/HomePages/MypharmacyPage',
                  });
                })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
          }
        }, (item: Medicine) => item.id.toString())

        // 底部提示
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
      .layoutWeight(1)
      .backgroundColor('#fff')
      .divider({ strokeWidth: 1, color: '#eee' })  // divider 放在 List 上
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}