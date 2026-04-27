import { BusinessError } from '@kit.BasicServicesKit';
import { Router } from '@kit.ArkUI';

@Entry
@Component
struct Login {
  build() {
    Column() {
      // 1. 顶部图标
      Image($r('app.media.img1'))
        .width(100)
        .height(100)
        .objectFit(ImageFit.Contain)
        .margin({ top: 40 })

      Blank().height(30)

      // 2. 标题
      Text("手机验证码登录")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 10 })
      Text("欢迎登录有道在线问诊医生端")
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
      .backgroundColor("#f5f5f5")
      .padding({ left: 15 })
      .margin({ bottom: 20 })

      // 4. 验证码输入框
      Row() {
        Image($r('app.media.img_6'))
          .width(20)
          .height(20)
          .margin({ right: 8 })
        TextInput({ placeholder: "请输入验证码" })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .margin({ right: 10 })
        Button("获取验证码")
          .fontSize(14)
          .fontColor("#007aff")
          .backgroundColor(Color.Transparent)
          .onClick(() => {
            console.log("点击获取验证码")
          })
      }
      .width('85%')
      .height(50)
      .borderRadius(25)
      .backgroundColor("#f5f5f5")
      .padding({ left: 15, right: 15 })
      .margin({ bottom: 20 })

      // 5. 账号密码登录 → 点击跳转到 LoginPin 页面
      Text("账号密码登录")
        .fontSize(14)
        .fontColor("#007aff")
        .alignSelf(ItemAlign.Start)
        .margin({ left: "7.5%", bottom: 30 })
        .onClick(() => {
          console.log("跳转到账号密码登录页");
          // 获取UIContext
          const uiContext = this.getUIContext();
          const router = uiContext.getRouter();

          // 跳转页面并添加错误处理
          router.pushUrl({ url: 'pages/Login_Register/LoginPin' })
            .then(() => {
              console.info('Succeeded in jumping to LoginPin page.');
            })
            .catch((err: BusinessError) => {
              console.error(`Failed to jump, error code: ${err.code}, message: ${err.message}`);
            });
        })

      // 6. 登录按钮
      Button("登录")
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#007aff")
        .fontSize(18)
        .fontColor("#fff")
        .margin({ bottom: 20 })

      // 7. 注册新用户 → 点击跳转到 Register 页面
      Text("注册新用户")
        .fontSize(14)
        .fontColor("#007aff")
        .margin({ bottom: 20 })
        .onClick(() => {
          console.log("跳转到注册页面");
          // 获取UIContext
          const uiContext = this.getUIContext();
          const router = uiContext.getRouter();

          // 跳转页面并添加错误处理
          router.pushUrl({ url: 'pages/Login_Register/Register' })
            .then(() => {
              console.info('Succeeded in jumping to Register page.');
            })
            .catch((err: BusinessError) => {
              console.error(`Failed to jump, error code: ${err.code}, message: ${err.message}`);
            });
        })

      Blank().layoutWeight(1)

      // 8. 底部隐私政策
      Text("登录即代表您已同意有道医生在线问诊隐私政策")
        .fontSize(12)
        .fontColor("#999")
        .width('100%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 30 })
        .onClick(() => {
          console.log("打开隐私政策")
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }
}