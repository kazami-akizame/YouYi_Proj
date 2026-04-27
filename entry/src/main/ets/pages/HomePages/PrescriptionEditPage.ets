// pages/PrescriptionEditPage.ets
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';
import { ConsultationItem, ChatMessage } from '../common/ConsultationData';
import { UIContext } from '@ohos.arkui.UIContext';

// 处方药品项接口
interface MedicineItem {
  name: string;
  specification: string;
  dosage: string;
}

// 处方数据结构（从路由接收）
interface PrescriptionData {
  id?: string;
  patientName?: string;
  patientGender?: string;
  patientAge?: number;
  diagnosis: string;
  medicineCount: number;
  medicineList: string[];
}

interface PrescriptionEditParams {
  prescriptionJson?: string;
  item?: ConsultationItem;   // 直接接收对象（来自 MyPharmacyPage）
}

// 用于路由传递的问诊对象纯数据结构
interface ConsultationPlainData {
  id: string;
  patientName: string;
  patientGender: string;
  patientAge: number;
  type: string;
  status: string;
  description: string;
  createTime: string;
  rejectReason?: string;
  chatMessages?: ChatMessage[];   // 如果你的 ChatMessage 也需导入，请在前面 import
}


@Entry
@Component
struct PrescriptionEditPage {
  // 处方基础信息
  @State prescriptionNo: string = '2020280000';
  @State prescriptionDate: string = '2020-02-23';
  @State hospitalName: string = '*****医院处方笺';

  // 患者信息（可从路由传入或固定示例）
  @State patientName: string = '';
  @State patientAge: string = '';
  @State patientGender: string = '';

  // 诊断信息
  @State diagnosis: string = '';

  // 药品列表（解析处方数据后填充）
  @State medicineList: MedicineItem[] = [];

  // 是否保存为常用处方
  @State isSavedAsCommon: boolean = false;

  // 控制性别选择弹窗
  @State showGenderDialog: boolean = false;

  @State consultationItem: ConsultationItem | null = null;

  private uiContext: UIContext | null = null;

  aboutToAppear() {
    // 保存 UI 上下文
    this.uiContext = this.getUIContext();
    const params = router.getParams() as PrescriptionEditParams;
    if (params.item) {
      this.consultationItem = params.item;   // 直接赋值，不用 JSON.parse
    }
    if (params.prescriptionJson) {
      try {
        const data = JSON.parse(params.prescriptionJson) as PrescriptionData;
        this.diagnosis = data.diagnosis;

        // 赋值患者信息（现在接口已经定义了，不会报错）
        if (data.patientName) this.patientName = data.patientName;
        if (data.patientGender) this.patientGender = data.patientGender;
        if (data.patientAge !== undefined) this.patientAge = data.patientAge + '岁';

        // 解析药品列表
        this.medicineList = data.medicineList.map((medStr: string): MedicineItem => {
          return {
            name: medStr,
            specification: '',
            dosage: '2次/天，每次1片，温水送服'
          };
        });
      } catch (e) {
        promptAction.showToast({ message: '数据加载失败' });
      }
    }
  }

  // 删除药品
  deleteMedicine(index: number) {
    this.medicineList.splice(index, 1);
    promptAction.showToast({ message: '已删除' });
  }

  // 编辑用量
  editDosage(index: number) {
    const item = this.medicineList[index];
    router.pushUrl({
      url: 'pages/HomePages/MedicineUsagePage',
      params: {
        index: index,
        medicineName: item.name,
        dosage: item.dosage || ''
      }
    });
  }

  // 新增药品（跳转药品库选择，此处为演示）
  addMedicine() {
    router.pushUrl({
      url: 'pages/HomePages/AddComMedSDCPage'
    });
  }

