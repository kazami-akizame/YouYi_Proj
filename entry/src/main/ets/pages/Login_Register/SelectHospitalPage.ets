import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

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

// 省份列表
const PROVINCES: string[] = ['北京', '天津', '上海', '重庆', '河北', '山西', '内蒙古', '辽宁', '吉林', '黑龙江', '江苏', '浙江'];

// 省份-区县映射
const PROVINCE_DISTRICT_MAP: Map<string, string[]> = new Map<string, string[]>([
  ['北京', ['东城区', '西城区', '朝阳区', '海淀区', '丰台区', '石景山区', '通州区', '大兴区']],
  ['天津', ['和平区', '河东区', '河西区', '南开区', '河北区', '红桥区', '滨海新区']],
  ['上海', ['黄浦区', '徐汇区', '长宁区', '静安区', '普陀区', '虹口区', '杨浦区', '浦东新区']],
  ['重庆', ['渝中区', '大渡口区', '江北区', '沙坪坝区', '九龙坡区', '南岸区', '北碚区']],
  ['河北', ['石家庄市', '唐山市', '秦皇岛市', '邯郸市', '邢台市', '保定市', '张家口市']],
  ['山西', ['太原市', '大同市', '阳泉市', '长治市', '晋城市', '朔州市', '晋中市']],
  ['内蒙古', ['呼和浩特市', '包头市', '乌海市', '赤峰市', '通辽市', '鄂尔多斯市']],
  ['辽宁', ['沈阳市', '大连市', '鞍山市', '抚顺市', '本溪市', '丹东市', '锦州市']],
  ['吉林', ['长春市', '吉林市', '四平市', '辽源市', '通化市', '白山市']],
  ['黑龙江', ['哈尔滨市', '齐齐哈尔市', '鸡西市', '鹤岗市', '双鸭山市', '大庆市']],
  ['江苏', ['南京市', '无锡市', '徐州市', '常州市', '苏州市', '南通市', '连云港市']],
  ['浙江', ['杭州市', '宁波市', '温州市', '嘉兴市', '湖州市', '绍兴市', '金华市']]
]);

