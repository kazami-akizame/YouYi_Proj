import router from '@ohos.router';
@Entry
@Component
export struct MePage {
  build() {
    Column() {

      // ====================== 【核心：Stack 层叠布局】 ======================
      // 底层 = 蓝色背景条
      // 上层 = 医生信息悬浮在上面
      Stack({ alignContent: Alignment.BottomStart }) {

        // 1. 底层：蓝色标题栏（只负责高度+背景）
        Row()
          .width('100%')
          .height(180)
          .backgroundColor("#2578eb")

        // 2. 上层：真正的顶部栏（我的 + 客服设置）
        Column({space:5}) {


        Row({ space: 0 }) {
          Text("我的")
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor("#fff")

          Blank().layoutWeight(1)

          Row({ space: 25 }) {
            Image($r('app.media.u5900')).width(24).height(24)
              .onClick(() => {
              //  点击耳机 → 跳转到医生助手页面
              router.pushUrl({
                url: "pages/MedicalAssistant" // 写你的页面真实路径
              });
            })
            Image($r('app.media.u5899')).width(24).height(24)
              .onClick(() => {
              router.pushUrl({
                url: "pages/SettingPage" // 你的设置页面路径，跳转到设置页面
              });
            })
          }
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 40 })
        .alignItems(VerticalAlign.Top)

        // 3. 最上层：医生信息（自动悬浮在蓝色条底部，不需要任何负margin！）
        Row() {
          Image($r('app.media.u5871'))
            .width(60)
            .height(60)
            .borderRadius(30)

          Column({ space: 8 }) {
            Row({ space: 10 }) {
              Text("李明明")
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor("#fff")
              Text("副主任医师")
                .fontSize(14)
                .fontColor("#e8f1ff")
            }

            Text("北京积水潭医院")
              .fontSize(14)
              .fontColor("#e8f1ff")
          }.margin({ left: 10 })

          Blank().layoutWeight(1)
          Image($r('app.media.u5873')).width(18).height(18)
            .onClick(() => {
            // 跳转到个人信息页面
            router.pushUrl({
              url: "pages/PersonalInformation"
            })
          })
        }
        .width('100%')
        .padding({ left: 20, right: 20, bottom: 15 }) // 只靠 padding 定位
      }.justifyContent(FlexAlign.SpaceAround).height(180)
      }
      .width('100%')
      .height(180)

      Blank().height(15).backgroundColor("#f5f5f5")


      // ====================== 下方菜单列表 ======================
      List({ space: 0 }) {
        // 1. 我的认证 → 医师认证页面
        ListItem() {
          this.MenuItem($r('app.media.u1237'), "我的认证", "pages/DoctorCertify_pass")
        }
        // 2. 我的收入
        ListItem() {
          this.MenuItem($r('app.media.u1241'), "我的收入", "pages/MyIncome")
        }
        // 3. 我的银行卡
        ListItem() {
          this.MenuItem($r('app.media.u1245'), "我的银行卡", "pages/MyBankCard")
        }
        // 4. 患者评价
        ListItem() {
          this.MenuItem($r('app.media.u1249'), "患者评价", "pages/PatientEvaluate")
        }
        // 5. 服务设置
        ListItem() {
          this.MenuItem($r('app.media.u1253'), "服务设置", "pages/ServiceSetting")
        }
        // 6. 帮助中心
        ListItem() {
          this.MenuItem($r('app.media.u1257'), "帮助中心", "pages/HelpCenter")
        }
      }
      .width('100%')
      .backgroundColor("#fff")

      // 页面底部灰色留白
      Blank().layoutWeight(1)
        .backgroundColor("#f5f5f5")
    }
    .width('100%')
    .height('100%')
  }

  // 菜单条目通用组件
  @Builder
  MenuItem(icon: Resource, title: string, jumpUrl: string) {
    Column() {
      Row() {
        // 左侧图标+标题
        Row({ space: 15 }) {
          Image(icon).width(22).height(22).objectFit(ImageFit.Fill)
          Text(title).fontSize(16).fontColor("#333")
        }

        // 右侧箭头图标
        Image($r('app.media.u1158')).width(16).height(16)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })
      .justifyContent(FlexAlign.SpaceBetween)
      // ✅ 点击事件写在根Row上！鸿蒙标准语法，完全消除之前void报错
      .onClick(() => {
        router.pushUrl({
          url: jumpUrl
        })
      })

      // 条目底部分割线
      Divider()
        .color("#eee")
        .strokeWidth(1)
        .width('90%')
        .margin({ left: 20 })
    }
  }
}
