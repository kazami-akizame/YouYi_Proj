import { router } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';

// 文章主数据结构
interface Article {
  id: number;
  title: string;
  author: string;
  hospital: string;
  collect: string;
  like: string;
  comment: string;
  content: string;
  topics: string[]; // ✅ 改为 topics 数组
}

// 路由参数
interface RouterParams {
  article?: Article;
}

// 推荐文章
interface RecommendArticle {
  id: number;
  title: string;
  author: string;
  hospital: string;
  avatar: Resource;
  cover: Resource;
  collect: string;
  like: string;
  comment: string;
  content: string;
  topics: string[]; // ✅ 改为 topics 数组
}

// 评论
interface Comment {
  username: string;
  time: string;
  content: string;
}

@Entry
@Component
struct ArticalDetailPage {
  @State currentArticle: Article | null = null;
  @State recommendList: RecommendArticle[] = [];

  private commentList: Comment[] = [
    {
      username: '匿名用户555',
      time: '2018-10-15 10:15',
      content: '说的很清晰，谢谢张医生的分享，期待张医生分享更多内容！'
    },
    {
      username: '匿名用户555',
      time: '2018-10-15 10:15',
      content: '说的很清晰，谢谢张医生的分享，期待张医生分享更多内容！'
    },
    {
      username: '匿名用户555',
      time: '2018-10-15 10:15',
      content: '说的很清晰，谢谢张医生的分享，期待张医生分享更多内容！'
    }
  ];

  private readonly articlesUrl: string = "http://127.0.0.1:8888/articles";

  onPageShow(): void {
    const params = router.getParams() as RouterParams;
    if (params && params.article) {
      this.currentArticle = params.article;
    }
    this.loadRecommendArticles();
  }

