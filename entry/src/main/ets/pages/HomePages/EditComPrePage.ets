/*import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { PrescriptionMedicine, Prescription, MedicineApiService } from './MedicineApiService';
import { getTempUsageData, clearTempUsageData, UsageData } from './MedicineUsagePage';

// ✅ 定义显式接口
interface SavedMedicine {
  name: string;
  specification: string;
  quantity: number;
  usageMethod?: string;
  frequency?: string;
  singleDose?: string;
  remark?: string;
}

interface RouteParams {
  prescription?: Prescription;
}

@Entry
@Component
struct EditComPrePage {
  @State diagnosis: string = '';
  @State medicineList: PrescriptionMedicine[] = [];
  private isEditMode: boolean = false;
  private editingPrescriptionId: string = '';

  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    console.log('EditComPrePage aboutToAppear 收到参数:', JSON.stringify(params));

    if (params && params.prescription) {
      const prescription = params.prescription;
      this.isEditMode = true;
      this.editingPrescriptionId = prescription.id;
      this.diagnosis = prescription.clinicalDiagnosis;

      const loadedMedicines: PrescriptionMedicine[] = [];
      for (let i = 0; i < prescription.medicines.length; i++) {
        const med = prescription.medicines[i];
        const prescriptionMed: PrescriptionMedicine = {
          id: Date.now().toString(),
          name: med.name,
          specification: med.specification,
          quantity: med.quantity,
          usageMethod: med.usageMethod || '',
          frequency: med.frequency || '',
          singleDose: med.singleDose || '',
          remark: med.remark || ''
        };
        loadedMedicines.push(prescriptionMed);
      }
      this.medicineList = loadedMedicines;

      console.log('编辑模式加载处方数据，药品数量:', this.medicineList.length);
      promptAction.showToast({ message: '进入编辑模式' });
    }
  }

  onPageShow() {
    const data = getTempUsageData();
    if (data) {
      const med: PrescriptionMedicine = {
        id: Date.now().toString(),
        name: data.medicine.name,
        specification: data.medicine.spec,
        quantity: data.count,
        usageMethod: data.usageMethod,
        frequency: data.frequency,
        singleDose: data.singleDose,
        remark: data.remark
      };

      const exist = this.medicineList.some(item => item.name === med.name);
      if (!exist) {
        this.medicineList.push(med);
        promptAction.showToast({ message: `添加成功：${med.name}` });
      } else {
        promptAction.showToast({ message: `${med.name} 已存在` });
      }
      clearTempUsageData();
    }
  }

  deleteMedicine(name: string) {
    this.medicineList = this.medicineList.filter(item => item.name !== name);
  }

  async savePrescription() {
    if (!this.diagnosis) {
      promptAction.showToast({ message: "请输入诊断" });
      return;
    }
    if (this.medicineList.length === 0) {
      promptAction.showToast({ message: "请先添加药品" });
      return;
    }

    if (this.isEditMode) {
      const deleteSuccess = await MedicineApiService.deleteCommonPrescription(this.editingPrescriptionId);
      if (!deleteSuccess) {
        promptAction.showToast({ message: "更新失败" });
        return;
      }
    }

    // ✅ 使用显式接口类型
    const savedMedicines: SavedMedicine[] = [];
    for (let i = 0; i < this.medicineList.length; i++) {
      const med = this.medicineList[i];
      const savedMed: SavedMedicine = {
        name: med.name,
        specification: med.specification,
        quantity: med.quantity,
        usageMethod: med.usageMethod,
        frequency: med.frequency,
        singleDose: med.singleDose,
        remark: med.remark
      };
      savedMedicines.push(savedMed);
    }

    const newPrescription: Prescription = {
      id: Date.now().toString(),
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: this.diagnosis,
      medicineCount: this.medicineList.length,
      medicines: savedMedicines,
      createDate: new Date().toLocaleDateString(),
      isCommon: true
    };

    const success = await MedicineApiService.addCommonPrescription(newPrescription);

    if (success) {
      promptAction.showToast({ message: this.isEditMode ? "更新成功" : "保存成功" });
      this.isEditMode = false;
      this.medicineList = [];
      router.back();
    } else {
      promptAction.showToast({ message: "保存失败" });
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();
          })

        Text(this.isEditMode ? '编辑常用处方' : '常用处方')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      Divider().height(1).color('#ddd')

      Column() {
        Text("诊断").fontSize(16).fontColor('#333').margin({ bottom: 8 }).width('100%')
        TextInput({ placeholder: "请输入诊断", text: this.diagnosis })
          .onChange((v) => {
            this.diagnosis = v;
          })
      }
      .width('90%').padding(16).backgroundColor('#fff').borderRadius(12).margin(16)

      if (this.medicineList.length > 0) {
        List() {
          ForEach(this.medicineList, (item: PrescriptionMedicine) => {
            ListItem() {
              Column() {
                Text(`Rp`).fontSize(20).fontWeight(FontWeight.Bold).margin({ bottom: 16 })
                Text(`${item.name}`).fontSize(17).margin({ bottom: 8 })
                Text(`规格：${item.specification}`).fontSize(14).fontColor('#999')
                Text(`数量：${item.quantity}盒`).fontSize(14).fontColor('#999')
                Text(`用法：${item.usageMethod} | ${item.frequency} | ${item.singleDose}片/次`).fontSize(14).fontColor('#999')
                if (item.remark) {
                  Text(`备注：${item.remark}`).fontColor('#666')
                }

                Row() {
                  Button('删除')
                    .fontSize(14).fontColor('#999').backgroundColor('#fff')
                    .border({ width: 1, color: '#ddd' }).borderRadius(16)
                    .width(70).height(32)
                    .onClick(() => {
                      this.deleteMedicine(item.name);
                    })

                  Button('编辑用量')
                    .fontSize(14).fontColor('#3677F2').backgroundColor('#fff')
                    .border({ width: 1, color: '#3677F2' }).borderRadius(16)
                    .width(90).height(32).margin({ left: 12 })
                }
                .width('100%')
                .justifyContent(FlexAlign.End)
              }
              .width('100%').padding(16).backgroundColor('#fff').borderRadius(12).alignItems(HorizontalAlign.Start)
            }
            .margin({ bottom: 10 })
          })
        }.layoutWeight(1).padding({ left: 16, right: 16 })
      } else {
        Column() {
          Text("暂无药品，请先从药品列表添加")
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      }

      Button('+ 新增药品')
        .width('90%').height(44).fontSize(16).fontColor('#3677F2').backgroundColor('#fff')
        .border({ width: 1, color: '#3677F2' }).borderRadius(22).margin({ bottom: 12 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/ACPSDCPPage' });
        })

      Button(this.isEditMode ? "更新处方" : "保存到我的药房")
        .width('90%').height(48).backgroundColor('#3677F2')
        .onClick(() => {
          this.savePrescription();
        })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').backgroundColor('#f5f5f5')
  }
}*/




