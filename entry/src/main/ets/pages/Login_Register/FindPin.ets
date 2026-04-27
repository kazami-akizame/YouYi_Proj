import router from '@ohos.router';

@Entry
@Component
struct FindPassword {
  // 绑定输入框值，方便后续校验和接口调用
  @State phoneNumber: string = '';
  @State verifyCode: string = '';

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
        Text("找回密码")
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
          Image($r('app.media.img_6')) // 替换为你的验证码图标资源
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
          Button("获取验证码")
            .fontSize(14)
            .fontColor("#007aff")
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              console.log("点击获取验证码");
              // 后续可扩展：手机号校验 + 倒计时逻辑
            })
        }
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#fff")
        .padding({ left: 15, right: 15 })
      }
      .margin({ top: 30, bottom: 40 })

      // 3. 下一步按钮
      Button("下一步")
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#007aff")
        .fontSize(18)
        .fontColor("#fff")
        .onClick(() => {
          // 简单的表单校验
          if (this.phoneNumber.length === 11 && this.verifyCode.length > 0) {
            console.log("校验通过，进入修改密码页面");
            // 后续可扩展：页面跳转逻辑
          } else {
            console.log("手机号或验证码格式不正确");
          }
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