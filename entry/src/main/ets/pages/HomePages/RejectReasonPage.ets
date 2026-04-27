// pages/RejectReasonPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct RejectReasonPage {
  @State selectedReason: string = '';
  private reasonOptions: string[] = ['咨询不对症', '患者缺少诊疗资料', '患者病情复杂'];

  // 提交退诊
  submit() {
    if (!this.selectedReason) {
      promptAction.showToast({ message: '请选择退诊原因' });
      return;
    }
    // 返回上一页并携带退诊原因
    router.back({
      url: 'pages/HomePages/ChatPage',
      params: { rejectReason: this.selectedReason }
    });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r("app.media.left"))
          .width(14)
          .onClick(() => router.back())
        Text('选择退诊原因')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        if (this.selectedReason) {
          Text('提交')
            .fontSize(16)
            .fontColor('#007AFF')
            .width(60)
            .textAlign(TextAlign.Center)
            .onClick(() => this.submit())
        } else {
          Blank().width(60)
        }
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')
      .padding({ left: 20, right: 8 })

      // 原因列表
      Column() {
        ForEach(this.reasonOptions, (reason: string, index: number) => {
          Row() {
            Radio({ value: reason, group: 'rejectGroup' })
              .checked(this.selectedReason === reason)
              .onChange((isChecked: boolean) => {
                if (isChecked) this.selectedReason = reason;
              })
            Text(reason)
              .fontSize(16)
              .fontColor('#333')
              .margin({ left: 12 })
          }
          .width('100%')
          .height(56)
          .padding({ left: 16, right: 16 })
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 1 })
          .onClick(() => {
            this.selectedReason = reason;
          })
        }, (reason: string, index: number) => index.toString())
      }
      .width('100%')
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}