  saveAsCommonPrescription() {
    // 校验必填项
    if (!this.diagnosis || this.medicineList.length === 0) {
      promptAction.showToast({ message: '请填写诊断和药品' });
      return;
    }

    // 构建常用处方模板（声明类型）
    const commonPrescription: PrescriptionData = {
      diagnosis: this.diagnosis,
      medicineCount: this.medicineList.length,
      medicineList: this.medicineList.map(item => item.name)
    };

    // 1. 创建 http 请求
    let httpRequest = http.createHttp();

    // 2. 发送 POST 请求，写入 data.json
    httpRequest.request(
      "http://127.0.0.1:8888/commonPrescriptions",
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(commonPrescription)
      },
      (err, data) => {
        if (!err) {
          promptAction.showToast({ message: '已保存到常用处方' });
        } else {
          promptAction.showToast({ message: '保存失败' });
        }
        // 销毁请求实例，释放资源
        httpRequest.destroy();
      }
    );
  }


  // 发送处方
  async sendPrescription() {
    if (!this.patientName || !this.patientGender || !this.patientAge || !this.diagnosis || this.medicineList.length === 0) {
      promptAction.showToast({ message: '信息不完整' });
      return;
    }

    // 声明纯数据对象，使用接口类型
    const itemPlain: ConsultationPlainData | null = this.consultationItem ? {
      id: this.consultationItem.id,
      patientName: this.consultationItem.patientName,
      patientGender: this.consultationItem.patientGender,
      patientAge: this.consultationItem.patientAge,
      type: this.consultationItem.type,        // 如果 type 是枚举，可能需转字符串
      status: this.consultationItem.status,    // 同理，如果不是字符串可以这里转一下
      description: this.consultationItem.description,
      createTime: this.consultationItem.createTime,
      rejectReason: this.consultationItem.rejectReason,
      chatMessages: this.consultationItem.chatMessages
    } : null;

    const prescription: PrescriptionData = {
      patientName: this.patientName,
      patientGender: this.patientGender,
      patientAge: parseInt(this.patientAge),
      diagnosis: this.diagnosis,
      medicineCount: this.medicineList.length,
      medicineList: this.medicineList.map(item => item.name)
    };
    console.log('准备发送处方:', JSON.stringify(prescription));

    try {
      let httpRequest = http.createHttp();
      // 1. 发送 HTTP 请求并等待结果
      let response = await httpRequest.request(
        "http://127.0.0.1:8888/historyPrescriptions",
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify(prescription)
        }
      );
      httpRequest.destroy();
      console.log('HTTP 响应:', JSON.stringify(response));

      // ✅ 通过 UIContext 执行 UI 操作
      if (this.uiContext) {
        const prompt = this.uiContext.getPromptAction();
        prompt.showToast({ message: '处方已发送' });

        const uiRouter = this.uiContext.getRouter();
        uiRouter.pushUrl({
          url: 'pages/HomePages/ChatPage',
          params: {
            prescriptionJson: JSON.stringify(prescription),
            item: JSON.stringify(itemPlain)
          }
        }).catch((err: Error) => {
          console.error('跳转失败', err.message);
        });
      } else {
        // 无法获取 UIContext 时的降级处理（理论上不会进这里）
        promptAction.showToast({ message: '处方已发送，但无法跳转' });
      }
    } catch (err) {
      // 同样用 UIContext 显示错误
      if (this.uiContext) {
        this.uiContext.getPromptAction().showToast({ message: '发送失败' });
      }
    }
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
              TextInput({ text: this.patientName, placeholder: '请输入患者姓名' })
                .fontSize(14)
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.patientName = value;
                })
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('患者年龄')
                .fontSize(14)
                .fontColor('#999')
                .width(80)
              TextInput({ text: this.patientAge, placeholder: '请输入年龄' })
                .fontSize(14)
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.patientAge = value;
                })
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('患者性别')
                .fontSize(14)
                .fontColor('#999')
                .width(80)
              Text(this.patientGender || '请选择')
                .fontSize(14)
                .fontColor('#007AFF')
                .layoutWeight(1)
              Image($r('app.media.right'))
                .width(8)
                .height(15)
                .fillColor('#999')
            }
            .width('100%')
            .onClick(() => {
              this.showGenderDialog = true; // 点击弹出选择框
            })
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
            TextInput({ text: this.diagnosis, placeholder: '请输入诊断' })
              .fontSize(16)
              .width('100%')
              .onChange((value: string) => {
                this.diagnosis = value;
              })
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

      // 性别选择弹窗
      if (this.showGenderDialog) {
        Column() {
          Column() {
            Text('请选择患者性别')
              .fontSize(14)
              .fontColor('#999')
              .margin({ bottom: 20 })

            Divider()
              .color('#eee')

            Text('男')
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(15)
              .onClick(() => {
                this.patientGender = '男';
                this.showGenderDialog = false;
              })

            Divider()
              .color('#eee')

            Text('女')
              .fontSize(16)
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding(15)
              .onClick(() => {
                this.patientGender = '女';
                this.showGenderDialog = false;
              })
          }
          .width('80%')
          .backgroundColor(Color.White)
          .borderRadius(12)
          .margin({ bottom: 10 })

          Button('取消')
            .width('80%')
            .height(44)
            .fontSize(16)
            .backgroundColor(Color.White)
            .fontColor('#007AFF')
            .borderRadius(12)
            .onClick(() => {
              this.showGenderDialog = false;
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('rgba(0,0,0,0.4)')
        .justifyContent(FlexAlign.Center)
        .position({ x: 0, y: 0 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')

  }
}