import router from '@ohos.router';
import { RegisterBusiness } from '../../business/RegisterBusiness';
import prompt from '@ohos.prompt';

@Entry
@Component
struct Register {
  // 勾选状态
  @State isAgree: boolean = false;
  // 注册表单数据
  @State phone: string = '';
  @State password: string = '';
  @State code: string = '';
  // 错误提示
  @State errorTip: string = '';
  // 加载状态
  @State isLoading: boolean = false;
  // 倒计时
  @State countdown: number = 0;
  @State isSendingCode: boolean = false;
  private countdownTimer: number = -1;

  // 页面加载时接收参数
  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params.phoneNumber) {
      this.phone = params.phoneNumber;
      console.log('接收到手机号参数:', this.phone);
    }
  }

  // 页面销毁时清理定时器
  aboutToDisappear() {
    this.stopCountdown();
  }

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
    if (!this.phone || this.phone.length !== 11) {
      this.errorTip = '请输入正确的手机号';
      return;
    }
    
    this.errorTip = '';
    const success = await RegisterBusiness.handleSendCode(this.phone);
    
    if (success) {
      prompt.showToast({ message: '验证码已发送' });
      this.startCountdown();
    } else {
      this.errorTip = '该手机号已注册，请直接登录';
    }
  }

  // 注册
  async handleRegister() {
    if (this.isLoading) return;
    
    this.errorTip = '';
    
    // 表单校验
    if (!this.phone || this.phone.length !== 11) {
      this.errorTip = '请输入正确的手机号';
      return;
    }
    if (!this.password || this.password.length < 6) {
      this.errorTip = '密码长度不能少于6位';
      return;
    }
    if (!this.code || this.code.length !== 6) {
      this.errorTip = '请输入6位验证码';
      return;
    }
    if (!this.isAgree) {
      this.errorTip = '请先阅读并同意隐私政策';
      return;
    }

    this.isLoading = true;
    
    try {
      // 调用注册业务逻辑
      const success = await RegisterBusiness.handleRegister(
        this.phone,
        this.password,
        this.code
      );
      
      if (success) {
        // 注册成功后跳转到登录页
        router.replaceUrl({ url: 'pages/Login_Register/Login' });
      }
    } catch (error) {
      this.errorTip = '注册失败，请检查网络';
      console.error('注册异常:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 1. 顶部图标
      Image($r('app.media.img1'))
        .width(120)
        .height(120)
        .objectFit(ImageFit.Contain)
        .margin({ top: 60, bottom: 20 })

      // 2. 标题
      Text("账号注册")
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 6 })
      Text("欢迎注册有道在线问诊医生端")
        .fontSize(15)
        .fontColor("#8E8E93")
        .margin({ bottom: 36 })

      // 3. 手机号输入框
      Row() {
        Image($r('app.media.img_7'))
          .width(22)
          .height(22)
          .margin({ right: 12 })
        Text("+86")
          .fontSize(16)
          .fontColor(Color.Black)
        TextInput({ placeholder: "请输入手机号码", text: this.phone })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .margin({ left: 10 })
          .onChange((value) => {
            this.phone = value;
          })
      }
      .width('85%')
      .height(52)
      .padding({ left: 16 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
      .margin({ bottom: 16 })

      // 4. 密码输入框
      Row() {
        Image($r('app.media.img_5'))
          .width(22)
          .height(22)
          .margin({ right: 12 })
        TextInput({ placeholder: "请设置6-16位密码", text: this.password })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .type(InputType.Password)
          .onChange((value) => {
            this.password = value;
          })
      }
      .width('85%')
      .height(52)
      .padding({ left: 16 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
      .margin({ bottom: 16 })

      // 5. 验证码输入框
      Row() {
        Image($r('app.media.img_6'))
          .width(22)
          .height(22)
          .margin({ right: 12 })
        TextInput({ placeholder: "请输入验证码", text: this.code })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .onChange((value) => {
            this.code = value;
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
      .margin({ bottom: 20 })

      // 用户协议勾选框
      Row({ space: 6 }) {
        Toggle({ type: ToggleType.Checkbox, isOn: this.isAgree })
          .onChange((isOn: boolean) => {
            this.isAgree = isOn;
          })
          .width(20)
          .height(20)

        Text("已阅读并同意")
          .fontSize(14)
          .fontColor("#8E8E93")

        Text("《隐私权政策》")
          .fontSize(14)
          .fontColor("#007AFF")
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/PrivacyPolicy' });
          })
      }
      .width('85%')
      .alignItems(VerticalAlign.Center)
      .margin({ bottom: 20 })

      // 错误提示
      if (this.errorTip) {
        Text(this.errorTip)
          .fontSize(14)
          .fontColor("#FF3B30")
          .width('85%')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 20 })
      }

      // 6. 注册按钮
      Button(this.isLoading ? "注册中..." : "完成注册")
        .width('85%')
        .height(54)
        .borderRadius(14)
        .backgroundColor(this.isAgree && !this.isLoading ? "#007AFF" : "#C7C7CC")
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .shadow({ radius: this.isAgree && !this.isLoading ? 3 : 0, color: "#007AFF30", offsetX: 0, offsetY: 2 })
        .enabled(this.isAgree && !this.isLoading)
        .margin({ bottom: 24 })
        .onClick(() => {
          this.handleRegister();
        })

      // 去登录
      Text("已有账号？立即登录")
        .fontSize(15)
        .fontColor("#007AFF")
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Login_Register/LoginPin' });
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