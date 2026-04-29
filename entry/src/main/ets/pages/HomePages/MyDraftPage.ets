import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import http from '@ohos.net.http';

// 草稿数据结构（明确类型）
interface Draft {
  id?: number;
  title: string;
  editTime: string;
}

@Entry
@Component
struct MyDraftPage {
  // 草稿列表（明确类型）
  @State drafts: Draft[] = [];

  // 接口地址
  private readonly baseUrl: string = "http://10.0.2.2:8080/drafts";

  // 页面显示时加载数据
  onPageShow(): void {
    this.loadDrafts();
  }

  // ========== 1. GET 查询所有草稿（修复版） ==========
  loadDrafts(): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(this.baseUrl, {
      method: http.RequestMethod.GET
    }).then((res: http.HttpResponse): void => {
      if (res.responseCode === 200) {
        try {
          // 明确解析为 Draft[] 类型
          const data: Draft[] = JSON.parse(res.result as string);
          this.drafts = data;
        } catch (e) {
          console.error("JSON解析失败：", JSON.stringify(e));
        }
      }
    }).catch((err: Error): void => {
      console.error("请求失败：", JSON.stringify(err));
    });
  }

  // ========== 2. DELETE 删除草稿（修复版） ==========
  deleteDraft(id: number, index: number): void {
    const req: http.HttpRequest = http.createHttp();
    req.request(`${this.baseUrl}/${id}`, {
      method: http.RequestMethod.DELETE
    }).then((): void => {
      this.drafts.splice(index, 1);
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
            router.pushUrl({ url: 'pages/HomePages/CreatCenter' });
          });

        Text('我的草稿')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center);

        Row()
          .width(20);
      }
      .width('100%')
      .height(46)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White);
      Divider().color("#ddd").strokeWidth(1);

      // 草稿列表
      Column({ space: 0 }) {
        ForEach(this.drafts, (item: Draft, index: number) => {
          Column() {
            Row() {
              Column({ space: 12 }) {
                Text(item.title)
                  .fontSize(14)
                  .fontColor('#333333')
                  .width('100%');
                Text(item.editTime)
                  .fontSize(13)
                  .fontColor('#999999')
                  .width('100%');
              }
              .layoutWeight(1)
              .padding({ right: 12 });

              Image($r('app.media.u981'))
                .width(100)
                .height(80)
                .backgroundColor('#E8F3FF')
                .borderRadius(8);
            }
            .width('100%')
            .padding(16);

            Row({ space: 40 }) {
              Row({ space: 8 }) {
                Image($r('app.media.u4128'))
                  .width(17)
                  .height(17)
                Text('编辑')
                  .fontSize(14)
                  .fontColor('#007AFF');
              }
              .onClick(() => {
                router.pushUrl({ url: 'pages/HomePages/EditArticlePage' });
              });

              Row({ space: 8 }) {
                Image($r('app.media.u4130'))
                  .width(17)
                  .height(17);
                Text('删除')
                  .fontSize(14)
                  .fontColor('#007AFF');
              }
              .onClick(() => {
                promptAction.showDialog({
                  title: '删除确认',
                  message: '删除草稿后无法恢复，确定删除吗？',
                  buttons: [
                    { text: '取消', color: '#999999' },
                    { text: '确定', color: '#007AFF' }
                  ]
                }).then((result) => {
                  if (result.index === 1) {
                    // 非空断言，确保 id 存在
                    this.deleteDraft(item.id!, index);
                  }
                });
              });
            }
            .width('100%')
            .padding({ left: 16, bottom: 13 });

            if (index < this.drafts.length - 1) {
              Divider()
                .width('100%')
                .height(1)
                .color('#F0F0F0');
            }
          }
          .width('100%')
          .backgroundColor(Color.White);
        });

        Text('没有更多了～')
          .fontSize(16)
          .fontColor('#999999')
          .width('100%')
          .textAlign(TextAlign.Center)
          .margin({ top: 10, bottom: 30 });
      }
      .width('100%')
      .layoutWeight(1);
    }
    .width('100%')
    .height('100%');
  }
}