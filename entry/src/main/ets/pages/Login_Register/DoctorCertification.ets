import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { DoctorCertificationBusiness } from '../../business/DoctorCertificationBusiness';
import { DoctorInfo, DoctorCertImages } from '../common/Doctor';

// 1. 路由返回数据类型
interface RouterBackResult {
  key: keyof DoctorInfo;
  value: string;
}

@Entry
@Component
struct DoctorCertification {
  @State doctorInfo: DoctorInfo = new DoctorInfo();
  // 使用 @StorageLink 绑定 AppStorage，实现自动响应状态变化
  @StorageLink('imagesUploaded') imagesUploaded: boolean = false;
  // 当前登录用户的手机号(从 AppStorage 读取)
  private currentUserPhone: string = '';

  aboutToAppear() {
    // 初始化 AppStorage 全局状态（如果未初始化）
    if (AppStorage.get<boolean>('imagesUploaded') === undefined) {
      AppStorage.setOrCreate<boolean>('imagesUploaded', false);
      AppStorage.setOrCreate<string>('avatarUri', '');
      AppStorage.setOrCreate<string>('idCardFrontUri', '');
      AppStorage.setOrCreate<string>('idCardBackUri', '');
      AppStorage.setOrCreate<string>('certUri', '');
    }
    
    // 从 AppStorage 获取当前用户手机号
    const storedPhone = AppStorage.get<string>('currentUserPhone');
    if (storedPhone) {
      this.currentUserPhone = storedPhone;
    }
  }

  // 用 switch-case 替代索引访问，避免 arkts-no-props-by-index
  private updateField(key: keyof DoctorInfo, value: string): void {
    switch (key) {
      case 'name': this.doctorInfo.name = value; break;
      case 'hospital': this.doctorInfo.hospital = value; break;
      case 'department': this.doctorInfo.department = value; break;
      case 'title': this.doctorInfo.title = value; break;
      case 'specialty': this.doctorInfo.specialty = value; break;
      case 'intro': this.doctorInfo.intro = value; break;
      case 'experience': this.doctorInfo.experience = value; break;
    }
  }

  // 表单校验
  private isFormValid(): boolean {
    return !!(
      this.doctorInfo.name &&
      this.doctorInfo.hospital &&
      this.doctorInfo.department &&
      this.doctorInfo.title &&
      this.doctorInfo.specialty
    );
  }

