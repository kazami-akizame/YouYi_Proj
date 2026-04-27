// pages/ChatPage.ets
import { ConsultationItem, ConsultationStatus } from '../common/ConsultationData';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

interface ChatMessage {
  isDoctor: boolean;
  content: string;
  time: string;
  isImage?: boolean;
  isPrescription?: boolean; // 标记是否为处方消息
  prescriptionData?: Prescription; // 处方数据
}

// 处方数据结构
interface Prescription {
  id: string;
  diagnosis: string;
  medicineCount: number;
  medicineList: string[];
}


// 定义接口
interface TopBarInfo {
  text: string;
  bgColor: string;
  textColor: string;
}

// 定义 ActionMenu 返回结果类型
interface ActionMenuResult {
  index: number;
}

@Entry
@Component
struct ChatPage {
  @State consultationItem: ConsultationItem | null = null;
  @State inputText: string = '';
  @State messageList: ChatMessage[] = [];
  @State previewVisible: boolean = false;
  @State previewImage: Resource | null = null;
  @State hasProcessedReject: boolean = false;
  @State showFinishDialog: boolean = false;
  private scroller: Scroller = new Scroller();

  aboutToAppear() {
    // 获取路由参数，解析 JSON 字符串
    const params = router.getParams() as Record<string, string>;
    if (params && params.itemJson) {
      try {
        const item = JSON.parse(params.itemJson) as ConsultationItem;
        this.consultationItem = item;
        this.initMessages();
      } catch (e) {
        console.error('解析参数失败', e);
      }
    }
    this.checkRejectReason(params);
    this.checkPrescriptionData(params);
  }

  // 监听页面显示（用于接收退诊页面返回的结果）
  onPageShow() {
    const params = router.getParams() as Record<string, string>;
    this.checkRejectReason(params);
    this.checkPrescriptionData(params);
  }



  initMessages() {
    if (!this.consultationItem) return;

    // 患者发的首条消息（病情描述 + 图片）
    const baseMessages: ChatMessage[] = [
      {
        isDoctor: false,
        content: `病情描述：${this.consultationItem.description}\n患病时长：一周内\n就诊情况：就诊过`,
        time: '10:10'
      },
      {
        isDoctor: false,
        content: '',
        time: '10:10',
        isImage: true
      }
    ];

    switch (this.consultationItem.status) {
      case ConsultationStatus.WAITING:
        this.messageList = baseMessages;
        break;
      case ConsultationStatus.IN_PROGRESS:
        this.messageList = [
          ...baseMessages,
          { isDoctor: true, content: '您好', time: '' },
          { isDoctor: true, content: '建议先服用药物来控制调理，看看效果怎么样？', time: '' }
        ];
        break;
      case ConsultationStatus.REJECTED:
        const rejectMsg = this.consultationItem.rejectReason
          ? `您好，退诊原因：${this.consultationItem.rejectReason}`
          : '您好，此症状不在我的诊疗范围之内，请选择对症科室进行问诊。';
        this.messageList = [
          ...baseMessages,
          { isDoctor: true, content: rejectMsg, time: this.getCurrentTime() }
        ];
        break;
      case ConsultationStatus.FINISHED:
        this.messageList = [
          ...baseMessages,
          { isDoctor: true, content: '您好', time: '' },
          { isDoctor: true, content: '建议先服用药物来控制调理，看看效果怎么样？', time: '' }
        ];
        break;
      default:
        this.messageList = baseMessages;
    }
  }

  // 顶部状态提示信息
  getTopBarInfo(): TopBarInfo {
    if (!this.consultationItem) return { text: '', bgColor: '#FFFFFF', textColor: '#333' };
    switch (this.consultationItem.status) {
      case ConsultationStatus.WAITING:
        return { text: '等待接诊中', bgColor: '#E8F5F2', textColor: '#4ECDC4' };
      case ConsultationStatus.IN_PROGRESS:
        return { text: '正在咨询中，此次咨询将在23小时45分后结束', bgColor: '#FFECEC', textColor: '#F44336' };
      case ConsultationStatus.REJECTED:
        return { text: '问诊结束', bgColor: '#F5F5F5', textColor: '#999999' };
      case ConsultationStatus.FINISHED:
        return { text: '问诊已结束', bgColor: '#F5F5F5', textColor: '#999999' };
      default:
        return { text: '', bgColor: '#FFFFFF', textColor: '#333' };
    }
  }

