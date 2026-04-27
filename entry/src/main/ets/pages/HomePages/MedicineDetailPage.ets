import router from '@ohos.router';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';

// 药品数据模型（与你的 data.json 完全对应）
interface Medicine {
  id: number;
  name: string;
  price: number;
  originalPrice: number;
  manufacturer: string;
  description: string;
  images: string[];
}

interface RouterParams {
  id?: number;
}

@Entry
@Component
struct MedicineDetailPage {
  @State medicineData: Medicine | null = null;
  @State isLoading: boolean = true; // 加载状态
  @State errorMsg: string = ''; // 错误提示
  private baseUrl: string = 'http://127.0.0.1:8888/medicines';

  onPageShow(): void {
    this.isLoading = true;
    this.errorMsg = '';
    const params = router.getParams() as RouterParams;
    console.log("【详情页】收到的参数：", params); // 日志1：检查是否拿到 id

    if (!params?.id) {
      this.errorMsg = '未获取到药品ID';
      this.isLoading = false;
      return;
    }
    this.getMedicineDetail(params.id);
  }

  getMedicineDetail(id: number): void {
    const httpRequest = http.createHttp();
    console.log("【详情页】请求地址：", `${this.baseUrl}/${id}`); // 日志2：检查请求地址
    httpRequest.request(`${this.baseUrl}/${id}`, {
      method: http.RequestMethod.GET
    })
      .then((res: http.HttpResponse): void => {
        console.log("【详情页】响应码：", res.responseCode); // 日志3：检查响应状态
        if (res.responseCode === 200) {
          try {
            const resultStr: string = String(res.result);
            console.log("【详情页】接口返回数据：", resultStr); // 日志4：检查返回内容
            const data: Medicine = JSON.parse(resultStr);
            this.medicineData = data;
          } catch (e) {
            console.error("【详情页】JSON解析失败：", e);
            this.errorMsg = '数据解析失败';
          }
        } else {
          this.errorMsg = `请求失败，状态码：${res.responseCode}`;
        }
        this.isLoading = false;
      })
      .catch((err: Error) => {
        console.error("【详情页】请求异常：", err);
        this.errorMsg = '网络请求失败';
        this.isLoading = false;
      });
  }

  build() {
    Column() {
      // 顶部导航栏（完全不变）
      Row() {
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .onClick(() => {
            router.back(); // 用back()返回列表页更合理
          })

        Text('药品详情')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Row()
          .width(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      // 加载状态
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(50).height(50)
          Text('加载中...').fontSize(14).fontColor('#999999').margin({ top: 10 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      // 错误状态
      else if (this.errorMsg) {
        Column() {
          Text(this.errorMsg).fontSize(14).fontColor('#FF3B30')
          Button('重试').onClick(() => {
            const params = router.getParams() as RouterParams;
            if (params?.id) this.getMedicineDetail(params.id);
          }).margin({ top: 10 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      }
      // 数据加载完成
      else if (this.medicineData) {
        Scroll() {
          Column() {
            // 轮播图（动态渲染）
            Swiper() {
              ForEach(this.medicineData.images, () => {
                Image($r('app.media.u981'))
                  .width('90%')
                  .height(220)
                  .objectFit(ImageFit.Contain);
              })
            }
            .indicator(true)
            .autoPlay(true)
            .height(220)

            // 价格（动态）
            Row() {
              Text(`¥${this.medicineData.price}`)
                .fontSize(32)
                .fontColor('#FF3B30')
                .fontWeight(FontWeight.Bold)

              Text(`¥${this.medicineData.originalPrice}`)
                .fontSize(16)
                .fontColor('#999999')
                .decoration({ type: TextDecorationType.LineThrough })
                .margin({ left: 16 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 16 })
            .backgroundColor(Color.White)

            // 名称 + 厂商（动态）
            Column() {
              Text(this.medicineData.name)
                .fontSize(16)
                .fontColor('#333333')
                .fontWeight(FontWeight.Regular)
                .width('100%')
                .margin({ bottom: 12 })

              Text(`厂商：${this.medicineData.manufacturer}`)
                .fontSize(14)
                .fontColor('#999999')
                .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)

            // 药品说明书（动态）
            Column() {
              Text('药品说明')
                .fontSize(22)
                .fontColor('#333333')
                .fontWeight(FontWeight.Bold)
                .width('100%')
                .margin({ bottom: 14 })

              Text(this.medicineData.description)
                .fontSize(14)
                .fontColor('#999999')
                .lineHeight(24)
                .width('100%')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
          }
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}