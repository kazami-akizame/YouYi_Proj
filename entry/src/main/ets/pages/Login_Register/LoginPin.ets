import router from '@ohos.router';
import prompt from '@ohos.prompt';
import { LoginBusiness } from '../../business/LoginBusiness';
import { LoginService } from '../../service/LoginService';
import { LoginResponse } from '../common/User';

@Entry
@Component
struct LoginPin {
  // 勾选状态
  @State isAgree: boolean = false;
  // 手机号和密码
  @State phoneNumber: string = '';
  @State password: string = '';

  build() {
    Column() {
      // 顶部导航栏（iOS 标准样式）
      Stack({ alignContent: Alignment.Center }) {
        Row() {
          Image($r('app.media.img_4'))
            .width(24)
            .height(24)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              router.replace({ url: 'pages/Login_Register/Login' });
            })
        }
        .width('100%')
        .padding({ left: 20 })
        .alignItems(VerticalAlign.Center)

        Text("密码登录")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 顶部图标
      Image($r('app.media.img1'))
        .width(120)
        .height(120)
        .objectFit(ImageFit.Contain)
        .margin({ top: 60, bottom: 20 })

      // 标题
      Text("手机密码登录")
        .fontSize(26)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 6 })
      Text("欢迎使用有道在线问诊医生版")
        .fontSize(15)
        .fontColor("#8E8E93")
        .margin({ bottom: 36 })

      // 手机号输入框（iOS 卡片）
      Row() {
        Image($r('app.media.img_7'))
          .width(22)
          .height(22)
          .margin({ right: 12 })
        Text("+86")
          .fontSize(16)
          .fontColor(Color.Black)
        TextInput({ placeholder: "请输入手机号码", text: this.phoneNumber })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.phoneNumber = value;
          })
      }
      .width('85%')
      .height(52)
      .padding({ left: 16 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
      .margin({ bottom: 16 })

      // 密码输入框
      Row() {
        Image($r('app.media.img_5'))
          .width(22)
          .height(22)
          .margin({ right: 12 })
        TextInput({ placeholder: "请输入密码", text: this.password })
          .layoutWeight(1)
          .fontSize(16)
          .backgroundColor(Color.Transparent)
          .placeholderColor("#8E8E93")
          .type(InputType.Password)
          .onChange((value: string) => {
            this.password = value;
          })
      }
      .width('85%')
      .height(52)
      .padding({ left: 16 })
      .backgroundColor(Color.White)
      .borderRadius(14)
      .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
      .margin({ bottom: 20 })

      // 用户协议（iOS 清爽排版）
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
      .margin({ bottom: 32 })

      // 登录按钮（iOS 质感按钮）
      Button("登录")
        .width('85%')
        .height(54)
        .borderRadius(14)
        .backgroundColor(this.isAgree ? "#007AFF" : "#C7C7CC")
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .shadow({ radius: this.isAgree ? 3 : 0, color: "#007AFF30", offsetX: 0, offsetY: 2 })
        .enabled(this.isAgree)
        .margin({ bottom: 28 })
        .onClick(async () => {
          if (!this.phoneNumber) {
            prompt.showToast({ message: '请输入手机号码', duration: 2000 });
            return;
          }
          if (!LoginBusiness.validatePhoneNumber(this.phoneNumber)) {
            prompt.showToast({ message: '请输入正确的手机号码', duration: 2000 });
            return;
          }
          if (!this.password) {
            prompt.showToast({ message: '请输入密码', duration: 2000 });
            return;
          }
          const result: LoginResponse = await LoginService.loginWithPassword(this.phoneNumber, this.password);
          if (result.code === 200) {
            AppStorage.setOrCreate<string>('currentUserPhone', this.phoneNumber);
            prompt.showToast({ message: '登录成功', duration: 2000 });
            //👈 👈--------------
            //登录成功跳转真的首页，而不是又回到启动
            router.replaceUrl({ url: 'pages/Login_Register/DoctorCertification' });
            //-----------
            //👈 👈------
          } else {
            prompt.showToast({ message: result.message || '登录失败', duration: 2000 });
          }
        })

      // 功能按钮（iOS 文字按钮，去掉丑按钮）
      Row({ space: 30 }) {
        Text("修改密码")
          .fontSize(15)
          .fontColor("#007AFF")
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/FindPin' });
          })

        Text("忘记密码")
          .fontSize(15)
          .fontColor("#007AFF")
          .fontWeight(FontWeight.Medium)
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login_Register/ForgetPassword' });
          })
      }
      .margin({ bottom: 20 })

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
    .backgroundColor("#F2F2F7") // iOS 系统背景色
  }
}