import { GroupItem } from './PatientModels'
import { BroadcastMessageEntity, PatientEntity } from '../../backend/patient/model/PatientEntities'
import { patientService } from '../../backend/patient/service/PatientService'
import { broadcastService } from '../../backend/patient/service/BroadcastService'
import promptAction from '@ohos.promptAction'
import common from '@ohos.app.ability.common'
import router from '@ohos.router'

@Component
export struct CreateBroadcastPage {
  @Link activePage: string;
  @Link selectedMessageId: number;
  @Link selectedRecipientIds: number[];
  @State private recipients: PatientEntity[] = [];
  @State private messageContent: string = '';

  aboutToAppear() {
    const allPatients = patientService.getAllPatients();
    if (this.selectedRecipientIds.length === 0) {
      this.recipients = allPatients;
      return;
    }
    this.recipients = allPatients.filter((item: PatientEntity) => {
      return this.selectedRecipientIds.indexOf(item.id) >= 0;
    });
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .onClick(() => {
            this.activePage = '患者';
          })
          .margin({ right: 8 })
        Text('新建群发').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text('群发历史')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = '群发历史';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })

      Text('群发内容').fontSize(20).fontWeight(FontWeight.Medium).width('100%').padding({ left: 16, right: 16 })
      TextArea({ text: this.messageContent, placeholder: '可将就诊通知/文章等消息发送给患者' })
        .width('100%')
        .height(180)
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .onChange((value: string) => {
          this.messageContent = value;
        })

      Column({ space: 8 }) {
        Row() {
          Text(`接收人（已选择${this.recipients.length}人）`)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .layoutWeight(1)
          Image($r('app.media.u4795'))
            .width(16)
            .height(16)
            .syncLoad(true)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.activePage = '选择患者';
            })
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Scroll() {
          Row({ space: 16 }) {
            ForEach(this.recipients, (item: PatientEntity) => {
              Column({ space: 4 }) {
                Image(item.avatar)
                  .width(50)
                  .height(44)
                  .syncLoad(true)
                  .borderRadius(22)
                  .objectFit(ImageFit.Cover)
                Text(item.name).fontSize(14)
              }
            }, (item: PatientEntity) => item.id.toString())
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .padding({ right: 4 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height(72)
        .align(Alignment.Start)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF')

      Text(broadcastService.getTodayQuotaText())
        .fontSize(14)
        .fontColor('#909090')
        .width('100%')
        .padding({ left: 16, right: 16 })

      Blank()
      Button('确认发送')
        .width('92%')
        .height(48)
        .margin({ bottom: 14 })
        .backgroundColor('#3F74F5')
        .onClick(async () => {
          const context = getContext(this) as common.UIAbilityContext;
          const content = this.messageContent.trim().length > 0 ? this.messageContent.trim() : '（演示群发消息）';
          const patientIds = this.recipients.length > 0
            ? this.recipients.map((item: PatientEntity) => item.id)
            : patientService.getAllPatients().map((item: PatientEntity) => item.id);
          const newId = await broadcastService.createAndSendMessage(context, content, patientIds);
          this.selectedMessageId = newId;
          this.messageContent = '';
          promptAction.showToast({ message: '群发发送成功' });
          this.activePage = '群发历史';
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct BroadcastHistoryPage {
  @Link activePage: string;
  @Link selectedMessageId: number;
  @State private historyList: BroadcastMessageEntity[] = [];

  async aboutToAppear() {
    const context = getContext(this) as common.UIAbilityContext;
    this.historyList = await broadcastService.listHistory(context);
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = '新建群发';
          })
        Blank()
        Text('群发历史').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      TextInput({ placeholder: '请输入群发消息关键字' })
        .width('92%')
        .height(42)
        .backgroundColor('#F4F5F7')
        .onClick(() => {
          this.activePage = '搜索消息';
        })

      List() {
        ForEach(this.historyList, (item: BroadcastMessageEntity, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Column({ space: 6 }) {
                  Text(item.content).fontSize(18).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(item.sentAt).fontSize(14).fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Image($r('app.media.u4795'))
                  .width(16)
                  .height(16)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                this.selectedMessageId = item.id;
                this.activePage = '消息详情';
              })

              if (index < this.historyList.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (item: BroadcastMessageEntity) => item.id.toString())
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct SearchMessagePage {
  @Link activePage: string;
  @Link selectedMessageId: number;
  @State private keyword: string = '';
  @State private resultList: BroadcastMessageEntity[] = [];

  async aboutToAppear() {
    const context = getContext(this) as common.UIAbilityContext;
    this.resultList = await broadcastService.listHistory(context);
  }

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '请输入群发消息关键字', text: this.keyword })
          .layoutWeight(1)
          .height(42)
          .backgroundColor('#F4F5F7')
          .onChange(async (value: string) => {
            this.keyword = value;
            const context = getContext(this) as common.UIAbilityContext;
            this.resultList = await broadcastService.searchHistory(context, value);
          })
        Text('取消')
          .fontSize(18)
          .fontColor('#7A7A7A')
          .margin({ left: 10 })
          .onClick(() => {
            this.activePage = '群发历史';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      List() {
        ForEach(this.resultList, (item: BroadcastMessageEntity, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Column({ space: 6 }) {
                  Text(item.content).fontSize(18).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
                  Text(item.sentAt).fontSize(14).fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Image($r('app.media.u4795'))
                  .width(16)
                  .height(16)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                this.selectedMessageId = item.id;
                this.activePage = '消息详情';
              })

              if (index < this.resultList.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (item: BroadcastMessageEntity) => item.id.toString())
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct MessageDetailPage {
  @Link activePage: string;
  @Link selectedMessageId: number;
  @Link detailReturnPage: string;
  @State private currentMessage: BroadcastMessageEntity | null = null;
  @State private recipients: PatientEntity[] = [];

  async aboutToAppear() {
    const context = getContext(this) as common.UIAbilityContext;
    let messageId = this.selectedMessageId;
    if (messageId <= 0) {
      const history = await broadcastService.listHistory(context);
      messageId = history.length > 0 ? history[0].id : 0;
    }
    if (messageId > 0) {
      this.currentMessage = await broadcastService.getMessageDetail(context, messageId);
      this.recipients = await broadcastService.getRecipientsByMessage(context, messageId);
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            if (this.detailReturnPage === '__BACK__') {
              router.back()
              return;
            }
            this.activePage = '群发历史';
          })
        Blank()
        Text('消息详情').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      Column({ space: 10 }) {
        Text('群发内容').fontSize(20).fontWeight(FontWeight.Medium)
        Text(this.currentMessage?.sentAt ?? '--').fontSize(14).fontColor('#999999')
        Text(this.currentMessage?.content ?? '暂无内容')
          .fontSize(16)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF')
      .alignItems(HorizontalAlign.Start)

      Column({ space: 8 }) {
        Text(`接收人（${this.recipients.length}人）`).fontSize(18).fontWeight(FontWeight.Medium)
        Scroll() {
          Row({ space: 16 }) {
            ForEach(this.recipients, (item: PatientEntity) => {
              Column({ space: 4 }) {
                Image(item.avatar)
                  .width(50)
                  .height(44)
                  .syncLoad(true)
                  .borderRadius(22)
                  .objectFit(ImageFit.Cover)
                Text(item.name).fontSize(14)
              }
            }, (item: PatientEntity) => item.id.toString())
          }
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Top)
          .padding({ right: 4 })
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .edgeEffect(EdgeEffect.Spring)
        .width('100%')
        .height(72)
        .align(Alignment.Start)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 10 })
      .backgroundColor('#FFFFFF')

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct SelectPatientPage {
  @Link activePage: string;
  @Link searchReturnPage: string;
  @Link selectedRecipientIds: number[];
  @Link selectedRecipientGroupId: number;
  @Link selectedRecipientGroupName: string;
  /** 与 groups 下标对应：第 0 行「所有患者」的勾选表示下方分组是否已全选 */
  @State private rowSelected: boolean[] = [false];
  @State private groups: GroupItem[] = [new GroupItem('所有患者', '0人')];
  @State private groupIds: number[] = [0];

  aboutToAppear() {
    const actualGroups = patientService.getPatientGroupItems();
    const realGroups = patientService.getGroups();
    const totalCount = patientService.getAllPatients().length;
    this.groups = [new GroupItem('所有患者', `${totalCount}人`), ...actualGroups];
    this.groupIds = [0, ...realGroups.map((item) => item.id)];
    this.rowSelected = this.groups.map(() => false);
  }

  private allBelowSelected(): boolean {
    for (let k = 1; k < this.rowSelected.length; k++) {
      if (!this.rowSelected[k]) {
        return false;
      }
    }
    return true;
  }

  private selectedBelowCount(): number {
    let n = 0;
    for (let k = 1; k < this.rowSelected.length; k++) {
      if (this.rowSelected[k]) {
        n++;
      }
    }
    return n;
  }

  /** 左侧勾选图标是否显示「已选」：第 0 行与下方全选一致；其余行看 rowSelected */
  private isLeftChecked(index: number): boolean {
    if (index === 0) {
      return this.allBelowSelected();
    }
    return this.rowSelected[index];
  }

  private toggleRow(index: number): void {
    let len = this.rowSelected.length;
    let next: boolean[] = [];
    for (let k = 0; k < len; k++) {
      next.push(this.rowSelected[k]);
    }
    if (index === 0) {
      let turnOff = this.allBelowSelected();
      for (let k = 1; k < len; k++) {
        next[k] = !turnOff;
      }
    } else {
      next[index] = !next[index];
    }
    this.rowSelected = next;
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = '新建群发';
          })
        Blank()
        Text('选择患者').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      TextInput({ placeholder: '请输入患者相关信息' })
        .width('92%')
        .height(42)
        .margin({ bottom: 8 })
        .backgroundColor('#F4F5F7')
        .onClick(() => {
          this.searchReturnPage = '选择患者';
          this.activePage = '搜索患者';
        })
      List() {
        ForEach(this.groups, (item: GroupItem, index: number) => {
          ListItem() {
            Column() {
              Row() {
                if (this.isLeftChecked(index)) {
                  Image($r('app.media.u3078'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 10 })
                    .onClick(() => {
                      this.toggleRow(index);
                    })
                } else {
                  Image($r('app.media.u3077'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .opacity(0.9)
                    .margin({ right: 10 })
                    .onClick(() => {
                      this.toggleRow(index);
                    })
                }
                Row() {
                  Text(item.name).fontSize(20)
                  Blank()
                  Text(item.count).fontSize(16).fontColor('#999999')
                  Image($r('app.media.u4795'))
                    .width(16)
                    .height(16)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                }
                .layoutWeight(1)
                .width('100%')
                .alignItems(VerticalAlign.Center)
                .onClick(() => {
                  const gid = this.groupIds[index] ?? 0;
                  if (gid > 0) {
                    this.selectedRecipientGroupId = gid;
                    this.selectedRecipientGroupName = item.name;
                  } else {
                    this.selectedRecipientGroupId = 1;
                    this.selectedRecipientGroupName = '默认分组';
                  }
                  this.activePage = '我的患者';
                })
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14, bottom: 14 })
              .alignItems(VerticalAlign.Center)
              .backgroundColor('#FFFFFF')

              if (index < this.groups.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (item: GroupItem) => item.name)
      }
      .layoutWeight(1)
      .width('100%')

      Row() {
        Text('已选择' + this.selectedBelowCount().toString() + '项分组')
          .fontSize(16)
          .fontColor('#888888')
        Blank()
        Text('确定')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            if (this.selectedBelowCount() > 0) {
              this.activePage = '新建群发';
            }
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 14 })
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct MyPatientsPage {
  @Link activePage: string;
  @Link searchReturnPage: string;
  @Link selectedRecipientIds: number[];
  @Link selectedRecipientGroupId: number;
  @Link selectedRecipientGroupName: string;
  @State private patients: PatientEntity[] = [];
  @State private rowSelected: boolean[] = [];

  aboutToAppear() {
    this.patients = patientService.getPatientsByGroup(this.selectedRecipientGroupId);
    this.rowSelected = this.patients.map((patient: PatientEntity) => {
      return this.selectedRecipientIds.indexOf(patient.id) >= 0;
    });
  }

  private allPatientsSelected(): boolean {
    for (let k = 0; k < this.rowSelected.length; k++) {
      if (!this.rowSelected[k]) {
        return false;
      }
    }
    return true;
  }

  private selectedPatientCount(): number {
    let n = 0;
    for (let k = 0; k < this.rowSelected.length; k++) {
      if (this.rowSelected[k]) {
        n++;
      }
    }
    return n;
  }

  private toggleSelectAll(): void {
    let turnOff = this.allPatientsSelected();
    let next: boolean[] = [];
    for (let k = 0; k < this.patients.length; k++) {
      next.push(!turnOff);
    }
    this.rowSelected = next;
  }

  private togglePatientRow(index: number): void {
    let next: boolean[] = [];
    for (let k = 0; k < this.patients.length; k++) {
      next.push(this.rowSelected[k]);
    }
    next[index] = !next[index];
    this.rowSelected = next;
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = '选择患者';
          })
        Blank()
        Text(this.selectedRecipientGroupName).fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      TextInput({ placeholder: '请输入患者相关信息' })
        .width('92%')
        .height(42)
        .margin({ bottom: 8 })
        .backgroundColor('#F4F5F7')
        .onClick(() => {
          this.searchReturnPage = '我的患者';
          this.activePage = '搜索患者';
        })

      List() {
        ListItem() {
          Column() {
            Row() {
              if (this.allPatientsSelected()) {
                Image($r('app.media.u3078'))
                  .width(22)
                  .height(22)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.toggleSelectAll();
                  })
              } else {
                Image($r('app.media.u3077'))
                  .width(22)
                  .height(22)
                  .syncLoad(true)
                  .objectFit(ImageFit.Contain)
                  .opacity(0.9)
                  .margin({ right: 8 })
                  .onClick(() => {
                    this.toggleSelectAll();
                  })
              }
              Text('全选')
                .fontSize(20)
                .textAlign(TextAlign.Start)
              Blank()
              Text(`${this.patients.length}人`).fontSize(16).fontColor('#999999')
            }
            .width('100%')
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .padding({ left: 16, right: 16, top: 12, bottom: 12 })
            Divider()
              .strokeWidth(0.5)
              .color('#E8E8E8')
              .margin({ left: 16, right: 16 })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }

        ForEach(this.patients, (patient: PatientEntity, index: number) => {
          ListItem() {
            Column() {
              Row() {
                if (this.rowSelected[index]) {
                  Image($r('app.media.u3078'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .margin({ right: 8 })
                    .onClick(() => {
                      this.togglePatientRow(index);
                    })
                } else {
                  Image($r('app.media.u3077'))
                    .width(22)
                    .height(22)
                    .syncLoad(true)
                    .objectFit(ImageFit.Contain)
                    .opacity(0.9)
                    .margin({ right: 8 })
                    .onClick(() => {
                      this.togglePatientRow(index);
                    })
                }
                Image(patient.avatar)
                  .width(48)
                  .height(48)
                  .syncLoad(true)
                  .borderRadius(24)
                  .objectFit(ImageFit.Cover)
                  .margin({ right: 12 })
                Column({ space: 5 }) {
                  Text(`${patient.name} ${patient.gender} ${patient.age}岁`).fontSize(18)
                  Text(`添加时间：${patient.createdAt}`).fontSize(14).fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Blank()
                Text(patient.serviceType)
                  .fontSize(12)
                  .fontColor('#CFAF3A')
                  .backgroundColor('#FFF4C9')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(10)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })
              .alignItems(VerticalAlign.Center)

              if (index < this.patients.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (patient: PatientEntity) => 'p' + patient.id.toString())
      }
      .layoutWeight(1)
      .width('100%')

      Row() {
        Text('已选择' + this.selectedPatientCount().toString() + '人')
          .fontSize(16)
          .fontColor('#888888')
        Blank()
        Button('确定')
          .type(ButtonType.Normal)
          .fontSize(18)
          .fontColor('#4A74F5')
          .backgroundColor(Color.Transparent)
          .stateEffect(false)
          .padding({ left: 8, right: 8, top: 6, bottom: 6 })
          .onClick(() => {
            this.selectedRecipientIds = this.patients
              .filter((_item: PatientEntity, index: number) => this.rowSelected[index])
              .map((item: PatientEntity) => item.id);
            this.activePage = '新建群发';
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 10, bottom: 14 })
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}
