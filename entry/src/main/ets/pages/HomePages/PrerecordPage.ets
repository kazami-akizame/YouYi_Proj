import router from '@ohos.router';

@Entry
@Component
struct HistoryPrescriptionDetailPage {
  @State showImagePreview: boolean = false;

  build() {
    Stack() {
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

          Text('历史处方详情')
            .fontSize(18)
            .layoutWeight(1) .margin({ left: 50 })
            .textAlign(TextAlign.Center)

          Text('查看原始处方')
            .fontSize(14)
            .fontColor('#3677F2')
            .margin({ right: 16 })
            .onClick(() => {
              this.showImagePreview = true;
            })
        }
        .width('100%')
        .height(56)
        .backgroundColor('#fff')

        // 主体内容区域（灰色背景）
        Scroll() {
          Column() {
            // 处方信息卡片
            Column() {
              // 处方编号和日期
              Row() {
                Text('NO: 2020280000')
                  .fontSize(14)
                  .fontColor('#666')

                Text('2020-02-23')
                  .fontSize(14)
                  .fontColor('#666')
              }
              .width('90%')
              .padding({ top: 16, bottom: 8 })
              .justifyContent(FlexAlign.SpaceBetween)

              // 医院名称
              Text('*****医院处方笺')
                .fontSize(20)
                .fontColor('#333')
                .width('100%')
                .textAlign(TextAlign.Center)
                .margin({ top: 12, bottom: 16 })

              Divider().color('#fff').width('100%').height(1)

              // 患者信息
              Column() {
                Row() {
                  Text('患者姓名')
                    .fontSize(14)
                    .fontColor('#333')
                    .width(80)

                  Text('吴珊珊')
                    .fontSize(14)
                    .fontColor('#3677F2')
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ top: 16, bottom: 16 })

                Divider().color('#ddd').width('100%').height(1)

                Row() {
                  Text('患者年龄')
                    .fontSize(14)
                    .fontColor('#333')
                    .width(80)

                  Text('23岁')
                    .fontSize(14)
                    .fontColor('#3677F2')
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ top: 16, bottom: 16 })

                Divider().color('#aaa').width('100%').height(1)

                Row() {
                  Text('患者性别')
                    .fontSize(14)
                    .fontColor('#333')
                    .width(80)

                  Text('女')
                    .fontSize(14)
                    .fontColor('#3677F2')
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ top: 16, bottom: 8 })
              }
              .width('100%')
              .padding({ left: 16, right: 16 })
            }
            .width('92%')
            .backgroundColor('#fff')
            .borderRadius(12)
            .margin({ top: 16 })

            // 诊断卡片
            Column() {
              Text('诊断')
                .fontSize(14)
                .fontColor('#333')
                .width('100%')
                .margin({ bottom: 12 })

              Text('感冒')
                .fontSize(16)
                .fontColor('#3677F2')
                .width('100%')
            }
            .width('92%')
            .backgroundColor('#fff')
            .borderRadius(12)
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .margin({ top: 16 })

            // 药品Rp卡片
            Column() {
              Text('Rp')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333')
                .margin({ bottom: 20 })
                .width('100%')

              Text('钙铁锌咀嚼片 * 1')
                .fontSize(16)
                .fontColor('#333')
                .margin({ bottom: 12 })
                .width('100%')

              Text('用法用量：2次/天，每次1片，温水送服')
                .fontSize(14)
                .fontColor('#666')
                .width('100%')
            }
            .width('92%')
            .backgroundColor('#fff')
            .borderRadius(12)
            .padding({ left: 16, right: 16, top: 16, bottom: 16 })
            .margin({ top: 16 })

            Blank().height(20)
          }
          .width('100%').height('100%')
        }
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')

        // 底部按钮栏
        Row() {
          Button('设为常用处方')
            .fontSize(14)
            .fontColor('#3677F2')
            .backgroundColor('#fff')
            .border({ width: 1, color: '#3677F2' })
            .borderRadius(22)
            .height(40)
            .layoutWeight(1)
            .onClick(() => {
              console.log('设为常用处方');
            })

          Button('续处方')
            .fontSize(14)
            .fontColor('#fff')
            .backgroundColor('#3677F2')
            .borderRadius(22)
            .height(40)
            .layoutWeight(1)
            .margin({ left: 12 })
            .onClick(() => {
              console.log('续处方');
            })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 12, bottom: 20 })
        .backgroundColor('#fff')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f5f5f5')

      // 图片预览遮罩层
      if (this.showImagePreview) {
        Column() {
          // 顶部关闭栏
          Row() {
            Blank()
            Text('✕')
              .fontSize(28)
              .fontColor('#fff')
              .width(44)
              .height(44)
              .textAlign(TextAlign.Center)
              .margin({ right: 16, top: 40 })
              .onClick(() => {
                this.showImagePreview = false;
              })
          }
          .width('100%')
          .height(80)

          // 图片
          Column() {
            Image($r('app.media.__80px_u1116'))
              .width('90%')
              .height('70%')
              .objectFit(ImageFit.Contain)
              .borderRadius(8)
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)

          // 底部提示
          Text('点击关闭')
            .fontSize(14)
            .fontColor('rgba(255,255,255,0.6)')
            .margin({ bottom: 40 })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.9)')
        .position({ x: 0, y: 0 })
        .zIndex(100)
        .onClick(() => {
          this.showImagePreview = false;
        })
      }
    }
    .width('100%')
    .height('100%')
  }
}