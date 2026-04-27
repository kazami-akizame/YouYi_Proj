import router from '@ohos.router';
import { LoginBusiness } from '../../business/LoginBusiness';
import prompt from '@ohos.prompt';

@Entry
@Component
struct Login {
  @State phoneNumber: string = '';
  @State verifyCode: string = '';
  @State isSendingCode: boolean = false;
  @State countdown: number = 0;
  @State errorTip: string = '';  // 错误提示
  @State showRegisterTip: boolean = false;  // 是否显示注册提示
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
  async sendVerifyCode() {
    if (this.isSendingCode) {
      return;
    }

    if (!this.phoneNumber) {
      this.errorTip = '请输入手机号码';
      return;
    }

    // 清空错误提示
    this.errorTip = '';
    this.showRegisterTip = false;

    const success = await LoginBusiness.handleSendCode(this.phoneNumber);
    if (success) {
      this.startCountdown();
    } else {
      // 发送失败（可能是用户未注册或其他原因）
      // 错误提示已经在LoginBusiness中通过toast显示
    }
  }

  // 登录
  async handleLogin() {
    console.log(`Login: 准备登录, 手机号: ${this.phoneNumber}, 验证码: ${this.verifyCode}`);
    const success = await LoginBusiness.handleLogin(this.phoneNumber, this.verifyCode);
    if (success) {
      // 登录成功，保存用户手机号到 AppStorage
      AppStorage.setOrCreate<string>('currentUserPhone', this.phoneNumber);
      console.log(`Login: 保存当前用户手机号到 AppStorage: ${this.phoneNumber}`);
      
      //👈 👈 跳转到首页（避免跳回Index造成循环）
      // ------------------------------
      //！！！后期改成跳转真正的首页
      // ------------------------------
      router.replaceUrl({ url: 'pages/Login_Register/DoctorCertification' });
    }
  }

  aboutToDisappear() {
    this.stopCountdown();
  }

  build() {
    Column() {
      // 1. 顶部图标（iOS 更大更精致）
      Image($r('app.media.img1'))
        .width(120)
        .height(120)
        .objectFit(ImageFit.Contain)
        .margin({ top: 60, bottom: 20 })

      // 2. 标题（iOS 紧凑优雅）
      Text("手机验证码登录")
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 6 })
      Text("欢迎登录有道在线问诊医生端")
        .fontSize(15)
        .fontColor("#8E8E93") // iOS 标准灰色
        .margin({ bottom: 28 })

      // 错误提示区域（iOS 卡片圆角）
      if (this.errorTip) {
        Column() {
          Text(this.errorTip)
            .fontSize(14)
            .fontColor(this.showRegisterTip ? "#D4A147" : "#FF3B30")
            .textAlign(TextAlign.Center)

          if (this.showRegisterTip) {
            Text("立即注册")
              .fontSize(14)
              .fontColor("#007AFF")
              .fontWeight(FontWeight.Medium)
              .margin({ top: 4 })
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/Login_Register/Register',
                  params: { phoneNumber: this.phoneNumber }
                });
              })
          }
        }
        .width('85%')
        .padding(12)
        .backgroundColor(this.showRegisterTip ? "#FFF8E6" : "#FFF2F2")
        .borderRadius(12) // iOS 大圆角
        .margin({ bottom: 24 })
      }

      // 3. 手机号输入框
      Row() {
        Image($r('app.media.img_7'))
          .width(22)
          .height(22)
          .margin({ right: 10 })
        Text("+86")
          .fontSize(16)
          .fontColor("#000000")
          .margin({ right: 8 })
        TextInput({ placeholder: "请输入手机号码", text: this.phoneNumber })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .onChange((value: string) => {
            this.phoneNumber = value;
            this.errorTip = '';
            this.showRegisterTip = false;
          })
          .type(InputType.PhoneNumber)
      }
      .width('85%')
      .height(52)
      .padding({ left: 16 })
      .backgroundColor(Color.White)
      .borderRadius(14) // iOS 圆角
      .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 }) // 轻阴影
      .border({
        width: this.errorTip && !this.showRegisterTip ? 1.5 : 0,
        color: this.errorTip && !this.showRegisterTip ? "#FF3B30" : Color.Transparent
      })
      .margin({ bottom: 16 })

      // 4. 验证码输入框
      Row() {
        Image($r('app.media.img_6'))
          .width(22)
          .height(22)
          .margin({ right: 10 })
        TextInput({ placeholder: "请输入验证码" })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .type(InputType.Number)
          .margin({ right: 8 })
          .onChange((value: string) => {
            this.verifyCode = value;
          })

        Text(this.isSendingCode ? `${this.countdown}s` : "获取验证码")
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.isSendingCode ? "#8E8E93" : "#007AFF")
          .enabled(!this.isSendingCode)
          .onClick(() => {
            this.sendVerifyCode();
          })
      }
      .width('85%')
      .height(52)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
      .margin({ bottom: 12 })

      // 提示文字
      Text("请输入注册时使用的手机号")
        .fontSize(12)
        .fontColor("#8E8E93")
        .width('85%')
        .margin({ bottom: 24 })

      // 账号密码登录
      Text("账号密码登录")
        .fontSize(15)
        .fontColor("#007AFF")
        .fontWeight(FontWeight.Medium)
        .alignSelf(ItemAlign.Start)
        .margin({ left: "7.5%", bottom: 32 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Login_Register/LoginPin' });
        })

      // 6. 登录按钮（iOS 质感按钮）
      Button("登录")
        .width('85%')
        .height(54)
        .backgroundColor("#007AFF")
        .borderRadius(14)
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .shadow({ radius: 3, color: "#007AFF30", offsetX: 0, offsetY: 2 })
        .margin({ bottom: 24 })
        .onClick(() => {
           this.handleLogin();
        })

      // 注册新用户
      Text("注册新用户")
        .fontSize(15)
        .fontColor("#007AFF")
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 24 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Login_Register/Register' });
        })

      Blank().layoutWeight(1)

      // 底部隐私政策
      Text("登录即代表您已同意有道医生在线问诊隐私政策")
        .fontSize(12)
        .fontColor("#8E8E93")
        .textAlign(TextAlign.Center)
        .margin({ bottom: 24 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Login_Register/PrivacyPolicy' });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F2F2F7")
  }
}