import router from '@ohos.router';
import { LoginService } from '../../service/LoginService';
import prompt from '@ohos.prompt';

@Entry
@Component
struct Password {
  // 手机号
  @State phoneNumber: string = '';
  @State oldPassword: string = '';  // 从 data.json 检索到的旧密码
  @State isLoadingData: boolean = true;  // 加载用户数据中
  @State errorTip: string = '';

  // 页面加载时接收参数并获取用户信息
  async aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params.phoneNumber) {
      this.phoneNumber = params.phoneNumber;
      console.log('接收到手机号参数:', this.phoneNumber);

      // 获取用户信息（包括密码）
      await this.loadUserInfo();
    } else {
      this.errorTip = '参数错误';
      this.isLoadingData = false;
    }
  }

  // 加载用户信息
  async loadUserInfo() {
    if (!this.phoneNumber) {
      this.errorTip = '手机号信息丢失，请重试';
      this.isLoadingData = false;
      return;
    }

    this.isLoadingData = true;

    try {
      // 调用 LoginService 获取用户信息
      const userInfo = await LoginService.getUserInfo(this.phoneNumber);

      if (userInfo) {
        this.oldPassword = userInfo.password || '未设置';
        console.log('获取到用户信息, 手机号:', this.phoneNumber, '密码:', this.oldPassword);
      } else {
        this.errorTip = '该用户不存在';
        console.log('用户不存在, 手机号:', this.phoneNumber);
        prompt.showToast({
          message: '该用户不存在',
          duration: 2000
        });
      }
    } catch (error) {
      this.errorTip = '获取用户信息失败';
      console.error('获取用户信息异常:', JSON.stringify(error));
    } finally {
      this.isLoadingData = false;
    }
  }

  // 返回上一页
  handleBack() {
    router.back();
  }

  build() {
    Column() {
      // 1. 顶部导航栏（iOS 标准）
      Stack({ alignContent: Alignment.Center }) {
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
          this.handleBack();
        })

        Text("查看密码")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 加载状态
      if (this.isLoadingData) {
        Column() {
          Text("加载中...")
            .fontSize(16)
            .fontColor("#8E8E93")
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        // 2. 用户信息卡片区域（iOS 卡片风格）
        Column({ space: 16 }) {
          Text("您的账号信息如下：")
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor("#000000")
            .width('85%')
            .margin({ top: 30 })

          // 手机号卡片
          Row() {
            Row() {
              Image($r('app.media.img_7'))
                .width(22)
                .height(22)
                .margin({ right: 10 })
              Text("手机号")
                .fontSize(15)
                .fontColor("#8E8E93")
            }
            Text(this.phoneNumber)
              .fontSize(16)
              .fontColor("#000000")
              .fontWeight(FontWeight.Bold)
          }
          .width('85%')
          .padding({ top: 18, bottom: 18, left: 20, right: 20 })
          .backgroundColor(Color.White)
          .borderRadius(14)
          .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

          // 密码卡片
          Row() {
            Row() {
              Image($r('app.media.img_5'))
                .width(22)
                .height(22)
                .margin({ right: 10 })
              Text("当前密码")
                .fontSize(15)
                .fontColor("#8E8E93")
            }
            Text(this.oldPassword)
              .fontSize(16)
              .fontColor("#007AFF")
              .fontWeight(FontWeight.Bold)
          }
          .width('85%')
          .padding({ top: 18, bottom: 18, left: 20, right: 20 })
          .backgroundColor(Color.White)
          .borderRadius(14)
          .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(VerticalAlign.Center)

          // 安全提示
          Text("请妥善保管您的密码，不要泄露给他人")
            .fontSize(13)
            .fontColor("#FF3B30")
            .width('85%')
            .textAlign(TextAlign.Center)
            .margin({ top: 6 })
        }
        .width('100%')

        // 错误提示（iOS 红色）
        if (this.errorTip) {
          Text(this.errorTip)
            .fontSize(14)
            .fontColor("#FF3B30")
            .width('85%')
            .textAlign(TextAlign.Center)
            .margin({ top: 20 })
        }

        // 返回按钮（iOS 质感按钮）
        Button("返回")
          .width('85%')
          .height(54)
          .borderRadius(14)
          .backgroundColor("#007AFF")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .fontColor("#FFFFFF")
          .shadow({ radius: 3, color: "#007AFF30", offsetX: 0, offsetY: 2 })
          .margin({ top: 40 })
          .onClick(() => {
            router.replaceUrl({ url: 'pages/Login_Register/LoginPin' });
          })
      }

      Blank().layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F2F2F7") // iOS 系统背景色
  }
}