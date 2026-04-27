import router from '@ohos.router';

// 药品数据结构
interface Drug {
  id: number;
  name: string;
}

// 科室数据结构
interface Department {
  name: string;
  drugs: Drug[];
}

@Entry
@Component
struct AddDrugPage {
  // 当前选中的科室索引
  @State selectedIndex: number = 0;
  // 搜索关键词
  @State searchText: string = '';
  // 过滤后的药品列表
  @State filteredDrugs: Drug[] = [];

  // 模拟科室和药品数据
  private departments: Department[] = [
    { name: '内科', drugs: [
      { id: 1, name: '高血压' },
      { id: 2, name: '糖尿病' },
      { id: 3, name: '感冒' },
      { id: 4, name: '肺炎' },
      { id: 5, name: '胃炎' },
      { id: 6, name: '冠心病' },
      { id: 7, name: '痛风' },
      { id: 8, name: '哮喘' },
      { id: 9, name: '脑梗' },
      { id: 10, name: '心律失常' },
      { id: 11, name: '支气管炎' },
      { id: 12, name: '慢性阻塞性肺病' },
      { id: 13, name: '胃溃疡' },
      { id: 14, name: '十二指肠溃疡' },
      { id: 15, name: '肝炎' },
      { id: 16, name: '肝硬化' },
      { id: 17, name: '肾炎' },
      { id: 18, name: '尿路感染' },
      { id: 19, name: '贫血' },
      { id: 20, name: '甲状腺功能亢进' },
      { id: 21, name: '甲状腺功能减退' },
      { id: 22, name: '类风湿性关节炎' },
      { id: 23, name: '系统性红斑狼疮' },
      { id: 24, name: '帕金森病' },
      { id: 25, name: '阿尔茨海默病' },
      { id: 26, name: '偏头痛' },
      { id: 27, name: '神经衰弱' },
      { id: 28, name: '失眠症' },
      { id: 29, name: '焦虑症' },
      { id: 30, name: '抑郁症' }
    ]},
    { name: '外科', drugs: [
      { id: 31, name: '阑尾炎' },
      { id: 32, name: '骨折' },
      { id: 33, name: '痔疮' },
      { id: 34, name: '胆囊炎' },
      { id: 35, name: '疝气' },
      { id: 36, name: '颈椎病' },
      { id: 37, name: '腰椎间盘突出' },
      { id: 38, name: '肾结石' },
      { id: 39, name: '乳腺炎' },
      { id: 40, name: '外伤' },
      { id: 41, name: '胆结石' },
      { id: 42, name: '胰腺炎' },
      { id: 43, name: '肠梗阻' },
      { id: 44, name: '静脉曲张' },
      { id: 45, name: '甲状腺结节' },
      { id: 46, name: '乳腺增生' },
      { id: 47, name: '前列腺增生' },
      { id: 48, name: '包皮过长' },
      { id: 49, name: '肛裂' },
      { id: 50, name: '肛瘘' },
      { id: 51, name: '腱鞘囊肿' },
      { id: 52, name: '脂肪瘤' },
      { id: 53, name: '神经鞘瘤' },
      { id: 54, name: '皮肤囊肿' },
      { id: 55, name: '甲沟炎' },
      { id: 56, name: '骨髓炎' },
      { id: 57, name: '关节炎' },
      { id: 58, name: '半月板损伤' },
      { id: 59, name: '韧带损伤' },
      { id: 60, name: '肩周炎' }
    ]},
    { name: '妇产科', drugs: [
      { id: 61, name: '阴道炎' },
      { id: 62, name: '盆腔炎' },
      { id: 63, name: '月经不调' },
      { id: 64, name: '子宫肌瘤' },
      { id: 65, name: '痛经' },
      { id: 66, name: '宫颈炎' },
      { id: 67, name: '卵巢囊肿' },
      { id: 68, name: '孕期保健' },
      { id: 69, name: '产后恢复' },
      { id: 70, name: '更年期综合征' },
      { id: 71, name: '宫颈糜烂' },
      { id: 72, name: '子宫内膜异位症' },
      { id: 73, name: '多囊卵巢综合征' },
      { id: 74, name: '卵巢早衰' },
      { id: 75, name: '先兆流产' },
      { id: 76, name: '妊娠高血压' },
      { id: 77, name: '妊娠糖尿病' },
      { id: 78, name: '产后抑郁' },
      { id: 79, name: '乳腺炎' },
      { id: 80, name: '不孕症' },
      { id: 81, name: '习惯性流产' },
      { id: 82, name: '宫外孕' },
      { id: 83, name: '葡萄胎' },
      { id: 84, name: '子宫脱垂' },
      { id: 85, name: '阴道壁膨出' },
      { id: 86, name: '尿失禁' },
      { id: 87, name: '闭经' },
      { id: 88, name: '功能性子宫出血' },
      { id: 89, name: '产前焦虑' },
      { id: 90, name: '妊娠呕吐' }
    ]},
    { name: '儿科', drugs: [
      { id: 91, name: '小儿感冒' },
      { id: 92, name: '小儿肺炎' },
      { id: 93, name: '小儿腹泻' },
      { id: 94, name: '手足口病' },
      { id: 95, name: '小儿湿疹' },
      { id: 96, name: '小儿发烧' },
      { id: 97, name: '小儿积食' },
      { id: 98, name: '小儿贫血' },
      { id: 99, name: '小儿哮喘' },
      { id: 100, name: '新生儿护理' },
      { id: 101, name: '小儿扁桃体炎' },
      { id: 102, name: '小儿腮腺炎' },
      { id: 103, name: '小儿水痘' },
      { id: 104, name: '小儿麻疹' },
      { id: 105, name: '小儿风疹' },
      { id: 106, name: '小儿百日咳' },
      { id: 107, name: '小儿猩红热' },
      { id: 108, name: '小儿结核病' },
      { id: 109, name: '小儿蛔虫病' },
      { id: 110, name: '小儿佝偻病' },
      { id: 111, name: '小儿营养不良' },
      { id: 112, name: '小儿肥胖症' },
      { id: 113, name: '小儿多动症' },
      { id: 114, name: '小儿自闭症' },
      { id: 115, name: '小儿癫痫' },
      { id: 116, name: '小儿脑瘫' },
      { id: 117, name: '小儿心肌炎' },
      { id: 118, name: '小儿肾炎' },
      { id: 119, name: '小儿过敏性紫癜' },
      { id: 120, name: '小儿川崎病' }
    ]},
    { name: '眼科', drugs: [
      { id: 121, name: '近视' },
      { id: 122, name: '结膜炎' },
      { id: 123, name: '角膜炎' },
      { id: 124, name: '麦粒肿' },
      { id: 125, name: '干眼症' },
      { id: 126, name: '青光眼' },
      { id: 127, name: '白内障' },
      { id: 128, name: '远视' },
      { id: 129, name: '散光' },
      { id: 130, name: '眼底病变' },
      { id: 131, name: '视网膜脱落' },
      { id: 132, name: '黄斑变性' },
      { id: 133, name: '糖尿病视网膜病变' },
      { id: 134, name: '高血压视网膜病变' },
      { id: 135, name: '视神经萎缩' },
      { id: 136, name: '葡萄膜炎' },
      { id: 137, name: '巩膜炎' },
      { id: 138, name: '虹膜炎' },
      { id: 139, name: '眼睑炎' },
      { id: 140, name: '泪囊炎' },
      { id: 141, name: '沙眼' },
      { id: 142, name: '眼外伤' },
      { id: 143, name: '斜视' },
      { id: 144, name: '弱视' },
      { id: 145, name: '眼球震颤' },
      { id: 146, name: '色盲' },
      { id: 147, name: '夜盲症' },
      { id: 148, name: '飞蚊症' },
      { id: 149, name: '眼肌麻痹' },
      { id: 150, name: '眼眶肿瘤' }
    ]},
    { name: '口腔科', drugs: [
      { id: 151, name: '龋齿' },
      { id: 152, name: '牙龈炎' },
      { id: 153, name: '牙周炎' },
      { id: 154, name: '口腔溃疡' },
      { id: 155, name: '智齿痛' },
      { id: 156, name: '牙髓炎' },
      { id: 157, name: '口臭' },
      { id: 158, name: '牙敏感' },
      { id: 159, name: '鹅口疮' },
      { id: 160, name: '牙齿不齐' },
      { id: 161, name: '牙结石' },
      { id: 162, name: '牙龈出血' },
      { id: 163, name: '牙龈萎缩' },
      { id: 164, name: '牙齿松动' },
      { id: 165, name: '牙缺失' },
      { id: 166, name: '四环素牙' },
      { id: 167, name: '氟斑牙' },
      { id: 168, name: '牙齿美白' },
      { id: 169, name: '口腔扁平苔藓' },
      { id: 170, name: '口腔白斑' },
      { id: 171, name: '口腔红斑' },
      { id: 172, name: '唇炎' },
      { id: 173, name: '舌炎' },
      { id: 174, name: '口角炎' },
      { id: 175, name: '腮腺炎' },
      { id: 176, name: '颌下腺炎' },
      { id: 177, name: '颞下颌关节紊乱' },
      { id: 178, name: '口腔颌面外伤' },
      { id: 179, name: '口腔肿瘤' },
      { id: 180, name: '唇腭裂' }
    ]},
    { name: '皮肤病科', drugs: [
      { id: 181, name: '湿疹' },
      { id: 182, name: '荨麻疹' },
      { id: 183, name: '痤疮' },
      { id: 184, name: '皮炎' },
      { id: 185, name: '脚气' },
      { id: 186, name: '灰指甲' },
      { id: 187, name: '带状疱疹' },
      { id: 188, name: '银屑病' },
      { id: 189, name: '白癜风' },
      { id: 190, name: '黄褐斑' },
      { id: 191, name: '玫瑰糠疹' },
      { id: 192, name: '扁平疣' },
      { id: 193, name: '寻常疣' },
      { id: 194, name: '尖锐湿疣' },
      { id: 195, name: '梅毒' },
      { id: 196, name: '淋病' },
      { id: 197, name: '生殖器疱疹' },
      { id: 198, name: '毛囊炎' },
      { id: 199, name: '疖肿' },
      { id: 200, name: '痈' },
      { id: 201, name: '丹毒' },
      { id: 202, name: '蜂窝织炎' },
      { id: 203, name: '痱子' },
      { id: 204, name: '冻疮' },
      { id: 205, name: '鸡眼' },
      { id: 206, name: '胼胝' },
      { id: 207, name: '瘢痕疙瘩' },
      { id: 208, name: '血管瘤' },
      { id: 209, name: '色素痣' },
      { id: 210, name: '皮肤癌' }
    ]},
    { name: '中医科', drugs: [
      { id: 211, name: '脾胃虚弱' },
      { id: 212, name: '失眠多梦' },
      { id: 213, name: '气血不足' },
      { id: 214, name: '肝郁气滞' },
      { id: 215, name: '肾虚' },
      { id: 216, name: '风湿骨痛' },
      { id: 217, name: '痛经调理' },
      { id: 218, name: '体质虚弱' },
      { id: 219, name: '湿气重' },
      { id: 220, name: '更年期调理' },
      { id: 221, name: '阳虚' },
      { id: 222, name: '阴虚' },
      { id: 223, name: '气虚' },
      { id: 224, name: '血虚' },
      { id: 225, name: '痰湿' },
      { id: 226, name: '血瘀' },
      { id: 227, name: '湿热' },
      { id: 228, name: '寒湿' },
      { id: 229, name: '上火' },
      { id: 230, name: '中暑' },
      { id: 231, name: '感冒' },
      { id: 232, name: '咳嗽' },
      { id: 233, name: '哮喘' },
      { id: 234, name: '胃痛' },
      { id: 235, name: '腹痛' },
      { id: 236, name: '便秘' },
      { id: 237, name: '腹泻' },
      { id: 238, name: '水肿' },
      { id: 239, name: '眩晕' },
      { id: 240, name: '耳鸣' }
    ]},
    { name: '传染病科', drugs: [
      { id: 241, name: '流感' },
      { id: 242, name: '肺结核' },
      { id: 243, name: '肝炎' },
      { id: 244, name: '痢疾' },
      { id: 245, name: '新冠感染' },
      { id: 246, name: '水痘' },
      { id: 247, name: '腮腺炎' },
      { id: 248, name: '手足口病' },
      { id: 249, name: '梅毒' },
      { id: 250, name: '艾滋病' },
      { id: 251, name: '狂犬病' },
      { id: 252, name: '破伤风' },
      { id: 253, name: '疟疾' },
      { id: 254, name: '登革热' },
      { id: 255, name: '霍乱' },
      { id: 256, name: '伤寒' },
      { id: 257, name: '副伤寒' },
      { id: 258, name: '猩红热' },
      { id: 259, name: '百日咳' },
      { id: 260, name: '白喉' },
      { id: 261, name: '麻疹' },
      { id: 262, name: '风疹' },
      { id: 263, name: '流行性脑脊髓膜炎' },
      { id: 264, name: '流行性乙型脑炎' },
      { id: 265, name: '钩端螺旋体病' },
      { id: 266, name: '血吸虫病' },
      { id: 267, name: '蛔虫病' },
      { id: 268, name: '绦虫病' },
      { id: 269, name: '钩虫病' },
      { id: 270, name: '蛲虫病' }
    ]},
    { name: '康复科', drugs: [
      { id: 271, name: '中风康复' },
      { id: 272, name: '骨折康复' },
      { id: 273, name: '颈肩腰腿痛' },
      { id: 274, name: '关节康复' },
      { id: 275, name: '神经损伤' },
      { id: 276, name: '产后康复' },
      { id: 277, name: '运动损伤' },
      { id: 278, name: '脑瘫康复' },
      { id: 279, name: '疼痛康复' },
      { id: 280, name: '老年康复' },
      { id: 281, name: '脊髓损伤康复' },
      { id: 282, name: '烧伤康复' },
      { id: 283, name: '心肺康复' },
      { id: 284, name: '言语康复' },
      { id: 285, name: '吞咽康复' },
      { id: 286, name: '认知康复' },
      { id: 287, name: '心理康复' },
      { id: 288, name: '职业康复' },
      { id: 289, name: '儿童康复' },
      { id: 290, name: '体育康复' },
      { id: 291, name: '截肢康复' },
      { id: 292, name: '假肢训练' },
      { id: 293, name: '轮椅训练' },
      { id: 294, name: '平衡训练' },
      { id: 295, name: '步态训练' },
      { id: 296, name: '肌力训练' },
      { id: 297, name: '耐力训练' },
      { id: 298, name: '柔韧性训练' },
      { id: 299, name: '协调性训练' },
      { id: 300, name: '日常生活能力训练' }
    ]},
    { name: '营养科', drugs: [
      { id: 301, name: '肥胖症' },
      { id: 302, name: '营养不良' },
      { id: 303, name: '糖尿病饮食' },
      { id: 304, name: '高血压饮食' },
      { id: 305, name: '孕期营养' },
      { id: 306, name: '儿童营养' },
      { id: 307, name: '老年营养' },
      { id: 308, name: '肾病营养' },
      { id: 309, name: '痛风饮食' },
      { id: 310, name: '消瘦调理' },
      { id: 311, name: '厌食症' },
      { id: 312, name: '暴食症' },
      { id: 313, name: '维生素缺乏' },
      { id: 314, name: '矿物质缺乏' },
      { id: 315, name: '蛋白质缺乏' },
      { id: 316, name: '缺铁性贫血' },
      { id: 317, name: '缺钙' },
      { id: 318, name: '缺锌' },
      { id: 319, name: '高血脂饮食' },
      { id: 320, name: '冠心病饮食' },
      { id: 321, name: '肝病饮食' },
      { id: 322, name: '肿瘤营养' },
      { id: 323, name: '术后营养' },
      { id: 324, name: '肠内营养' },
      { id: 325, name: '肠外营养' },
      { id: 326, name: '减重营养' },
      { id: 327, name: '增肌营养' },
      { id: 328, name: '运动营养' },
      { id: 329, name: '素食营养' },
      { id: 330, name: '中医药膳' }
    ]},
    { name: '急诊科', drugs: [
      { id: 331, name: '高烧' },
      { id: 332, name: '急性腹痛' },
      { id: 333, name: '外伤出血' },
      { id: 334, name: '急性过敏' },
      { id: 335, name: '晕厥' },
      { id: 336, name: '呼吸困难' },
      { id: 337, name: '食物中毒' },
      { id: 338, name: '酒精中毒' },
      { id: 339, name: '烧烫伤' },
      { id: 340, name: '急性心梗' },
      { id: 341, name: '脑出血' },
      { id: 342, name: '脑卒中' },
      { id: 343, name: '癫痫发作' },
      { id: 344, name: '急性胰腺炎' },
      { id: 345, name: '肠梗阻' },
      { id: 346, name: '急腹症' },
      { id: 347, name: '急性阑尾炎' },
      { id: 348, name: '急性胆囊炎' },
      { id: 349, name: '肾绞痛' },
      { id: 350, name: '急性尿潴留' },
      { id: 351, name: '急性青光眼' },
      { id: 352, name: '中暑' },
      { id: 353, name: '溺水' },
      { id: 354, name: '触电' },
      { id: 355, name: '中毒' },
      { id: 356, name: '蛇咬伤' },
      { id: 357, name: '狗咬伤' },
      { id: 358, name: '虫蛰伤' },
      { id: 359, name: '休克' },
      { id: 360, name: '心肺复苏' }
    ]}
  ];

