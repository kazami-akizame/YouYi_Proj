import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';

// 药品数据模型（前后端通用）
interface Medicine {
  id?: number;
  name: string;
  spec: string;
  company: string;
  price: number;
  imageUrl?: Resource;
}

@Entry
@Component
struct MedicineListPage {
  @State searchText: string = '';
  // 🔥 动态列表（从后端加载）
  @State medicineList: Medicine[] = [];

  // 后端接口地址
  private readonly baseUrl: string = "http://127.0.0.1:8888/medicineslist";

  // 页面打开自动加载后端数据
  onPageShow(): void {
    this.loadMedicines();
  }

  // ==========================
  // 1. 🔥 GET 加载药品列表
  // ==========================
  loadMedicines(): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(this.baseUrl, {
      method: http.RequestMethod.GET
    }).then((res: http.HttpResponse): void => {
      if (res.responseCode === 200) {
        try {
          const data: Medicine[] = JSON.parse(res.result as string);
          const finalList: Medicine[] = [];

          // 手动赋值图片（不使用...扩展符，无报错）
          for (let i = 0; i < data.length; i++) {
            const item = data[i];
            finalList.push({
              id: item.id,
              name: item.name,
              spec: item.spec,
              company: item.company,
              price: item.price,
              imageUrl: $r('app.media.u1107')
            });
          }
          this.medicineList = finalList;
        } catch (e) {}
      }
    }).catch(() => {});
  }

  build() {
    Column() {
      // 顶部导航（完全不变）
      Row() {
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .onClick(() => { router.back(); })

        Text('我的常用药品')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row().width(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      // 搜索栏（完全不变）
      Row() {
        Stack() {
          Row() {
            Image($r('app.media.u2201'))
              .width(18)
              .height(18)
              .margin({ right: 8 })
              .opacity(0.6)

            Text("请输入药品信息")
              .fontSize(15)
              .fontColor('#999999')
              .layoutWeight(1)
          }
          .width('100%')
          .height(36)
          .padding({ left: 12, right: 12 })
          .backgroundColor('#F5F5F5')
          .borderRadius(18)

          Row()
            .width('100%')
            .height('10')
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              router.pushUrl({ url: 'pages/HomePages/MedicineSearchPage' })
            })
        }
        .width('100%')
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 8, bottom: 12 })
      .backgroundColor(Color.White)

      // 药品列表（动态渲染）
      List() {
        ForEach(this.medicineList, (item: Medicine) => {
          ListItem() { this.MedicineItem(item) }
        })

        ListItem() {
          Text('没有更多了～')
            .fontSize(14)
            .fontColor('#999999')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ top: 20, bottom: 20 })
        }
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor('#F8F8F8')
      .divider({ strokeWidth: 1, color: '#EEEEEE' })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8')
  }

  // 药品列表项（完全不变）
  @Builder
  MedicineItem(item: Medicine) {
    Row() {
      Image(item.imageUrl ?? $r('app.media.u1107'))
        .width(50)
        .height(50)
        .backgroundColor('#E8F3FF')
        .borderRadius(8)
        .margin({ right: 12 })

      Column() {
        Text(`${item.name} ${item.spec}`)
          .fontSize(16)
          .width('100%')
          .margin({ bottom: 8 })

        Text(item.company)
          .fontSize(14)
          .fontColor('#666666')
          .width('100%')
          .margin({ bottom: 12 })

        Row() {
          Text(`¥ ${item.price.toFixed(2)}`)
            .fontSize(18)
            .fontColor('#FF3B30')
            .fontWeight(FontWeight.Bold)

          Blank()

          Button('加入处方')
            .fontSize(14)
            .fontColor('#007AFF')
            .backgroundColor(Color.Transparent)
            .border({ width: 1, color: '#007AFF', radius: 20 })
            .padding({ left: 16, right: 16, top: 6, bottom: 6 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/HomePages/MedicineUsagePage' });
            })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .onClick(() => {
      router.pushUrl({ url: 'pages/HomePages/MedicineDetailPage',
        params: { id: item.id }});
    })
  }
}