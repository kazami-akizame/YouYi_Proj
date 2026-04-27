import { BusinessError } from '@kit.BasicServicesKit';
import { Router } from '@kit.ArkUI';

@Entry
@Component
struct Splash {
  @State currentIndex: number = 0;
  private swiperController: SwiperController = new SwiperController();
  private timerId: number = -1;
  private delayTimerId: number = -1; // 新增延迟跳转定时器

  build() {
    Stack() {
      Swiper(this.swiperController) {
        Image($r('app.media.splash_1'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
        Image($r('app.media.splash_2'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
        Image($r('app.media.splash_3'))
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
      }
      .width('100%')
      .height('100%')
      .loop(false) // 不循环，播放到最后一张后停止自动滑动
      .autoPlay(true) // 开启自动播放
      .interval(1500) // 每3秒切换一次
      .duration(400) // 滑动动画时长500ms
      .curve(Curve.EaseInOut) // 平滑缓动曲线
      .index(this.currentIndex)
      .onChange((index: number) => {
        this.currentIndex = index;
        if (index === 2) {
          // 清除之前可能存在的延迟定时器
          if (this.delayTimerId !== -1) {
            clearTimeout(this.delayTimerId);
            this.delayTimerId = -1;
          }
          // 新增2秒延迟跳转
          this.delayTimerId = setTimeout(() => {
            this.toLogin();
          }, 2500);
        }
      })

      // 跳过按钮
      Text("跳过")
        .fontSize(15)
        .backgroundColor("#007aff")
        .fontColor("#fff")
        .padding(10)
        .borderRadius(20)
        .position({ right: 20, top: 40 })
        .onClick(() => {
          this.toLogin();
        })
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      // 可选：添加定时器作为备用跳转（例如10秒后自动跳转）
      this.timerId = setInterval(() => {
        if (this.currentIndex >= 2) {
          this.toLogin();
        }
      }, 12000);
    })
  }

  toLogin() {
    // 清除所有定时器
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    if (this.delayTimerId !== -1) {
      clearTimeout(this.delayTimerId);
      this.delayTimerId = -1;
    }

    // 获取UIContext
    const uiContext = this.getUIContext();
    const router = uiContext.getRouter();

    // 跳转页面并添加错误处理
    router.replaceUrl({ url: 'pages/Login_Register/Login' })
      .then(() => {
        console.info('Succeeded in jumping to Login page.');
      })
      .catch((err: BusinessError) => {
        console.error(`Failed to jump, error code: ${err.code}, message: ${err.message}`);
      });
  }
}