// PrivacyPolicy.ets 隐私政策详情页面
// 旧版鸿蒙兼容 · 零报错 · 置顶布局
import router from '@ohos.router';

@Entry
@Component
struct PrivacyPolicyPage {
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left:16, right:12 })
          .onClick(()=>router.back())
        Text('优医在线问诊隐私政策')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
          .position({ x: '28%', y: '20%' })
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')

    Column(){
          Scroll() {
            Column() {
              Text(`优医在线问诊隐私政策

    1. 本应用严格保护您的个人信息与手机号隐私安全
    2. 您的手机号仅用于账号登录、身份验证，不会泄露给第三方
    3. 更换手机号操作仅变更您的登录账号，不会影响原有账号数据
    4. 您有权随时查看、修改、注销您的个人信息
    5. 本政策最终解释权归优医在线问诊平台所有`)
                .fontSize(15)
                .fontColor('#333')
                .lineHeight(26)
                .width('100%')
                .padding({left:16,right:16,top:20})
            }
          }
          .flexGrow(1)
          .backgroundColor('#F5F5F5')
        }
        .justifyContent(FlexAlign.Start)
  }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
  }
}