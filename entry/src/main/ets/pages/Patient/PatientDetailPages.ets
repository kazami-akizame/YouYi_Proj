import { ConsultationItem, ConsultationStatus, ConsultationType } from '../common/ConsultationData'
import { PatientEntity } from '../../backend/patient/model/PatientEntities'
import { patientService } from '../../backend/patient/service/PatientService'
import router from '@ohos.router'

/** 默认分组：分组下患者列表（搜索 + 列表 + 底部「没有更多了」） */
@Component
export struct DefaultGroupPage {
  @Link activePage: string;
  @Link searchReturnPage: string;
  @Link currentGroupId: number;
  @Link currentGroupName: string;
  @Link currentPatientId: number;

  @State private patients: PatientEntity[] = [];

  aboutToAppear() {
    this.patients = patientService.getPatientsByGroup(this.currentGroupId);
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
            this.activePage = '患者';
          })
        Blank()
        Text(this.currentGroupName).fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      .backgroundColor('#FFFFFF')

      Row({ space: 8 }) {
        Image($r('app.media.u2201'))
          .width(18)
          .height(18)
          .opacity(0.6)
        TextInput({ placeholder: '请输入患者相关信息' })
          .layoutWeight(1)
          .height(40)
          .padding(0)
          .fontSize(16)
          .placeholderColor('#B4B9C2')
          .backgroundColor(Color.Transparent)
          .border({ width: 0 })
          .onClick(() => {
            this.searchReturnPage = '默认分组';
            this.activePage = '搜索患者';
          })
      }
      .width('92%')
      .height(42)
      .padding({ left: 12, right: 12 })
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .backgroundColor('#F4F5F7')
      .borderRadius(21)
      .margin({ bottom: 8 })
      .onClick(() => {
        this.searchReturnPage = '默认分组';
        this.activePage = '搜索患者';
      })

      List() {
        ForEach(this.patients, (patient: PatientEntity, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Image(patient.avatar)
                  .width(48)
                  .height(48)
                  .syncLoad(true)
                  .borderRadius(24)
                  .objectFit(ImageFit.Cover)
                  .margin({ right: 12 })
                Column({ space: 6 }) {
                  Text(`${patient.name} ${patient.gender} ${patient.age}岁`).fontSize(18).fontWeight(FontWeight.Medium)
                  Text(`添加时间：${patient.createdAt}`).fontSize(14).fontColor('#999999')
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)
                Text(patient.serviceType)
                  .fontSize(12)
                  .fontColor('#CFAF3A')
                  .backgroundColor('#FFF4C9')
                  .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                  .borderRadius(10)
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 12, bottom: 12 })
              .alignItems(VerticalAlign.Center)
              .onClick(() => {
                this.currentPatientId = patient.id;
                this.activePage = '患者资料';
              })

              if (index < this.patients.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
          }
        }, (patient: PatientEntity) => patient.id.toString())
      }
      .layoutWeight(1)
      .width('100%')
      .backgroundColor('#FFFFFF')

      Text('没有更多了～')
        .fontSize(14)
        .fontColor('#C8C8C8')
        .width('100%')
        .textAlign(TextAlign.Center)
        .padding({ top: 8, bottom: 16 })
        .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

/** 患者资料：单患者详情（卡片 + 问诊记录 + 底栏按钮） */
@Component
export struct PatientProfilePage {
  @Link activePage: string;
  @Link profileReturnPage: string;
  /** 与修改分组页共用：当前患者所属分组（多选） */
  @Link patientGroupSelection: string[];
  @Link currentPatientId: number;

  @State private consultRecordExpanded: boolean = false;
  @State private patientDetail: PatientEntity | null = null;
  @State private consultations: ConsultationItem[] = [];

  private readonly consultDescShort: string = '病情描述：孩子从出生后睡眠就不好，入睡困难...';
  private readonly consultDescFull: string =
    '病情描述：孩子从出生后睡眠就不好，入睡困难，夜间易醒，白天精神差，家长曾尝试多种方法未见明显改善。';