// 医院数据（按区县分类）
const HOSPITAL_MAP: Map<string, string[]> = new Map<string, string[]>([
  // 北京
  ['北京-东城区', ['北京市东城区第一人民医院', '北京市东城区中医医院', '北京协和医院（东单院区）']],
  ['北京-西城区', ['北京大学人民医院', '北京友谊医院', '北京宣武医院', '北京市西城区中医院']],
  ['北京-朝阳区', ['北京朝阳医院', '中日友好医院', '北京安贞医院', '北京市朝阳区中医院']],
  ['北京-海淀区', ['北京大学第三医院', '北京海淀医院', '北京市中关村医院']],
  ['北京-丰台区', ['北京天坛医院', '北京丰台医院', '北京市丰台区中医院']],
  ['北京-石景山区', ['北京石景山医院', '北京市石景山区中医院']],
  ['北京-通州区', ['北京市通州区人民医院', '北京市通州区中医院']],
  ['北京-大兴区', ['北京市大兴区人民医院', '北京市大兴区中医院']],
  
  // 天津
  ['天津-和平区', ['天津市和平区人民医院', '天津医科大学总医院']],
  ['天津-河东区', ['天津市河东区人民医院', '天津市中医药大学第一附属医院']],
  ['天津-河西区', ['天津市河西区人民医院', '天津市天津医院']],
  ['天津-南开区', ['天津市南开区人民医院', '天津市第一中心医院']],
  ['天津-河北区', ['天津市河北区人民医院', '天津市第四中心医院']],
  ['天津-红桥区', ['天津市红桥区人民医院', '天津市人民医院']],
  ['天津-滨海新区', ['天津市滨海新区人民医院', '天津市第五中心医院']],
  
  // 上海
  ['上海-黄浦区', ['上海交通大学医学院附属瑞金医院', '上海市黄浦区中心医院']],
  ['上海-徐汇区', ['复旦大学附属中山医院', '上海市徐汇区中心医院']],
  ['上海-长宁区', ['上海市长宁区人民医院', '上海市同仁医院']],
  ['上海-静安区', ['复旦大学附属华山医院', '上海市静安区中心医院']],
  ['上海-普陀区', ['上海市普陀区人民医院', '上海同济医院']],
  ['上海-虹口区', ['上海市虹口区人民医院', '上海市第四人民医院']],
  ['上海-杨浦区', ['上海市杨浦区中心医院', '新华医院']],
  ['上海-浦东新区', ['上海市浦东新区人民医院', '上海东方医院']],
  
  // 重庆
  ['重庆-渝中区', ['重庆市渝中区人民医院', '重庆医科大学附属第一医院']],
  ['重庆-大渡口区', ['重庆市大渡口区人民医院']],
  ['重庆-江北区', ['重庆市江北区人民医院', '重庆市第九人民医院']],
  ['重庆-沙坪坝区', ['重庆市沙坪坝区人民医院', '重庆医科大学附属第二医院']],
  ['重庆-九龙坡区', ['重庆市九龙坡区人民医院', '重庆市第十三人民医院']],
  ['重庆-南岸区', ['重庆市南岸区人民医院', '重庆市第四人民医院']],
  ['重庆-北碚区', ['重庆市北碚区人民医院', '重庆市第九人民医院北碚院区']],
  
  // 河北
  ['河北-石家庄市', ['河北省人民医院', '石家庄市第一医院', '河北医科大学第二医院']],
  ['河北-唐山市', ['唐山市人民医院', '唐山市工人医院', '开滦总医院']],
  ['河北-秦皇岛市', ['秦皇岛市第一医院', '秦皇岛市中医院']],
  ['河北-邯郸市', ['邯郸市中心医院', '邯郸市第一医院']],
  ['河北-邢台市', ['邢台市人民医院', '邢台市中医院']],
  ['河北-保定市', ['保定市第一中心医院', '河北大学附属医院']],
  ['河北-张家口市', ['张家口市第一医院', '张家口市医院']],
  
  // 山西
  ['山西-太原市', ['山西省人民医院', '山西医科大学第一医院', '太原市中心医院']],
  ['山西-大同市', ['大同市第一人民医院', '大同市第三人民医院']],
  ['山西-阳泉市', ['阳泉市第一人民医院', '阳泉煤业集团总医院']],
  ['山西-长治市', ['长治市人民医院', '长治医学院附属和平医院']],
  ['山西-晋城市', ['晋城市人民医院', '晋城市中医院']],
  ['山西-朔州市', ['朔州市人民医院', '朔州市中医院']],
  ['山西-晋中市', ['晋中市第一人民医院', '晋中市中医院']],
  
  // 内蒙古
  ['内蒙古-呼和浩特市', ['内蒙古自治区人民医院', '呼和浩特市第一医院', '内蒙古医科大学附属医院']],
  ['内蒙古-包头市', ['包头市中心医院', '包头市第一医院', '内蒙古科技大学包头医学院第一附属医院']],
  ['内蒙古-乌海市', ['乌海市人民医院', '乌海市中医医院']],
  ['内蒙古-赤峰市', ['赤峰市医院', '赤峰市中医院']],
  ['内蒙古-通辽市', ['通辽市医院', '通辽市中医院']],
  ['内蒙古-鄂尔多斯市', ['鄂尔多斯市中心医院', '鄂尔多斯市中医医院']],
  
  // 辽宁
  ['辽宁-沈阳市', ['中国医科大学附属第一医院', '中国医科大学附属盛京医院', '沈阳市中心医院']],
  ['辽宁-大连市', ['大连医科大学附属第一医院', '大连医科大学附属第二医院', '大连市中心医院']],
  ['辽宁-鞍山市', ['鞍山市中心医院', '鞍山市中医院']],
  ['辽宁-抚顺市', ['抚顺市中心医院', '抚顺市中医院']],
  ['辽宁-本溪市', ['本溪市中心医院', '本溪市中医院']],
  ['辽宁-丹东市', ['丹东市中心医院', '丹东市中医院']],
  ['辽宁-锦州市', ['锦州医科大学附属第一医院', '锦州市中心医院']],
  
  // 吉林
  ['吉林-长春市', ['吉林大学第一医院', '吉林大学第二医院', '吉林省人民医院', '长春市中心医院']],
  ['吉林-吉林市', ['吉林市中心医院', '吉林市人民医院', '吉林医药学院附属医院']],
  ['吉林-四平市', ['四平市中心人民医院', '四平市中医院']],
  ['吉林-辽源市', ['辽源市中心医院', '辽源市中医院']],
  ['吉林-通化市', ['通化市中心医院', '通化市中医院']],
  ['吉林-白山市', ['白山市中心医院', '白山市中医院']],
  
  // 黑龙江
  ['黑龙江-哈尔滨市', ['哈尔滨医科大学附属第一医院', '哈尔滨医科大学附属第二医院', '黑龙江省医院']],
  ['黑龙江-齐齐哈尔市', ['齐齐哈尔市第一医院', '齐齐哈尔市中医院']],
  ['黑龙江-鸡西市', ['鸡西市人民医院', '鸡西市中医院']],
  ['黑龙江-鹤岗市', ['鹤岗市人民医院', '鹤岗市中医院']],
  ['黑龙江-双鸭山市', ['双鸭山市人民医院', '双鸭山市中医院']],
  ['黑龙江-大庆市', ['大庆市人民医院', '大庆油田总医院']],
  
  // 江苏
  ['江苏-南京市', ['江苏省人民医院', '南京鼓楼医院', '东南大学附属中大医院', '南京市第一医院']],
  ['江苏-无锡市', ['无锡市人民医院', '无锡市第二人民医院', '江南大学附属医院']],
  ['江苏-徐州市', ['徐州医科大学附属医院', '徐州市中心医院', '徐州市第一人民医院']],
  ['江苏-常州市', ['常州市第一人民医院', '常州市第二人民医院', '常州市中医院']],
  ['江苏-苏州市', ['苏州大学附属第一医院', '苏州大学附属第二医院', '苏州市立医院']],
  ['江苏-南通市', ['南通市第一人民医院', '南通大学附属医院', '南通市中医院']],
  ['江苏-连云港市', ['连云港市第一人民医院', '连云港市中医院']],
  
  // 浙江
  ['浙江-杭州市', ['浙江大学医学院附属第一医院', '浙江大学医学院附属第二医院', '浙江省人民医院', '杭州市第一人民医院']],
  ['浙江-宁波市', ['宁波市第一医院', '宁波大学医学院附属医院', '宁波市第二医院']],
  ['浙江-温州市', ['温州医科大学附属第一医院', '温州医科大学附属第二医院', '温州市人民医院']],
  ['浙江-嘉兴市', ['嘉兴市第一医院', '嘉兴市第二医院', '嘉兴市中医院']],
  ['浙江-湖州市', ['湖州市中心医院', '湖州市第一人民医院', '湖州市中医院']],
  ['浙江-绍兴市', ['绍兴市人民医院', '绍兴市中医院', '绍兴市中心医院']],
  ['浙江-金华市', ['金华市中心医院', '金华市人民医院', '金华市中医院']]
]);

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

  // 切换省份时，自动选择第一个区县
  onProvinceChange(province: string): void {
    this.selectedProvince = province;
    // 切换到新省份时，自动选择第一个区县
    const districts = PROVINCE_DISTRICT_MAP.get(province);
    if (districts && districts.length > 0) {
      this.selectedDistrict = districts[0];
    }
  }

  // 获取当前省份的区县列表
  getCurrentDistricts(): string[] {
    return PROVINCE_DISTRICT_MAP.get(this.selectedProvince) || [];
  }

  // 获取当前区县的医院列表
  getCurrentHospitals(): string[] {
    const key = `${this.selectedProvince}-${this.selectedDistrict}`;
    return HOSPITAL_MAP.get(key) || [];
  }

  build() {
    Column() {
      // 导航栏（iOS 标准）
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
        Text("医院")
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .shadow({ radius: 0.5, color: "#00000010", offsetX: 0, offsetY: 1 })

      // 搜索框（iOS 卡片风格）
      TextInput({ placeholder: '请输入搜索医院', text: this.searchText })
        .width('90%')
        .height(44)
        .backgroundColor("#F2F2F7")
        .placeholderColor("#8E8E93")
        .borderRadius(22)
        .padding({ left: 18 })
        .margin({ top: 16, bottom: 16 })
        .onChange((val: string) => {
          this.searchText = val;
        })

      // 三列联动列表（iOS 清爽选择器）
      Row() {
        // 省份列表
        List() {
          ForEach(PROVINCES, (province: string) => {
            ListItem() {
              Text(province)
                .width('100%')
                .padding({ top: 16, bottom: 16, left: 8, right: 8 })
                .fontSize(15)
                .textAlign(TextAlign.Center)
                .fontColor(this.selectedProvince === province ? "#007AFF" : "#000000")
                .backgroundColor(this.selectedProvince === province ? "#E8F3FF" : "#F2F2F7")
            }
            .onClick(() => this.onProvinceChange(province))
          })
        }
        .width(100)
        .height('100%')
        .backgroundColor("#F2F2F7")
        .divider({ strokeWidth: 0.5, color: "#00000008" })

        // 区县列表
        List() {
          ForEach(this.getCurrentDistricts(), (district: string) => {
            ListItem() {
              Text(district)
                .width('100%')
                .padding({ top: 16, bottom: 16, left: 8, right: 8 })
                .fontSize(15)
                .textAlign(TextAlign.Center)
                .fontColor(this.selectedDistrict === district ? "#007AFF" : "#1C1C1E")
                .backgroundColor(this.selectedDistrict === district ? "#E8F3FF" : "#FFFFFF")
            }
            .onClick(() => this.selectedDistrict = district)
          })
        }
        .width(100)
        .height('100%')
        .backgroundColor(Color.White)
        .divider({ strokeWidth: 0.5, color: "#00000008" })

        // 医院列表
        List() {
          ForEach(
            this.getCurrentHospitals().filter((h: string) => !this.searchText || h.includes(this.searchText)),
            (hospital: string) => {
              ListItem() {
                Text(hospital)
                  .width('100%')
                  .padding({ top: 16, bottom: 16, left: 20, right: 20 })
                  .fontSize(15)
                  .fontColor("#1C1C1E")
                  .backgroundColor(Color.White)
              }
              .onClick(() => {
                console.log(`选择医院: ${hospital}`);
                AppStorage.SetOrCreate<RouterBackResult>('routerBackResult', {
                  key: this.fieldKey,
                  value: hospital
                });
                promptAction.showToast({ message: '选择成功', duration: 1500 });
                router.back();
              })
            }
          )
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
}
