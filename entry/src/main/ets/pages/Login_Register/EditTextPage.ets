import router from '@ohos.router';

// 路由返回数据类型
interface RouterBackResult {
  key: string;
  value: string;
}

@Entry
@Component
struct EditTextPage {
  @State text: string = '';
  @State fieldKey: string = ''; // 改名：key → fieldKey
  @State title: string = '';
  @State placeholder: string = '';
  @State maxLength: number = 150;

  aboutToAppear() {
    //
    interface RouterParams {
      key?: string;
      current?: string;
      title?: string;
      placeholder?: string;
      maxLength?: number;
    }
    const params = router.getParams() as RouterParams;

    this.fieldKey = params.key ?? '';
    this.text = params.current ?? '';
    this.title = params.title ?? '';
    this.placeholder = params.placeholder ?? '';
    this.maxLength = params.maxLength ?? 150;
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Image($r('app.media.img_4'))
          .width(24)
          .height(24)
          .onClick(() => router.back())
        Text(this.title)
          .fontSize(18)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
        Text('保存')
          .fontSize(16)
          .fontColor('#007DFF')
          .onClick(() => {
            // 将数据存入 AppStorage
            AppStorage.set<RouterBackResult>('routerBackResult', {
              key: this.fieldKey,
              value: this.text
            });
            router.back();
          })
      }
      .width('100%')
      .padding(15)

      // 文本输入框
      TextArea({
        text: this.text,
        placeholder: this.placeholder
      })
        .width('92%')
        .height(250)
        .padding(16)
        .fontSize(15)
        .backgroundColor('#F2F2F7')
        .borderRadius(12)
        .alignSelf(ItemAlign.Center)
        .onChange((val) => {
          if (val.length <= this.maxLength) {
            this.text = val;
          }
        })

      // 字数统计
      Text(`${this.text.length}/${this.maxLength}`)
        .fontSize(14)
        .fontColor('#8E8E93')
        .width('100%')
        .textAlign(TextAlign.End)
        .padding({ right: 16, bottom: 20, top: 8 })

      Blank()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F2F7')
  }
}