  aboutToAppear() {
    // 初始化显示第一个科室的药品列表
    this.filteredDrugs = this.departments[0].drugs;
  }

  // 搜索过滤方法
  filterDrugs() {
    if (this.searchText.trim() === '') {
      // 搜索框为空时，显示当前科室的所有药品
      this.filteredDrugs = this.departments[this.selectedIndex].drugs;
    } else {
      // 根据搜索关键词过滤药品
      const keyword = this.searchText.toLowerCase();
      this.filteredDrugs = this.departments[this.selectedIndex].drugs.filter((drug: Drug) =>
      drug.name.toLowerCase().includes(keyword)
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

        Text('新增药品')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .height(46)
      .backgroundColor('#fff')

      Divider()
        .height(1)
        .color('#ddd')
      Blank().height(10)

      // 搜索框
      TextInput({ placeholder: '请输入药品信息' })
        .width('90%')
        .height(40)
        .margin({ top: 1, bottom: 16 })
        .backgroundColor('#f5f5f5')
        .borderRadius(20)
        .placeholderColor('#999')
        .fontSize(14)
        .onChange((value: string) => {
          this.searchText = value;
          this.filterDrugs();
        })

      // 主内容区：左侧科室列表 + 右侧药品列表
      Row() {
        // 左侧科室列表
        List() {
          ForEach(this.departments, (dept: Department, index: number) => {
            ListItem() {
              Text(dept.name)
                .fontSize(16)
                .width('100%')
                .textAlign(TextAlign.Center)
                .padding({ top: 16, bottom: 16 })
                .backgroundColor(this.selectedIndex === index ? '#fff' : '#f5f5f5')
                .fontColor(this.selectedIndex === index ? '#007DFF' : '#333')
            }
            .onClick(() => {
              this.selectedIndex = index;
              this.filterDrugs();
            })
          })
        }
        .width('30%')
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
        .divider({ strokeWidth: 1, color: '#eee' })

        // 右侧药品列表
        List() {
          ForEach(this.filteredDrugs, (drug: Drug) => {
            ListItem() {
              Text(drug.name)
                .fontSize(16)
                .width('100%')
                .padding({ left: 20, top: 16, bottom: 16, right: 0 })
                .backgroundColor('#fff')
            }
            .padding({ left: 0, right: 0 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HomePages/AddComMedSDPage',
                params: { diseaseName: drug.name }
              });
            })
          })
        }
        .width('70%')
        .layoutWeight(2)
        .backgroundColor('#fff')
        .divider({ strokeWidth: 1, color: '#eee' })
        .padding({ left: 0, right: 0 })
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}