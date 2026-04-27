import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

interface RouterBackResult {
  key: string;
  value: string;
}

const mainDepartments = ['内科', '外科', '妇产科', '儿科', '眼科', '口腔科'];
const subDepartments: Record<string, string[]> = {
  '内科': ['血液科', '呼吸科', '消化科', '心血管科', '神经内科'],
  '外科': ['普外科', '骨科', '泌尿外科', '神经外科', '心胸外科'],
  '妇产科': ['妇科', '产科', '生殖医学科'],
  '儿科': ['新生儿科', '小儿内科', '小儿外科'],
  '眼科': ['视光科', '眼底病科', '白内障科'],
  '口腔科': ['牙体牙髓科', '牙周科', '正畸科']
};

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
      // 导航栏 → 已修改：固定显示“科室”
      Row() {
        Image($r('app.media.img_4'))
          .width(24)
          .height(24)
          .onClick(() => router.back())
        Text("科室") // 👈 这里固定写死“科室”
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ top: 12, bottom: 12, left: 15, right: 15 })

      // 科室列表（紧贴导航栏，无空白）
      Row() {
        // 左侧主科室
        List() {
          ForEach(mainDepartments, (dept: string) => {
            ListItem() {
              Text(dept)
                .width('100%')
                .padding(15)
                .fontColor(this.selectedMain === dept ? '#007DFF' : '#333')
                .backgroundColor(this.selectedMain === dept ? '#E8F3FF' : '#fff')
            }
            .onClick(() => this.selectedMain = dept)
          })
        }
        .width(120)
        .backgroundColor('#fff')

        // 右侧子科室
        List() {
          ForEach(subDepartments[this.selectedMain], (subDept: string) => {
            ListItem() {
              Text(subDept)
                .width('100%')
                .padding(15)
            }
            .onClick(() => {
              AppStorage.SetOrCreate<RouterBackResult>('routerBackResult', {
                key: this.fieldKey,
                value: `${this.selectedMain}-${subDept}`
                //绑定点击保存科室返回个人信息页
              });
              promptAction.showToast({ message: '选择成功' });
              router.back();
            })
          })
        }
        .layoutWeight(1)
        .backgroundColor('#fff')
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}