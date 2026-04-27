import http from '@ohos.net.http';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { MedicineApiService, MyMedicine } from './MedicineApiService';

// 处方药品项
export  interface PrescriptionItem {
  name: string;
  specification: string;
  quantity: number;
  usageMethod?: string;    // ✅ 添加
  frequency?: string;      // ✅ 添加
  singleDose?: string;     // ✅ 添加
  remark?: string;         // ✅ 添加
}

// 处方数据类型
export interface Prescription {
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
  @State currentTab: number = 0;
  @State medicineList: MyMedicine[] = [];
  @State commonPrescriptions: Prescription[] = [
    {
      id: '1',
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: '感冒',
      medicineCount: 2,
      medicines: [
        { name: '板蓝根颗粒', specification: '10包/盒', quantity: 1 },
        { name: '感冒灵颗粒', specification: '9袋/盒', quantity: 1 }
      ],
      createDate: '',
      isCommon: true
    }
  ];
  @State historyPrescriptions: Prescription[]=[];
  @State loading: boolean = false;

  async aboutToAppear() {
    console.log('=== MyPharmacyPage aboutToAppear 开始 ===');
    await this.loadMyMedicines();

    await this.loadHistoryPrescriptions(); // 添加这行


    console.log('=== MyPharmacyPage aboutToAppear 结束 ===');
  }

