import router from '@ohos.router';
import { PasswordBusiness } from '../../business/PasswordBusiness';
import { LoginService } from '../../service/LoginService';
import prompt from '@ohos.prompt';

@Entry
@Component
struct ModifyPassword {
  // 绑定输入框的值
  @State newPassword: string = '';
  @State confirmPassword: string = '';

  // 错误提示文字
  @State errorTip: string = '';

  // 加载状态
  @State isLoading: boolean = false;

  // 手机号和模式
  @State phoneNumber: string = '';
  @State oldPassword: string = '';  // 从 data.json 检索到的旧密码
  @State isResetPassword: boolean = false;  // true=找回密码, false=修改密码
  @State isLoadingData: boolean = true;  // 加载用户数据中

  // 页面加载时接收参数并获取用户信息
  async aboutToAppear() {
    const params = router.getParams() as Record<string, string | boolean>;
    if (params) {
      this.phoneNumber = params.phoneNumber as string || '';
      this.isResetPassword = params.isResetPassword as boolean || false;
      console.log('接收到参数:', this.phoneNumber, '找回密码:', this.isResetPassword);
      
      // 获取用户信息（包括密码）
      await this.loadUserInfo();
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

  // 提交密码
  async handleSubmit() {
    this.errorTip = '';
    
    // 校验新密码
    if (!this.newPassword || this.newPassword.length < 6) {
      this.errorTip = '密码长度不能少于6位';
      return;
    }
    
    if (this.newPassword.length > 16) {
      this.errorTip = '密码长度不能超过16位';
      return;
    }
    
    // 校验确认密码
    if (this.newPassword !== this.confirmPassword) {
      this.errorTip = '两次密码不一致';
      return;
    }

    if (!this.phoneNumber) {
      this.errorTip = '手机号信息丢失，请重试';
      return;
    }

    this.isLoading = true;

    try {
      if (this.isResetPassword) {
        // 找回密码模式
        const success = await PasswordBusiness.handleResetPassword(
          this.phoneNumber,
          this.newPassword
        );
        
        if (success) {
          prompt.showToast({ message: '密码重置成功，请登录' });
          // 跳转到密码登录页
          router.replaceUrl({ url: 'pages/Login_Register/LoginPin' });
        } else {
          this.errorTip = '密码重置失败';
        }
      } else {
        // 修改密码模式（需要原密码，这里简化处理）
        const success = await PasswordBusiness.handleResetPassword(
          this.phoneNumber,
          this.newPassword
        );
        
        if (success) {
          prompt.showToast({ message: '密码修改成功' });
          router.back();
        } else {
          this.errorTip = '密码修改失败';
        }
      }
    } catch (error) {
      this.errorTip = '操作失败，请重试';
      console.error('密码操作异常:', JSON.stringify(error));
    } finally {
      this.isLoading = false;
    }
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
          router.back();
        })

        Text("修改密码")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 2. 输入框区域（iOS 卡片 + 阴影）
      Column({ space: 16 }) {
        // 显示手机号（只读）
        Row() {
          Image($r('app.media.img_7'))
            .width(22)
            .height(22)
            .margin({ right: 12 })
          Text(this.phoneNumber)
            .layoutWeight(1)
            .fontSize(16)
            .fontColor("#000000")
        }
        .width('85%')
        .height(52)
        .padding({ left: 16, right: 16 })
        .backgroundColor("#F2F2F7")
        .borderRadius(14)
        .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })

        // 显示旧密码（只读）
        Row() {
          Image($r('app.media.img_5'))
            .width(22)
            .height(22)
            .margin({ right: 12 })
          Text(this.oldPassword)
            .layoutWeight(1)
            .fontSize(16)
            .fontColor("#8E8E93")
        }
        .width('85%')
        .height(52)
        .padding({ left: 16, right: 16 })
        .backgroundColor("#F2F2F7")
        .borderRadius(14)
        .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })

        // 新密码输入框
        Row() {
          Image($r('app.media.img_5'))
            .width(22)
            .height(22)
            .margin({ right: 12 })
          TextInput({ placeholder: "请输入新密码", text: this.newPassword })
            .layoutWeight(1)
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .placeholderColor("#8E8E93")
            .type(InputType.Password)
            .onChange((value: string) => {
              this.newPassword = value;
            })
        }
        .width('85%')
        .height(52)
        .padding({ left: 16 })
        .backgroundColor(Color.White)
        .borderRadius(14)
        .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })

        // 确认密码输入框
        Row() {
          Image($r('app.media.img_5'))
            .width(22)
            .height(22)
            .margin({ right: 12 })
          TextInput({ placeholder: "请再次输入密码", text: this.confirmPassword })
            .layoutWeight(1)
            .fontSize(16)
            .backgroundColor(Color.Transparent)
            .placeholderColor("#8E8E93")
            .type(InputType.Password)
            .onChange((value: string) => {
              this.confirmPassword = value;
            })
        }
        .width('85%')
        .height(52)
        .padding({ left: 16 })
        .backgroundColor(Color.White)
        .borderRadius(14)
        .shadow({ radius: 1, color: "#00000010", offsetX: 0, offsetY: 1 })
      }
      .margin({ top: 40, bottom: 24 })

      // 错误提示（iOS 红色）
      if (this.errorTip) {
        Text(this.errorTip)
          .fontSize(14)
          .fontColor("#FF3B30")
          .width('85%')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 20 })
      }

      // 3. 确定按钮（iOS 质感）
      Button(this.isLoading ? "提交中..." : "确定")
        .width('85%')
        .height(54)
        .borderRadius(14)
        .backgroundColor(this.isLoading ? "#C7C7CC" : "#007AFF")
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .shadow({ radius: this.isLoading ? 0 : 3, color: "#007AFF30", offsetX: 0, offsetY: 2 })
        .enabled(!this.isLoading)
        .onClick(() => {
          this.handleSubmit();
        })

      // 4. 自动撑开
      Blank()
        .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F2F2F7") // iOS 系统背景
  }
}