  aboutToAppear() {
    const profile = patientService.getPatientProfile(this.currentPatientId);
    if (profile) {
      this.patientDetail = profile.patient;
      this.consultations = profile.consultations;
      this.patientGroupSelection = patientService.getPatientGroupNames(this.currentPatientId);
    }
  }

  private displayName(): string {
    return this.patientDetail ? this.patientDetail.name : '患者资料';
  }

  private displayBaseInfo(): string {
    if (!this.patientDetail) {
      return '患者信息加载中';
    }
    return `${this.patientDetail.name} ${this.patientDetail.gender} ${this.patientDetail.age}岁`;
  }

  private displayPhone(): string {
    return this.patientDetail ? this.patientDetail.phone : '--';
  }

  private firstConsultation(): ConsultationItem | null {
    return this.consultations.length > 0 ? this.consultations[0] : null;
  }

  private secondConsultation(): ConsultationItem | null {
    return this.consultations.length > 1 ? this.consultations[1] : null;
  }

  private consultationStatusText(item: ConsultationItem | null): string {
    if (!item) {
      return '--';
    }
    return item.status;
  }

  private consultationStatusColor(item: ConsultationItem | null): string {
    if (!item) {
      return '#999999';
    }
    return item.status === ConsultationStatus.IN_PROGRESS ? '#F5222D' : '#999999';
  }

  private consultationTypeText(item: ConsultationItem | null): string {
    return item ? `${item.type}问诊` : '图文问诊';
  }

  private consultationDescShort(item: ConsultationItem | null): string {
    if (!item) {
      return this.consultDescShort;
    }
    return `病情描述：${item.description.length > 20 ? item.description.slice(0, 20) + '...' : item.description}`;
  }

  private consultationDescFullText(item: ConsultationItem | null): string {
    if (!item) {
      return this.consultDescFull;
    }
    return `病情描述：${item.description}`;
  }

  private groupLineText(): string {
    if (this.patientGroupSelection.length === 0) {
      return '未选择分组';
    }
    return this.patientGroupSelection.join('、');
  }

