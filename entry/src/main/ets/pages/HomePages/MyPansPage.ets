// MyFansPage.ets
import router from '@ohos.router'; // 修正导入路径

// 粉丝数据模型
interface FanItem {
  name: string;
  gender: string;
  age: number;
  phone: string;
}

@Entry
@Component
struct MyFansPage {
  // 模拟粉丝列表数据（共8个）
  @State fanList: FanItem[] = [
    { name: '吴珊珊', gender: '女', age: 23, phone: '188****8766' },
    { name: '张明', gender: '男', age: 28, phone: '139****1234' },
    { name: '李华', gender: '女', age: 25, phone: '136****5678' },
    { name: '王芳', gender: '女', age: 30, phone: '159****9012' },
    { name: '刘强', gender: '男', age: 32, phone: '158****3456' },
    { name: '陈晓', gender: '女', age: 27, phone: '150****7890' },
    { name: '赵雷', gender: '男', age: 29, phone: '137****2345' },
    { name: '周梅', gender: '女', age: 26, phone: '152****6789' },
  ];

  build() {
    Column() {
      // 顶部导航栏
      this.buildNavBar()

      // 粉丝总数标题栏
      Row() {
        Text(`共${this.fanList.length}个粉丝`)
          .fontSize(16)
          .fontColor('#333333')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .padding({ left: 20, top: 16, bottom: 12 })
      .backgroundColor('#F5F5F5')

      // 粉丝列表
      List() {
        ForEach(this.fanList, (item: FanItem) => {
          ListItem() {
            Row() {
              // 头像
              Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1219.png')
                .width(52)
                .height(52)
                .borderRadius(26)
                .objectFit(ImageFit.Cover)  // 添加图片填充模式
                .backgroundColor('#E8F3FF')

              // 姓名+性别年龄
              Column() {
                Text(item.name)
                  .fontSize(16)
                  .fontColor('#007AFF')
                Text(`${item.gender} ${item.age}岁`)
                  .fontSize(13)
                  .fontColor('#666666')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start)

              // 右侧脱敏手机号
              Text(item.phone)
                .fontSize(14)
                .fontColor('#999999')
                .margin({ right: 20 })
            }
            .width('100%')
            .height(72)
            .padding({ left: 20, right: 20 })
            .alignItems(VerticalAlign.Center)
          }
        })

        // 底部无更多提示
        ListItem() {
          Text('没有更多了~')
            .fontSize(14)
            .fontColor('#BBBBBB')
            .width('100%')
            .textAlign(TextAlign.Center)
            .padding({ top: 30, bottom: 40 })
        }
      }
      .layoutWeight(1)
      .width('100%')
      .divider({
        strokeWidth: 1,
        color: '#EEEEEE',
        startMargin: 20,
        endMargin: 20
      })
      .backgroundColor(Color.White)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }


  // 顶部导航栏组件
  @Builder
  buildNavBar() {
    Row() {
      // 返回按钮（使用系统资源）
      Image($r('app.media.u695'))
        .width(16)
        .height(16)
        .margin({ left: 16 })
        .fillColor(Color.Black)
        .onClick(() => {
          router.back();
        })

      // 页面标题
      Text('我的粉丝')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 右侧占位，保证标题居中
      Text('')
        .width(24)
        .margin({ right: 16 })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }
}