import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { PrescriptionMedicine, Prescription, MedicineApiService } from './MedicineApiService';
import { getTempUsageData, clearTempUsageData, UsageData, Medicine } from './MedicineUsagePage';

// ✅ 定义显式接口
interface SavedMedicine {
  name: string;
  specification: string;
  quantity: number;
  usageMethod?: string;
  frequency?: string;
  singleDose?: string;
  remark?: string;
}

interface RouteParams {
  prescription?: Prescription;
}

// 添加编辑数据接口
interface EditDataParams {
  editedData?: string;
  editIndex?: number;
}

@Entry
@Component
struct EditComPrePage {
  @State diagnosis: string = '';
  @State medicineList: PrescriptionMedicine[] = [];
  private isEditMode: boolean = false;
  private editingPrescriptionId: string = '';

  aboutToAppear() {
    const params = router.getParams() as RouteParams;
    console.log('EditComPrePage aboutToAppear 收到参数:', JSON.stringify(params));

    if (params && params.prescription) {
      const prescription = params.prescription;
      this.isEditMode = true;
      this.editingPrescriptionId = prescription.id;
      this.diagnosis = prescription.clinicalDiagnosis;

      const loadedMedicines: PrescriptionMedicine[] = [];
      for (let i = 0; i < prescription.medicines.length; i++) {
        const med = prescription.medicines[i];
        const prescriptionMed: PrescriptionMedicine = {
          id: Date.now().toString(),
          name: med.name,
          specification: med.specification,
          quantity: med.quantity,
          usageMethod: med.usageMethod || '',
          frequency: med.frequency || '',
          singleDose: med.singleDose || '',
          remark: med.remark || ''
        };
        loadedMedicines.push(prescriptionMed);
      }
      this.medicineList = loadedMedicines;

      console.log('编辑模式加载处方数据，药品数量:', this.medicineList.length);
      promptAction.showToast({ message: '进入编辑模式' });
    }
  }