  private buildInProgressConsultation(): ConsultationItem {
    const patientName = this.patientDetail ? this.patientDetail.name : '患者';
    const patientGender = this.patientDetail ? this.patientDetail.gender : '女';
    const patientAge = this.patientDetail ? this.patientDetail.age : 23;
    const first = this.firstConsultation();
    if (first) {
      return new ConsultationItem(
        first.id,
        first.patientName,
        first.patientGender,
        first.patientAge,
        first.type,
        ConsultationStatus.IN_PROGRESS,
        first.description,
        first.createTime,
        first.rejectReason
      );
    }
    return new ConsultationItem(
      `P${this.currentPatientId.toString()}`,
      patientName,
      patientGender,
      patientAge,
      ConsultationType.GRAPHIC,
      ConsultationStatus.IN_PROGRESS,
      '病情描述：请根据患者主诉继续问诊。',
      '2026-04-22 10:10'
    );
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
            if (this.profileReturnPage === '__BACK__') {
              router.back();
              return;
            }
            this.activePage = '默认分组';
          })
        Blank()
        Text(this.displayName()).fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text(' ')
          .fontSize(24)
          .opacity(0)
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column({ space: 10 }) {
          Column() {
            Row() {
              Image($r('app.media.__80px_u1228'))
                .width(56)
                .height(56)
                .syncLoad(true)
                .borderRadius(28)
                .objectFit(ImageFit.Cover)
                .margin({ right: 12 })
              Column({ space: 6 }) {
                Text(this.displayBaseInfo()).fontSize(18).fontWeight(FontWeight.Medium)
                Text(this.displayPhone()).fontSize(14).fontColor('#888888')
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
              .onClick(() => {
                this.profileReturnPage = '患者资料';
                this.activePage = '个人信息';
              })
              Image($r('app.media.u4795'))
                .width(10)
                .height(16)
                .syncLoad(true)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
            .padding(14)
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(12)

          Column({ space: 10 }) {
            Row() {
              Text('分组').fontSize(16).fontColor('#666666')
              Blank()
              Image($r('app.media.u4795'))
                .width(10)
                .height(16)
                .syncLoad(true)
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
            .onClick(() => {
              this.profileReturnPage = '患者资料';
              this.activePage = '修改分组';
            })
            Text(this.groupLineText())
              .fontSize(16)
              .fontColor('#999999')
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          Column({ space: 0 }) {
            Row() {
              Text('私人医生服务').fontSize(18).fontWeight(FontWeight.Medium)
              Blank()
              Text('进行中').fontSize(14).fontColor('#52C41A')
            }
            .width('100%')
            .padding({ bottom: 10 })
            Divider().color('#F0F0F0').strokeWidth(0.5)
            Column({ space: 8 }) {
              Text('服务时长：半年').fontSize(15).fontColor('#666666')
              Text('开始日期：2020-02-05').fontSize(15).fontColor('#666666')
              Text('结束日期：2020-08-05').fontSize(15).fontColor('#666666')
            }
            .width('100%')
            .padding({ top: 10 })
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          Column({ space: 12 }) {
            Text('问诊记录').fontSize(18).fontWeight(FontWeight.Medium)
            Row() {
              Column() {
                Circle().width(8).height(8).fill('#4A74F5')
              }
              .width(16)
              .alignItems(HorizontalAlign.Center)
              Column({ space: 6 }) {
                Row() {
                  Text(this.firstConsultation()?.createTime ?? '2020-02-05').fontSize(14).fontColor('#666666')
                  Text(this.consultationStatusText(this.firstConsultation()))
                    .fontSize(12)
                    .fontColor(this.consultationStatusColor(this.firstConsultation()))
                    .margin({ left: 8 })
                }
                Text(this.consultationTypeText(this.firstConsultation())).fontSize(16).fontColor('#4A74F5')
                Text(this.consultRecordExpanded ?
                  this.consultationDescFullText(this.firstConsultation()) :
                  this.consultationDescShort(this.firstConsultation()))
                  .fontSize(14)
                  .fontColor('#666666')
                Row() {
                  Blank()
                  Row({ space: 4 }) {
                    Image($r('app.media.u1158'))
                      .width(14)
                      .height(14)
                      .syncLoad(true)
                      .objectFit(ImageFit.Contain)
                      .rotate({ angle: this.consultRecordExpanded ? 90 : -90, centerX: '50%', centerY: '50%' })
                    Text(this.consultRecordExpanded ? '收起' : '展开')
                      .fontSize(14)
                      .fontColor('#4A74F5')
                  }
                  .alignItems(VerticalAlign.Center)
                  .onClick(() => {
                    this.consultRecordExpanded = !this.consultRecordExpanded;
                  })
                }
                .width('100%')
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)

            Divider().color('#F0F0F0').strokeWidth(0.5).margin({ top: 4, bottom: 4 })

            Row() {
              Column() {
                Circle().width(8).height(8).fill('#CCCCCC')
              }
              .width(16)
              .alignItems(HorizontalAlign.Center)
              Column({ space: 6 }) {
                Row() {
                  Text(this.secondConsultation()?.createTime ?? '2020-02-05').fontSize(14).fontColor('#666666')
                  Text(this.consultationStatusText(this.secondConsultation()))
                    .fontSize(12)
                    .fontColor(this.consultationStatusColor(this.secondConsultation()))
                    .margin({ left: 8 })
                }
                Text(this.consultationTypeText(this.secondConsultation())).fontSize(16).fontColor('#333333')
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)
          }
          .width('100%')
          .padding(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          Row({ space: 12 }) {
            Button('开处方')
              .width('44%')
              .height(44)
              .fontColor('#3F74F5')
              .backgroundColor('#FFFFFF')
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/HomePages/MyPrescriptionPage'
                });
              })
            Button('进入咨询')
              .width('44%')
              .height(44)
              .backgroundColor('#3F74F5')
              .onClick(() => {
                const item = this.buildInProgressConsultation();
                router.pushUrl({
                  url: 'pages/HomePages/ChatPage',
                  params: {
                    itemJson: JSON.stringify(item)
                  }
                });
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ bottom: 20 })
        }
        .width('100%')
        .padding({ left: 12, right: 12, top: 8, bottom: 8 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
