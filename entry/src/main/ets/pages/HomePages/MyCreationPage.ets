import { router } from '@kit.ArkUI';
import http from '@ohos.net.http';
import promptAction from '@ohos.promptAction';

// 文章数据结构（已加入 topics 数组）
interface ArticleItem {
  id?: number;
  title: string;
  author: string;
  hospital: string;
  avatar?: Resource;
  cover?: Resource;
  collect: string;
  like: string;
  comment: string;
  topics: string[]; // ✅ 话题数组
}

@Entry
@Component
struct MyCreationPage {
  @State currentTab: number = 1;
  @State articleList: ArticleItem[] = [];

  // 后端接口地址
  private readonly baseUrl: string = "http://10.0.2.2:8080/articles";

  // 页面打开自动加载数据
  onPageShow(): void {
    this.loadArticles();
  }

  // ========== 1. GET 查询文章列表 ==========
  loadArticles(): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(this.baseUrl, {
      method: http.RequestMethod.GET
    }).then((res: http.HttpResponse): void => {
      if (res.responseCode === 200) {
        try {
          const data: ArticleItem[] = JSON.parse(res.result as string);
          const listWithImage: ArticleItem[] = [];
          for (let i = 0; i < data.length; i++) {
            const item = data[i];
            listWithImage.push({
              id: item.id,
              title: item.title,
              author: item.author,
              hospital: item.hospital,
              avatar: $r('app.media.u4052'),
              cover: $r('app.media.u981'),
              collect: item.collect,
              like: item.like,
              comment: item.comment,
              topics: item.topics || [] // ✅ 加载话题
            });
          }
          this.articleList = listWithImage;
        } catch (e) {
          console.error("JSON解析失败：", JSON.stringify(e));
        }
      }
    }).catch((err: Error): void => {
      console.error("请求失败：", JSON.stringify(err));
    });
  }

  // ========== 2. DELETE 删除文章 ==========
  deleteArticle(id: number, index: number): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(`${this.baseUrl}/${id}`, {
      method: http.RequestMethod.DELETE
    }).then((): void => {
      this.articleList.splice(index, 1);
      promptAction.showToast({ message: "删除成功" });
    }).catch((err: Error): void => {
      console.error("删除失败：", JSON.stringify(err));
    });
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695'))
          .width(16)
          .height(16)
          .onClick(() => {
            router.push({ url: 'pages/HomePages/CreatCenter' });
          });

        Text('我的创作')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Row()
          .width(24);
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White);

      // 标签栏
      Row() {
        Column() {
          Text('视频')
            .fontSize(18)
            .fontColor('#333333');
          if (this.currentTab === 0) {
            Row().width(60).height(3).backgroundColor('#007AFF');
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => { this.currentTab = 0 });

        Column() {
          Text('文章')
            .fontSize(18)
            .fontColor('#333333');
          if (this.currentTab === 1) {
            Row().width(60).height(3).backgroundColor('#007AFF');
          }
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
        .onClick(() => { this.currentTab = 1 });
      }
      .width('100%')
      .backgroundColor(Color.White);

      // 内容区域
      Column() {
        if (this.currentTab === 0) {
          // 视频卡片
          Column() {
            Text('夏天不能光脚丫、不能吃冰激凌？别用养生折腾孩子了')
              .fontSize(18)
              .fontColor('#333333')
              .width('100%')
              .margin({ bottom: 16 });

            Row() {
              Image($r('app.media.u4052'))
                .width(36)
                .height(36)
                .borderRadius(18);
              Text('张清北 北京协和医院')
                .fontSize(16)
                .fontColor('#666666')
                .margin({ left: 10 });
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
            .margin({ bottom: 20 });

            Stack() {
              Image($r('app.media.u4006'))
                .width('100%')
                .height(240)
                .backgroundColor('#E8F3FF')
                .borderRadius(8);
              Image($r('app.media.u4092'))
                .width(80)
                .height(80);
            }
            .margin({ bottom: 16 });

            Row({ space: 20 }) {
              Text('95收藏').fontSize(14).fontColor('#999');
              Text('10点赞').fontSize(14).fontColor('#999');
              Text('34评论').fontSize(14).fontColor('#999');
            }
          }
          .padding(16)
          .backgroundColor(Color.White)
          .onClick(() => {
            router.push({ url: 'pages/HomePages/ArticalDetailPage' })
          });
        } else {
          // 动态文章列表
          List() {
            ForEach(this.articleList, (item: ArticleItem, index) => {
              ListItem() {
                Column({ space: 12 }) {
                  Row() {
                    Column({ space: 12 }) {
                      Text(item.title)
                        .fontSize(14)
                        .fontColor('#333')
                        .width('100%');

                      // ==========================
                      // ✅ 显示话题（取第一个）
                      // ==========================
                      if (item.topics && item.topics.length > 0) {
                        Text("# " + item.topics[0])
                          .fontSize(12)
                          .fontColor('#007AFF')
                          .width('100%');
                      }

                      Row() {
                        Image(item.avatar ?? $r('app.media.u4052'))
                          .width(36)
                          .height(26)
                          .borderRadius(18);
                        Text(`${item.author} ${item.hospital}`)
                          .fontSize(13)
                          .fontColor('#666')
                          .margin({ left: 10 });
                      }

                      Row({ space: 20 }) {
                        Text(item.collect).fontSize(12).fontColor('#999');
                        Text(item.like).fontSize(12).fontColor('#999');
                        Text(item.comment).fontSize(12).fontColor('#999');
                      }
                    }
                    .layoutWeight(1);

                    Image(item.cover ?? $r('app.media.u981'))
                      .width(90)
                      .height(80)
                      .backgroundColor('#E8F3FF')
                      .borderRadius(8);
                  }
                  .padding(16)
                  .onClick(() => {
                    router.push({
                      url: 'pages/HomePages/ArticalDetailPage',
                      params: { article: item }
                    });
                  })

                  if (index < this.articleList.length - 1) {
                    Divider().width('100%').height(1).color('#F0F0F0');
                  }
                }
                .backgroundColor(Color.White);
              }
            })
          }
          .width('100%');
        }

        Text('没有更多了～')
          .fontSize(16)
          .fontColor('#999')
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ top: 40, bottom: 40 });
      }
      .width('100%');
    }
    .layoutWeight(1)
    .backgroundColor(Color.White);
  }
}