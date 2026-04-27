/*import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';

export class Medicine {
  id: number = 0;
  name: string = '';
  spec: string = '';
  company: string = '';
  price: number = 0;
  imageUrl?: Resource = undefined;
}

export class UsageData {
  medicine: Medicine = new Medicine();
  count: number = 1;
  frequency: string = '';
  singleDose: string = '';
  usageMethod: string = '';
  remark: string = '';
}

 let tempUsageData: UsageData | null = null;

@Entry
@Component
struct MedicineUsagePage {
  @State medicine: Medicine = new Medicine();
  @State medicineCount: number = 1;
  @State frequency: string = '';
  @State singleDose: string = '';
  @State usageMethod: string = '';
  @State remark: string = '';

  aboutToAppear() {
    try {
      const params = router.getParams() as Record<string, Medicine>;
      if (params?.medicine) {
        let m = params.medicine as Medicine;
        this.medicine.id = m.id;
        this.medicine.name = m.name;
        this.medicine.spec = m.spec;
        this.medicine.company = m.company;
        this.medicine.price = m.price;
        this.medicine.imageUrl = $r('app.media.u1107');
      }
    } catch (err) {
      console.error('getParams err:', (err as BusinessError).message);
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .onClick(() => {
            router.back();
          })

        Text('用法用量')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row().width(24)
      }
      .width('100%')
      .height(46)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      Row() {
        Image(this.medicine.imageUrl || $r('app.media.u1107'))
          .width(80)
          .height(80)
          .backgroundColor('#E8F3FF')
          .borderRadius(8)
          .margin({ right: 12 })

        Column() {
          Text(`${this.medicine.name} ${this.medicine.spec}`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .margin({ bottom: 8 })

          Text(this.medicine.company)
            .fontSize(14)
            .fontColor('#999999')
            .width('100%')
            .margin({ bottom: 8 })

          Text(`¥ ${this.medicine.price.toFixed(2)}`)
            .fontSize(18)
            .fontColor('#FF3B30')
            .fontWeight(FontWeight.Bold)
            .width('100%')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)

      Divider().width('100%').height(10).color('#F5F5F5')

      Column() {
        Row() {
          Text('药品数量').fontSize(16).fontColor('#333333')
          Blank()
          Button('-')
            .width(44).height(44).backgroundColor('#F0F5FF').fontColor('#007AFF').borderRadius(22)
            .fontSize(24)
            .onClick(() => {
              if (this.medicineCount > 1) this.medicineCount--;
            })
          Text(this.medicineCount.toString()).fontSize(16).width(40).textAlign(TextAlign.Center)
          Button('+')
            .width(44).height(44).backgroundColor('#F0F5FF').fontColor('#007AFF').borderRadius(22)
            .fontSize(24)
            .onClick(() => {
              this.medicineCount++;
            })
          Text('盒')
            .fontSize(16).padding({ left: 16, right: 16 }).backgroundColor('#E8F3FF').borderRadius(8).height(36).margin({ left: 12 })
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Row() {
          Text('用药频率').fontSize(16).fontColor('#333333')
          Blank()
          TextInput({ placeholder: '请输入', text: this.frequency })
            .width(180).height(40).fontSize(16).textAlign(TextAlign.End)
            .backgroundColor('#F5F5F5').borderRadius(8)
            .onChange((value) => {
              this.frequency = value;
            })
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Row() {
          Text('单次用量').fontSize(16).fontColor('#333333')
          Blank()
          TextInput({ placeholder: '请输入', text: this.singleDose })
            .width(100).height(40).fontSize(16).textAlign(TextAlign.Center)
            .backgroundColor('#F5F5F5').borderRadius(8)
            .onChange((value) => {
              this.singleDose = value;
            })
          Text('片/次')
            .fontSize(16).padding({ left: 16, right: 16 }).backgroundColor('#E8F3FF').borderRadius(8).height(40)
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Row() {
          Text('用药方法').fontSize(16).fontColor('#333333')
          Blank()
          TextInput({ placeholder: '请输入', text: this.usageMethod })
            .width(180).height(40).fontSize(16).textAlign(TextAlign.End)
            .backgroundColor('#F5F5F5').borderRadius(8)
            .onChange((value) => {
              this.usageMethod = value;
            })
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Column() {
          Text('备注').fontSize(16).fontColor('#333333').width('100%').margin({ bottom: 8 })
          TextArea({ placeholder: '请填写药品备注', text: this.remark })
            .width('100%').height(80).fontSize(16).backgroundColor(Color.Transparent)
            .onChange((value) => {
              this.remark = value;
            })
        }
        .width('100%').padding(16)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .layoutWeight(1)

      Button('保存')
        .width('90%').height(50).fontSize(18).backgroundColor('#007AFF').borderRadius(25).margin({ top: 20, bottom: 10 })
        .onClick(() => {
          if (!this.frequency || !this.singleDose || !this.usageMethod) {
            promptAction.showToast({ message: '请完善必填信息', duration: 2000 });
            return;
          }

          let data = new UsageData();
          data.medicine = this.medicine;
          data.count = this.medicineCount;
          data.frequency = this.frequency;
          data.singleDose = this.singleDose;
          data.usageMethod = this.usageMethod;
          data.remark = this.remark;

          promptAction.showDialog({
            title: '请选择返回方式',
            buttons: [
              { text: '返回处方开立页面', color: '#007AFF' },
              { text: '返回新增常用处方页面', color: '#007AFF' },
              //{ text: '返回', color: '#007AFF' },
              { text: '取消', color: '#999999' }
            ]
          }).then((result) => {
            if (result.index === 0) {
              router.pushUrl({ url: 'pages/HomePages/MedicineListPage' });
            }
            if (result.index === 1 ) {
              tempUsageData = data;
              router.back();
            }
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
// 导出 getter/setter，而不是直接导出变量，这样 EditComPrePage 就能读写了
export function getTempUsageData(): UsageData | null {
  return tempUsageData;
}

export function clearTempUsageData(): void {
  tempUsageData = null;
}*/


