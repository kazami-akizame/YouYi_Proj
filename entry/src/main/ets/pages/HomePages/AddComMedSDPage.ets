import router from '@ohos.router';

// 药品数据结构
interface Medicine {
  id: number;
  name: string;
  spec: string;
  factory: string;
  price: number;
}

// 👇 关键：建立疾病到药品的映射关系（每个疾病至少2个药品）
const diseaseMedicineMap: Record<string, Medicine[]> = {
  // 内科疾病
  '高血压': [
    { id: 1, name: '硝苯地平片', spec: '10mg*100片', factory: '山东新华制药', price: 15.00 },
    { id: 2, name: '厄贝沙坦片', spec: '150mg*7片', factory: '赛诺菲制药', price: 28.50 }
  ],
  '糖尿病': [
    { id: 3, name: '二甲双胍片', spec: '0.5g*20片', factory: '施贵宝制药', price: 32.00 },
    { id: 4, name: '格列齐特片', spec: '80mg*60片', factory: '天津华津制药', price: 45.00 }
  ],
  '感冒': [
    { id: 5, name: '感冒灵颗粒', spec: '10g*9袋', factory: '华润三九医药', price: 18.00 },
    { id: 6, name: '复方氨酚烷胺片', spec: '12片', factory: '吴太药业', price: 12.50 }
  ],
  '肺炎': [
    { id: 7, name: '阿莫西林胶囊', spec: '0.25g*20粒', factory: '联邦制药', price: 22.00 },
    { id: 8, name: '头孢克肟片', spec: '100mg*6片', factory: '白云山制药', price: 35.00 }
  ],
  '胃炎': [
    { id: 9, name: '奥美拉唑肠溶胶囊', spec: '20mg*14粒', factory: '阿斯利康', price: 45.00 },
    { id: 10, name: '铝碳酸镁片', spec: '0.5g*20片', factory: '拜耳医药', price: 28.00 }
  ],
  '冠心病': [
    { id: 11, name: '阿司匹林肠溶片', spec: '100mg*30片', factory: '拜耳医药', price: 45.00 },
    { id: 12, name: '硝酸甘油片', spec: '0.5mg*100片', factory: '北京益民药业', price: 28.00 }
  ],
  '痛风': [
    { id: 13, name: '别嘌醇片', spec: '0.1g*100片', factory: '广东彼迪药业', price: 35.00 },
    { id: 14, name: '秋水仙碱片', spec: '0.5mg*20片', factory: '云南植物药业', price: 25.00 }
  ],
  '哮喘': [
    { id: 15, name: '沙丁胺醇气雾剂', spec: '100μg*200掀', factory: '葛兰素史克', price: 38.00 },
    { id: 16, name: '布地奈德气雾剂', spec: '200μg*100掀', factory: '阿斯利康', price: 85.00 }
  ],
  '脑梗': [
    { id: 17, name: '阿司匹林肠溶片', spec: '100mg*30片', factory: '拜耳医药', price: 45.00 },
    { id: 18, name: '氯吡格雷片', spec: '75mg*7片', factory: '赛诺菲制药', price: 98.00 }
  ],
  '心律失常': [
    { id: 19, name: '美托洛尔片', spec: '25mg*20片', factory: '阿斯利康', price: 22.00 },
    { id: 20, name: '胺碘酮片', spec: '200mg*10片', factory: '赛诺菲制药', price: 35.00 }
  ],

  // 外科疾病
  '阑尾炎': [
    { id: 21, name: '头孢曲松钠', spec: '1g*1支', factory: '罗氏制药', price: 45.00 },
    { id: 22, name: '甲硝唑片', spec: '0.2g*100片', factory: '四川科伦', price: 12.00 }
  ],
  '骨折': [
    { id: 23, name: '骨肽片', spec: '0.3g*24片', factory: '南京新百', price: 48.00 },
    { id: 24, name: '钙尔奇D片', spec: '600mg*60片', factory: '惠氏制药', price: 78.00 }
  ],
  '痔疮': [
    { id: 25, name: '马应龙麝香痔疮膏', spec: '10g', factory: '马应龙药业', price: 25.00 },
    { id: 26, name: '痔疮栓', spec: '2g*6粒', factory: '马应龙药业', price: 18.00 }
  ],
  '胆囊炎': [
    { id: 27, name: '消炎利胆片', spec: '100片', factory: '广东罗浮山', price: 15.00 },
    { id: 28, name: '熊去氧胆酸胶囊', spec: '250mg*25粒', factory: '德国霍克', price: 220.00 }
  ],
  '疝气': [
    { id: 29, name: '疝气带', spec: '成人款', factory: '康舒医疗', price: 68.00 },
    { id: 30, name: '布洛芬缓释胶囊', spec: '0.3g*20粒', factory: '中美史克', price: 25.00 }
  ],
  '颈椎病': [
    { id: 31, name: '颈复康颗粒', spec: '5g*10袋', factory: '承德颈复康', price: 35.00 },
    { id: 32, name: '双氯芬酸钠贴', spec: '50mg*4贴', factory: '北京泰德', price: 28.00 }
  ],

  // 妇产科疾病
  '阴道炎': [
    { id: 33, name: '甲硝唑栓', spec: '0.5g*10粒', factory: '西安杨森', price: 28.00 },
    { id: 34, name: '克霉唑阴道片', spec: '500mg*1片', factory: '拜耳医药', price: 45.00 }
  ],
  '盆腔炎': [
    { id: 35, name: '妇炎康片', spec: '0.25g*100片', factory: '云南白药', price: 32.00 },
    { id: 36, name: '金刚藤胶囊', spec: '0.5g*36粒', factory: '湖北福人', price: 28.00 }
  ],
  '月经不调': [
    { id: 37, name: '乌鸡白凤丸', spec: '9g*10丸', factory: '北京同仁堂', price: 45.00 },
    { id: 38, name: '益母草颗粒', spec: '15g*10袋', factory: '江西济民可信', price: 22.00 }
  ],
  '子宫肌瘤': [
    { id: 39, name: '桂枝茯苓胶囊', spec: '0.31g*100粒', factory: '江苏康缘', price: 68.00 },
    { id: 40, name: '宫瘤清胶囊', spec: '0.37g*60粒', factory: '四川奇力', price: 55.00 }
  ],
  '痛经': [
    { id: 41, name: '布洛芬缓释胶囊', spec: '0.3g*20粒', factory: '中美史克', price: 25.00 },
    { id: 42, name: '田七痛经胶囊', spec: '0.4g*24粒', factory: '广州白云山', price: 18.00 }
  ],

  // 儿科疾病
  '小儿感冒': [
    { id: 43, name: '小儿氨酚黄那敏颗粒', spec: '6g*10袋', factory: '华润三九', price: 15.00 },
    { id: 44, name: '小儿豉翘清热颗粒', spec: '2g*6袋', factory: '济川药业', price: 48.00 }
  ],
  '小儿肺炎': [
    { id: 45, name: '阿奇霉素干混悬剂', spec: '0.1g*6袋', factory: '辉瑞制药', price: 45.00 },
    { id: 46, name: '小儿肺热咳喘颗粒', spec: '3g*10袋', factory: '葵花药业', price: 32.00 }
  ],
  '小儿腹泻': [
    { id: 47, name: '蒙脱石散', spec: '3g*10袋', factory: '博福益普生', price: 25.00 },
    { id: 48, name: '双歧杆菌三联活菌', spec: '0.5g*24片', factory: '上海上药', price: 38.00 }
  ],

  // 眼科疾病
  '近视': [
    { id: 49, name: '珍视明滴眼液', spec: '15ml', factory: '江西珍视明', price: 25.00 },
    { id: 50, name: '叶黄素软胶囊', spec: '10mg*60粒', factory: '汤臣倍健', price: 158.00 }
  ],
  '结膜炎': [
    { id: 51, name: '左氧氟沙星滴眼液', spec: '5ml', factory: '参天制药', price: 35.00 },
    { id: 52, name: '妥布霉素滴眼液', spec: '5ml', factory: '爱尔康', price: 28.00 }
  ],

  // 皮肤病科
  '湿疹': [
    { id: 53, name: '糠酸莫米松乳膏', spec: '10g', factory: '默沙东', price: 32.00 },
    { id: 54, name: '炉甘石洗剂', spec: '100ml', factory: '上海运佳', price: 12.00 }
  ],
  '荨麻疹': [
    { id: 55, name: '氯雷他定片', spec: '10mg*6片', factory: '拜耳医药', price: 28.00 },
    { id: 56, name: '西替利嗪片', spec: '10mg*12片', factory: 'UCB制药', price: 25.00 }
  ],

  // 中医科
  '脾胃虚弱': [
    { id: 57, name: '健脾丸', spec: '9g*10丸', factory: '北京同仁堂', price: 35.00 },
    { id: 58, name: '参苓白术散', spec: '6g*10袋', factory: '山西广誉远', price: 28.00 }
  ],
  '失眠多梦': [
    { id: 59, name: '安神补脑液', spec: '10ml*10支', factory: '吉林敖东', price: 32.00 },
    { id: 60, name: '枣仁安神胶囊', spec: '0.45g*25粒', factory: '贵州同济堂', price: 28.00 }
  ],

  // 更多疾病...
};

