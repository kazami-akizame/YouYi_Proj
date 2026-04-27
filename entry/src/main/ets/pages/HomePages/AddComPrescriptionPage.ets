import router from '@ohos.router';

import promptAction from '@ohos.promptAction';  // 👈 添加这一行

// 👇 添加处方数据类型定义
interface PrescriptionItem {
  name: string;
  specification: string;
  quantity: number;
}

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
struct AddPrescriptionPage {
  @State diagnosis: string = '';

  @State medicines: PrescriptionItem[] = [];  // 👈 添加药品列表状态

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();// 返回逻辑
          })

        Text('新增常用处方')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(40)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      Divider()
        .height(1)
        .color('#ddd')

      Column() {
        // 诊断
        Column() {
          Text('诊断')
            .fontSize(16)
            .fontColor('#333')
            .margin({ bottom: 8 })
            .width('100%')

          // 多行输入框
          TextArea({ placeholder: '请输入诊断' })
            .width('100%')
            .height(64)
            .backgroundColor('#fff')
            .borderRadius(8)
            .padding({ left:1, top: 8 })
            .maxLines(4)  // 最大4行
            .onChange((value: string) => {
              this.diagnosis = value;
            })

        }.backgroundColor('#fff')
        .width('90%')
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13)


        // Rp
        Column() {
          Row() {
            Text('Rp')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')


          Blank().height(15)


          // 👇 显示已添加的药品列表
          if (this.medicines.length > 0) {
            Column() {
              ForEach(this.medicines, (medicine: PrescriptionItem, index: number) => {
                Row() {
                  Text(`${medicine.name} ${medicine.specification} ×${medicine.quantity}`)
                    .fontSize(14)
                    .layoutWeight(1)

                  Text('删除')
                    .fontSize(12)
                    .fontColor('#ff6b6b')
                    .onClick(() => {
                      this.medicines = this.medicines.filter((_, i) => i !== index);
                    })
                }
                .width('100%')
                .padding({ top: 8, bottom: 8 })
                .borderWidth({ bottom: 1 })
                .borderColor('#eee')
              })
            }
            .width('100%')
            .margin({ bottom: 15 })
          }

          // +新增药品
          Row() {
            Text('+新增药品')
              .fontSize(18)
              .fontColor('#3677F2')//.borderWidth(1).width('90%')
          }.borderWidth(1).borderStyle(BorderStyle.Dashed).borderRadius(24).borderColor('#3677F2')
          .width('100%').height(50).justifyContent(FlexAlign.Center)
          .padding({
            top: 1,
          })
          .onClick(() => {  // 👈 添加这行：点击跳转
            router.pushUrl({
              url: 'pages/HomePages/ACPSDCPPage',
              params: { returnData: true }  // 👈 传递参数表示需要返回数据
            });
          })
        }
        .backgroundColor('#fff')
        .width('90%')
        .padding(16)
        .margin({ top: 16 })
        .borderRadius(13)

        Blank()
      }.backgroundColor('#f5f5f5').height('85%').width('100%')
      Blank().height(10)
        // 保存常用处方按钮
        Button('保存常用处方')
          .width('90%')
          .height(48)
          .fontSize(16)
          .fontColor('#fff')
          .backgroundColor('#3677F2')
          .borderRadius(24)
          .margin({ bottom: 1 })
          .onClick(() => {
            //router.back();
            // 👇 修改这里：保存处方并返回数据
            this.savePrescription();
          })

    }
    .width('100%')
    .height('100%')
    //.backgroundColor('#fff')


  }

  // 👇 添加保存方法
  savePrescription() {
    // 验证诊断和药品
    if (!this.diagnosis.trim()) {
      promptAction.showToast({
        message: '请输入诊断',
        duration: 2000
      });
      return;
    }

    if (this.medicines.length === 0) {
      promptAction.showToast({
        message: '请至少添加一种药品',
        duration: 2000
      });
      return;
    }

    // 创建处方对象
    const newPrescription: Prescription = {
      id: Date.now().toString(),
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: this.diagnosis,
      medicineCount: this.medicines.length,
      medicines: this.medicines,
      createDate: '',
      isCommon: true
    };

    // 返回数据到我的药房页面
    router.back({
      url: 'pages/HomePages/MypharmacyPage',
      params: {
        newPrescription: newPrescription
      }
    });
  }

  // 👇 接收从药品选择页面返回的数据
  aboutToAppear() {
    const params = router.getParams() as Record<string, object>;
    if (params && params['selectedMedicine']) {
      const selectedMedicine = params['selectedMedicine'] as PrescriptionItem;
      // 添加药品到列表
      this.medicines = [...this.medicines, selectedMedicine];
    }
  }


}