import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';

export class Medicine {
  id: number = 0;
  name: string = '';
  spec: string = '';
  company: string = '';
  price: number = 0;
  imageUrl?: Resource = undefined;
}

export class UsageData {
  medicine: Medicine = new Medicine();
  count: number = 1;
  frequency: string = '';
  singleDose: string = '';
  usageMethod: string = '';
  remark: string = '';
}

// 路由参数接口
class PageParams {
  editData?: string;
  editIndex?: number;
  medicine?: Medicine;
}

// 加在文件最上面
interface DialogResult {
  index: number;
}

let tempUsageData: UsageData | null = null;

@Entry
@Component
struct MedicineUsagePage {
  @State medicine: Medicine = new Medicine();
  @State medicineCount: number = 1;
  @State frequency: string = '';
  @State singleDose: string = '';
  @State usageMethod: string = '';
  @State remark: string = '';

  @State isEditMode: boolean = false;
  @State editIndex: number = -1;

  aboutToAppear() {
    try {
      const params = router.getParams() as PageParams;

      if (params && params.editData) {
        const editDataStr: string = params.editData as string;
        const editData: UsageData = JSON.parse(editDataStr);
        const editIndex: number = params.editIndex !== undefined ? params.editIndex : -1;

        // 不传id，只传药品名称和规格
        this.medicine.name = editData.medicine.name;
        this.medicine.spec = editData.medicine.spec;
        this.medicineCount = editData.count;
        this.frequency = editData.frequency;
        this.singleDose = editData.singleDose;
        this.usageMethod = editData.usageMethod;
        this.remark = editData.remark;

        this.editIndex = editIndex;
        this.isEditMode = true;
      } else if (params && params.medicine) {
        let m: Medicine = params.medicine;
        this.medicine.id = m.id;
        this.medicine.name = m.name;
        this.medicine.spec = m.spec;
        this.medicine.company = m.company;
        this.medicine.price = m.price;
        this.medicine.imageUrl = $r('app.media.u1107');
      }
    } catch (err) {
      console.error('getParams err:', (err as BusinessError).message);
    }
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(10)
          .height(15)
          .onClick(() => {
            router.back();
          })

        Text('用法用量')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row().width(24)
      }
      .width('100%')
      .height(46)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      Row() {
        Image(this.medicine.imageUrl || $r('app.media.u1107'))
          .width(80)
          .height(80)
          .backgroundColor('#E8F3FF')
          .borderRadius(8)
          .margin({ right: 12 })

        Column() {
          Text(`${this.medicine.name} ${this.medicine.spec}`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .margin({ bottom: 8 })

          Text(this.medicine.company)
            .fontSize(14)
            .fontColor('#999999')
            .width('100%')
            .margin({ bottom: 8 })

          Text(`¥ ${this.medicine.price.toFixed(2)}`)
            .fontSize(18)
            .fontColor('#FF3B30')
            .fontWeight(FontWeight.Bold)
            .width('100%')
        }
        .layoutWeight(1)
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White)

      Divider().width('100%').height(10).color('#F5F5F5')

      Column() {
        Row() {
          Text('药品数量').fontSize(16).fontColor('#333333')
          Blank()
          Button('-')
            .width(44).height(44).backgroundColor('#F0F5FF').fontColor('#007AFF').borderRadius(22)
            .fontSize(24)
            .onClick(() => {
              if (this.medicineCount > 1) this.medicineCount--;
            })
          Text(this.medicineCount.toString()).fontSize(16).width(40).textAlign(TextAlign.Center)
          Button('+')
            .width(44).height(44).backgroundColor('#F0F5FF').fontColor('#007AFF').borderRadius(22)
            .fontSize(24)
            .onClick(() => {
              this.medicineCount++;
            })
          Text('盒')
            .fontSize(16).padding({ left: 16, right: 16 }).backgroundColor('#E8F3FF').borderRadius(8).height(36).margin({ left: 12 })
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Row() {
          Text('用药频率').fontSize(16).fontColor('#333333')
          Blank()
          TextInput({ placeholder: '请输入', text: this.frequency })
            .width(180).height(40).fontSize(16).textAlign(TextAlign.End)
            .backgroundColor('#F5F5F5').borderRadius(8)
            .onChange((value: string) => {
              this.frequency = value;
            })
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Row() {
          Text('单次用量').fontSize(16).fontColor('#333333')
          Blank()
          TextInput({ placeholder: '请输入', text: this.singleDose })
            .width(100).height(40).fontSize(16).textAlign(TextAlign.Center)
            .backgroundColor('#F5F5F5').borderRadius(8)
            .onChange((value: string) => {
              this.singleDose = value;
            })
          Text('片/次')
            .fontSize(16).padding({ left: 16, right: 16 }).backgroundColor('#E8F3FF').borderRadius(8).height(40)
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Row() {
          Text('用药方法').fontSize(16).fontColor('#333333')
          Blank()
          TextInput({ placeholder: '请输入', text: this.usageMethod })
            .width(180).height(40).fontSize(16).textAlign(TextAlign.End)
            .backgroundColor('#F5F5F5').borderRadius(8)
            .onChange((value: string) => {
              this.usageMethod = value;
            })
        }
        .width('100%').height(60).padding({ left: 16, right: 16 }).alignItems(VerticalAlign.Center)

        Divider().width('100%').color('#EEEEEE')

        Column() {
          Text('备注').fontSize(16).fontColor('#333333').width('100%').margin({ bottom: 8 })
          TextArea({ placeholder: '请填写药品备注', text: this.remark })
            .width('100%').height(80).fontSize(16).backgroundColor(Color.Transparent)
            .onChange((value: string) => {
              this.remark = value;
            })
        }
        .width('100%').padding(16)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .layoutWeight(1)

      Button('保存')
        .width('90%').height(50).fontSize(18).backgroundColor('#007AFF').borderRadius(25).margin({ top: 20, bottom: 10 })
        .onClick(() => {
          if (!this.frequency || !this.singleDose || !this.usageMethod) {
            promptAction.showToast({ message: '请完善必填信息', duration: 2000 });
            return;
          }

          let data: UsageData = new UsageData();
          data.medicine.name = this.medicine.name;
          data.medicine.spec = this.medicine.spec;
          data.count = this.medicineCount;
          data.frequency = this.frequency;
          data.singleDose = this.singleDose;
          data.usageMethod = this.usageMethod;
          data.remark = this.remark;

          if (this.isEditMode) {
            router.back({
              url: 'pages/HomePages/EditComPrePage',
              params: {
                editedData: JSON.stringify(data),
                editIndex: this.editIndex
              }
            });
          } else {
            promptAction.showDialog({
              title: '请选择返回方式',
              buttons: [
                { text: '返回处方开立页面', color: '#007AFF' },
                { text: '返回新增常用处方页面', color: '#007AFF' },
                { text: '取消', color: '#999999' }
              ]
            }).then((result:  DialogResult) => {
              if (result.index === 0) {
                router.pushUrl({ url: 'pages/HomePages/MedicineListPage' });
              }
              if (result.index === 1) {
                tempUsageData = data;
                router.back();
              }
            });
          }
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

export function getTempUsageData(): UsageData | null {
  return tempUsageData;
}

export function clearTempUsageData(): void {
  tempUsageData = null;
}