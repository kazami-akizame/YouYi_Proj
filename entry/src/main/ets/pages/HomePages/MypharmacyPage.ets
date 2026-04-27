import router from '@ohos.router'
// 药品数据类型
interface Medicine {
  id: string;
  name: string;
  manufacturer: string;
  price: number;
  specification: string;
}

// 处方药品项
interface PrescriptionItem {
  name: string;
  specification: string;
  quantity: number;
}

// 处方数据类型
interface Prescription {
  id: string;
  patientName: string;
  patientGender: string;
  patientAge: number;
  clinicalDiagnosis: string;
  medicineCount: number;
  medicines: PrescriptionItem[];
  createDate: string;
  isCommon: boolean;
}

@Entry
@Component
struct MyPharmacyPage {
  @State currentTab: number = 0; // 0-常用药品，1-常用处方，2-历史处方
  @State medicineList: Medicine[] = [
    {
      id: '1',
      name: '钙铁锌咀嚼片',
      manufacturer: '特一药业集团股份有限公司',
      price: 25.00,
      specification: '1.2g*60片'
    },
    {
      id: '2',
      name: '钙铁锌咀嚼片',
      manufacturer: '特一药业集团股份有限公司',
      price: 25.00,
      specification: '1.2g*60片'
    },
    {
      id: '3',
      name: '钙铁锌咀嚼片',
      manufacturer: '特一药业集团股份有限公司',
      price: 25.00,
      specification: '1.2g*60片'
    },
    {
      id: '4',
      name: '钙铁锌咀嚼片',
      manufacturer: '特一药业集团股份有限公司',
      price: 25.00,
      specification: '1.2g*60片'
    }
  ];
  @State commonPrescriptions: Prescription[] = [
    {
      id: '1',
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: '感冒',
      medicineCount: 5,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 }
      ],
      createDate: '',
      isCommon: true
    },
    {
      id: '2',
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: '感冒',
      medicineCount: 5,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 }
      ],
      createDate: '',
      isCommon: true
    },
    {
      id: '3',
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: '感冒',
      medicineCount: 5,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 }
      ],
      createDate: '',
      isCommon: true
    }
  ];
  @State historyPrescriptions: Prescription[] = [
    {
      id: '1',
      patientName: '吴珊珊',
      patientGender: '女',
      patientAge: 23,
      clinicalDiagnosis: '感冒',
      medicineCount: 5,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 }
      ],
      createDate: '2024-01-15',
      isCommon: false
    },
    {
      id: '2',
      patientName: '吴珊珊',
      patientGender: '女',
      patientAge: 23,
      clinicalDiagnosis: '感冒',
      medicineCount: 5,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 }
      ],
      createDate: '2024-01-10',
      isCommon: false
    },
    {
      id: '3',
      patientName: '吴珊珊',
      patientGender: '女',
      patientAge: 23,
      clinicalDiagnosis: '感冒',
      medicineCount: 5,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 }
      ],
      createDate: '2024-01-05',
      isCommon: false
    }
  ];

  // 药品列表项
  @Builder
  MedicineItem(item: Medicine) {
    Column() {
      Row() {
        // 药品图片占位
        Column() {
          Text('💊')
            .fontSize(32)
        }
        .width(60)
        .height(60)
        .backgroundColor('#f0f0f0')
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)

        // 药品信息
        Column() {
          Text(item.name)
            .fontSize(16)

            .margin({ bottom: 4 })

          Text(item.manufacturer)
            .fontSize(12)
            .fontColor('#ccc')
            .margin({ bottom: 4 })


          Row() {
            Text(`￥${item.price.toFixed(2)}`)
              .fontSize(14)
              .fontColor('#ff6b6b')


            Button('删除')
              .fontSize(13)
              .fontColor('#666')
              .backgroundColor('#fff')
              .border({ width: 1, color: '#ddd' })
              .borderRadius(16)
              .width(65)
              .height(28)
              .onClick(() => {
                this.deleteMedicine(item.id);
              })
              .margin({ left: 140 })
          }

        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(2)
        .margin({ left: 12 })

      }
      .width('100%')
      .padding(12)
      .backgroundColor('#fff')
      .borderRadius(8)
    }
    .width('100%')
    .margin({ bottom: 1 })
  }

  // 常用处方列表项
  @Builder
  CommonPrescriptionItem(item: Prescription) {
    Column() {
      // 顶部：处方图标和药品数量
      Row() {
        Row() {
          Text('Rp')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          //.fontColor('#3677F2')

          Text(`共${item.medicineCount}种药品`)
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 8 })
        }.justifyContent(FlexAlign.SpaceBetween).width('100%')

        Blank()
      }
      .width('100%')
      .margin({ bottom: 12 })

      Row() {
        // 临床诊断
        Text(`临床诊断：${item.clinicalDiagnosis}`)
          .fontSize(15)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12 })
          .width('100%')

        Image($r('app.media.u2630')).width(7).margin({ left: -22 }) .onClick(() => {  // 👈 添加这行：点击跳转
          router.pushUrl({
            url: 'pages/PresciptionPage',
            //params: { diseaseName: drug.name }
          });
        })
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      // 药品列表
      Column() {
        if (item.medicines.length > 0) {
          Text(`${item.medicines[0].name}${item.medicines[0].specification}*${item.medicines[0].quantity}盒`)
            .fontSize(13)
            .fontColor('#666')
            .margin({ bottom: 6 })
            .width('100%')
        }

        if (item.medicines.length > 1) {
          Text(`${item.medicines[1].name}${item.medicines[1].specification}*${item.medicines[1].quantity}盒`)
            .fontSize(13)
            .fontColor('#666')
            .margin({ bottom: 6 })
            .width('100%')
        }

        // 如果还有其他药品，显示省略号
        if (item.medicines.length > 2) {
          Text('......')
            .fontSize(13)
            .fontColor('#999')
            .width('100%')
        }
      }
      .width('100%')
      .margin({ bottom: 16 })


      // 按钮组
      Row() {
        Button('删除')
          .fontSize(13)
          .fontColor('#999')
          .backgroundColor('#fff')
          .border({ width: 1, color: '#ddd' })
          .borderRadius(16)
          .width(70)
          .height(32)
          .onClick(() => {
            this.deleteCommonPrescription(item.id);
          })

        Button('编辑处方')
          .fontSize(13)
          .fontColor('#3677F2')
          .backgroundColor('#fff')
          .border({ width: 1, color: '#3677F2' })
          .borderRadius(16)
          .width(90)
          .height(32)
          .margin({ left: 12 })
          .onClick(() => {  // 👈 添加这行：点击跳转
          router.pushUrl({
            url: 'pages/EditComPrePage',
            //params: { diseaseName: drug.name }
          });
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .padding(15)
    .backgroundColor('#fff')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }


  // 历史处方列表项 - 患者信息在右侧版本
  @Builder
  HistoryPrescriptionItem(item: Prescription) {
    Column() {
      // 顶部：处方图标和药品数量
      Row() {
        Row() {
          Text('Rp')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          //.fontColor('#3677F2')

          Text(`共${item.medicineCount}种药品`)
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 8 })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')

        Blank()
      }
      .width('100%')
      .margin({ bottom: 12 })



      // 药品列表
      Column() {
        Text(`${item.patientName} ${item.patientGender} ${item.patientAge}岁`)
          .fontSize(15)
          .fontColor('#111')
          .width('100%')

        Row() {
          Text(`临床诊断：${item.clinicalDiagnosis}`)
            .fontSize(15)
            .fontColor('#333')
            .fontWeight(FontWeight.Medium)
            .width('100%')

          Image($r('app.media.u2630')).width(7).margin({ left: -22 }).onClick(() => { // 👈 添加这行：点击跳转
            router.pushUrl({
              url: 'pages/PrerecordPage',
              //params: { diseaseName: drug.name }
            });
          })
        }





        if (item.medicines.length > 0) {
          Text(`${item.medicines[0].name}${item.medicines[0].specification}*${item.medicines[0].quantity}盒`)
            .fontSize(13)
            .fontColor('#666')
            .margin({ bottom: 6 })
            .width('100%')
        }

        if (item.medicines.length > 1) {
          Text(`${item.medicines[1].name}${item.medicines[1].specification}*${item.medicines[1].quantity}盒`)
            .fontSize(13)
            .fontColor('#666')
            .margin({ bottom: 6 })
            .width('100%')
        }

        // 如果还有其他药品，显示省略号
        if (item.medicines.length > 2) {
          Text('......')
            .fontSize(13)
            .fontColor('#999')
            .width('100%')
        }
      }
      .width('100%')
      .margin({ bottom: 16 })


      // 按钮组
      Row() {
        Button('设为常用处方')
          .fontSize(11)
          .fontColor('#999')
          .backgroundColor('#fff')
          .border({ width: 1, color: '#ddd' })
          .borderRadius(16)
          .width(100)
          .height(32)
          .onClick(() => {
            this.setAsCommonPrescription(item);
          })

        Button('续处方')
          .fontSize(11)
          .fontColor('#3677F2')
          .backgroundColor('#fff')
          .border({ width: 1, color: '#3677F2' })
          .borderRadius(16)
          .width(70)
          .height(32)
          .margin({ left: 12 })
          .onClick(() => {
            this.renewPrescription(item);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .padding(15)
    .backgroundColor('#fff')
    .borderRadius(12)
    .margin({ bottom: 12 })
  }



  // 删除药品
  deleteMedicine(id: string) {
    this.medicineList = this.medicineList.filter(item => item.id !== id);
  }

  // 删除常用处方
  deleteCommonPrescription(id: string) {
    this.commonPrescriptions = this.commonPrescriptions.filter(item => item.id !== id);
  }

  // 编辑处方
  editPrescription(item: Prescription) {
    console.log('编辑处方', item.id);
    // 跳转到编辑页面
  }

  // 设为常用处方
  setAsCommonPrescription(item: Prescription) {
    // 手动创建新对象，不使用展开运算符
    const newCommonPrescription: Prescription = {
      id: Date.now().toString(),
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: item.clinicalDiagnosis,
      medicineCount: item.medicineCount,
      medicines: this.copyMedicines(item.medicines),
      createDate: '',
      isCommon: true
    };
    this.commonPrescriptions = [newCommonPrescription, ...this.commonPrescriptions];
    console.log('已添加到常用处方');
  }

  // 复制药品列表
  copyMedicines(medicines: PrescriptionItem[]): PrescriptionItem[] {
    const newMedicines: PrescriptionItem[] = [];
    for (let i = 0; i < medicines.length; i++) {
      newMedicines.push({
        name: medicines[i].name,
        specification: medicines[i].specification,
        quantity: medicines[i].quantity
      });
    }
    return newMedicines;
  }

  // 续处方
  renewPrescription(item: Prescription) {
    console.log('续处方', item.id);
    // 跳转到续处方页面
  }



  // 新增常用处方
  addPrescription() {
    console.log('新增常用处方');
    // 跳转到新增页面
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
            console.log('返回');
          })

        Text('我的药房')
          .fontSize(20)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(24)
          .margin({ right: 16 })
      }
      .width('100%')
      .height(40)
      .backgroundColor('#fff')

      Divider()
        .height(1)
        .color('#ddd')
      Blank().height(15)

      // Tab栏
      Row() {
        ForEach(['常用药品', '常用处方', '历史处方'], (tab: string, index: number) => {
          Column() {
            Text(tab)
              .fontSize(16)
              .fontColor(this.currentTab === index ? '#3677F2' : '#333')
              .fontWeight(this.currentTab === index ? FontWeight.Medium : FontWeight.Normal)
              .onClick(() => {
                this.currentTab = index;
              })

            if (this.currentTab === index) {
              Divider()
                .width(60)
                .height(3)
                .color('#3677F2')
                .borderRadius(1.5)
                .margin({ top: 8 })
                .strokeWidth(3)
            } else {
              Divider()
                .width(30)
                .height(3)
                .color('transparent')
                .margin({ top: 8 })
            }
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        })
      }
      .width('100%')
      .height(30)
      .backgroundColor('#fff')

      // 内容区域
      if (this.currentTab === 0) {
        // 常用药品
        Column() {
          // 标题
          Row() {
            Text(`常用药品列表（${this.medicineList.length}）`)
              .fontSize(14)
              .fontColor('#666')
          }
          .width('100%')
          .padding(15)

          // 药品列表
          if (this.medicineList.length === 0) {
            Column() {
              Text('暂无常用药品')
                .fontSize(14)
                .fontColor('#999')
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            List() {
              ForEach(
                this.medicineList,
                (item: Medicine) => {
                  ListItem() {
                    this.MedicineItem(item)
                  }
                },
                (item: Medicine) => item.id
              )

              ListItem() {
                Text('没有更多了~')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20, bottom: 20 })
              }
            }
            .layoutWeight(1)
            //.padding({ left: 15, right: 15 })
            .backgroundColor('#f5f5f5')
          }

          // 新增按钮
          Button('+ 新增常用药品')
            .width('90%')
            .height(44)
            .fontSize(16)
            .fontColor('#fff')
            .backgroundColor('#3677F2')
            .border({ width: 1, color: '#3677F2' })
            .borderRadius(22)
            .margin({ bottom: 20, top: 10 })
            .onClick(() => {  // 👈 添加这行：点击跳转
              router.pushUrl({
                url: 'pages/AddComMedSDCPage',
                //params: { diseaseName: drug.name }
              });
            })



        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
      } else if (this.currentTab === 1) {
        // 常用处方
        Column() {
          // 标题
          Row() {
            Text(`常用处方列表（${this.commonPrescriptions.length}）`)
              .fontSize(14)
              .fontColor('#666')
          }
          .width('100%')
          .padding(15)

          // 处方列表
          if (this.commonPrescriptions.length === 0) {
            Column() {
              Text('暂无常用处方')
                .fontSize(14)
                .fontColor('#999')
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            List() {
              ForEach(
                this.commonPrescriptions,
                (item: Prescription) => {
                  ListItem() {
                    this.CommonPrescriptionItem(item)
                  }
                },
                (item: Prescription) => item.id
              )

              ListItem() {
                Text('没有更多了~')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20, bottom: 20 })
              }
            }
            .layoutWeight(1)
            .padding({ left: 15, right: 15 })
            .backgroundColor('#f5f5f5')
          }

          // 新增按钮
          Button('+ 新增常用处方')
            .width('90%')
            .height(44)
            .fontSize(16)
            .fontColor('#fff')
            .backgroundColor('#3677F2')
            .border({ width: 1, color: '#3677F2' })
            .borderRadius(22)
            .margin({ bottom: 20, top: 10 })
            .onClick(() => {
          router.pushUrl({
            url: 'pages/AddComPrescriptionPage',
            //params: { diseaseName: drug.name }
          });
        })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
      } else {
        // 历史处方
        Column() {
          // 标题
          Row() {
            Text(`历史处方列表（${this.historyPrescriptions.length}）`)
              .fontSize(14)
              .fontColor('#666')
          }
          .width('100%')
          .padding(15)

          // 历史处方列表
          if (this.historyPrescriptions.length === 0) {
            Column() {
              Text('暂无历史处方')
                .fontSize(14)
                .fontColor('#999')
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else {
            List() {
              ForEach(
                this.historyPrescriptions,
                (item: Prescription) => {
                  ListItem() {
                    this.HistoryPrescriptionItem(item)
                  }
                },
                (item: Prescription) => item.id
              )

              ListItem() {
                Text('没有更多了~')
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .margin({ top: 20, bottom: 20 })
              }
            }
            .layoutWeight(1)
            .padding({ left: 15, right: 15 })
            .backgroundColor('#f5f5f5')
          }
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#fff')
  }
}