  onPageShow() {
    const data = getTempUsageData();
    if (data) {
      const med: PrescriptionMedicine = {
        id: Date.now().toString(),
        name: data.medicine.name,
        specification: data.medicine.spec,
        quantity: data.count,
        usageMethod: data.usageMethod,
        frequency: data.frequency,
        singleDose: data.singleDose,
        remark: data.remark
      };

      const exist = this.medicineList.some(item => item.name === med.name);
      if (!exist) {
        this.medicineList.push(med);
        promptAction.showToast({ message: `添加成功：${med.name}` });
      } else {
        promptAction.showToast({ message: `${med.name} 已存在` });
      }
      clearTempUsageData();
    }

    // 处理编辑药品返回
    const editParams = router.getParams() as EditDataParams;
    if (editParams && editParams.editedData) {
      try {
        const editedDataStr: string = editParams.editedData as string;
        const editedData: UsageData = JSON.parse(editedDataStr);
        const editIndex: number = editParams.editIndex !== undefined ? editParams.editIndex : -1;

        if (editIndex !== -1 && this.medicineList[editIndex]) {
          // 通过药品名称匹配来更新（不依赖id）
          this.medicineList[editIndex].quantity = editedData.count;
          this.medicineList[editIndex].usageMethod = editedData.usageMethod;
          this.medicineList[editIndex].frequency = editedData.frequency;
          this.medicineList[editIndex].singleDose = editedData.singleDose;
          this.medicineList[editIndex].remark = editedData.remark;
          this.medicineList = [...this.medicineList];
          promptAction.showToast({ message: '用量已更新' });
        }
      } catch (err) {
        console.error('解析编辑数据失败', JSON.stringify(err));
      }
    }
  }

  deleteMedicine(name: string) {
    this.medicineList = this.medicineList.filter(item => item.name !== name);
  }

  async savePrescription() {
    if (!this.diagnosis) {
      promptAction.showToast({ message: "请输入诊断" });
      return;
    }
    if (this.medicineList.length === 0) {
      promptAction.showToast({ message: "请先添加药品" });
      return;
    }

    if (this.isEditMode) {
      const deleteSuccess = await MedicineApiService.deleteCommonPrescription(this.editingPrescriptionId);
      if (!deleteSuccess) {
        promptAction.showToast({ message: "更新失败" });
        return;
      }
    }

    const savedMedicines: SavedMedicine[] = [];
    for (let i = 0; i < this.medicineList.length; i++) {
      const med = this.medicineList[i];
      const savedMed: SavedMedicine = {
        name: med.name,
        specification: med.specification,
        quantity: med.quantity,
        usageMethod: med.usageMethod,
        frequency: med.frequency,
        singleDose: med.singleDose,
        remark: med.remark
      };
      savedMedicines.push(savedMed);
    }

    const newPrescription: Prescription = {
      id: Date.now().toString(),
      patientName: '',
      patientGender: '',
      patientAge: 0,
      clinicalDiagnosis: this.diagnosis,
      medicineCount: this.medicineList.length,
      medicines: savedMedicines,
      createDate: new Date().toLocaleDateString(),
      isCommon: true
    };

    const success = await MedicineApiService.addCommonPrescription(newPrescription);

    if (success) {
      promptAction.showToast({ message: this.isEditMode ? "更新成功" : "保存成功" });
      this.isEditMode = false;
      this.medicineList = [];
      router.back();
    } else {
      promptAction.showToast({ message: "保存失败" });
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();
          })

