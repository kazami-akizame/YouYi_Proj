import router from '@ohos.router';
import { http } from '@kit.NetworkKit';

interface OrderItem {
  id: number;
  time: string;
  name: string;
  serviceType: string;
  status: string;
  price: string;
  serviceColor: string;
  patientName: string;
  patientGender: string;
  patientAge: string;
  patientPhone: string;

  department?: string;
  discount?: string;
  realPay?: string;
  realRefund?: string;
  orderNo?: string;
  createTime?: string;
  payTime?: string;
  payType?: string;
  refundTime?: string;
  refundType?: string;
  closeReason?: string;
}

@Entry
@Component
struct DoctorOrderDetail {
  @State order: OrderItem | null = null;
  @State isLoading: boolean = true;

  onPageShow() {
    this.fetchData();
  }

  fetchData() {
    const params = router.getParams() as Record<string, number>;
    const id = params?.id ?? 1;

    let httpRequest = http.createHttp();
    const url = 'http://localhost:8888/doctorOrder';
    httpRequest.request(
      url,
      { method: http.RequestMethod.GET },
      (err, data) => {
        if (!err) {
          try {
            const jsonStr = data.result.toString();
            const orderList = JSON.parse(jsonStr) as OrderItem[];
            const foundOrder = orderList.find(item => String(item.id) === String(id));
            if (foundOrder) {
              this.order = foundOrder;
            }
          } catch (e) {
            console.error('JSON 解析失败', e);
          }
        } else {
          console.error('网络请求失败', err);
        }
        this.isLoading = false;
        httpRequest.destroy();
      }
    );
  }

  build() {
    if (this.isLoading) {
      Column() {
        LoadingProgress()
          .width(40)
          .height(40)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else if (this.order) {
      Scroll() {
        Column() {
          // 顶部导航栏
          Row() {
            Image($r('app.media.u695'))
              .width(24)
              .height(24)
              .onClick(() => {
                router.back();
              })

            Text("订单详情")
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .padding({ top: 12, bottom: 12, left: 16, right: 16 })
          .backgroundColor('#FFFFFF')

          // 订单状态
          Row() {
            Text("订单状态")
              .fontSize(14)
              .fontColor("#666")
              .width(80)

            Text(this.order.status ?? "-")
              .fontSize(14)
              .fontColor("#FF4444")
              .layoutWeight(1)
              .textAlign(TextAlign.End)
          }
          .width('90%')
          .backgroundColor("#FFFFFF")
          .padding(20)
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 患者信息卡片
          Column() {
            Text("患者信息")
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 16 })

            Row() {
              Text("姓名")
                .width(80)
                .fontColor("#666")
              Text(this.order.patientName ?? "未知")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("性别")
                .width(80)
                .fontColor("#666")
              Text(this.order.patientGender ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("年龄")
                .width(80)
                .fontColor("#666")
              Text(this.order.patientAge ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("手机")
                .width(80)
                .fontColor("#666")
              Text(this.order.patientPhone ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
          }
          .width('90%')
          .padding(20)
          .backgroundColor("#FFFFFF")
          .borderRadius(12)
          .margin({ bottom: 16 })

          // 订单信息卡片
          Column() {
            Text("订单信息")
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 16 })

            Row() {
              Text("问诊类型")
                .width(80)
                .fontColor("#666")
              Text(this.order.serviceType ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("问诊科室")
                .width(80)
                .fontColor("#666")
              Text(this.order.department ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("问诊单价")
                .width(80)
                .fontColor("#666")
              Text(this.order.price ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("优惠")
                .width(80)
                .fontColor("#666")
              Text(this.order.discount ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("实付款")
                .width(80)
                .fontColor("#666")
              Text(this.order.realPay ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            // 退款信息
            if (this.order.status === "已退款" || this.order.realRefund !== undefined) {
              Divider()
                .strokeWidth(1)
                .color('#F5F5F5')
                .margin({ top: 12, bottom: 12 })

              Row() {
                Text("实退款")
                  .width(80)
                  .fontColor("#666")
                Text(this.order.realRefund ?? "-")
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 12 })

              Row() {
                Text("退款时间")
                  .width(80)
                  .fontColor("#666")
                Text(this.order.refundTime ?? "-")
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 12 })

              Row() {
                Text("退款方式")
                  .width(80)
                  .fontColor("#666")
                Text(this.order.refundType ?? "-")
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 12 })
            }

            Divider()
              .strokeWidth(1)
              .color('#F5F5F5')
              .margin({ top: 12, bottom: 12 })

            Row() {
              Text("订单编号")
                .width(80)
                .fontColor("#666")
              Text(this.order.orderNo ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("创建时间")
                .width(80)
                .fontColor("#666")
              Text(this.order.createTime ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("支付时间")
                .width(80)
                .fontColor("#666")
              Text(this.order.payTime ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text("支付方式")
                .width(80)
                .fontColor("#666")
              Text(this.order.payType ?? "-")
                .layoutWeight(1)
                .textAlign(TextAlign.End)
            }
            .width('100%')
            .margin({ bottom: 12 })

            // 关闭原因
            if (this.order.status === "已关闭" || this.order.closeReason !== undefined) {
              Divider()
                .strokeWidth(1)
                .color('#F5F5F5')
                .margin({ top: 12, bottom: 12 })

              Row() {
                Text("关闭原因")
                  .width(80)
                  .fontColor("#666")
                Text(this.order.closeReason ?? "-")
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
              .margin({ bottom: 12 })
            }
          }
          .width('90%')
          .padding(20)
          .backgroundColor("#FFFFFF")
          .borderRadius(12)
          .margin({ bottom: 20 })
        }
        .width('100%')
        .backgroundColor('#F5F5F5')
      }
      .height('100%')
    }
  }
}