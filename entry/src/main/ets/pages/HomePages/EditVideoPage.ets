// EditVideoPage.ets
import router from '@ohos.router';

@Entry
@Component
struct EditVideoPage {
  @State videoTitle: string = '';
  @State videoDesc: string = '';

  build() {
    Column() {
      // 1. 顶部导航栏
      this.buildNavBar()

      // 2. 主体滚动内容
      Scroll() {
        Column() {
          // ✅ 视频预览区域（真正视频）
          this.buildVideoPlayer()

          // 标题输入
          TextInput({ text: this.videoTitle, placeholder: '请输入视频标题' })
            .width('100%')
            .height(52)
            .fontSize(16)
            .placeholderColor('#CCCCCC')
            .placeholderFont({ size: 16 })
            .backgroundColor(Color.Transparent)
            .fontColor('#333333')
            .onChange((val: string) => {
              this.videoTitle = val
            })

          // 分割线
          Divider()
            .width('100%')
            .height(1)
            .color('#EEEEEE')

          // 简介输入
          TextArea({ text: this.videoDesc, placeholder: '请输入视频简介' })
            .width('100%')
            .height(180)
            .fontSize(16)
            .placeholderColor('#CCCCCC')
            .placeholderFont({ size: 16 })
            .backgroundColor(Color.Transparent)
            .fontColor('#333333')
            .margin({ top: 12 })
            .onChange((val: string) => {
              this.videoDesc = val
            })

          Blank()
            .height(300)
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 12 })
        .backgroundColor(Color.White)
      }
      .layoutWeight(1)

      // 3. 底部话题栏
      this.buildBottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  // 顶部导航栏
  @Builder
  buildNavBar() {
    Row() {
      // 返回箭头
      Image($r('app.media.u695'))
        .width(16)
        .height(16)
        .margin({ left: 16 })
        .onClick(() => {
          router.back()
        })

      // 页面标题
      Text('编辑视频')
        .fontSize(17)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 保存草稿
      Text('保存草稿')
        .fontSize(16)
        .fontColor('#007AFF')
        .margin({ right: 20 })
        .onClick(() => {

        })

      // 发布
      Text('发布')
        .fontSize(16)
        .fontColor('#007AFF')
        .margin({ right: 16 })
        .onClick(() => {

        })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // ====================== ✅ 真正的视频播放器 ======================
  @Builder
  buildVideoPlayer() {
    Stack({ alignContent: Alignment.Center }) {
      // 视频组件（支持网络视频 + 本地视频）
      Video({
        // 这里可以替换成你的本地视频或网络视频
        src: 'https://cdn8.axureshop.com/demo2024/1306719/demo_video.mp4',
        // 本地视频写法：
        // src: $rawfile('你的视频名.mp4')
      })
        .width('100%')
        .height(220)
        .borderRadius(12)
        .autoPlay(true)        // 自动播放
        .loop(true)            // 循环播放
        .muted(true)           // 默认静音
        .controls(true)        // 显示播放控件
        .objectFit(ImageFit.Cover)

      // 播放按钮（可选）
      Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E5%8F%91%E5%B8%83_%E7%BC%96%E8%BE%91%E8%A7%86%E9%A2%91/u4391.png')
        .width(50)
        .height(50)
        .fillColor('#FFFFFF')
        .opacity(0.8)
    }
    .width('100%')
    .margin({ bottom: 20 })
  }

  // 底部话题+字数栏
  @Builder
  buildBottomBar() {
    Row() {
      // 添加话题入口
      Row() {
        Text('#')
          .fontSize(18)
          .fontColor('#007AFF')
        Text('添加话题')
          .fontSize(16)
          .fontColor('#333333')
          .margin({ left: 4 })
      }
      .margin({ left: 20 })
      .onClick(() => {
        router.pushUrl({ url: 'pages/AddTopicPage' })
      })

      Blank()

      // 字数统计
      Text(`${this.videoDesc.length}`)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ right: 20 })
    }
    .width('100%')
    .height(60)
    .backgroundColor(Color.White)
    .margin({top:1})
    .border({color:'#EEEEEE' })
    .alignItems(VerticalAlign.Center)
  }
}