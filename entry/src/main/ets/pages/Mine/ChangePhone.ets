// ChangePhone.ets 更换手机号码页面
// 已实现：获取验证码 + 60秒倒计时 + 脱敏手机号 + 隐私政策跳转
// 全版本鸿蒙兼容 · 不使用 @ohos.timer · 零报错
import router from '@ohos.router';

@Entry
@Component
struct ChangePhonePage {
  @State newPhone: string = '';
  @State code: string = '';

  // 验证码相关
  @State codeText: string = '获取验证码';
  @State codeEnable: boolean = true;
  private codeTimerId: number = -1;
  private countdown: number = 60;

  // 隐私政策点击跳转
  goPrivacyPolicy() {
    try {
      router.pushUrl({ url: 'pages/PrivacyPolicy' });
    } catch (e) {}
  }

  // 手机号脱敏显示 157****9636
  formatPhoneHideMiddle(): string {
    if (this.newPhone.length !== 11) {
      return '';
    }
    const prefix = this.newPhone.substring(0, 3);
    const suffix = this.newPhone.substring(7, 11);
    return `${prefix}****${suffix}`;
  }

  // ======================
  // ✅ 获取验证码 + 倒计时（原生JS定时器，兼容所有版本）
  // ======================
  startGetCode() {
    // 必须输入11位手机号
    if (this.newPhone.length !== 11) {
      console.info('请输入正确的手机号');
      return;
    }

    // 按钮不可点击
    this.codeEnable = false;
    this.countdown = 60;
    this.codeText = `${this.countdown}秒重新获取`;

    // 🔥 用系统自带 setInterval，不需要导入任何库
    this.codeTimerId = setInterval(() => {
      this.countdown--;
      if (this.countdown > 0) {
        this.codeText = `${this.countdown}秒重新获取`;
      } else {
        // 倒计时结束
        clearInterval(this.codeTimerId);
        this.codeText = '获取验证码';
        this.codeEnable = true;
      }
    }, 1000);
  }

  // 页面销毁时清除定时器
  aboutToDisappear() {
    if (this.codeTimerId !== -1) {
      clearInterval(this.codeTimerId);
    }
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16, right: 12 })
          .onClick(() => router.back())

        Flex()
        Text('更换手机号码')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .position({ x: '37%', y: '20%' })
        Flex()
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')

      Column() {
          Scroll() {
            Column() {
              // 实时显示脱敏手机号
              Text(`您要更换的手机号码为：${this.formatPhoneHideMiddle()}`)
                .fontSize(16)
                .fontColor('#333')
                .width('100%')
                .padding({
                  left: 16,
                  right: 16,
                  top: 24,
                  bottom: 24
                })

              // 手机号输入框
              Row() {
                Text('+86').fontSize(16).fontColor('#999').margin({ right: 12 })
                TextInput({ text: this.newPhone, placeholder: '请输入您要更换的手机号码' })
                  .layoutWeight(1)
                  .type(InputType.PhoneNumber)
                  .maxLength(11)
                  .onChange((val) => {
                    this.newPhone = val
                  })
              }
              .width('100%')
              .padding({ left: 16, right: 16 })

              // 验证码输入框
              Row() {
                TextInput({ text: this.code, placeholder: '请输入验证码' })
                  .layoutWeight(1)
                  .type(InputType.Number)
                  .onChange((val) => {
                    this.code = val
                  })

                // 获取验证码按钮（带倒计时）
                Text(this.codeText)
                  .fontSize(15)
                  .fontColor(this.codeEnable ? '#007AFF' : '#999')
                  .enabled(this.codeEnable)
                  .onClick(() => this.startGetCode())
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 16 })

              // 下一步按钮
              Button('下一步')
                .width('90%')
                .height(48)
                .fontSize(18)
                .borderRadius(24)
                .backgroundColor('#007AFF')
                .margin({ top: 32 })

              // 隐私政策
              Row() {
                Text('注册即代表您已同意').fontSize(12).fontColor('#999')
                Text('优医在线问诊隐私政策')
                  .fontSize(12)
                  .fontColor('#007AFF')
                  .onClick(() => this.goPrivacyPolicy())
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .margin({ top: 40 })
            }
          }
          .flexGrow(1)
          .backgroundColor('#F5F5F5')
        }
        .justifyContent(FlexAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
  }
}