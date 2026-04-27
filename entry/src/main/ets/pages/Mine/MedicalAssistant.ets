import router from '@ohos.router';

@Entry
@Component
struct MedicalAssistant {
  @State inputText: string = "";
  @State currentTime: string = "";

  // 纯原生Date，无任何系统API依赖，永远不会报系统能力缺失
  getSystemTime() {
    const now = new Date();
    // 补零函数：个位数时间自动补0，保证 HH:MM 格式
    const padZero = (num: number) => num < 10 ? '0' + num : num;
    const hour = padZero(now.getHours());
    const minute = padZero(now.getMinutes());
    this.currentTime = `${hour}:${minute}`;
  }

  // 页面打开自动执行获取时间
  onPageShow() {
    this.getSystemTime();
  }

  build() {
    Column(){
      Row() {
        Image($r('app.media.u695'))
          .width(20)
          .onClick(() => {
            router.back();
          })

        Text("医生助手")
          .fontSize(30)
          .textAlign(TextAlign.Center)
          .layoutWeight(1)

        Blank().width(20)
      }
      .height(50)
      .width('100%')
      .padding({ left:15, right:15 })
      .backgroundColor("#fff")
      .alignItems(VerticalAlign.Center)

      // 聊天消息滚动区域
      List()
      {
        ListItem() {
          Column({ space: 8 }) {
            // 自动获取的系统当前时间
            Text(this.currentTime)
              .fontSize(12)
              .fontColor("#999")
              .width('100%')
              .textAlign(TextAlign.Center)

            // 医生初始消息
            Row() {
              Image($r('app.media.u5936'))
                .width(40)
                .height(40)
                .borderRadius(20)
                .margin({ right: 10 })

              Text("您好，这里是医生助手，请问有什么可以帮您？")
                .fontSize(14)
                .fontColor("#333")
                .padding(12)
                .backgroundColor("#fff")
                .borderRadius(16)
                .constraintSize({ maxWidth: '70%' })
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .margin({ top:10, bottom:10 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#f5f5f5")
      .padding(10)

      // 底部输入栏
      Row() {
        Image($r('app.media.u2887'))
          .width(24)
          .height(24)

        TextInput({ text: this.inputText, placeholder: "请输入您的问题" })
          .layoutWeight(1)
          .height(40)
          .borderRadius(20)
          .backgroundColor("#f5f5f5")
          .padding({ left:15, right:15 })
          .onChange((value: string) => {
            this.inputText = value;
          })

        Button("发送")
          .width(80)
          .height(40)
          .borderRadius(20)
          .backgroundColor("#cce5ff")
          .onClick(() => {
            console.log("发送消息：" + this.inputText);
            this.inputText = "";
          })

        Image($r('app.media.u2889'))
          .width(24)
          .height(24)
          .margin({ left: 15 })

        Image($r('app.media.u2888'))
          .width(24)
          .height(24)
          .margin({ left: 15 })
      }
      .width('100%')
      .height(60)
      .padding({ left:15, right:15 })
      .backgroundColor("#fff")
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}