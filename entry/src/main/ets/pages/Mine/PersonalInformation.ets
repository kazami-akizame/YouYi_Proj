import router from '@ohos.router';
import { http } from '@kit.NetworkKit';

// 数据模型
interface DoctorInfo {
  realName: string;
  hospital: string;
  department: string;
  title: string;
  skills: string;
  intro: string;
  experience: string;
}

@Entry
@Component
struct PersonalInformation {

  // ==============================================
  // ✅ 【默认先赋值】页面一打开就显示！不会空白
  // ==============================================
  @State doctorInfo: DoctorInfo = {
    realName: "李明明",
    hospital: "北京天坛医院",
    department: "消化内科",
    title: "副主任医师",
    skills: "急性肠胃炎、胃溃疡、肠道疾病",
    intro: "医学博士，从事临床工作15年",
    experience: "2010-2015 北京协和医院\n2015-至今 北京天坛医院消化内科"
  };

  // 页面显示时 → 自动请求后端更新数据
  onPageShow() {
    this.loadDoctorInfo();
  }

  // ========== 网络请求（保留完整后端功能） ==========
  async loadDoctorInfo() {
    const httpTask = http.createHttp();

    try {
      // ✅ 修复：使用 localhost
      const response = await httpTask.request(
        "http://localhost:8888/doctorInfo",
        { method: http.RequestMethod.GET }
      );

      console.log("✅ 个人信息状态码：" + response.responseCode);

      if (response.responseCode === 200) {
        // json-server 返回数组，取第一条
        const result: DoctorInfo[] = JSON.parse(response.result.toString());
        if (result && result.length > 0) {
          this.doctorInfo = result[0];
          console.log("✅ 个人信息加载成功 → 使用后端数据");
        }
      }

    } catch (err) {
      console.error("⚠️ 请求失败，使用本地默认数据", err);
    } finally {
      httpTask.destroy();
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Image($r('app.media.u695'))
          .objectFit(ImageFit.Fill)
          .width(26)
          .height(26)
          .onClick(() => router.back())

        Text("个人信息")
          .fontSize(22)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(26)
      }
      .width('100%')
      .height(56)
      .padding({ left: 15, right: 15 })
      .backgroundColor("#ffffff")
      .alignItems(VerticalAlign.Center)

      // 信息列表
      List({ space: 0 }) {
        ListItem() {
          this.InfoItem(true, "真实姓名", this.doctorInfo.realName, true)
        }
        ListItem() {
          this.InfoItem(true, "就职医院", this.doctorInfo.hospital, true)
        }
        ListItem() {
          this.InfoItem(true, "所属科室", this.doctorInfo.department, true)
        }
        ListItem() {
          this.InfoItem(true, "职称", this.doctorInfo.title, true)
        }

        ListItem() {
          Column().width('100%').height(10).backgroundColor("#f5f5f5")
        }

        ListItem() {
          this.InfoItem(true, "擅长领域", this.doctorInfo.skills, true)
        }
        ListItem() {
          this.InfoItem(false, "个人简介", this.doctorInfo.intro, true)
        }
        ListItem() {
          this.InfoItem(false, "职业经历", this.doctorInfo.experience, false)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#ffffff")

      // 底部按钮
      Column() {
        Text("编辑资料")
          .fontSize(18)
          .fontColor("#ffffff")
      }
      .width('90%')
      .height(48)
      .backgroundColor("#1677FF")
      .borderRadius(24)
      .justifyContent(FlexAlign.Center)
      .margin({ top: 30, bottom: 40 })
      .alignSelf(ItemAlign.Center)
      .onClick(() => {
        router.pushUrl({ url: "pages/Login_Register/DoctorCertification" });
      })

    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }

  // 列表项封装
  @Builder
  InfoItem(isRequired: boolean, label: string, value: string, showDivider: boolean) {
    Column() {
      Row() {
        if (isRequired) {
          Text("*").fontSize(17).fontColor("#ff3333")
        }
        Text(label).fontSize(17).fontColor("#222222")
        Blank().layoutWeight(1)
        Text(value).fontSize(17).fontColor("#666666")
        Image($r('app.media.u1158')).width(16).height(16)
      }
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })

      if (showDivider) {
        Divider().color("#E5E5E5").width('100%').margin({ left: 20, right: 20 })
      }
    }
  }
}