  async loadHistoryPrescriptions() {
    try {
      let httpRequest = http.createHttp();
      let response = await httpRequest.request(
        "http://127.0.0.1:8888/historyPrescriptions",
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' }
        }
      );
      let data: Prescription[] = JSON.parse(response.result as string);
      this.historyPrescriptions = data;
      httpRequest.destroy();
    } catch (err) {
      console.error('加载历史处方失败', JSON.stringify(err));
    }
  }

  // 页面每次显示时都会调用，用于接收路由参数
  onPageShow() {
    console.log('=== onPageShow 开始 ===');

    // 刷新药品列表
    //this.loadMyMedicines();
    this.loadCommonPrescriptions(); // 每次显示页面都刷新处方


    const params = router.getParams() as Record<string, object>;
    console.log('收到的参数:', JSON.stringify(params));

    if (params && params['newMedicine']) {
      const newMedicine = params['newMedicine'] as MyMedicine;
      console.log('收到新药品:', JSON.stringify(newMedicine));
      this.addMedicineFromPage(newMedicine);

      // 清除参数，避免重复添加
      router.clear();
    }

    console.log('=== onPageShow 结束 ===');
  }

  async loadCommonPrescriptions() {
    this.commonPrescriptions = await MedicineApiService.getCommonPrescriptions();
  }

  async loadMyMedicines() {
    this.loading = true;
    console.log('开始加载常用药品...');
    try {
      this.medicineList = await MedicineApiService.getMyMedicines();
      console.log('加载常用药品成功，数量:', this.medicineList.length);
    } catch (error) {
      console.error('加载失败:', error);
      promptAction.showToast({ message: '加载失败' });
    } finally {
      this.loading = false;
    }
  }


  async addMedicineFromPage(newMedicine: MyMedicine) {
    console.log('开始添加药品:', JSON.stringify(newMedicine));

    // 检查是否已存在
    const exists = this.medicineList.some(item => item.id === newMedicine.id);
    console.log('药品是否存在:', exists);

    if (exists) {
      promptAction.showToast({ message: '该药品已存在' });
      return;
    }

    const success = await MedicineApiService.addMyMedicine(newMedicine);
    console.log('API添加结果:', success);

    if (success) {
      await this.loadMyMedicines();
      promptAction.showToast({ message: '添加成功' });
    } else {
      promptAction.showToast({ message: '添加失败' });
    }
  }

  async deleteMedicine(id: string) {
    console.log('删除药品:', id);
    const success = await MedicineApiService.deleteMyMedicine(id);
    if (success) {
      await this.loadMyMedicines();
      promptAction.showToast({ message: '删除成功' });
    } else {
      promptAction.showToast({ message: '删除失败' });
    }
  }

  // 药品列表项
  @Builder
  MedicineItem(item: MyMedicine) {
    Column() {
      Row() {
        Column() {
          Text('💊')
            .fontSize(32)
        }
        .width(60)
        .height(60)
        .backgroundColor('#f0f0f0')
        .borderRadius(8)
        .justifyContent(FlexAlign.Center)

        Column() {
          Text(item.name)
            .fontSize(16)
            .margin({ bottom: 4 })

          Text(item.manufacturer)
            .fontSize(12)
            .fontColor('#999')
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
      Row() {
        Row() {
          Text('Rp')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Text(`共${item.medicineCount}种药品`)
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 8 })
        }
        .width('100%')
      }
      .width('100%')
      .margin({ bottom: 12 })




      Row() {
        // 临床诊断
        Text(`临床诊断：${item.clinicalDiagnosis}`)
          .fontSize(15)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
          .margin({ bottom: 12})
          .width('100%')

        Image($r('app.media.u2630')).width(7).margin({ left: -22 }) .onClick(() => {  // 👈 添加这行：点击跳转
          router.pushUrl({
            url: 'pages/HomePages/PresciptionPage',
            params: { prescription: item }
          });
        })
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)



      Column() {
        ForEach(item.medicines, (medicine: PrescriptionItem) => {
          Text(`${medicine.name} ${medicine.specification} ×${medicine.quantity}盒`)
            .fontSize(13)
            .fontColor('#666')
            .margin({ bottom: 6 })
            .width('100%')

          // ✅ 新增：显示用法信息
          if (medicine.usageMethod || medicine.frequency || medicine.singleDose) {
            Text(`用法：${medicine.usageMethod || ''} ${medicine.frequency || ''} ${medicine.singleDose ? medicine.singleDose + '片/次' : ''}`)
              .fontSize(11)
              .fontColor('#999')
              .margin({ bottom: 2 }).width('100%')
          }

          // ✅ 新增：显示备注
          if (medicine.remark) {
            Text(`备注：${medicine.remark}`)
              .fontSize(11)
              .fontColor('#999').width('100%')
          }

          if (item.medicines.indexOf(medicine) < item.medicines.length - 1) {
            Divider().height(1).color('#eee').margin({ top: 8, bottom: 8 })
          }

        })
      }
      .width('100%')
      .margin({ bottom: 16 })

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
          .onClick(() => {
            router.pushUrl({
              url: 'pages/HomePages/EditComPrePage',
              params: { prescription: item }
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

  // 历史处方列表项
  @Builder
  HistoryPrescriptionItem(item: Prescription) {
    Column() {
      Row() {
        Row() {
          Text('Rp')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
          Text(`共${item.medicineCount}种药品`)
            .fontSize(12)
            .fontColor('#999')
            .margin({ left: 8 })
        }
        .width('100%')
      }
      .width('100%')
      .margin({ bottom: 12 })

      Text(`${item.patientName} ${item.patientGender} ${item.patientAge}岁`)
        .fontSize(15)
        .fontColor('#111')
        .width('100%')
        .margin({ bottom: 4 })

      Row() {
        Text(`临床诊断：${item.clinicalDiagnosis}`)
          .fontSize(15)
          .fontColor('#333')
          .fontWeight(FontWeight.Medium)
          .width('100%')

        Image($r('app.media.u2630')).width(7).margin({ left: -22 }).onClick(() => { // 👈 添加这行：点击跳转
          router.pushUrl({
            url: 'pages/HomePages/PrerecordPage',
            params: { prescription: JSON.stringify(item) }

          });
        })
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      Column() {
        ForEach(item.medicines, (medicine: PrescriptionItem) => {
          Text(`${medicine.name} ${medicine.specification} ×${medicine.quantity}盒`)
            .fontSize(13)
            .fontColor('#666')
            .margin({ bottom: 6 })
            .width('100%')
        })
      }
      .width('100%')
      .margin({ bottom: 16 })

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
            //this.renewPrescription(item);
            router.pushUrl({
              url:'pages/HomePages/PrescriptionEditPage'
            })
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

  async deleteCommonPrescription(id: string) {
    console.log('删除处方, ID:', id);

    // 调用 API 删除服务器数据
    const success = await MedicineApiService.deleteCommonPrescription(id);

    if (success) {
      // 删除成功后，刷新前端列表
      await this.loadCommonPrescriptions();
      promptAction.showToast({ message: '删除成功' });
    } else {
      promptAction.showToast({ message: '删除失败' });
    }
  }

  setAsCommonPrescription(item: Prescription) {
    const newCommonPrescription: Prescription = {
      id: Date.now().toString(),
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: item.clinicalDiagnosis,
      medicineCount: item.medicineCount,
      medicines: this.copyMedicines(item.medicines),
      createDate: new Date().toISOString().split('T')[0],
      isCommon: true
    };

    this.addToCommonPrescriptions(newCommonPrescription);
  }

  async addToCommonPrescriptions(prescription: Prescription) {
    try {
      let httpRequest = http.createHttp();
      let response = await httpRequest.request(
        "http://127.0.0.1:8888/commonPrescriptions",
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify(prescription)
        }
      );
      httpRequest.destroy();

      if (response.responseCode === 200 || response.responseCode === 201) {
        await this.loadCommonPrescriptions();
        promptAction.showToast({ message: '已添加到常用处方' });
      } else {
        promptAction.showToast({ message: '添加失败' });
      }
    } catch (err) {
      console.error('添加常用处方失败', JSON.stringify(err));
      promptAction.showToast({ message: '添加失败' });
    }
  }

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
                .strokeWidth(3)
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
        Column() {
          Row() {
            Text(`常用药品列表（${this.medicineList.length}）`)
              .fontSize(14)
              .fontColor('#666')
          }
          .width('100%')
          .padding(15)

          if (this.loading) {
            Column() {
              LoadingProgress()
                .width(40)
                .height(40)
                .color('#3677F2')
              Text('加载中...')
                .fontSize(14)
                .fontColor('#999')
                .margin({ top: 12 })
            }
            .width('100%')
            .layoutWeight(1)
            .justifyContent(FlexAlign.Center)
          } else if (this.medicineList.length === 0) {
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
                (item: MyMedicine) => {
                  ListItem() {
                    this.MedicineItem(item)
                  }
                },
                (item: MyMedicine) => item.id
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
            .backgroundColor('#f5f5f5')
          }

          Button('+ 新增常用药品')
            .width('90%')
            .height(44)
            .fontSize(16)
            .fontColor('#fff')
            .backgroundColor('#3677F2')
            .borderRadius(22)
            .margin({ bottom: 20, top: 10 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HomePages/AddComMedSDCPage',
              });
            })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
      } else if (this.currentTab === 1) {
        Column() {
          Row() {
            Text(`常用处方列表（${this.commonPrescriptions.length}）`)
              .fontSize(14)
              .fontColor('#666')
          }
          .width('100%')
          .padding(15)

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

          Button('+ 新增常用处方')
            .width('90%')
            .height(44)
            .fontSize(16)
            .fontColor('#fff')
            .backgroundColor('#3677F2')
            .borderRadius(22)
            .margin({ bottom: 20, top: 10 })
            .onClick(() => {
              router.pushUrl({
                url: 'pages/HomePages/EditComPrePage',
              });
            })
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#f5f5f5')
      } else {
        Column() {
          Row() {
            Text(`历史处方列表（${this.historyPrescriptions.length}）`)
              .fontSize(14)
              .fontColor('#666')
          }
          .width('100%')
          .padding(15)

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