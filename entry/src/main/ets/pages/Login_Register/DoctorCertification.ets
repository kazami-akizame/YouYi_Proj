import router from '@ohos.router';

// 1. 医生信息模型
interface DoctorInfo {
  name: string;
  hospital: string;
  department: string;
  title: string;
  specialty: string;
  intro: string;
  experience: string;
}

// 2. 路由返回数据类型（避免 any）
interface RouterBackResult {
  key: keyof DoctorInfo;
  value: string;
}

@Entry
@Component
struct DoctorCertification {
  @State doctorInfo: DoctorInfo = {
    name: '',
    hospital: '',
    department: '',
    title: '',
    specialty: '',
    intro: '',
    experience: ''
  };

  // 👉 核心修复：用 switch-case 替代索引访问，避免 arkts-no-props-by-index
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
      // 导航栏
      Row() {
        Image($r('app.media.img_4'))
          .width(24)
          .height(24)
          .onClick(() => router.back())
        Text('医师认证')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding(15)

      // 提示文本
      Text('请如实填写您的个人信息')
        .width('100%')
        .backgroundColor('#F5F5F5')
        .padding(12)
        .fontSize(15)
        .fontColor('#333')

      // 👉 List 显式设置宽高，消除警告
      List() {
        // 1. 真实姓名（直接输入）
        ListItem() {
          Row() {
            Text('* 真实姓名')
              .fontSize(16)
              .width(100)
            TextInput({
              text: this.doctorInfo.name,
              placeholder: '请填写您的真实姓名'
            })
              .layoutWeight(1)
              .fontSize(15)
              .onChange((val: string) => this.updateField('name', val))
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
        }

        // 2. 就职医院
        ListItem() {
          Row() {
            Text('* 就职医院')
              .fontSize(16)
              .width(100)
            Text(this.doctorInfo.hospital || '请填写您目前所执业的医院')
              .fontSize(15)
              .fontColor(this.doctorInfo.hospital ? '#333' : '#999')
              .layoutWeight(1)
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            // 👉 ArkTS 标准跳转写法，无回调，目标页面通过 router.getParams() 接收参数，返回时通过 AppStorage 或返回参数传递
            router.pushUrl({
              url: 'pages/Login_Register/SelectHospitalPage',
              params: {
                key: 'hospital',
                title: '选择医院'
              }
            });
          })
        }

        // 3. 所属科室
        ListItem() {
          Row() {
            Text('* 所属科室')
              .fontSize(16)
              .width(100)
            Text(this.doctorInfo.department || '请填写您所属的科室')
              .fontSize(15)
              .fontColor(this.doctorInfo.department ? '#333' : '#999')
              .layoutWeight(1)
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login_Register/SelectDepartmentPage',
              params: { key: 'department', title: '选择科室' }
            });
          })
        }

        // 4. 职称
        ListItem() {
          Row() {
            Text('* 职称')
              .fontSize(16)
              .width(100)
            Text(this.doctorInfo.title || '请填写您目前的职称')
              .fontSize(15)
              .fontColor(this.doctorInfo.title ? '#333' : '#999')
              .layoutWeight(1)
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login_Register/SelectTitlePage',
              params: { key: 'title', title: '选择职称' }
            });
          })
        }

        ListItem() {
          Divider().color('#EEE').width('100%')
        }

        // 5. 擅长领域
        ListItem() {
          Row() {
            Text('* 擅长领域')
              .fontSize(16)
              .width(100)
            Text(this.doctorInfo.specialty || '请填写您擅长的治疗领域')
              .fontSize(15)
              .fontColor(this.doctorInfo.specialty ? '#333' : '#999')
              .layoutWeight(1)
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login_Register/EditTextPage',
              params: {
                key: 'specialty',
                current: this.doctorInfo.specialty,
                title: '擅长领域',
                placeholder: '填写示例：关节疾病:常见关节炎，关节疼痛诊治...',
                maxLength: 150
              }
            });
          })
        }

        // 6. 个人简介
        ListItem() {
          Row() {
            Text('个人简介')
              .fontSize(16)
              .width(100)
            Text(this.doctorInfo.intro || '请填写个人简介')
              .fontSize(15)
              .fontColor(this.doctorInfo.intro ? '#333' : '#999')
              .layoutWeight(1)
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login_Register/EditTextPage',
              params: {
                key: 'intro',
                current: this.doctorInfo.intro,
                title: '个人简介',
                placeholder: '请输入您的个人简介',
                maxLength: 150
              }
            });
          })
        }

        // 7. 职业经历
        ListItem() {
          Row() {
            Text('职业经历')
              .fontSize(16)
              .width(100)
            Text(this.doctorInfo.experience || '请填写您的职业经历')
              .fontSize(15)
              .fontColor(this.doctorInfo.experience ? '#333' : '#999')
              .layoutWeight(1)
            Image($r('app.media.import'))
              .width(16)
              .height(16)
          }
          .width('100%')
          .padding(16)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Login_Register/EditTextPage',
              params: {
                key: 'experience',
                current: this.doctorInfo.experience,
                title: '职业经历',
                placeholder: '请输入您的职业经历',
                maxLength: 150
              }
            });
          })
        }
      }
      .width('100%')
      .layoutWeight(1)

      // 下一步按钮
      Button('下一步')
        .width('90%')
        .height(50)
        .margin({ bottom: 30 })
        .backgroundColor('#007DFF')
        .enabled(this.isFormValid())
        .opacity(this.isFormValid() ? 1 : 0.5)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Login_Register/DoctorCertificationUpload',
            params: { doctorInfo: this.doctorInfo }
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF')
  }

  // 👉 页面每次显示时都会调用（包括从子页面返回时）
  onPageShow() {
    // 从 AppStorage 中读取子页面返回的数据
    const result = AppStorage.get<RouterBackResult>('routerBackResult');
    if (result && result.key && result.value) {
      this.updateField(result.key, result.value);
      // 清空数据，避免重复触发
      AppStorage.set<RouterBackResult>('routerBackResult', { key: '' as keyof DoctorInfo, value: '' });
    }
  }
}