  getBottomTip(): string {
    if (!this.consultationItem) return '';
    switch (this.consultationItem.status) {
      case ConsultationStatus.WAITING:
        return '请在24小时内接诊，超时将自动退诊';
      case ConsultationStatus.IN_PROGRESS:
        return '问诊已开始，本次问诊可持续24小时';
      case ConsultationStatus.REJECTED:
        return '退诊成功，问诊费用已退回患者账户';
      case ConsultationStatus.FINISHED:
        return '问诊已开始，本次问诊可持续24小时';
      default:
        return '';
    }
  }

  @Builder
  MessageBubble(msg: ChatMessage) {
    if (msg.isImage) {
      Column() {
        if (msg.time) {
          Text(msg.time)
            .fontSize(12)
            .fontColor('#999')
            .margin({ bottom: 4 })
        }
        Row() {
          if (!msg.isDoctor) {
            Image($r("app.media.profile")).width(60).height(60).borderRadius(50)
          }
          // 图片消息的气泡区域
          Column() {
            Image($r("app.media.image"))
              .width(150)
              .height(120)
              .objectFit(ImageFit.Cover)
              .borderRadius(8)
              .onClick(() => {
                this.previewImage = $r("app.media.image");
                this.previewVisible = true;
              })
          }
          .padding(6)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .constraintSize({ maxWidth: '70%' })
          if (msg.isDoctor) {
            Circle({ width: 40, height: 40 })
              .fill('#81D4FA')
              .margin({ left: 8 })
          }
        }
        .width('100%')
        .justifyContent(msg.isDoctor ? FlexAlign.End : FlexAlign.Start)
      }
      .width('100%')
      .margin({ top: 8, bottom: 8 })
    }else if (msg.isPrescription) {
      // 处方消息卡片
      Column() {
        if (msg.time) {
          Text(msg.time)
            .fontSize(12)
            .fontColor('#999')
            .margin({ bottom: 4 })
        }
        Row() {
          // 卡片本体（医生消息 → 放右边）
          Column() {
            Row() {
              Image($r("app.media.Himg")).width(20).margin({ right: 6 })
              Text('电子处方')
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
              Blank()
            }
            .width('100%')
            .margin({ bottom: 12 })

            // 疾病诊断
            Row() {
              Text('疾病诊断')
                .fontSize(14)
                .fontColor('#666')
              Text(msg.prescriptionData?.diagnosis || '')
                .fontSize(14)
                .fontColor('#333')
                .margin({ left: 10 })
            }
            .width('100%')
            .margin({ bottom: 10 })

            Text('药品')
              .fontSize(14)
              .margin({ top: 4, bottom: 6 })
              .width('100%')
              .textAlign(TextAlign.Start)

            if (msg.prescriptionData?.medicineList) {
              ForEach(msg.prescriptionData.medicineList.slice(0, 2), (med: string) => {
                Text(`· ${med}`)
                  .fontSize(14)
                  .fontColor('#666')
                  .width('100%')
              })
              if (msg.prescriptionData.medicineList.length > 2) {
                Text(`...等${msg.prescriptionData.medicineList.length}种药品`)
                  .fontSize(12)
                  .fontColor('#999')
              }
            }

            Button('查看处方')
              .fontSize(14)
              .fontColor('#007AFF')
              .backgroundColor('#fff')
              .border({ width: 1, color: '#007AFF', radius: 20 })
              .padding({ left: 16, right: 16, top: 6, bottom: 6 })
              .margin({ top: 12 })
          }
          .padding(16)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .width('70%') // 固定宽度，不会超出

          // 医生头像（在卡片右边）
          Image($r("app.media.doctorProfile"))
            .width(50)
            .height(50)
            .borderRadius(50)
            .margin({ left: 8 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)
      }
      .width('100%')
      .margin({ top: 8, bottom: 8 })
    } else {
      Column() {
        if (msg.time) {
          Text(msg.time)
            .fontSize(12)
            .fontColor('#999')
            .margin({ bottom: 4 })
        }
        Row() {
          if (!msg.isDoctor) {
            // 患者头像
            Image($r("app.media.profile")).width(60).height(60).borderRadius(50)
          }
          Text(msg.content)
            .fontSize(14)
            .fontColor('#333')
            .padding(12)
            .backgroundColor(msg.isDoctor ? '#FFFFFF' : '#FFFFFF')
            .borderRadius(12)
            .constraintSize({ maxWidth: '70%' })
            .wordBreak(WordBreak.BREAK_ALL)
          if (msg.isDoctor) {
            // 医生头像
            Image($r("app.media.doctorProfile")).width(50).height(50).borderRadius(50)
          }
        }
        .width('100%')
        .justifyContent(msg.isDoctor ? FlexAlign.End : FlexAlign.Start)
      }
      .width('100%')
      .margin({ top: 8, bottom: 8 })
    }
  }

  checkRejectReason(params: Record<string, string> | undefined) {
    if (params && params.rejectReason && !this.hasProcessedReject) {
      this.hasProcessedReject = true;
      this.doRejectConsultation(params.rejectReason);
    }
  }

  // 接收处方数据，自动发送处方消息
  checkPrescriptionData(params: Record<string, string> | undefined) {
    if (params && params.prescriptionJson) {
      try {
        const prescription = JSON.parse(params.prescriptionJson) as Prescription;
        this.sendPrescriptionMessage(prescription);
        // 可选：清除路由参数中的 prescriptionJson，防止重复发送
        // router.clear() 没有直接清参数的方法，可以通过页面返回时携带标志位处理，但通常无需处理
      } catch (e) {
        console.error('解析处方数据失败', e);
      }
    }
  }


  // 新增：发送处方消息
  sendPrescriptionMessage(prescription: Prescription) {
    if (!this.consultationItem) return;
    if (this.consultationItem.status === ConsultationStatus.FINISHED ||
      this.consultationItem.status === ConsultationStatus.REJECTED) {
      promptAction.showToast({ message: '问诊已结束，无法发送处方' });
      return;
    }

    const newMsg: ChatMessage = {
      isDoctor: true,
      content: '',
      time: this.getCurrentTime(),
      isPrescription: true,
      prescriptionData: prescription
    };
    this.messageList = [...this.messageList, newMsg];
    this.scroller.scrollEdge(Edge.Bottom);
    promptAction.showToast({ message: '处方已发送' });
  }

  // 实际退诊操作
  doRejectConsultation(reason: string) {
    if (!this.consultationItem) return;
    // 更新状态和原因
    this.consultationItem.status = ConsultationStatus.REJECTED;
    this.consultationItem.rejectReason = reason;
    // 同步更新全局数据管理器（如果有）
    // consultationDataManager.updateItem(this.consultationItem);
    this.initMessages();  // 重新生成消息列表
    promptAction.showToast({ message: `已退诊，原因：${reason}` });
  }

  // 退诊按钮点击：跳转到退诊原因选择页
  rejectConsultation() {
    router.pushUrl({
      url: 'pages/RejectReasonPage'
    }).catch((err: Error) => {
      console.error(`跳转失败: ${err.message}`);
      promptAction.showToast({ message: '页面跳转失败，请检查页面配置' });
    });
  }

  // 接诊逻辑
  acceptConsultation() {
    if (!this.consultationItem) return;
    this.consultationItem.status = ConsultationStatus.IN_PROGRESS;
    this.initMessages();
    promptAction.showToast({ message: '已接诊，开始问诊' });
  }

  // 发送消息
  sendMessage() {
    if (!this.consultationItem) return;
    if (this.consultationItem.status === ConsultationStatus.FINISHED ||
      this.consultationItem.status === ConsultationStatus.REJECTED) {
      promptAction.showToast({ message: '问诊已结束，无法发送消息' });
      return;
    }
    if (!this.inputText.trim()) return;
    const newMsg: ChatMessage = {
      isDoctor: true,
      content: this.inputText,
      time: this.getCurrentTime()
    };
    this.messageList = [...this.messageList, newMsg];
    this.inputText = '';
    // 模拟患者自动回复（可选）
    setTimeout(() => {
      const autoReply: ChatMessage = {
        isDoctor: false,
        content: '收到，谢谢医生',
        time: this.getCurrentTime()
      };
      this.messageList = [...this.messageList, autoReply];
      this.scroller.scrollEdge(Edge.Bottom);
    }, 300);
    this.scroller.scrollEdge(Edge.Bottom);
  }

  getCurrentTime(): string {
    const now = new Date();
    return `${now.getHours().toString().padStart(2, '0')}:${now.getMinutes().toString().padStart(2, '0')}`;
  }

  confirmFinishConsultation() {
    if (!this.consultationItem) return;
    this.consultationItem.status = ConsultationStatus.FINISHED;
    this.initMessages();
    this.showFinishDialog = false;
    promptAction.showToast({ message: '已结束问诊' });
  }

  build() {
    Column() {
      if (!this.consultationItem) {
        // 数据未加载时显示空白
        Text('加载中...')
          .width('100%')
          .height('100%')
          .textAlign(TextAlign.Center)
      } else {
        // 顶部导航栏
        Row() {
          Image($r("app.media.left"))
            .width(14)
            .onClick(() => {
              router.back();
            })
          Blank()
          Text(this.consultationItem.patientName)
            .fontSize(17)
            .fontColor('#333')
          Blank()
          if (this.consultationItem.status === ConsultationStatus.IN_PROGRESS) {
            Text('结束问诊')
              .fontSize(15)
              .fontColor('#007AFF')
              .onClick(() => {
                this.showFinishDialog = true;
              })
          } else {
            Blank().width(34)
          }
        }
        .width('100%')
        .height(56)
        .padding({ left: 20, right: 16 })
        .backgroundColor('#FFFFFF')

        // 状态提示条
        Row() {
          Circle()
            .width(8)
            .height(8)
            .fill(this.getTopBarInfo().textColor)
            .margin({ right: 6 })
          Text(this.getTopBarInfo().text)
            .fontSize(14)
            .fontColor(this.getTopBarInfo().textColor)
        }
        .width('100%')
        .height(40)
        .backgroundColor(this.getTopBarInfo().bgColor)
        .padding({ left: 16 })
        .alignItems(VerticalAlign.Center)

        // 患者信息栏
        Row() {
          Column() {
            Text(`${this.consultationItem.patientName} ${this.consultationItem.patientGender} ${this.consultationItem.patientAge}岁`)
              .fontSize(16)
              .fontColor('#333')
          }
          .alignItems(HorizontalAlign.Start)
          .layoutWeight(1)

          Text('查看病人详情 >')
            .fontSize(14)
            .fontColor('#999')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')

        // 聊天消息列表
        List({ scroller: this.scroller }) {
          ForEach(this.messageList, (msg: ChatMessage, index: number) => {
            ListItem() {
              this.MessageBubble(msg)
            }
          }, (_msg: ChatMessage, index: number) => index.toString())

          ListItem() {
            Row() {
              Text(this.getBottomTip())
                .fontSize(13)
                .fontColor('#999')
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .padding({ top: 16, bottom: 16 })
          }
        }
        .layoutWeight(1)
        .width('100%')
        .backgroundColor('#F5F5F5')
        .edgeEffect(EdgeEffect.Spring)

        // 底部操作栏（根据状态动态显示）
        if (this.consultationItem.status === ConsultationStatus.WAITING) {
          Row() {
            Button('退诊')
              .width('45%')
              .height(48)
              .fontSize(16)
              .fontColor('#007AFF')
              .backgroundColor('#FFFFFF')
              .border({ width: 1, color: '#007AFF', radius: 24 })
              .onClick(() => this.rejectConsultation())
            Blank()
            Button('接诊')
              .width('45%')
              .height(48)
              .fontSize(16)
              .backgroundColor('#007AFF')
              .borderRadius(24)
              .onClick(() => this.acceptConsultation())
          }
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 15,
            bottom: 8
          })
          .backgroundColor('#FFFFFF')
        } else if (this.consultationItem.status === ConsultationStatus.IN_PROGRESS ||
          this.consultationItem.status === ConsultationStatus.FINISHED) {
          Column() {
            Row() {
              TextInput({ placeholder: '请回复患者', text: $$this.inputText })
                .layoutWeight(1)
                .height(40)
                .backgroundColor('#F5F5F5')
                .borderRadius(20)
                .padding({ left: 16, right: 16 })
                .onChange((value: string) => {
                  this.inputText = value;
                })
              Button('发送')
                .width(70)
                .height(40)
                .fontSize(14)
                .backgroundColor('#007AFF')
                .borderRadius(20)
                .margin({ left: 8 })
                .onClick(() => this.sendMessage())
            }
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 2
            })

            Row() {
              Image($r("app.media.voice")).width(20).height(25)
              Image($r("app.media.expression")).width(25).height(25)
              Image($r("app.media.imageIcon")).width(25).height(25)
              // 常用语按钮
              Button('常用语')
                .fontSize(13)
                .fontColor('#666')
                .backgroundColor('#F0F0F0')
                .padding({
                  left: 12,
                  right: 12,
                  top: 4,
                  bottom: 4
                })
                .borderRadius(4)
                .onClick(() => {
                  promptAction.showActionMenu({
                    title: '常用语',
                    buttons: [
                      { text: '建议先服用药物控制调理', color: '#007AFF' },
                      { text: '请多休息，注意饮食', color: '#007AFF' },
                      { text: '建议到医院进一步检查', color: '#007AFF' }
                    ]
                  }).then((result: ActionMenuResult) => {
                    if (result.index === 0) {
                      this.inputText = '建议先服用药物控制调理';
                    } else if (result.index === 1) {
                      this.inputText = '请多休息，注意饮食';
                    } else if (result.index === 2) {
                      this.inputText = '建议到医院进一步检查';
                    }
                  }).catch((error: Error) => {
                    console.error('showActionMenu error: ' + JSON.stringify(error));
                  });
                })
              Button('开处方')
                .fontSize(13)
                .fontColor('#007AFF')
                .backgroundColor('#F0F8FF')
                .padding({
                  left: 12,
                  right: 12,
                  top: 4,
                  bottom: 4
                })
                .borderRadius(4)
                .onClick(() => {
                  router.pushUrl({ url: 'pages/MyPrescriptionPage' });
                })
            }
            .width('100%')
            .padding({
              left: 16,
              right: 16,
              top: 5,
              bottom: 2
            })
            .justifyContent(FlexAlign.SpaceEvenly)
          }
          .backgroundColor('#FFFFFF')
        }
      }

      // 展示图片详情
      if (this.previewVisible && this.previewImage) {
        Stack() {
          // 黑色背景
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#000000')
          // 图片（居中）
          Image(this.previewImage)
            .width('100%')
            .objectFit(ImageFit.Contain)
          // 左上角关闭按钮
          Text('✕')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .position({ x: 20, y: 50 })
            .onClick(() => {
              this.previewVisible = false;
            })
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })
      }

      // 结束问诊确认弹窗
      if (this.showFinishDialog) {
        Stack() {

          // 遮罩层
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#88919191')
            .onClick(() => {
              this.showFinishDialog = false;
            })

          // 弹窗内容
          Column() {
            Text('结束确认')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 24, bottom: 16 })

            Text('确定结束此次问诊吗？')
              .fontSize(16)
              .fontColor('#333')
              .margin({ bottom: 30 })

            Divider()

            Row() {
              Text('取消')
                .fontSize(16)
                .fontColor('#666')
                .layoutWeight(1)
                .height(48)
                .textAlign(TextAlign.Center)
                .onClick(() => {
                  this.showFinishDialog = false;
                })

              Divider().width(1).height(48)

              Text('确定')
                .fontSize(16)
                .fontColor('#007AFF')
                .layoutWeight(1)
                .height(48)
                .textAlign(TextAlign.Center)
                .onClick(() => this.confirmFinishConsultation())
            }
          }
          .width(280)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
        .position({ x: 0, y: 0 })
        .zIndex(999)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}