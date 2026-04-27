import router from '@ohos.router';

@Entry
@Component
struct ModifyPassword {
  // 绑定两个输入框的值，用于后续校验两次密码是否一致
  @State newPassword: string = '';
  @State confirmPassword: string = '';
  // 错误提示文字
  @State errorTip: string = '';

  build() {
    Column() {
      // 1. 顶部导航栏
      Stack({ alignContent: Alignment.Center }) {
        // 返回按钮
        Row() {
          Image($r('app.media.img_4'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .width('100%')
        .padding({ left: 20 })
        .alignItems(VerticalAlign.Center)
        .onClick(() => {
          router.back();
        })

        // 标题
        Text("修改密码")
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 2. 输入框区域
      Column({ space: 20 }) {
        // 新密码输入框
        Row() {
          Image($r('app.media.img_5'))
            .width(20)
            .height(20)
            .margin({ right: 8 })
          TextInput({ placeholder: "请输入新密码", text: this.newPassword })
            .layoutWeight(1)
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.newPassword = value;
            })
        }
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#fff")
        .padding({ left: 15 })

        // 确认密码输入框
        Row() {
          Image($r('app.media.img_5'))
            .width(20)
            .height(20)
            .margin({ right: 8 })
          TextInput({ placeholder: "请再次输入密码", text: this.confirmPassword })
            .layoutWeight(1)
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .type(InputType.Password)
            .onChange((value: string) => {
              this.confirmPassword = value;
            })
        }
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#fff")
        .padding({ left: 15 })
      }
      .margin({ top: 30, bottom: 20 })

      // 错误提示（红色文字）
      Text(this.errorTip)
        .fontSize(14)
        .fontColor(Color.Red)
        .width('85%')
        .textAlign(TextAlign.Center)
        .margin({ bottom: 15 })

      // 3. 确定按钮
      Button("确定")
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor("#007aff")
        .fontSize(18)
        .fontColor("#fff")
        .onClick(() => {
          this.errorTip = ''; // 每次点击先清空提示
          if (this.newPassword === this.confirmPassword && this.newPassword.length >= 6) {
            console.log("密码修改成功");
            // 修改成功后返回密码登录页
            router.replace({ url: 'pages/Login_Register/LoginPin' });
          } else {
            // 页面红色提示
            this.errorTip = "两次密码不一致或密码长度不足6位";
          }
        })

      // 4. 自动撑开剩余空间，保持布局适配
      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }
}