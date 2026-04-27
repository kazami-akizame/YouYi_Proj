import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

interface Topic {
  id: number;
  name: string;
  followers: number;
  articles: number;
  isAdded: boolean;
}

@Entry
@Component
struct AddTopicPage {
  @State searchKeyword: string = '';

  @State topicList: Topic[] = [
    { id: 1, name: '两性健康', followers: 300, articles: 700, isAdded: false },
    { id: 2, name: '心脏健康', followers: 300, articles: 700, isAdded: false },
    { id: 3, name: '脾胃健康', followers: 300, articles: 700, isAdded: false },
    { id: 4, name: '儿童健康', followers: 300, articles: 700, isAdded: false },
    { id: 5, name: '骨健康', followers: 300, articles: 700, isAdded: false },
    { id: 6, name: '老人健康', followers: 300, articles: 700, isAdded: false },
    { id: 7, name: '皮肤健康', followers: 300, articles: 700, isAdded: false },
    { id: 8, name: '泌尿健康', followers: 300, articles: 700, isAdded: false },
  ];

  build() {
    Column() {
      Row() {
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .margin({ left: 16, bottom: 5 })
          .onClick(() => router.back());

        Text('添加话题')
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Button('完成')
          .fontSize(16)
          .fontColor('#007AFF')
          .backgroundColor(Color.Transparent)
          .margin({ right: 16 })
          .onClick(() => {
            // 🔥 只存字符串数组！！！和文章接口完全匹配
            let selectedNames: string[] = this.topicList
              .filter((item: Topic) => item.isAdded)
              .map((item: Topic) => item.name);

            AppStorage.set<string[]>('articleTopics', selectedNames);
            router.back();
          });
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Center);

      Row() {
        Image($r('sys.symbol.magnifyingglass'))
          .width(20)
          .height(20)
          .fillColor('#999999')
          .margin({ left: 12 });

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
          });
      }
      .width('94%')
      .height(40)
      .backgroundColor('#F5F5F5')
      .borderRadius(20)
      .margin({ top: 12, bottom: 12 });

      List() {
        ForEach(this.topicList, (item: Topic) => {
          ListItem() {
            Row() {
              Image($r('app.media.u4429'))
                .width(50)
                .height(50)
                .backgroundColor('#E8F3FF')
                .fillColor('#007AFF')
                .borderRadius(25)
                .margin({ left: 16 });

              Column() {
                Text(item.name)
                  .fontSize(16)
                  .fontColor('#333333');
                Text(`${item.followers}人关注 ${item.articles}篇文章`)
                  .fontSize(13)
                  .fontColor('#999999')
                  .margin({ top: 4 });
              }
              .layoutWeight(1)
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start);

              Button(item.isAdded ? "已添加" : "添加")
                .width(70)
                .height(30)
                .backgroundColor(item.isAdded ? '#E0E0E0' : Color.White)
                .fontColor(item.isAdded ? '#999999' : '#007AFF')
                .border({ width: 1, color: item.isAdded ? '#E0E0E0' : '#007AFF' })
                .borderRadius(15)
                .fontSize(14)
                .enabled(!item.isAdded)
                .margin({ right: 16 })
                .onClick(() => {
                  if (!item.isAdded) {
                    item.isAdded = true;
                    this.topicList = [...this.topicList];
                    promptAction.showToast({ message: '已添加', duration: 1500 });
                  }
                });
            }
            .width('100%')
            .height(80)
            .alignItems(VerticalAlign.Center);
          }
        }, (item: Topic) => item.id.toString());
      }
      .width('100%')
      .layoutWeight(1)
      .divider({ strokeWidth: 1, color: '#F0F0F0' });

      Row() {
        Text('数据正在加载中')
          .fontSize(12)
          .fontColor('#999999');
      }
      .height(50)
      .justifyContent(FlexAlign.Center);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }
}