        Text(this.isEditMode ? '编辑常用处方' : '常用处方')
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(56)
      .backgroundColor('#fff')

      Divider().height(1).color('#ddd')

      Column() {
        Text("诊断").fontSize(16).fontColor('#333').margin({ bottom: 8 }).width('100%')
        TextInput({ placeholder: "请输入诊断", text: this.diagnosis })
          .onChange((v: string) => {
            this.diagnosis = v;
          })
      }
      .width('90%').padding(16).backgroundColor('#fff').borderRadius(12).margin(16)

      if (this.medicineList.length > 0) {
        List() {
          ForEach(this.medicineList, (item: PrescriptionMedicine, index: number) => {
            ListItem() {
              Column() {
                Text(`Rp`).fontSize(20).fontWeight(FontWeight.Bold).margin({ bottom: 16 })
                Text(`${item.name}`).fontSize(17).margin({ bottom: 8 })
                Text(`规格：${item.specification}`).fontSize(14).fontColor('#999')
                Text(`数量：${item.quantity}盒`).fontSize(14).fontColor('#999')
                Text(`用法：${item.usageMethod} | ${item.frequency} | ${item.singleDose}片/次`).fontSize(14).fontColor('#999')
                if (item.remark) {
                  Text(`备注：${item.remark}`).fontColor('#666')
                }

                Row() {
                  Button('删除')
                    .fontSize(14).fontColor('#999').backgroundColor('#fff')
                    .border({ width: 1, color: '#ddd' }).borderRadius(16)
                    .width(70).height(32)
                    .onClick(() => {
                      this.deleteMedicine(item.name);
                    })

                  Button('编辑用量')
                    .fontSize(14).fontColor('#3677F2').backgroundColor('#fff')
                    .border({ width: 1, color: '#3677F2' }).borderRadius(16)
                    .width(90).height(32).margin({ left: 12 })
                    .onClick(() => {
                      // 创建用法用量数据（不传id）
                      const usageDataToEdit: UsageData = new UsageData();
                      usageDataToEdit.medicine.name = item.name;
                      usageDataToEdit.medicine.spec = item.specification;
                      usageDataToEdit.count = item.quantity;
                      usageDataToEdit.frequency = item.frequency || '';
                      usageDataToEdit.singleDose = item.singleDose || '';
                      usageDataToEdit.usageMethod = item.usageMethod || '';
                      usageDataToEdit.remark = item.remark || '';

                      router.pushUrl({
                        url: 'pages/HomePages/MedicineUsagePage',
                        params: {
                          editData: JSON.stringify(usageDataToEdit),
                          editIndex: index
                        }
                      });
                    })
                }
                .width('100%')
                .justifyContent(FlexAlign.End)
              }
              .width('100%').padding(16).backgroundColor('#fff').borderRadius(12).alignItems(HorizontalAlign.Start)
            }
            .margin({ bottom: 10 })
          })
        }.layoutWeight(1).padding({ left: 16, right: 16 })
      } else {
        Column() {
          Text("暂无药品，请先从药品列表添加")
        }.layoutWeight(1).justifyContent(FlexAlign.Center)
      }

      Button('+ 新增药品')
        .width('90%').height(44).fontSize(16).fontColor('#3677F2').backgroundColor('#fff')
        .border({ width: 1, color: '#3677F2' }).borderRadius(22).margin({ bottom: 12 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/ACPSDCPPage' });
        })

      Button(this.isEditMode ? "更新处方" : "保存到我的药房")
        .width('90%').height(48).backgroundColor('#3677F2')
        .onClick(() => {
          this.savePrescription();
        })
        .margin({ bottom: 20 })
    }
    .width('100%').height('100%').backgroundColor('#f5f5f5')
  }
}