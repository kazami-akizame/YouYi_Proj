import router from '@ohos.router';

@Entry
@Component
struct LoginPin {
  // 勾选状态
  @State isAgree: boolean = false;

  build() {
    Column() {
      // 👇 新增：顶部导航栏（返回图标 + 标题）
      Stack({ alignContent: Alignment.Center }) {
        // 返回按钮
        Row() {
          Image($r('app.media.img_4')) // 返回图标
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              // 点击返回 验证码登录页面
              router.replace({ url: 'pages/Login_Register/Login' });
            })
        }
        .width('100%')
        .padding({ left: 20 })
        .alignItems(VerticalAlign.Center)

        // 页面标题
        Text("密码登录")
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 1. 顶部的医疗图标
      Image($r('app.media.img1'))
        .width(100)
        .height(100)
        .objectFit(ImageFit.Contain)
        .margin({ top: 40 })

      Blank().height(30)

      // 2. 标题
      Text("手机密码登录")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })
      Text("欢迎使用有道在线问诊医生版")
        .fontSize(14)
        .fontColor("#999")
        .margin({ bottom: 40 })

      // 3. 手机号输入框
      Row() {
        Image($r('app.media.img_7'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        Text("+86")
          .fontSize(16)
          .margin({ right: 10 })
          .padding({ right: 10 })
        TextInput({ placeholder: "请输入手机号码" })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
      }
      .width('85%')
      .height(50)
      .borderRadius(25)
      .backgroundColor("#fff")
      .padding({ left: 15 })
      .margin({ bottom: 20 })

      // 4. 密码输入框
      Row() {
        Image($r('app.media.img_5'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        TextInput({ placeholder: "请输入密码" })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .type(InputType.Password)
      }
      .width('85%')
      .height(50)
      .borderRadius(25)
      .backgroundColor("#fff")
      .padding({ left: 15 })
      .margin({ bottom: 20 })

      // ------------------------------
      // 用户协议勾选框
      // ------------------------------
      Row({ space: 4 }) {
        Toggle({ type: ToggleType.Checkbox, isOn: this.isAgree })
          .onChange((isOn: boolean) => {
            this.isAgree = isOn;
          })
          .width(20)
          .height(20)

        Text("已阅读并同意以下用户注册协议：")
          .fontSize(14)
          .fontColor("#666")

        Text("《隐私权政策》")
          .fontSize(14)
          .fontColor("#007aff")
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/PrivacyPolicy' });
          })

        Text("和")
          .fontSize(14)
          .fontColor("#666")

        Text("《注册相关协议》")
          .fontSize(14)
          .fontColor("#007aff")
      }
      .width('85%')
      .margin({ bottom: 30 })

      // 5. 登录按钮（勾选后可用）
      Button("登录")
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor(this.isAgree ? "#007aff" : "#ccc")
        .fontSize(18)
        .fontColor("#fff")
        .enabled(this.isAgree)
        .margin({ bottom: 20 })

      // 6. 修改密码 & 忘记登录密码
      Row({ space: 10 }) {
        Button('修改密码')
          .width(100)
          .borderRadius(6)
          .backgroundColor('#fff')
          .fontColor('#5D4037')
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/NewPin' });
          })

        Blank().width(40)

        Button('忘记密码')
          .width(100)
          .borderRadius(6)
          .backgroundColor('#fff')
          .fontColor('#5D4037')
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/FindPin' });
          })
      }

      Blank().layoutWeight(1)

      // 7. 底部隐私政策
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