import router from '@ohos.router';

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

  build() {
    Column() {
      // 1. 顶部图标
      Image($r('app.media.img1'))
        .width(100)
        .height(100)
        .objectFit(ImageFit.Contain)
        .margin({ top: 40 })

      Blank().height(30)

      // 2. 标题（改为注册）
      Text("账号注册")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })
      Text("欢迎注册有道在线问诊医生端")
        .fontSize(14)
        .fontColor("#999")
        .margin({ bottom: 40 })

      // 3. 手机号输入框
      Row() {
        Image($r('app.media.img_2'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        Text("+86")
          .fontSize(16)
          .margin({ right: 10 })
        TextInput({ placeholder: "请输入手机号码", text: this.phone })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .onChange((value) => {
            this.phone = value;
          })
      }
      .width('85%')
      .height(50)
      .borderRadius(25)
      .backgroundColor("#fff")
      .padding({ left: 15 })
      .margin({ bottom: 20 })

      // 4. 密码输入框（新增）
      Row() {
        Image($r('app.media.img_5'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        TextInput({ placeholder: "请设置6-16位密码", text: this.password })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .type(InputType.Password)
          .onChange((value) => {
            this.password = value;
          })
      }
      .width('85%')
      .height(50)
      .borderRadius(25)
      .backgroundColor("#fff")
      .padding({ left: 15 })
      .margin({ bottom: 20 })

      // 5. 验证码输入框
      Row() {
        Image($r('app.media.img_6'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        TextInput({ placeholder: "请输入验证码", text: this.code })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .onChange((value) => {
            this.code = value;
          })
        Button("获取验证码")
          .fontSize(14)
          .fontColor("#007aff")
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            console.log("获取验证码：" + this.phone);
          })
      }
      .width('85%')
      .height(50)
      .borderRadius(25)
      .backgroundColor("#fff")
      .padding({ left: 15, right: 15 })
      .margin({ bottom: 20 })

      // 用户协议勾选框
      Row({ space: 4 }) {
        Toggle({ type: ToggleType.Checkbox, isOn: this.isAgree })
          .onChange((isOn: boolean) => {
            this.isAgree = isOn;
          })
          .width(20)
          .height(20)

        Text("已阅读并同意")
          .fontSize(14)
          .fontColor("#666")

        Text("《隐私权政策》")
          .fontSize(14)
          .fontColor("#007aff")
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/PrivacyPolicy' });
          })

      }
      .width('85%')
      .margin({ bottom: 10 })

      // 错误提示（红色）
      Text(this.errorTip)
        .fontSize(14)
        .fontColor(Color.Red)
        .width('85%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 15 })

      // 6. 注册按钮（勾选后可用）
      Button("完成注册")
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor(this.isAgree ? "#007aff" : "#ccc")
        .fontSize(18)
        .fontColor("#fff")
        .enabled(this.isAgree)
        .onClick(() => {
          this.errorTip = '';
          // 表单校验
          if (!this.phone || this.phone.length !== 11) {
            this.errorTip = "请输入正确的手机号";
            return;
          }
          if (!this.password || this.password.length < 6) {
            this.errorTip = "密码长度不能少于6位";
            return;
          }
          if (!this.code) {
            this.errorTip = "请输入验证码";
            return;
          }

          // 注册成功 → 跳回验证码登录页
          console.log("注册成功");
          router.replace({ url: 'pages/Login_Register/Login' });
        })

      // 去登录
      Text("已有账号？立即登录")
        .fontSize(14)
        .fontColor("#007aff")
        .onClick(() => {
          router.pushUrl({ url: 'pages/Login_Register/Login' });
        })

      // 底部撑开
      Blank().layoutWeight(1)

      // 底部隐私政策
      Text("登录即代表您已同意有道医生在线问诊隐私政策")
        .fontSize(12)
        .fontColor("#999")
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 30 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }
}