  // 加载推荐文章（动态）
  loadRecommendArticles(): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(this.articlesUrl, {
      method: http.RequestMethod.GET
    }).then((res: http.HttpResponse): void => {
      if (res.responseCode === 200) {
        try {
          const data: Article[] = JSON.parse(res.result as string);
          const list: RecommendArticle[] = [];
          for (let i = 0; i < data.length; i++) {
            const item = data[i];
            list.push({
              id: item.id,
              title: item.title,
              author: item.author,
              hospital: item.hospital,
              avatar: $r('app.media.u4052'),
              cover: $r('app.media.u981'),
              collect: item.collect,
              like: item.like,
              comment: item.comment,
              content: item.content,
              topics: item.topics || [] // ✅ 读取 topics 数组
            });
          }
          this.recommendList = list;
        } catch (e) {}
      }
    }).catch(() => {});
  }

  shareArticle(): void {
    promptAction.showToast({ message: '分享成功', duration: 2000 });
  }

  editArticle(): void {
    if (this.currentArticle) {
      router.push({
        url: 'pages/HomePages/EditArticlePage',
        params: { article: this.currentArticle }
      });
    }
  }

  deleteArticle(): void {
    if (!this.currentArticle) return;

    promptAction.showDialog({
      title: '确认删除',
      message: '确定要删除这篇文章吗？',
      buttons: [
        { text: '取消', color: '#999999' },
        { text: '删除', color: '#ff0000' }
      ]
    }).then((result) => {
      if (result.index === 1) {
        const req = http.createHttp();
        req.request(`${this.articlesUrl}/${this.currentArticle!.id}`, {
          method: http.RequestMethod.DELETE
        }).then(() => {
          promptAction.showToast({ message: '删除成功' });
          router.back();
        });
      }
    });
  }

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: '分享' }).onClick(() => this.shareArticle());
      MenuItem({ content: '编辑' }).onClick(() => this.editArticle());
      MenuItem({ content: '删除' }).onClick(() => this.deleteArticle());
    }
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .onClick(() => {
            router.back();
          })

        Text('文章详情')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Image($r('app.media.u4211'))
          .width(25)
          .height(10)
          .objectFit(ImageFit.Contain)
          .bindMenu(this.menuBuilder);
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White);

      Scroll() {
        Column() {
          if (this.currentArticle) {
            Column({ space: 16 }) {
              Text(this.currentArticle.title)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .width('100%');

              Text(this.currentArticle.content)
                .fontSize(13)
                .fontColor('#666666')
                .lineHeight(24)
                .width('100%');

              Image($r('app.media.u981'))
                .width('100%')
                .height(200)
                .backgroundColor('#E8F3FF')
                .borderRadius(12);

              // ==========================
              // ✅ 显示话题（支持多个）
              // ==========================
              Row({ space: 8 }) {
                if (this.currentArticle.topics && this.currentArticle.topics.length > 0) {
                  ForEach(this.currentArticle.topics, (tagName: string) => {
                    Text("# " + tagName)
                      .fontSize(16)
                      .fontColor('#007AFF');
                  })
                }
              }
            }
            .width('100%')
            .padding(16);
          }

          Divider()
            .width('100%')
            .height(10)
            .color('#F5F5F5');

          // 推荐阅读
          Column() {
            Blank(10);
            Text('推荐阅读')
              .fontSize(18)
              .width('100%')
              .padding({ left: 16 });

            ForEach(this.recommendList, (item: RecommendArticle) => {
              Column({ space: 12 }) {
                Row() {
                  Column({ space: 8 }) {
                    Text(item.title)
                      .fontSize(16)
                      .fontColor('#333333')
                      .width('100%');

                    // 推荐列表也显示话题
                    if (item.topics && item.topics.length > 0) {
                      Text("# " + item.topics[0])
                        .fontSize(12)
                        .fontColor('#007AFF');
                    }

                    Row({ space: 8 }) {
                      Image(item.avatar)
                        .width(32)
                        .height(32)
                        .borderRadius(16);
                      Text(`${item.author} ${item.hospital}`)
                        .fontSize(13)
                        .fontColor('#666666');
                    }

                    Row({ space: 16 }) {
                      Text(item.collect).fontSize(10).fontColor('#999999');
                      Text(item.like).fontSize(10).fontColor('#999999');
                      Text(item.comment).fontSize(10).fontColor('#999999');
                    }
                  }
                  .layoutWeight(1);

                  Image(item.cover)
                    .width(100)
                    .height(80)
                    .backgroundColor('#E8F3FF')
                    .borderRadius(8);
                }
                .width('100%')
                .onClick(() => {
                  router.push({
                    url: 'pages/HomePages/ArticalDetailPage',
                    params: { article: item }
                  });
                });

                Divider()
                  .width('100%')
                  .height(1)
                  .color('#F0F0F0');
              }
              .width('100%')
              .padding(10);
            });
          }
          .width('100%')
          .backgroundColor(Color.White);

          Blank(10);

          // 评论区
          Column() {
            Text(`评论（${this.commentList.length}）`)
              .fontSize(18)
              .width('100%')
              .margin({ bottom: 14 });

            ForEach(this.commentList, (item: Comment) => {
              Column({ space: 8 }) {
                Row() {
                  Text(item.username)
                    .fontSize(16)
                    .fontColor('#333333')
                    .layoutWeight(1);
                  Text(item.time)
                    .fontSize(14)
                    .fontColor('#999999');
                }

                Text(item.content)
                  .fontSize(14)
                  .fontColor('#555555')
                  .lineHeight(22)
                  .width('100%');

                Divider()
                  .width('100%')
                  .height(1)
                  .color('#F0F0F0')
                  .margin({ top: 12 });
              }
              .width('100%')
              .padding({ left: 16, right: 16, bottom: 16 });
            });

            Text('已加载全部')
              .fontSize(14)
              .fontColor('#999999')
              .width('100%')
              .textAlign(TextAlign.Center)
              .margin({ top: 16, bottom: 30 });
          }
          .width('100%')
          .backgroundColor(Color.White);
        }
        .width('100%');
      }
      .layoutWeight(1);

      // 底部输入框
      Row() {
        TextInput({ placeholder: '发布你的评论' })
          .layoutWeight(1)
          .height(40)
          .borderRadius(20)
          .backgroundColor('#F5F5F5')
          .padding({ left: 16, right: 16 });

        Button('发布')
          .width(80)
          .height(40)
          .borderRadius(20)
          .backgroundColor('#007AFF')
          .margin({ left: 12 });
      }
      .width('100%')
      .padding(16)
      .backgroundColor(Color.White);
    }
    .width('100%')
    .height('100%');
  }
}