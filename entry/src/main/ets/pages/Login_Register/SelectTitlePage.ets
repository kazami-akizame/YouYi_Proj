import router from '@ohos.router';

// 路由返回数据类型
interface RouterBackResult {
  key: string;
  value: string;
}

const titles = ['主任医师', '副主任医师', '主治医师', '住院医师'];

@Entry
@Component
struct SelectTitlePage {
  @State fieldKey: string = '';
  @State title: string = '';

  aboutToAppear() {
    interface RouterParams {
      key?: string;
      title?: string;
    }
    const params = router.getParams() as RouterParams;
    this.fieldKey = params.key ?? '';
    this.title = params.title ?? '';
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.img_4'))
          .width(24)
          .height(24)
          .onClick(() => router.back())
        Text(this.title)
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
      }
      .width('100%')
      .padding(15)

      List() {
        ForEach(titles, (title: string) => {
          ListItem() {
            Column() {
              Text(title)
                .width('100%')
                .padding(18)
                .onClick(() => {
                  // 将数据存入 AppStorage
                  AppStorage.set<RouterBackResult>('routerBackResult', {
                    key: this.fieldKey,
                    value: title
                  });
                  router.back();
                })
              Divider().color('#EEE')
            }
          }
        })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFF')
  }
}