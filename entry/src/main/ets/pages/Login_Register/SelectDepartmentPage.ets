import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

interface RouterBackResult {
  key: string;
  value: string;
}

// 主科室列表
const MAIN_DEPARTMENTS: string[] = ['内科', '外科', '妇产科', '儿科', '眼科', '口腔科', '皮肤科', '精神科', '肿瘤科', '急诊科'];

// 主科室-子科室映射
const SUB_DEPARTMENTS_MAP: Map<string, string[]> = new Map<string, string[]>([
  ['内科', ['血液科', '呼吸科', '消化科', '心血管科', '神经内科', '内分泌科', '风湿免疫科', '感染科']],
  ['外科', ['普外科', '骨科', '泌尿外科', '神经外科', '心胸外科', '肝胆外科', '胃肠外科', '乳腺外科']],
  ['妇产科', ['妇科', '产科', '生殖医学科', '计划生育科', '妇科肿瘤科']],
  ['儿科', ['新生儿科', '小儿内科', '小儿外科', '儿童保健科', '小儿神经内科']],
  ['眼科', ['视光科', '眼底病科', '白内障科', '青光眼科', '眼表疾病科', '眼外伤科']],
  ['口腔科', ['牙体牙髓科', '牙周科', '正畸科', '口腔颌面外科', '口腔修复科', '口腔种植科']],
  ['皮肤科', ['皮肤病科', '性病科', '医学美容科', '皮肤外科']],
  ['精神科', ['普通精神科', '临床心理科', '睡眠医学科', '成瘾医学科']],
  ['肿瘤科', ['肿瘤内科', '肿瘤外科', '放疗科', '化疗科', '姑息治疗科']],
  ['急诊科', ['急诊内科', '急诊外科', '急诊儿科', '重症医学科（ICU）']]
]);

@Entry
@Component
struct SelectDepartmentPage {
  @State fieldKey: string = '';
  @State title: string = '';
  @State selectedMain: string = '内科';

  aboutToAppear() {
    interface RouterParams {
      key?: string;
      title?: string;
    }
    const params = router.getParams() as RouterParams;
    this.fieldKey = params.key ?? '';
    this.title = params.title ?? '';
  }

  build() {
    Column() {
      // 导航栏（iOS 标准样式）
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
        .onClick(() => router.back())

        // 标题
        Text("科室")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .shadow({ radius: 0.5, color: "#00000010", offsetX: 0, offsetY: 1 })

      // 搜索框（iOS 卡片风格）
      TextInput({ placeholder: '请输入搜索科室' })
        .width('90%')
        .height(44)
        .backgroundColor("#F2F2F7")
        .placeholderColor("#8E8E93")
        .borderRadius(22)
        .padding({ left: 18 })
        .margin({ top: 16, bottom: 16 })

      // 双列列表（iOS 清爽选择器）
      Row() {
        // 主科室列表
        List() {
          ForEach(MAIN_DEPARTMENTS, (dept: string) => {
            ListItem() {
              Text(dept)
                .width('100%')
                .padding({ top: 16, bottom: 16, left: 12, right: 12 })
                .fontSize(15)
                .fontColor(this.selectedMain === dept ? "#007AFF" : "#000000")
                .backgroundColor(this.selectedMain === dept ? "#E8F3FF" : "#F2F2F7")
                .textAlign(TextAlign.Center)
            }
            .onClick(() => {
              this.selectedMain = dept;
            })
          })
        }
        .width(100)
        .height('100%')
        .backgroundColor("#F2F2F7")
        .divider({ strokeWidth: 0.5, color: "#00000008" })

        // 子科室列表
        List() {
          ForEach(this.getCurrentSubDepartments(), (subDept: string) => {
            ListItem() {
              Text(subDept)
                .width('100%')
                .padding({ top: 16, bottom: 16, left: 20, right: 20 })
                .fontSize(15)
                .fontColor("#1C1C1E")
                .backgroundColor(Color.White)
            }
            .onClick(() => {
              console.log(`选择科室: ${this.selectedMain}-${subDept}`);
              AppStorage.SetOrCreate<RouterBackResult>('routerBackResult', {
                key: this.fieldKey,
                value: `${this.selectedMain}-${subDept}`
              });
              promptAction.showToast({ message: '选择成功', duration: 1500 });
              router.back();
            })
          })
        }
        .layoutWeight(1)
        .height('100%')
        .backgroundColor(Color.White)
        .divider({ strokeWidth: 0.5, color: "#00000008" })
      }
      .width('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#FFFFFF")
  }

  getCurrentSubDepartments(): string[] {
    return SUB_DEPARTMENTS_MAP.get(this.selectedMain) || [];
  }
}