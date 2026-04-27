import { InfoRow } from './PatientModels'

@Component
export struct PersonalInfoPage {
  @Link activePage: string;
  /** 左上角返回时回到的页面（进入前由患者资料页写入，如「患者资料」） */
  @Prop cancelReturnPage: string = '患者资料';
  /** 进入编辑姓名 / 编辑备注 / 编辑个人年龄前写入，供子页返回「个人信息」 */
  @Link personalInfoSubReturnPage: string;
  /** 年龄展示与编辑页共用（由预览容器持有状态） */
  @Link patientAgeDisplay: string;
  /** 患者姓名展示与编辑姓名页共用 */
  @Link patientNameDisplay: string;
  /** 备注展示与编辑备注页共用 */
  @Link patientRemarkDisplay: string;
  /** 地区展示（省 + 空格 + 地市），与预览容器共用 */
  @Link patientRegionDisplay: string;

  @State private showGenderSheet: boolean = false;
  @State private patientGender: string = '女';

  @State private showRegionPicker: boolean = false;
  @State private regionProvinceIndex: number = 0;
  @State private regionCityIndex: number = 0;

  /** 与示意图一致：左列省份顺序 */
  private readonly provinceList: string[] = ['上海', '北京', '江苏', '浙江', '广东'];

  private citiesOfProvince(name: string): string[] {
    if (name === '北京') {
      return ['东城', '朝阳', '海淀', '西城'];
    }
    if (name === '上海') {
      return ['黄浦', '浦东', '静安', '徐汇'];
    }
    if (name === '广东') {
      return ['深圳', '佛山', '广州', '东莞', '汕头'];
    }
    if (name === '江苏') {
      return ['南京', '苏州', '无锡', '常州'];
    }
    if (name === '浙江') {
      return ['杭州', '宁波', '温州', '嘉兴'];
    }
    return ['市区'];
  }

  private currentCityList(): string[] {
    const p = this.provinceList[this.regionProvinceIndex];
    return this.citiesOfProvince(p);
  }

  /** 根据 patientRegionDisplay 同步滚轮下标 */
  private syncRegionPickerFromDisplay(): void {
    const parts = this.patientRegionDisplay.trim().split(/\s+/);
    const provinceName = parts[0] ?? '北京';
    const cityName = parts.length > 1 ? parts.slice(1).join(' ') : '';

    let pi = this.provinceList.indexOf(provinceName);
    if (pi < 0) {
      pi = 0;
    }
    this.regionProvinceIndex = pi;

    const cities = this.citiesOfProvince(this.provinceList[pi]);
    let ci = cityName.length > 0 ? cities.indexOf(cityName) : 0;
    if (ci < 0) {
      ci = 0;
    }
    this.regionCityIndex = ci;
  }

  private openRegionPicker(): void {
    this.syncRegionPickerFromDisplay();
    this.showRegionPicker = true;
  }

  private confirmRegionPicker(): void {
    const province = this.provinceList[this.regionProvinceIndex];
    const cities = this.currentCityList();
    const city = cities.length > 0 ? cities[this.regionCityIndex] : '';
    this.patientRegionDisplay = city.length > 0 ? `${province} ${city}` : province;
    this.showRegionPicker = false;
  }

  private readonly rows: InfoRow[] = [
    new InfoRow('患者姓名', '吴珊珊'),
    new InfoRow('性别', '女'),
    new InfoRow('年龄', '23'),
    new InfoRow('电话号码', '188****6788'),
    new InfoRow('身份证号', '37***********7770'),
    new InfoRow('地区', '北京 朝阳'),
    new InfoRow('备注', '该患者需要于下月5号询问用药情况....')
  ];

  private rowDisplayValue(item: InfoRow): string {
    if (item.label === '患者姓名') {
      return this.patientNameDisplay;
    }
    if (item.label === '性别') {
      return this.patientGender;
    }
    if (item.label === '年龄') {
      return this.patientAgeDisplay;
    }
    if (item.label === '备注') {
      return this.patientRemarkDisplay;
    }
    if (item.label === '地区') {
      return this.patientRegionDisplay;
    }
    return item.value;
  }

