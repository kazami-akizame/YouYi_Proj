import router from '@ohos.router';

@Entry
@Component
struct PersonalInformation {
  build() {
    Column() {
      // ====================== 顶部导航栏 ======================
      Row() {
        // 左上角返回箭头
        Image($r('app.media.u695'))
          .objectFit(ImageFit.Fill)
          .width(26)
          .height(26)
          .onClick(() => {
            // 返回上一页 MePage 我的页面
            router.back();
          })

        // 页面居中标题
        Text("个人信息")
          .fontSize(22)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank().width(26)
      }
      .width('100%')
      .height(56)
      .padding({ left: 15, right: 15 })
      .backgroundColor("#ffffff")
      .alignItems(VerticalAlign.Center)

      // ====================== 鸿蒙官方List懒加载列表 ======================
      List({ space: 0 }) {
        // 1. 真实姓名 - 带分割线
        ListItem() {
          this.InfoItem(true, "真实姓名", "李明明", true)
        }
        // 2. 就职医院 - 带分割线
        ListItem() {
          this.InfoItem(true, "就职医院", "北京积水潭医院", true)
        }
        // 3. 所属科室 - 带分割线
        ListItem() {
          this.InfoItem(true, "所属科室", "消化内科", true)
        }
        // 4. 职称 - 带分割线
        ListItem() {
          this.InfoItem(true, "职称", "副主任医师", false)

        }



      ListItem() {
        Column() {
        }.width('100%').height(10).backgroundColor("#f5f5f5")
      }

        // 5. 擅长领域
        ListItem() {
          this.InfoItem(true, "擅长领域", "急性肠胃炎", true)
        }
        // 6. 个人简介
        ListItem() {
          this.InfoItem(false, "个人简介", "医学博士",true)
        }
        // 7. 职业经历 - 无分割线
        ListItem() {
          this.InfoItem(false, "职业经历", "请填写您的职业经历", false, true)
        }
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor("#ffffff")
    }
    .width('100%')
    .height('100%')
    .backgroundColor("#f5f5f5")
  }

  // ====================== 通用条目封装 ======================
  /**
   * @param isRequired 是否显示红色必填*号
   * @param label 左侧标题文字
   * @param value 右侧内容文字
   * @param showDivider 是否显示条目底部分割线
   * @param isEmpty 内容为空，显示灰色占位文字
   */
  @Builder
  InfoItem(isRequired: boolean, label: string, value: string, showDivider: boolean, isEmpty: boolean = false) {
    Column() {
      Row() {
        // 左侧：红色星号 + 标题
        Row({ space: 4 }) {
          if (isRequired) {
            Text("*")
              .fontSize(17)
              .fontColor("#ff3333")
          }
          Text(label)
            .fontSize(17)
            .fontColor("#222222")
        }

        Row(){}.layoutWeight(1)

        // 右侧：内容文字 + 箭头图标
        Row({ space: 8 }) {
          Text(value)
            .fontSize(17)
            .fontColor(isEmpty ? "#cccccc" : "#666666")
          Image($r('app.media.u1158'))
            .width(16)
            .height(16)
        }
      }
      .width('100%')
      .padding({ left: 20, right: 20, top: 18, bottom: 18 })

      // 精准控制
      if (showDivider) {
        Divider()
          .color("#E5E5E5")
          .strokeWidth(1)
          .width('100% ')
          .margin({ left: 20, right: 20 })
      }
    }
  }
}