import router from '@ohos.router';
import { PasswordBusiness } from '../../business/PasswordBusiness';
import prompt from '@ohos.prompt';

@Entry
@Component
struct FindPassword {
  // 绑定输入框值
  @State phoneNumber: string = '';
  @State verifyCode: string = '';
  @State isSendingCode: boolean = false;
  @State countdown: number = 0;
  @State errorTip: string = '';
  private countdownTimer: number = -1;

  // 倒计时
  startCountdown() {
    this.countdown = 60;
    this.isSendingCode = true;
    this.countdownTimer = setInterval(() => {
      if (this.countdown > 0) {
        this.countdown--;
      } else {
        this.stopCountdown();
      }
    }, 1000);
  }

  stopCountdown() {
    if (this.countdownTimer !== -1) {
      clearInterval(this.countdownTimer);
      this.countdownTimer = -1;
    }
    this.isSendingCode = false;
    this.countdown = 0;
  }

  // 发送验证码
  async handleSendCode() {
    if (this.isSendingCode) {
      return;
    }

    if (!this.phoneNumber) {
      this.errorTip = '请输入手机号码';
      return;
    }

    this.errorTip = '';
    const success = await PasswordBusiness.handleSendCode(this.phoneNumber);
    
    if (success) {
      this.startCountdown();
    } else {
      this.errorTip = '该手机号尚未注册';
    }
  }

  // 下一步
  async handleNext() {
    this.errorTip = '';
    
    if (!this.phoneNumber || this.phoneNumber.length !== 11) {
      this.errorTip = '请输入正确的手机号';
      return;
    }
    
    if (!this.verifyCode || this.verifyCode.length !== 6) {
      this.errorTip = '请输入6位验证码';
      return;
    }

    // 验证验证码
    const success = await PasswordBusiness.verifyResetCode(this.phoneNumber, this.verifyCode);
    
    if (success) {
      console.log('验证码验证成功，进入修改密码页面');
      // 跳转到修改密码页面，携带手机号
      router.pushUrl({
        url: 'pages/Login_Register/NewPin',
        params: {
          phoneNumber: this.phoneNumber,
          isResetPassword: true  // 标记是找回密码
        }
      });
    } else {
      this.errorTip = '验证码错误或已过期';
    }
  }

  aboutToDisappear() {
    this.stopCountdown();
  }

  build() {
    Column() {
      // 1. 顶部导航栏
      Stack({ alignContent: Alignment.Center }) {
        // 返回按钮
        Row() {
          Image($r('app.media.img_4')) // 替换为你的返回图标资源
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .padding({ left: 20 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.back(); // 👈 点击返回上一页
        })

        // 标题
        Text("修改密码")
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)

      // 2. 输入框区域
      Column({ space: 20 }) {
        // 手机号输入框（带+86前缀）
        Row() {
          Image($r('app.media.img_7')) // 替换为你的用户图标资源
            .width(20)
            .height(20)
            .margin({ right: 8 })
          Text("+86")
            .fontSize(16)
            .margin({ right: 10 })
            .padding({ right: 10 })
          TextInput({ placeholder: "请输入手机号码", text: this.phoneNumber })
            .layoutWeight(1)
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .onChange((value: string) => {
              this.phoneNumber = value;
            })
        }
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#fff")
        .padding({ left: 15 })

        // 验证码输入框 + 获取验证码按钮
        Row() {
          Image($r('app.media.img_6'))
            .width(20)
            .height(20)
            .margin({ right: 8 })
          TextInput({ placeholder: "请输入验证码", text: this.verifyCode })
            .layoutWeight(1)
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .margin({ right: 10 })
            .onChange((value: string) => {
              this.verifyCode = value;
            })
          Button(this.isSendingCode ? `${this.countdown}s` : "获取验证码")
            .fontSize(14)
            .fontColor(this.isSendingCode ? "#999" : "#007aff")
            .backgroundColor(Color.Transparent)
            .enabled(!this.isSendingCode)
            .onClick(() => {
              this.handleSendCode();
            })
        }
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#fff")
        .padding({ left: 15, right: 15 })
      }
      .margin({ top: 30, bottom: 40 })

      // 错误提示
      if (this.errorTip) {
        Text(this.errorTip)
          .fontSize(14)
          .fontColor(Color.Red)
          .width('85%')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 10 })
      }

      // 3. 下一步按钮
      Button("下一步")
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#007aff")
        .fontSize(18)
        .fontColor("#fff")
        .onClick(() => {
          this.handleNext();
        })

      // 4. 自动撑开剩余空间，适配不同屏幕
      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }
}