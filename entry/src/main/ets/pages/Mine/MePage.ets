import router from '@ohos.router';
import http from '@ohos.net.http';

// 只保留当前页面需要的结构
interface DoctorInfo {
  realName: string;
  hospital: string;
  title: string;
}

interface DoctorData {
  doctorInfo: DoctorInfo[];
}

@Entry
@Component
export struct MePage {
  @State doctorData: DoctorData | null = null;
  @State isLoading: boolean = true;

  scroller: Scroller = new Scroller();
  private httpRequest = http.createHttp();

  onPageShow() {
    this.getDoctorInfo();
  }

  // 获取医生信息（对接 json-server）
  async getDoctorInfo() {
    this.isLoading = true;
    try {
      let res = await this.httpRequest.request(
        "http://10.110.63.57:8888/doctorInfo", // json-server 接口地址
        { method: http.RequestMethod.GET }
      );

      if (res.responseCode === 200) {
        // json-server 返回数组，手动包装为 { doctorInfo: 数组 } 格式
        let data = JSON.parse(res.result.toString()) as DoctorInfo[];
        this.doctorData = { doctorInfo: data };
      }
    } catch (err) {
      console.error("获取医生信息失败", err);
    } finally {
      this.isLoading = false;
    }
  }

  build() {
    Column() {
      // 条件渲染：加载中/正常页面（小写 if/else）
      if (this.isLoading) {
        Text("加载中...")
          .fontSize(18)
          .fontColor("#999")
          .margin({ top: 100 })
      } else {
        Column() {
          // ====================== 顶部蓝色个人中心 ======================
          Stack({ alignContent: Alignment.BottomStart }) {
            Row()
              .width('100%')
              .height(180)
              .backgroundColor("#2578eb")

            Column({ space: 5 }) {
              Row({ space: 0 }) {
                Text("我的")
                  .fontSize(24)
                  .fontWeight(FontWeight.Bold)
                  .fontColor("#fff")

                Blank().layoutWeight(1)

                Row({ space: 25 }) {
                  Image($r('app.media.u5900')).width(24).height(24)
                    .onClick(() => {
                      router.pushUrl({ url: "pages/Mine/MedicalAssistant" });
                    })

                  Image($r('app.media.u5899')).width(24).height(24)
                    .onClick(() => {
                      router.pushUrl({ url: "pages/Mine/Setting" });
                    })
                }
              }
              .width('100%')
              .padding({ left: 20, right: 20, top: 40 })
              .alignItems(VerticalAlign.Top)

              Row() {
                Image($r('app.media.u5871'))
                  .width(60)
                  .height(60)
                  .borderRadius(30)

                Column({ space: 8 }) {
                  Row({ space: 10 }) {
                    // 姓名：安全访问 + 默认值
                    Text(this.doctorData?.doctorInfo?.[0]?.realName ?? "李明明")
                      .fontSize(20)
                      .fontWeight(FontWeight.Bold)
                      .fontColor("#fff")
                    // 职称
                    Text(this.doctorData?.doctorInfo?.[0]?.title ?? "副主任医师")
                      .fontSize(14)
                      .fontColor("#e8f1ff")
                  }
                  // 医院
                  Text(this.doctorData?.doctorInfo?.[0]?.hospital ?? "北京积水潭医院")
                    .fontSize(14)
                    .fontColor("#e8f1ff")
                }.margin({ left: 10 })

                Blank().layoutWeight(1)
                Image($r('app.media.u5873')).width(18).height(18)
                  .onClick(() => {
                    router.pushUrl({ url: "pages/Mine/PersonalInformation" });
                  })
              }
              .width('100%')
              .padding({ left: 20, right: 20, bottom: 15 })
            }
            .justifyContent(FlexAlign.SpaceAround)
            .height(180)
          }
          .width('100%')
          .height(180)

          Blank().height(15).backgroundColor("#f5f5f5")

          // ====================== 菜单列表 ======================
          List({ space: 0 }) {
            ListItem() { this.MenuItem($r('app.media.u1237'), "我的认证", "pages/Mine/DoctorCertify_pass") }
            ListItem() { this.MenuItem($r('app.media.u1241'), "我的收入", "pages/Mine/MyIncome") }
            ListItem() { this.MenuItem($r('app.media.u1245'), "我的银行卡", "pages/Mine/BankCard") }
            ListItem() { this.MenuItem($r('app.media.u1249'), "患者评价", "pages/Mine/PatientEvaluatePage") }
            ListItem() { this.MenuItem($r('app.media.u1253'), "服务设置", "pages/Mine/ServiceSettingPage") }
            ListItem() { this.MenuItem($r('app.media.u1257'), "帮助中心", "pages/Mine/HelpCenter") }
          }
          .width('100%')
          .backgroundColor("#fff")

          Blank().layoutWeight(1).backgroundColor("#f5f5f5")
          BottomNav()
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }

  // 菜单条目构建器
  @Builder
  MenuItem(icon: Resource, title: string, jumpUrl: string) {
    Column() {
      Row() {
        Row({ space: 15 }) {
          Image(icon).width(22).height(22).objectFit(ImageFit.Fill)
          Text(title).fontSize(16).fontColor("#333")
        }
        Image($r('app.media.u1158')).width(16).height(16)
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(() => {
        router.pushUrl({ url: jumpUrl });
      })

      Divider()
        .color("#eee")
        .strokeWidth(1)
        .width('90%')
        .margin({ left: 20 })
    }
  }
}

// ====================== 底部导航 ======================
@Component
struct BottomNav {
  build() {
    Row() {
      // 首页
      Column({ space: 4 }) {
        Image($r('app.media.u1070')).width(20).height(20)
        Text("首页").fontColor("#999").fontSize(12)
      }
      .flexGrow(1)
      .onClick(() => {
        router.pushUrl({ url: "pages/HomePages/HomePage" });
      })

      // 患者
      Column({ space: 4 }) {
        Image($r('app.media.u1071')).width(20).height(20)
        Text("患者").fontColor("#999").fontSize(12)
      }
      .flexGrow(1)
      .onClick(() => {
        router.pushUrl({ url: "pages/Patient/Index" });
      })

      // 我的
      Column({ space: 4 }) {
        Image($r('app.media.u1075')).width(20).height(20)
        Text("我的").fontColor("#1A73E8").fontSize(12)
      }
      .flexGrow(1)
    }
    .width('100%')
    .height(56)
    .backgroundColor("#ffffff")
  }
}