// AddTopicPage.ets
import router from '@ohos.router';

@Entry
@Component
struct AddTopicPage {
  @State searchKeyword: string = '';

  @State topicList: Topic[] = [
    { id: 1, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 2, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 3, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 4, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 5, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 6, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 7, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 8, name: '两性健康', followers: 300, articles: 700, isAdded: false },
  ];

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        // 返回按钮
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .margin({ left: 16 ,bottom:5})
          .onClick(() => {
            router.back(); // 返回上一页
          })

        // 页面标题
        Text('添加话题')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // ✅ 修改为可点击完成按钮，预留跳转逻辑
        Button('完成')
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .margin({ right: 16 })
          .onClick(() => {
            // 后续在这里写点击跳转逻辑
            router.pushUrl({url: 'pages/HomePages/EditArticlePage'})
            console.log('点击完成，保存选中话题并跳转');
          })
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Center)

      // 搜索框
      Row() {
        Image($r('sys.symbol.magnifyingglass'))
          .width(20)
          .height(20)
          .margin({ left: 12 })
          .fillColor('#999999')
        TextInput({ text: this.searchKeyword, placeholder: '请输入话题' })
          .layoutWeight(1)
          .height(40)
          .fontSize(14)
          .placeholderFont({ size: 14 })
          .placeholderColor('#999999')
          .backgroundColor(Color.Transparent)
          .margin({ left: 8 })
          .onChange((val: string) => {
            this.searchKeyword = val;
          })
      }
      .width('94%')
      .height(40)
      .backgroundColor('#F5F5F5')
      .borderRadius(20)
      .margin({ top: 12, bottom: 12 })

      // 话题列表
      List() {
        ForEach(this.topicList, (item: Topic) => {
          ListItem() {
            Row() {
              // ✅ 修改头像占位图，匹配原图圆形浅蓝底+三角图标
              Image($r('app.media.u4429'))
                .width(50)
                .height(50)
                .backgroundColor('#E8F3FF')
                .fillColor('#007AFF')
                .borderRadius(25)
                .margin({ left: 16 })

              Column() {
                Text(item.name)
                  .fontSize(16)
                  .fontColor('#333333')
                  .fontWeight(FontWeight.Normal)
                Text(`${item.followers}人关注 ${item.articles}篇文章`)
                  .fontSize(13)
                  .fontColor('#999999')
                  .margin({ top: 4 })
              }
              .layoutWeight(1)
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start)

              // ✅ 修正添加按钮样式，匹配原图白底蓝色边框
              Button(item.isAdded ? "已添加" : "添加")
                .width(70)
                .height(30)
                .backgroundColor(Color.White)
                .fontColor('#007AFF')
                .border({ width: 1, color: '#007AFF' })
                .borderRadius(15)
                .fontSize(14)
                .enabled(!item.isAdded)
                .margin({ right: 16 })
                .onClick(() => {
                  item.isAdded = true;
                })
            }
            .width('100%')
            .height(80)
            .alignItems(VerticalAlign.Center)
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#F0F0F0' })

      // 底部加载提示
      Row() {
        Text('数据正在加载中')
          .fontSize(12)
          .fontColor('#999999')
      }
      .height(50)
      .justifyContent(FlexAlign.Center)

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }
}

interface Topic {
  id: number;
  name: string;
  followers: number;
  articles: number;
  isAdded: boolean;
}