  private showChevron(label: string): boolean {
    return label === '患者姓名' || label === '备注' || label === '性别' || label === '年龄' || label === '地区';
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r('app.media.u695'))
            .width(24)
            .height(24)
            .syncLoad(true)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              this.activePage = this.cancelReturnPage;
            })
          Blank()
          Text('个人信息').fontSize(24).fontWeight(FontWeight.Medium)
          Blank()
          Text(' ')
            .fontSize(24)
            .opacity(0)
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 14, bottom: 8 })
        .backgroundColor('#FFFFFF')
        List() {
          ForEach(this.rows, (item: InfoRow, index: number) => {
            ListItem() {
              Column() {
                Row() {
                  Text(item.label).fontSize(18)
                  Blank()
                  Text(this.rowDisplayValue(item))
                    .fontSize(16)
                    .fontColor('#666666')
                    .layoutWeight(1)
                    .textAlign(TextAlign.End)
                    .maxLines(item.label === '备注' ? 2 : 1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                  if (this.showChevron(item.label)) {
                    Image($r('app.media.u1158'))
                      .width(10)
                      .height(16)
                      .syncLoad(true)
                      .objectFit(ImageFit.Contain)
                      .margin({ left: 8 })
                  }
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                .alignItems(VerticalAlign.Center)
                .onClick(() => {
                  if (item.label === '患者姓名') {
                    this.personalInfoSubReturnPage = '个人信息';
                    this.activePage = '编辑姓名';
                  } else if (item.label === '备注') {
                    this.personalInfoSubReturnPage = '个人信息';
                    this.activePage = '编辑备注';
                  } else if (item.label === '性别') {
                    this.showGenderSheet = true;
                  } else if (item.label === '年龄') {
                    this.personalInfoSubReturnPage = '个人信息';
                    this.activePage = '编辑个人年龄';
                  } else if (item.label === '地区') {
                    this.openRegionPicker();
                  }
                })

                if (index < this.rows.length - 1) {
                  Divider()
                    .strokeWidth(0.5)
                    .color('#E8E8E8')
                    .margin({ left: 16, right: 16 })
                }
              }
              .width('100%')
              .backgroundColor('#FFFFFF')
            }
          }, (item: InfoRow) => item.label)
        }
        .layoutWeight(1)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F3F4F6')

      if (this.showGenderSheet) {
        Column() {
          Blank()
            .layoutWeight(1)
            .width('100%')
            .backgroundColor('#80000000')
            .onClick(() => {
              this.showGenderSheet = false;
            })
          Column() {
            Text('请选择患者性别')
              .fontSize(14)
              .fontColor('#999999')
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 16, bottom: 12 })
            Divider().color('#F0F0F0').strokeWidth(0.5)
            Text('男')
              .fontSize(18)
              .fontColor('#4A74F5')
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 14, bottom: 14 })
              .onClick(() => {
                this.patientGender = '男';
                this.showGenderSheet = false;
              })
            Divider().color('#F0F0F0').strokeWidth(0.5)
            Text('女')
              .fontSize(18)
              .fontColor('#4A74F5')
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 14, bottom: 14 })
              .onClick(() => {
                this.patientGender = '女';
                this.showGenderSheet = false;
              })
            Column()
              .width('100%')
              .height(8)
              .backgroundColor('#F3F4F6')
            Text('取消')
              .fontSize(18)
              .fontColor('#4A74F5')
              .width('100%')
              .textAlign(TextAlign.Center)
              .padding({ top: 14, bottom: 20 })
              .backgroundColor('#FFFFFF')
              .onClick(() => {
                this.showGenderSheet = false;
              })
          }
          .width('100%')
          .borderRadius({ topLeft: 12, topRight: 12 })
          .clip(true)
          .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
      }

      if (this.showRegionPicker) {
        Column() {
          Blank()
            .layoutWeight(1)
            .width('100%')
            .backgroundColor('#80000000')
            .onClick(() => {
              this.showRegionPicker = false;
            })
          Column() {
            Row() {
              Text('取消')
                .fontSize(18)
                .fontColor('#4A74F5')
                .padding({ left: 4, right: 12, top: 8, bottom: 8 })
                .onClick(() => {
                  this.showRegionPicker = false;
                })
              Blank()
              Text('完成')
                .fontSize(18)
                .fontColor('#4A74F5')
                .padding({ left: 12, right: 4, top: 8, bottom: 8 })
                .onClick(() => {
                  this.confirmRegionPicker();
                })
            }
            .width('100%')
            .padding({ left: 12, right: 12, top: 8, bottom: 4 })
            .justifyContent(FlexAlign.SpaceBetween)

            Row() {
              TextPicker({ range: this.provinceList, selected: this.regionProvinceIndex })
                .layoutWeight(1)
                .height(220)
                .defaultPickerItemHeight(40)
                .canLoop(false)
                .onChange((_value: string | string[], index: number | number[]) => {
                  const i = Array.isArray(index) ? (index[0] ?? 0) : index;
                  this.regionProvinceIndex = i;
                  this.regionCityIndex = 0;
                })
              TextPicker({ range: this.currentCityList(), selected: this.regionCityIndex })
                .layoutWeight(1)
                .height(220)
                .defaultPickerItemHeight(40)
                .canLoop(false)
                .onChange((_value: string | string[], index: number | number[]) => {
                  const i = Array.isArray(index) ? (index[0] ?? 0) : index;
                  this.regionCityIndex = i;
                })
            }
            .width('100%')
            .padding({ bottom: 12 })
          }
          .width('100%')
          .borderRadius({ topLeft: 12, topRight: 12 })
          .clip(true)
          .backgroundColor('#FFFFFF')
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

@Component
export struct EditPersonalInfoPage {
  @Link activePage: string;
  @Prop cancelReturnPage: string = '个人信息';
  @Link patientNameDisplay: string;

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
        Blank()
        Text('填写姓名').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text('保存')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      .backgroundColor('#FFFFFF')

      TextInput({ text: this.patientNameDisplay, placeholder: '请输入姓名' })
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .onChange((value: string) => {
          this.patientNameDisplay = value;
        })
      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}


@Component
export struct EditPersonalAgePage {
  @Link activePage: string;
  @Prop cancelReturnPage: string = '个人信息';
  @Link patientAgeDisplay: string;

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
        Blank()
        Text('编辑个人年龄').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text('保存')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      .backgroundColor('#FFFFFF')

      TextInput({ text: this.patientAgeDisplay, placeholder: '请输入年龄' })
        .width('100%')
        .height(48)
        .padding({ left: 16, right: 16 })
        .type(InputType.Number)
        .onChange((value: string) => {
          this.patientAgeDisplay = value;
        })
      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}

@Component
export struct EditRemarkInfoPage {
  @Link activePage: string;
  @Prop cancelReturnPage: string = '个人信息';
  @Link patientRemarkDisplay: string;

  build() {
    Column({ space: 10 }) {
      Row() {
        Image($r('app.media.u695'))
          .width(24)
          .height(24)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
        Blank()
        Text('编辑备注').fontSize(24).fontWeight(FontWeight.Medium)
        Blank()
        Text('保存')
          .fontSize(18)
          .fontColor('#4A74F5')
          .onClick(() => {
            this.activePage = this.cancelReturnPage;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 14, bottom: 8 })
      .backgroundColor('#FFFFFF')

      TextArea({ text: this.patientRemarkDisplay, placeholder: '请输入备注' })
        .width('100%')
        .height(220)
        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        .onChange((value: string) => {
          this.patientRemarkDisplay = value;
        })
      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F3F4F6')
  }
}


