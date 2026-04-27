import { router } from '@kit.ArkUI';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';

// 文章数据模型（已加入 topics 数组）
interface Article {
  id: number;
  title: string;
  author: string;
  hospital: string;
  collect: string;
  like: string;
  comment: string;
  content: string;
  topics: string[]; // ✅ 话题改成数组
}

@Entry
@Component
struct CreatCenter {
  @State articleList: Article[] = [];

  // 后端接口地址
  private readonly baseUrl: string = "http://127.0.0.1:8888/articles";

  onPageShow(): void {
    this.loadArticles();
  }

  // 加载动态文章列表
  loadArticles(): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(this.baseUrl, {
      method: http.RequestMethod.GET
    }).then((res: http.HttpResponse): void => {
      if (res.responseCode === 200) {
        try {
          const data: Article[] = JSON.parse(res.result as string);
          this.articleList = data;
        } catch (e) {
          console.error("JSON解析失败");
        }
      }
    }).catch(() => {
      console.error("请求失败");
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
            router.push({ url: 'pages/HomePages/HomePage' });
          })

        Text('文章中心')
          .fontSize(18)
          .fontWeight(FontWeight.Normal)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Row()
          .width(24)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      // 可滚动页面
      Scroll() {
        Column() {
          // 顶部功能区
          Row({ space: 16 }) {
            // 发布创作
            Column() {
              Image($r('app.media.u3978'))
                .width(58)
                .height(58)
                .margin({ bottom: 3 })

              Text('发布创作')
                .fontSize(16)
                .fontColor('#007AFF')
            }
            .width('30%')
            .height(120)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .onClick(() => {
              promptAction.showDialog({
                title: '请选择发布类型',
                buttons: [
                  { text: '发布文章', color: '#007AFF' },
                  { text: '发布视频', color: '#007AFF' },
                  { text: '取消', color: '#007AFF' }
                ]
              }).then((result: promptAction.ShowDialogSuccessResponse) => {
                if (result.index === 0) {
                  router.push({ url: 'pages/HomePages/EditArticlePage' });
                } else if (result.index === 1) {
                  router.push({ url: 'pages/HomePages/PhotoPickerPage' });
                }
              }).catch(() => {
                console.error("弹窗出错");
              });
            })

            // 我的草稿
            Column() {
              Image($r('app.media.u4012'))
                .width(58)
                .height(58)
                .margin({ bottom: 8 })

              Text('我的草稿')
                .fontSize(16)
                .fontColor('#FF9500')
            }
            .width('30%')
            .height(120)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .onClick(() => {
              router.push({ url: 'pages/HomePages/MyDraftPage' });
            })

            // 我的创作
            Column() {
              Image($r('app.media.u4041'))
                .width(58)
                .height(58)
                .margin({ bottom: 10 })

              Text('我的创作')
                .fontSize(16)
                .fontColor('#34C759')
            }
            .width('30%')
            .height(120)
            .justifyContent(FlexAlign.Center)
            .backgroundColor(Color.White)
            .borderRadius(12)
            .onClick(() => {
              router.push({ url: 'pages/HomePages/MyCreationPage' });
            })
          }
          .width('100%')
          .padding(10)
          .backgroundColor(Color.White)

          Divider()
            .color('#EEEEEE')
            .strokeWidth(10)

          // 写作指南
          Column() {
            Text('写作指南')
              .fontSize(18)
              .fontWeight(FontWeight.Regular)
              .width('100%')
              .margin({ bottom: 16 })

            Row() {
              Text('1.常见问题解答')
                .fontSize(13)
                .layoutWeight(1)

              Text('2.文章撰写规范')
                .fontSize(13)
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 12 })

            Row() {
              Text('3.常见问题解答')
                .fontSize(13)
                .layoutWeight(1)

              Text('4.常见问题解答')
                .fontSize(13)
                .layoutWeight(1)
            }
            .width('100%')
          }
          .width('100%')
          .padding(10)
          .backgroundColor(Color.White)

          Divider()
            .color('#EEEEEE')
            .strokeWidth(6)

          // 案例展示
          Column() {
            Text('案例展示')
              .fontSize(18)
              .fontWeight(FontWeight.Regular)
              .width('100%')
              .margin({ bottom: 16 })

            // 动态渲染
            ForEach(this.articleList, (item: Article) => {
              Row() {
                Column() {
                  Text(item.title)
                    .fontSize(14)
                    .fontColor('#333333')
                    .width('100%')
                    .margin({ bottom: 4 })

                  // ==========================
                  // ✅ 显示 topics 数组（取第一个）
                  // ==========================
                  if (item.topics && item.topics.length > 0) {
                    Text("# " + item.topics[0])
                      .fontSize(12)
                      .fontColor('#007AFF')
                      .width('100%')
                      .margin({ bottom: 8 })
                  }

                  Row() {
                    Image($r('app.media.u4052'))
                      .width(32)
                      .height(32)
                      .borderRadius(16)

                    Text(`${item.author} ${item.hospital}`)
                      .fontSize(14)
                      .fontColor('#666666')
                      .margin({ left: 8 })
                  }
                  .width('100%')
                  .alignItems(VerticalAlign.Center)
                  .margin({ bottom: 8 })

                  Row({ space: 16 }) {
                    Text(item.collect)
                      .fontSize(14)
                      .fontColor('#999999')

                    Text(item.like)
                      .fontSize(14)
                      .fontColor('#999999')

                    Text(item.comment)
                      .fontSize(14)
                      .fontColor('#999999')
                  }
                  .width('100%')
                }
                .layoutWeight(1)
                .padding({ right: 12 })

                Image($r('app.media.u1107'))
                  .width(120)
                  .height(100)
                  .backgroundColor('#E8F3FF')
                  .borderRadius(8)
              }
              .width('100%')
              .padding({ bottom: 20 })
              .onClick(() => {
                router.push({
                  url: 'pages/HomePages/ArticalDetailPage',
                  params: { article: item }
                });
              })
            })

            // 加载提示
            Row({ space: 8 }) {
              LoadingProgress()
                .width(20)
                .height(20)
                .color('#999999')

              Text('数据正在加载中')
                .fontSize(14)
                .fontColor('#999999')
            }
            .width('100%')
            .justifyContent(FlexAlign.Center)
            .margin({ top: 20 })
          }
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
        }
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
  }
}