// 默认药品（当疾病没有对应药品时显示）
const defaultMedicines: Medicine[] = [
  { id: 999, name: '维生素C片', spec: '100mg*100片', factory: '东北制药', price: 8.00 },
  { id: 998, name: '布洛芬缓释胶囊', spec: '0.3g*20粒', factory: '中美史克', price: 25.00 },
  { id: 997, name: '板蓝根颗粒', spec: '10g*20袋', factory: '白云山和记', price: 15.00 }
];

@Entry
@Component
struct DrugListPage {
  @State diseaseName: string = '';
  @State medicineList: Medicine[] = [];
  @State searchText: string = '';

  // 页面加载时获取疾病名称并加载对应药品
  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params['diseaseName']) {
      this.diseaseName = params['diseaseName'];
      // 根据疾病名称获取对应的药品列表
      const medicines = diseaseMedicineMap[this.diseaseName];
      if (medicines && medicines.length > 0) {
        this.medicineList = [...medicines];
      } else {
        // 没有对应药品时显示默认药品
        this.medicineList = [...defaultMedicines];
      }
    }
  }

  // 搜索功能
  onSearch(value: string) {
    this.searchText = value;
    if (value.trim() === '') {
      // 重新加载原始数据
      const originalMedicines = diseaseMedicineMap[this.diseaseName] || defaultMedicines;
      this.medicineList = [...originalMedicines];
    } else {
      const originalMedicines = diseaseMedicineMap[this.diseaseName] || defaultMedicines;
      this.medicineList = originalMedicines.filter(medicine =>
      medicine.name.includes(value) ||
      medicine.factory.includes(value) ||
      medicine.spec.includes(value)
      );
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();
          })

        Text(`${this.diseaseName}药品`)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      // 搜索框
      TextInput({ placeholder: '请输入药品信息' })
        .width('90%')
        .height(40)
        .margin({ top: 16, bottom: 16 })
        .backgroundColor('#f5f5f5')
        .borderRadius(20)
        .placeholderColor('#999')
        .fontSize(14)
        .onChange((value: string) => {
          this.onSearch(value);
        })

      // 药品列表
      List() {
        ForEach(this.medicineList, (item: Medicine, index: number) => {
          ListItem() {
            Row() {
              // 左侧药品图标
              Column() {
                Text('💊')
                  .fontSize(36)
              }
              .width(80)
              .height(80)
              .backgroundColor('#e8f0fe')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .margin({ right: 12 })

              // 中间药品信息
              Column() {
                Text(`${item.name} ${item.spec}`)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .margin({ bottom: 4 })

                Text(item.factory)
                  .fontSize(14)
                  .fontColor('#999')
                  .margin({ bottom: 8 })

                Text(`¥${item.price.toFixed(2)}`)
                  .fontSize(16)
                  .fontColor('#ff4d4f')
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              // 右侧按钮
             /* Button('加入常用药品')
                .width(120)
                .height(32)
                .fontSize(14)
                .backgroundColor('#fff')
                .fontColor('#3677F2')
                .border({ width: 1, color: '#3677F2' })
                .borderRadius(16)

  .onClick(() => {
    // 👇 修改这里：将当前药品数据传递给 MyPharmacyPage
    router.pushUrl({
      url: 'pages/HomePages/MypharmacyPage',
      params: {
        newMedicine: {
          id: item.id.toString(),  // 转换为字符串匹配 Medicine 接口
          name: item.name,
          manufacturer: item.factory,  // 注意字段名映射
          price: item.price,
          specification: item.spec
        }
      }
    });
  })*/


              // 右侧按钮
              Button('加入常用药品')
                .width(120)
                .height(32)
                .fontSize(14)
                .backgroundColor('#fff')
                .fontColor('#3677F2')
                .border({ width: 1, color: '#3677F2' })
                .borderRadius(16)
                .onClick(() => {
                  // 将当前药品数据传递给 MyPharmacyPage
                  console.log('点击药品:', item.name);  // 添加调试日志
                  router.pushUrl({
                    url: 'pages/HomePages/MypharmacyPage',
                    params: {
                      newMedicine: {
                        id: item.id.toString(),
                        name: item.name,
                        manufacturer: item.factory,
                        price: item.price,
                        specification: item.spec
                      }
                    }
                  });
                })





}
.width('100%')
.padding({ left: 16, right: 16, top: 12, bottom: 12 })
}
}, (item: Medicine) => item.id.toString())

// 底部提示
ListItem() {
Text('没有更多了~')
.fontSize(14)
.fontColor('#999')
.width('100%')
.textAlign(TextAlign.Center)
.margin({ top: 20, bottom: 20 })
}
}
.width('100%')
.layoutWeight(1)
.backgroundColor('#fff')
.divider({ strokeWidth: 1, color: '#eee' })
}
.width('100%')
.height('100%')
.backgroundColor('#fff')
}
}



