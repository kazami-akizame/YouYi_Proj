// pages/PrescriptionEditPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

// 处方药品项接口
interface MedicineItem {
  name: string;
  specification: string;
  dosage: string;
}

// 处方数据结构（从路由接收）
interface PrescriptionData {
  id?: string;
  diagnosis: string;
  medicineCount: number;
  medicineList: string[];
}


@Entry
@Component
struct PrescriptionEditPage {
  // 处方基础信息
  @State prescriptionNo: string = '2020280000';
  @State prescriptionDate: string = '2020-02-23';
  @State hospitalName: string = '*****医院处方笺';

  // 患者信息（可从路由传入或固定示例）
  @State patientName: string = '吴珊珊';
  @State patientAge: string = '23岁';
  @State patientGender: string = '女';

  // 诊断信息
  @State diagnosis: string = '感冒';

  // 药品列表（解析处方数据后填充）
  @State medicineList: MedicineItem[] = [];

  // 是否保存为常用处方
  @State isSavedAsCommon: boolean = false;

  aboutToAppear() {
    const params = router.getParams() as Record<string, string>;
    if (params && params.prescriptionJson) {
      try {
        const data = JSON.parse(params.prescriptionJson) as PrescriptionData;
        this.diagnosis = data.diagnosis;
        // 将原始药品字符串解析为带用法用量的结构（此处生成默认用量）
        this.medicineList = data.medicineList.map(medStr => {
          // medStr 格式如："板蓝根颗粒10包/盒 *1盒"
          const item: MedicineItem = {
            name: medStr,
            specification: '',
            dosage: '2次/天，每次1片，温水送服'
          };
          return item;
        });
      } catch (e) {
        promptAction.showToast({ message: '数据加载失败' });
        router.back();
      }
    } else {
      // 默认示例数据（无参数时显示示例）
      this.medicineList = [
        { name: '钙铁锌咀嚼片*1', specification: '', dosage: '2次/天，每次1片，温水送服' }
      ];
    }
  }

  // 删除药品
  deleteMedicine(index: number) {
    this.medicineList.splice(index, 1);
    promptAction.showToast({ message: '已删除' });
  }

  // 编辑用量（示例弹出编辑框，可扩展为弹窗页面）
  editDosage(index: number) {
    const item = this.medicineList[index];
    promptAction.showToast({ message: `编辑用量：${item.name}` });
    // 此处可跳转到用量编辑页或使用自定义弹窗
  }

  // 新增药品（跳转药品库选择，此处为演示）
  addMedicine() {
    promptAction.showToast({ message: '新增药品功能演示' });
    // 实际业务应跳转到药品搜索页，选择后返回
  }

  saveAsCommonPrescription() {
    // 构建要保存的处方数据
    const commonPrescription: PrescriptionData = {
      id: this.prescriptionNo,
      diagnosis: this.diagnosis,
      medicineCount: this.medicineList.length,
      medicineList: this.medicineList.map(item => item.name)
    };

    // 模拟保存到常用处方列表（这里直接更新MyPrescriptionPage里的列表）
    // 实际项目中，你应该把这个列表存到AppStorage或全局状态里
    const commonPrescriptions = AppStorage.Get<PrescriptionData[]>('commonPrescriptions') || [];
    // 去重：如果已经存在就不再添加
    const isExist = commonPrescriptions.some(p => p.id === commonPrescription.id);
    if (!isExist) {
      commonPrescriptions.push(commonPrescription);
      AppStorage.SetOrCreate<PrescriptionData[]>('commonPrescriptions', commonPrescriptions);
      this.isSavedAsCommon = true;
      promptAction.showToast({ message: '已保存为常用处方' });
    } else {
      promptAction.showToast({ message: '该处方已在常用列表中' });
    }
  }


