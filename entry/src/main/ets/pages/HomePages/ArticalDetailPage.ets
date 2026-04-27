import { router } from '@kit.ArkUI';

interface CommentItem {
  id: number;
  name: string;
  content: string;
  time: string;
}

interface Topic {
  id: number;
  name: string;
  isAdded: boolean;
}

@Entry
@Component
struct ArticleDetailPage {
  @State commentText: string = '';
  @State commentList: CommentItem[] = [
    {
      id: 1,
      name: '儿科王医生',
      content: '小孩子光脚走路其实有利于触觉发育，只要地面不凉就完全没问题。',
      time: '10分钟前'
    },
    {
      id: 2,
      name: '小小妈妈',
      content: '学习了，一直不敢让孩子光脚，看来是我多虑了！',
      time: '35分钟前'
    },
    {
      id: 3,
      name: '张药师',
      content: '冰激凌偶尔吃一点没关系，不用过度禁止，反而容易引起逆反。',
      time: '1小时前'
    }
  ];

  @State selectedTopics: Topic[] = [];

  aboutToAppear() {
    // 强制读取全局话题
    let data = AppStorage.get<Topic[]>('selectedTopics');
    if (data) {
      this.selectedTopics = data;
    } else {
      this.selectedTopics = [];
    }
  }

  build() {
    Column() {
      this.buildVideoArea();

      Scroll() {
        Column({ space: 16 }) {
          Text('夏天不能光脚丫、不能吃冰激凌？别用养生折腾孩子了')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .width('100%')
            .lineHeight(30);

          Text('看到孩子不穿袜子，光脚在地板上踩，就说会着凉，要穿袜子。\n\n也有不少爷爷奶奶一到夏天就想给宝宝们剃光头，美其名曰散热好，不怕长痱子，这有道理吗？')
            .fontSize(15)
            .fontColor('#444444')
            .lineHeight(26)
            .width('100%');

          Image($r('app.media.u1288'))
            .width('100%')
            .height(200)
            .backgroundColor('#E8F3FF')
            .borderRadius(12)
            .objectFit(ImageFit.Cover);

          Text('看到孩子不穿袜子，光脚在地板上踩，就说会着凉，要穿袜子。')
            .fontSize(15)
            .fontColor('#444444')
            .lineHeight(26)
            .width('100%');

          // ====================== ✅ 话题显示在正文左下角 ======================
          this.buildTopicArea();

          Divider()
            .width('100%')
            .color('#EEEEEE')
            .margin({ top: 10, bottom: 10 });

          this.buildCommentList();
          Blank().height(40);
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16 })
        .backgroundColor(Color.White);
      }
      .layoutWeight(1);

      this.buildCommentBar();
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }

  // ✅ 话题区域：强制靠左（正文左下角）
  @Builder
  buildTopicArea() {
    if (this.selectedTopics.length > 0) {
      Row({ space: 8 }) {
        Text('话题：')
          .fontSize(14)
          .fontColor('#666');

        ForEach(this.selectedTopics, (item: Topic) => {
          Text(`#${item.name}`)
            .fontSize(14)
            .fontColor('#007AFF')
            .backgroundColor('#E8F3FF')
            .padding({ left: 10, right: 10, top: 4, bottom: 4 })
            .borderRadius(15);
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start) // 强制靠左
      .margin({ top: 4, bottom: 10 });
    }
  }

  @Builder
  buildVideoArea(): void {
    Stack({ alignContent: Alignment.TopStart }) {
      Video({
        src: 'https://cdn8.axureshop.com/demo2024/1302024/demo_video.mp4',
        previewUri: $r('app.media.u1158')
      })
        .width('100%')
        .height(240)
        .controls(true)
        .autoPlay(false)
        .objectFit(ImageFit.Cover);

      Row() {
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .fillColor(Color.White)
          .onClick(() => router.back());
        Blank();
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 36 });
    }
    .width('100%');
  }

  // 评论区靠左
  @Builder
  buildCommentList(): void {
    Column({ space: 16 }) {
      Row() {
        Text(`全部评论 ${this.commentList.length}`)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
          .textAlign(TextAlign.Start);
      }
      .width('100%')
      .justifyContent(FlexAlign.Start);

      ForEach(this.commentList, (item: CommentItem) => {
        Column({ space: 6 }) {
          Row() {
            Text(item.name)
              .fontSize(15)
              .fontColor('#007AFF')
              .fontWeight(FontWeight.Medium);
            Text(item.time)
              .fontSize(12)
              .fontColor('#999')
              .margin({ left: 8 });
          }
          .width('100%')
          .justifyContent(FlexAlign.Start);

          Text(item.content)
            .fontSize(15)
            .fontColor('#444')
            .lineHeight(24)
            .width('100%')
            .textAlign(TextAlign.Start);

          Divider()
            .width('100%')
            .color('#EEEEEE')
            .margin({ top: 10 });
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start);
      });
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .margin({ top: 10 });
  }

  @Builder
  buildCommentBar(): void {
    Row() {
      TextInput({ text: this.commentText, placeholder: '发布你的评论' })
        .layoutWeight(1)
        .height(40)
        .borderRadius(20)
        .backgroundColor('#F5F5F5')
        .padding({ left: 16 })
        .onChange((val: string) => {
          this.commentText = val;
        });

      Button('发布')
        .width(70)
        .height(40)
        .borderRadius(20)
        .backgroundColor('#007AFF')
        .fontColor(Color.White)
        .margin({ left: 10 })
        .onClick(() => {
          if (this.commentText.trim()) {
            this.commentList.unshift({
              id: Date.now(),
              name: '我',
              content: this.commentText,
              time: '刚刚'
            });
            this.commentText = '';
          }
        });
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 16, bottom: 24 })
    .backgroundColor(Color.White);
  }
}