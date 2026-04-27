import router from '@ohos.router';

// 路由返回数据类型
interface RouterBackResult {
  key: string;
  value: string;
}

// 路由参数类型
interface SelectPageParams {
  key?: string;
  title?: string;
}

const provinces: string[] = ['北京', '天津', '上海', '重庆', '河北', '山西', '内蒙古', '辽宁', '吉林', '黑龙江', '江苏', '浙江'];
const districts: string[] = ['东城区', '西城区', '朝阳区', '海淀区', '丰台区'];
const hospitals: string[] = [
  '北京市东城区第一人民医院',
  '北京市东城区第二人民医院',
  '北京市东城区第三人民医院'
];

@Entry
@Component
struct SelectHospitalPage {
  @State fieldKey: string = '';
  @State searchText: string = '';
  @State selectedProvince: string = '北京';
  @State selectedDistrict: string = '东城区';

  aboutToAppear(): void {
    const params = router.getParams() as SelectPageParams;
    this.fieldKey = params.key ?? '';
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Image($r('app.media.img_4'))
          .width(24)
          .height(24)
          .onClick(() => router.back())

        Text('医院')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding({ top: 12, bottom: 12, left: 15, right: 15 })

      // 搜索框
      TextInput({ placeholder: '请输入搜索医院', text: this.searchText })
        .width('90%')
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .margin({ top: 8, bottom: 8 })
        .onChange((val: string) => {
          this.searchText = val;
        })

      // 三列列表（完美置顶对齐）
      Row() {
        // 省份
        List() {
          ForEach(provinces, (province: string) => {
            ListItem() {
              Text(province)
                .width('100%')
                .padding(15)
                .fontColor(this.selectedProvince === province ? '#007DFF' : '#333')
                .backgroundColor(this.selectedProvince === province ? '#E8F3FF' : '#F5F5F5')
                .onClick(() => this.selectedProvince = province)
            }
          })
        }
        .width(100)
        .height('100%')
        .backgroundColor('#F5F5F5')

        // 区
        List() {
          ForEach(districts, (district: string) => {
            ListItem() {
              Text(district)
                .width('100%')
                .padding(15)
                .fontColor(this.selectedDistrict === district ? '#007DFF' : '#333')
                .backgroundColor(this.selectedDistrict === district ? '#E8F3FF' : '#FFFFFF')
                .onClick(() => this.selectedDistrict = district)
            }
          })
        }
        .width(100)
        .height('100%')
        .backgroundColor('#FFFFFF')

        // 医院
        List() {
          ForEach(hospitals.filter((h: string) => h.includes(this.searchText)), (hospital: string) => {
            ListItem() {
              Text(hospital)
                .width('100%')
                .padding(15)
                .onClick(() => {
                  AppStorage.SetOrCreate<RouterBackResult>('routerBackResult', {
                    key: this.fieldKey,
                    value: hospital
                    //点击之后返回个人信息页，保存显示个人信息
                  });
                  router.back();
                })
            }
          })
        }
        .layoutWeight(1)
        .height('100%')
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}