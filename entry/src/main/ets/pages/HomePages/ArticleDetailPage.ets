// ArticleDetailPage.ets
import { router } from '@kit.ArkUI';

// 评论数据结构
interface CommentItem {
  id: number;
  name: string;
  content: string;
  time: string;
}

@Entry
@Component
struct ArticleDetailPage {
  @State commentText: string = '';
  // 评论列表数据
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
      content: '冰激凌偶尔吃一点没关系，不用过度禁止，反而容易引起孩子逆反。',
      time: '1小时前'
    }
  ];

  build() {
    Column() {
      // 顶部视频区域
      this.buildVideoArea();

      // 正文内容 + 评论区
      Scroll() {
        Column({ space: 16 }) {
          // 文章标题
          Text('夏天不能光脚丫、不能吃冰激凌？别用养生折腾孩子了')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1A1A1A')
            .width('100%')
            .lineHeight(30);

          // 正文第一段
          Text('看到孩子不穿袜子，光脚在地板上踩，就说会着凉，要穿袜子。\n\n也有不少爷爷奶奶一到夏天就想给宝宝们剃光头，美其名曰散热好，不怕长痱子，这有道理吗？老人们还会担心孩子夏天拉肚子，看到孩子吃冰激凌就冲上去夺过来。老人的执着有道理吗？我们来详细聊一聊。')
            .fontSize(15)
            .fontColor('#444444')
            .lineHeight(26)
            .width('100%');

          // 图片
          Image($r('app.media.u1288'))
            .width('100%')
            .height(200)
            .backgroundColor('#E8F3FF')
            .borderRadius(12)
            .objectFit(ImageFit.Cover);

          // 正文第二段
          Text('看到孩子不穿袜子，光脚在地板上踩，就说会着凉，要穿袜子。\n\n也有不少爷爷奶奶一到夏天就想给宝宝们剃光头，美其名曰散热')
            .fontSize(15)
            .fontColor('#444444')
            .lineHeight(26)
            .width('100%');

          // ====================== ✅ 正文与评论之间的分割线 ======================
          Divider()
            .width('100%')
            .height(1)
            .color('#EEEEEE')
            .margin({ top: 10, bottom: 10 });

          // 评论列表区域
          this.buildCommentList();

          // 底部留白
          Blank().height(40);
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 16 })
        .backgroundColor(Color.White);
      }
      .layoutWeight(1);

      // 底部评论发布栏
      this.buildCommentBar();
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White);
  }

  // 顶部视频区域
  @Builder
  buildVideoArea(): void {
    Stack({ alignContent: Alignment.TopStart }) {
      // 视频
      Video({
        src: 'https://cdn8.axureshop.com/demo2024/1306719/demo_video.mp4',
        previewUri: $r('app.media.u1158')
      })
        .width('100%')
        .height(240)
        .controls(true)
        .autoPlay(false)
        .objectFit(ImageFit.Cover);

      // 顶部按钮
      Row() {
        // 返回按钮
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .fillColor(Color.White)
          .onClick(() => {
            router.back();
          });

        Blank();

        Row({ space: 3 }) {
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E8%A7%86%E9%A2%91/%E8%AF%A6%E6%83%85/u4265.png')
            .width(10)
            .height(10)
            .fillColor(Color.White);
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E8%A7%86%E9%A2%91/%E8%AF%A6%E6%83%85/u4265.png')
            .width(10)
            .height(10)
            .fillColor(Color.White);
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E8%A7%86%E9%A2%91/%E8%AF%A6%E6%83%85/u4265.png')
            .width(10)
            .height(10)
            .fillColor(Color.White);
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 36 });
    }
    .width('100%');
  }

  // 评论列表（靠左显示）
  @Builder
  buildCommentList(): void {
    Column({ space: 16 }) {
      // 评论标题（靠左）
      Row() {
        Text(`全部评论 ${this.commentList.length}`)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333')
          .textAlign(TextAlign.Start);
      }
      .width('100%')
      .justifyContent(FlexAlign.Start);

      // 循环渲染评论（全部强制靠左）
      ForEach(this.commentList, (item: CommentItem) => {
        Column({ space: 6 }) {
          // 用户名 + 时间
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

          // 评论内容（靠左）
          Text(item.content)
            .fontSize(15)
            .fontColor('#444')
            .lineHeight(24)
            .width('100%')
            .textAlign(TextAlign.Start);

          // 分割线
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

  // 底部评论发布栏
  @Builder
  buildCommentBar(): void {
    Row() {
      TextInput({ text: this.commentText, placeholder: '发布你的评论' })
        .layoutWeight(1)
        .height(40)
        .borderRadius(20)
        .backgroundColor('#F5F5F5')
        .padding({ left: 16, right: 16 })
        .fontSize(14)
        .placeholderColor('#BBBBBB')
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
          router.pushUrl({ url: 'pages/CommentSuccessPage' });
        });
    }
    .width('100%')
    .padding({ left: 20, right: 20, top: 16, bottom: 24 })
    .backgroundColor(Color.White)
    .border({ color: '#EEEEEE' })
    .margin({ top: 1 });
  }
}