  // 发送处方
  sendPrescription() {
    // 使用接口类型声明对象
    const prescription: PrescriptionData = {
      id: this.prescriptionNo,
      diagnosis: this.diagnosis,
      medicineCount: this.medicineList.length,
      medicineList: this.medicineList.map(item => item.name)
    };
    router.back({
      url: 'pages/ChatPage',
      params: { prescriptionJson: JSON.stringify(prescription) }
    });
    promptAction.showToast({ message: '处方已发送' });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r("app.media.left"))
          .width(14)
          .onClick(() => router.back())
        Text('开立处方')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('保存为常用')
          .fontSize(16)
          .fontColor('#007AFF')
          .onClick(() => this.saveAsCommonPrescription())
      }
      .width('100%')
      .height(56)
      .padding({ left: 20, right: 16 })
      .backgroundColor('#FFFFFF')

      // 可滚动内容区域
      Scroll() {
        Column() {
          // 处方头部信息
          Column() {
            Row() {
              Text(`NO:${this.prescriptionNo}`)
                .fontSize(14)
                .fontColor('#333')
              Blank()
              Text(this.prescriptionDate)
                .fontSize(14)
                .fontColor('#333')
            }
            .width('100%')
            .margin({ bottom: 8 })

            Text(this.hospitalName)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#000')
              .width('100%')
              .textAlign(TextAlign.Center)
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16, top: 16, bottom: 12 })

          // 患者信息卡片
          Column() {
            Row() {
              Text('患者姓名')
                .fontSize(14)
                .fontColor('#999')
                .width(80)
              Text(this.patientName)
                .fontSize(14)
                .fontColor('#333')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('患者年龄')
                .fontSize(14)
                .fontColor('#999')
                .width(80)
              Text(this.patientAge)
                .fontSize(14)
                .fontColor('#333')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('患者性别')
                .fontSize(14)
                .fontColor('#999')
                .width(80)
              Text(this.patientGender)
                .fontSize(14)
                .fontColor('#333')
                .layoutWeight(1)
            }
            .width('100%')
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 12 })

          // 诊断卡片
          Column() {
            Text('诊断')
              .fontSize(14)
              .fontColor('#999')
              .width('100%')
              .margin({ bottom: 8 })
            Text(this.diagnosis)
              .fontSize(16)
              .fontColor('#333')
              .width('100%')
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 12 })

          // 药品列表卡片
          Column() {
            Text('Rp')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .width('100%')
              .margin({ bottom: 16 })

            ForEach(this.medicineList, (item: MedicineItem, index: number) => {
              Column() {
                // 药品名称
                Text(item.name)
                  .fontSize(16)
                  .fontColor('#333')
                  .width('100%')
                  .margin({ bottom: 8 })

                // 用法用量
                Text(`用法用量：${item.dosage}`)
                  .fontSize(14)
                  .fontColor('#999')
                  .width('100%')
                  .margin({ bottom: 12 })

                // 操作按钮行
                Row() {
                  Button('删除')
                    .fontSize(13)
                    .fontColor('#F44336')
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#F44336', radius: 16 })
                    .padding({ left: 12, right: 12, top: 4, bottom: 4 })
                    .onClick(() => this.deleteMedicine(index))
                  Blank()
                  Button('编辑用量')
                    .fontSize(13)
                    .fontColor('#007AFF')
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#007AFF', radius: 16 })
                    .padding({ left: 12, right: 12, top: 4, bottom: 4 })
                    .onClick(() => this.editDosage(index))
                }
                .width('100%')
              }
              .width('100%')
              .margin({ bottom: 20 })
            })

            // 新增药品按钮
            Button('+新增药品')
              .width('100%')
              .height(44)
              .fontSize(15)
              .fontColor('#007AFF')
              .backgroundColor('#F0F8FF')
              .border({ width: 1, color: '#007AFF', style: BorderStyle.Dashed, radius: 8 })
              .onClick(() => this.addMedicine())
          }
          .width('90%')
          .padding(20)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ left: 16, right: 16, bottom: 20 })
        }
        .width('100%')
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
      .scrollBar(BarState.Off)

      // 底部发送按钮
      Button('发送处方')
        .width('90%')
        .height(50)
        .fontSize(16)
        .backgroundColor('#007AFF')
        .borderRadius(25)
        .margin({ bottom: 20 })
        .onClick(() => this.sendPrescription())
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}