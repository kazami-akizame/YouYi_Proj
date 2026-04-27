import { BusinessError } from '@kit.BasicServicesKit';
import { Router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  build() {
    Column() {
    }
    .width('100%')
    .height('100%')
    .onAppear(() => {
      // 获取UIContext
      const uiContext = this.getUIContext();
      const router = uiContext.getRouter();

      // 跳转页面并添加错误处理
      router.replaceUrl({ url: 'pages/Login_Register/Splash' })
        .then(() => {
          console.info('Succeeded in jumping to Splash page.');
        })
        .catch((err: BusinessError) => {
          console.error(`Failed to jump, error code: ${err.code}, message: ${err.message}`);
        });
    })
  }
}