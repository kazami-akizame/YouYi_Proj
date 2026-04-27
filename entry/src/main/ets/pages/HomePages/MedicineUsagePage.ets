import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';

interface Medicine {
  id: number;
  name: string;
  spec: string;
  company: string;
  price: number;
}

interface Prescription {
  id?: number;
  medicineId: number;
  quantity: number; // ✅ 改为 quantity
  frequency: string;
  singleDose: string;
  usageMethod: string;
  remark: string;
}

@Entry
@Component
struct MedicineUsagePage {
  @State medicineList: Medicine[] = [];
  @State selectedIndex: number = 0;

  @State quantity: number = 1; // ✅ 改为 quantity
  @State frequency: string = '';
  @State singleDose: string = '';
  @State usageMethod: string = '';
  @State remark: string = '';

  private baseUrl: string = 'http://127.0.0.1:8888';

  aboutToAppear() {
    this.loadMedicineList();
  }

  loadMedicineList(): void {
    const req = http.createHttp();
    req.request(this.baseUrl + '/medicineslist', {
      method: http.RequestMethod.GET
    }).then((res: http.HttpResponse) => {
      if (res.responseCode === 200) {
        this.medicineList = JSON.parse(res.result as string);
      }
    }).catch(() => {});
  }

  // 保存到 prescriptions 接口
  saveUsage(): void {
    if (this.medicineList.length === 0) return;

    const med = this.medicineList[this.selectedIndex];
    const data: Prescription = {
      medicineId: med.id,
      quantity: this.quantity, // ✅ 改为 quantity
      frequency: this.frequency,
      singleDose: this.singleDose,
      usageMethod: this.usageMethod,
      remark: this.remark
    };

    const req = http.createHttp();
    req.request(this.baseUrl + '/prescriptions', {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(data)
    }).then(() => {
      promptAction.showToast({ message: '保存成功' });
    }).catch(() => {
      promptAction.showToast({ message: '保存失败' });
    });
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Image($r('app.media.u695'))
          .width(18)
          .height(18)
          .onClick(() => { router.back(); })

        Text('用法用量')
          .fontSize(19)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .height(52)
      .padding({ left: 20, right: 20 })
      .backgroundColor(Color.White)
      .shadow({ radius: 6, color: '#00000010', offsetY: 2 })

      // 药品选择栏
      Row() {
        if (this.medicineList.length > 0) {
          Text(this.medicineList[this.selectedIndex].name + " " + this.medicineList[this.selectedIndex].spec)
            .fontSize(16)
            .fontColor('#333')
        } else {
          Text("加载中...")
            .fontSize(16)
            .fontColor('#999')
        }
      }
      .width('92%')
      .height(50)
      .margin({ top: 12 })
      .backgroundColor(Color.White)
      .borderRadius(12)
      .padding({ left: 18, right: 18 })
      .onClick(() => {
        if (this.medicineList.length > 0) {
          this.selectedIndex = (this.selectedIndex + 1) % this.medicineList.length;
        }
      })

      // 药品信息卡片
      if (this.medicineList.length > 0) {
        Row() {
          Image($r('app.media.u1107'))
            .width(86)
            .height(86)
            .backgroundColor('#E8F3FF')
            .borderRadius(12)
          Column() {
            Text(this.medicineList[this.selectedIndex].name)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#222')
            Text(this.medicineList[this.selectedIndex].company)
              .fontSize(14)
              .fontColor('#999999')
              .margin({ top: 6 })
            Text('¥ ' + this.medicineList[this.selectedIndex].price.toFixed(2))
              .fontColor('#FF3B30')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 8 })
          }
          .margin({ left: 14 })
          .alignItems(HorizontalAlign.Start)
        }
        .width('92%')
        .padding(18)
        .margin({ top: 12 })
        .backgroundColor(Color.White)
        .borderRadius(12)
        .shadow({ radius: 6, color: '#00000010', offsetY: 2 })
      }

      // 表单卡片容器
      Column() {
        // 药品数量
        Row() {
          Text('药品数量')
            .fontSize(16)
            .fontColor('#333')
          Blank()
          Button('—')
            .width(38)
            .height(38)
            .borderRadius(19)
            .backgroundColor('#F0F5FF')
            .fontColor('#007AFF')
            .onClick(() => {
              if (this.quantity > 1) { // ✅ 改为 quantity
                this.quantity--;
              }
            })
          Text(this.quantity.toString()) // ✅ 改为 quantity
            .width(40)
            .textAlign(TextAlign.Center)
            .fontSize(16)
          Button('+')
            .width(38)
            .height(38)
            .borderRadius(19)
            .backgroundColor('#F0F5FF')
            .fontColor('#007AFF')
            .onClick(() => {
              this.quantity++; // ✅ 改为 quantity
            })
          Text('盒')
            .backgroundColor('#E8F3FF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(8)
            .fontSize(15)
            .fontColor('#333')
            .margin({ left: 8 })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })

        Divider().margin({ left: 16, right: 16 }).color('#f2f2f2')

        // 用药频率
        Row() {
          Text('用药频率')
            .fontSize(16)
            .fontColor('#333')
          Blank()
          TextInput({ text: this.frequency, placeholder: '请输入' })
            .width(170)
            .height(38)
            .backgroundColor('#F5F7FA')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .onChange((v: string) => { this.frequency = v; })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })

        Divider().margin({ left: 16, right: 16 }).color('#f2f2f2')

        // 单次用量
        Row() {
          Text('单次用量')
            .fontSize(16)
            .fontColor('#333')
          Blank()
          TextInput({ text: this.singleDose, placeholder: '请输入' })
            .width(90)
            .height(38)
            .backgroundColor('#F5F7FA')
            .borderRadius(8)
            .textAlign(TextAlign.Center)
            .onChange((v: string) => { this.singleDose = v; })
          Text('片/次')
            .backgroundColor('#E8F3FF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .borderRadius(8)
            .fontSize(15)
            .margin({ left: 8 })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })

        Divider().margin({ left: 16, right: 16 }).color('#f2f2f2')

        // 用药方法
        Row() {
          Text('用药方法')
            .fontSize(16)
            .fontColor('#333')
          Blank()
          TextInput({ text: this.usageMethod, placeholder: '请输入' })
            .width(170)
            .height(38)
            .backgroundColor('#F5F7FA')
            .borderRadius(8)
            .padding({ left: 10, right: 10 })
            .onChange((v: string) => { this.usageMethod = v; })
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
      }
      .width('92%')
      .backgroundColor(Color.White)
      .borderRadius(12)
      .margin({ top: 12 })
      .shadow({ radius: 6, color: '#00000010', offsetY: 2 })

      // 备注
      Column() {
        Text('备注')
          .fontSize(16)
          .fontColor('#333')
          .width('100%')
          .margin({ bottom: 8 })
        TextArea({ text: this.remark, placeholder: '请填写备注' })
          .height(88)
          .width('100%')
          .backgroundColor('#F5F7FA')
          .borderRadius(10)
          .padding(12)
          .onChange((v: string) => { this.remark = v; })
      }
      .width('92%')
      .padding(16)
      .margin({ top: 12 })
      .backgroundColor(Color.White)
      .borderRadius(12)
      .shadow({ radius: 6, color: '#00000010', offsetY: 2 })
      .layoutWeight(1)

      // 保存按钮
      Button('保存')
        .width('86%')
        .height(52)
        .fontSize(18)
        .backgroundColor('#007AFF')
        .borderRadius(26)
        .margin({ top: 24, bottom: 20 })
        .shadow({ radius: 8, color: '#007AFF30', offsetY: 4 })
        .onClick(() => {
          if (!this.frequency || !this.singleDose || !this.usageMethod) {
            promptAction.showToast({ message: '请完善必填信息', duration: 2000 });
            return;
          }

          this.saveUsage();

          promptAction.showDialog({
            title: '请选择返回方式',
            buttons: [
              { text: '返回处方开立页面', color: '#007AFF' },
              { text: '返回新增常用处方页面', color: '#007AFF' },
              { text: '取消', color: '#999999' }
            ]
          }).then((result) => {
            if (result.index === 0) router.pushUrl({ url: 'pages/HomePages/PrescriptionEditPage' });
            if (result.index === 1) router.pushUrl({ url: 'pages/HomePages/EditComPrePage' });
          });
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F7FA')
  }
}