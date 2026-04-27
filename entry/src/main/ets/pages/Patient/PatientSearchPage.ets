import { PatientEntity } from '../../backend/patient/model/PatientEntities'
import { patientService } from '../../backend/patient/service/PatientService'

@Component
export struct SearchPatientPage {
  @Link activePage: string;
  /** 取消时回到的页面标识，由进入搜索页面前的页面写入（如「患者」「选择患者」） */
  @Prop cancelReturnPage: string = '患者';
  @State private keyword: string = '';
  @State private resultList: PatientEntity[] = [];

  aboutToAppear() {
    this.resultList = patientService.getAllPatients();
  }

  private doSearch(value: string): void {
    this.keyword = value;
    this.resultList = patientService.searchPatients(value);
  }

  build() {
    Column() {
      Row() {
        TextInput({ placeholder: '请输入患者信息', text: $$this.keyword })
          .layoutWeight(1)
          .height(42)
          .backgroundColor('#F4F5F7')
          .onChange((value: string) => {
            this.resultList = patientService.searchPatients(value);
          })
          .onSubmit((_enterKey: EnterKeyType) => {
            this.doSearch(this.keyword);
          })
        Text('取消')
          .fontSize(18)
          .fontColor('#7A7A7A')
          .margin({ left: 10 })
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 8 })

      List() {
        ForEach(this.resultList, (patient: PatientEntity, index: number) => {
          ListItem() {
            Column() {
              Row() {
                Image(patient.avatar)
                  .width(44)
                  .height(44)
                  .borderRadius(22)
                  .margin({ right: 10 })
                Column({ space: 4 }) {
                  Text(`${patient.name} ${patient.gender} ${patient.age}岁`).fontSize(16).fontWeight(FontWeight.Medium)
                  Text(patient.phone).fontSize(13).fontColor('#999999')
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
              .padding({ left: 16, right: 16, top: 10, bottom: 10 })

              if (index < this.resultList.length - 1) {
                Divider()
                  .strokeWidth(0.5)
                  .color('#E8E8E8')
                  .margin({ left: 16, right: 16 })
              }
            }
            .width('100%')
            .backgroundColor('#FFFFFF')
          }
        }, (patient: PatientEntity) => patient.id.toString())
      }
      .layoutWeight(1)
      .width('100%')

      if (this.resultList.length === 0) {
        Text('未找到匹配患者，请检查输入信息')
          .fontSize(14)
          .fontColor('#999999')
          .width('100%')
          .textAlign(TextAlign.Center)
          .padding({ top: 12, bottom: 20 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}