  build() {
    Column() {
      // 导航栏（iOS 标准）
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
        .onClick(() => router.back())

        Text("医师认证")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .shadow({ radius: 0.5, color: "#00000010", offsetX: 0, offsetY: 1 })

      // 提示条
      Text("请如实填写您的个人信息")
        .width('100%')
        .backgroundColor("#F2F2F7")
        .padding({ top: 12, bottom: 12, left: 20, right: 20 })
        .fontSize(14)
        .fontColor("#B98C5B")
        .margin({ bottom: 4 })

      // iOS 原生分组列表（单卡片 + 分割线）
      Column() {
        // 1. 真实姓名
        Row() {
          Text("* 真实姓名")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          TextInput({
            text: this.doctorInfo.name,
            placeholder: "请填写您的真实姓名"
          })
            .layoutWeight(1)
            .fontSize(16)
            .placeholderColor("#8E8E93")
            .backgroundColor(Color.Transparent)
            .onChange((val: string) => this.updateField("name", val))

        }
        .width('100%')
        .padding(16)

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 2. 就职医院
        Row() {
          Text("* 就职医院")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.doctorInfo.hospital || "请填写您目前所执业的医院")
            .fontSize(16)
            .fontColor(this.doctorInfo.hospital ? "#1C1C1E" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/SelectHospitalPage",
            params: { key: "hospital", title: "选择医院" }
          });
        })

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 3. 所属科室
        Row() {
          Text("* 所属科室")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.doctorInfo.department || "请填写您所属的科室")
            .fontSize(16)
            .fontColor(this.doctorInfo.department ? "#1C1C1E" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/SelectDepartmentPage",
            params: { key: "department", title: "选择科室" }
          });
        })

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 4. 职称
        Row() {
          Text("* 职称")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.doctorInfo.title || "请填写您目前的职称")
            .fontSize(16)
            .fontColor(this.doctorInfo.title ? "#1C1C1E" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/SelectTitlePage",
            params: { key: "title", title: "选择职称" }
          });
        })

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 5. 擅长领域
        Row() {
          Text("* 擅长领域")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.doctorInfo.specialty || "请填写您擅长的治疗领域")
            .fontSize(16)
            .fontColor(this.doctorInfo.specialty ? "#1C1C1E" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/EditTextPage",
            params: {
              key: "specialty",
              current: this.doctorInfo.specialty,
              title: "擅长领域",
              placeholder: "填写示例：关节疾病:常见关节炎，关节疼痛诊治...",
              maxLength: 150
            }
          });
        })

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 6. 个人简介
        Row() {
          Text("个人简介")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.doctorInfo.intro || "请填写个人简介")
            .fontSize(16)
            .fontColor(this.doctorInfo.intro ? "#1C1C1E" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/EditTextPage",
            params: {
              key: "intro",
              current: this.doctorInfo.intro,
              title: "个人简介",
              placeholder: "请输入您的个人简介",
              maxLength: 150
            }
          });
        })

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 7. 职业经历
        Row() {
          Text("职业经历")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.doctorInfo.experience || "请填写您的职业经历")
            .fontSize(16)
            .fontColor(this.doctorInfo.experience ? "#1C1C1E" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/EditTextPage",
            params: {
              key: "experience",
              current: this.doctorInfo.experience,
              title: "职业经历",
              placeholder: "请输入您的职业经历",
              maxLength: 150
            }
          });
        })

        Divider()
          .color("#E5E5EA")
          .margin({ left: 16 })

        // 8. 资料上传
        Row() {
          Text("* 资料上传")
            .fontSize(16)
            .width(100)
            .fontColor("#1C1C1E")
          Text(this.imagesUploaded ? "已上传" : "请上传认证资料")
            .fontSize(16)
            .fontColor(this.imagesUploaded ? "#007AFF" : "#8E8E93")
            .layoutWeight(1)
          Image($r('app.media.import'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .padding(16)
        .onClick(() => {
          router.pushUrl({
            url: "pages/Login_Register/DoctorCertificationUpload",
            params: { doctorInfo: this.doctorInfo }
          });
        })
      }
      .width('92%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .layoutWeight(1)

      // 底部提交按钮
      Button(this.imagesUploaded ? "提交" : "下一步")
        .width('90%')
        .height(54)
        .margin({ bottom: 30, top: 16 })
        .backgroundColor(this.isFormValid() ? "#007AFF" : "#C7C7CC")
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .borderRadius(14)
        .enabled(this.isFormValid())
        .shadow({ radius: this.isFormValid() ? 2 : 0, color: "#007AFF20", offsetX: 0, offsetY: 1 })
        .onClick(async () => {
          if (this.imagesUploaded) {
            await this.handleSubmitCertification();
          } else {
            router.pushUrl({
              url: "pages/Login_Register/DoctorCertificationUpload",
              params: { doctorInfo: this.doctorInfo }
            });
          }
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#F2F2F7")
  }

  // 页面每次显示时都会调用（包括从子页面返回时）
  onPageShow() {
    // 刷新当前用户手机号
    const phone = AppStorage.get<string>('currentUserPhone');
    if (phone) {
      this.currentUserPhone = phone;
    }

    const result = AppStorage.get<RouterBackResult>('routerBackResult');
    if (result && result.key && result.value) {
      this.updateField(result.key, result.value);
      AppStorage.set<RouterBackResult>('routerBackResult', { key: '' as keyof DoctorInfo, value: '' });
    }

    const uploadedStatus = AppStorage.get<boolean>('imagesUploaded');
    if (uploadedStatus !== undefined) {
      this.imagesUploaded = uploadedStatus;
    }
  }

  // 提交认证
  private async handleSubmitCertification(): Promise<void> {

    if (!this.isFormValid()) {
      promptAction.showToast({ message: '您当前未完善个人信息，无法提交', duration: 2000 });
      return;
    }

    const images: DoctorCertImages = new DoctorCertImages();
    images.avatar = AppStorage.get<string>('avatarUri') || '';
    images.idCardFront = AppStorage.get<string>('idCardFrontUri') || '';
    images.idCardBack = AppStorage.get<string>('idCardBackUri') || '';
    images.cert = AppStorage.get<string>('certUri') || '';

    const imagesComplete = !!(images.avatar && images.idCardFront && images.idCardBack && images.cert);
    if (!imagesComplete) {
      promptAction.showToast({ message: '您当前未完善个人信息，无法提交', duration: 2000 });
      return;
    }

    const success = await DoctorCertificationBusiness.submitCertification(
      this.currentUserPhone,
      this.doctorInfo,
      images
    );

    if (success) {
      AppStorage.set<boolean>('imagesUploaded', false);
      AppStorage.set<string>('avatarUri', '');
      AppStorage.set<string>('idCardFrontUri', '');
      AppStorage.set<string>('idCardBackUri', '');
      AppStorage.set<string>('certUri', '');

      router.pushUrl({
        url: 'pages/Login_Register/CertificationSuccess'
      });
    }
  }
}