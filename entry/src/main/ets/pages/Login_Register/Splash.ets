import router from '@ohos.router';

@Entry
@Component
struct Splash {
  @State currentIndex: number = 0;
  private swiperController: SwiperController = new SwiperController();
  private timerId: number = -1;

  build() {
    Stack() {
      // 轮播图
      Swiper(this.swiperController) {
        Image($r('app.media.splash_1'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
        Image($r('app.media.splash_3'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
        Image($r('app.media.splash_2'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      }
      .width('100%')
      .height('100%')
      .loop(false)
      .autoPlay(true)
      .interval(1500) // 修复：正常3秒切换（你之前写的600=0.6秒过快）
      .duration(400)
      .curve(Curve.EaseInOut)
      .index(this.currentIndex)
      .onChange((index: number) => {
        this.currentIndex = index;
        if (index === 2) {
          this.toLogin();
        }
      })

      // iOS 风格跳过按钮
      Text("跳过")
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .fontColor("#FFFFFF")
        .padding({ left: 16, right: 16, top: 8, bottom: 8 })
        .backgroundColor("#007AFF")
        .borderRadius(20)
        .position({ right: 20, top: 56 })
        .onClick(() => {
          this.toLogin();
        })
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      this.timerId = setInterval(() => {
        if (this.currentIndex >= 2) {
          this.toLogin();
        }
      }, 12000);
    })
  }

  toLogin() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    // 👈 👈 ------------------------------
    //后期跳转真的首页！！！
    router.replaceUrl({ url: 'pages/Login_Register/Login' });
    // 👈 👈 ------------------------------
  }
}