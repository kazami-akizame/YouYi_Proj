import { router, UIContext, PromptAction } from '@kit.ArkUI';

// 话题选项
interface TopicItem {
  id: number;
  name: string;
  isChecked: boolean;
}

@Entry
@Component
struct EditVideoPage {
  @State videoTitle: string = '';
  @State videoDesc: string = '';
  @State showTopicDialog: boolean = false;

  // 视频话题
  @State videoTopics: string[] = [];

  // 话题池
  @State allTopics: TopicItem[] = [
    { id: 1, name: "两性健康", isChecked: false },
    { id: 2, name: "心脏健康", isChecked: false },
    { id: 3, name: "脾胃健康", isChecked: false },
    { id: 4, name: "儿童健康", isChecked: false },
    { id: 5, name: "骨健康", isChecked: false },
    { id: 6, name: "老人健康", isChecked: false },
    { id: 7, name: "皮肤健康", isChecked: false },
    { id: 8, name: "泌尿健康", isChecked: false },
  ];

  build() {
    Stack() {
      // 全局布局
      Column() {
        // 顶部导航栏
        this.buildNavBar()

        // 主体滚动区域
        Scroll() {
          Column() {
            // 视频播放器
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

            // 已选话题显示
            if (this.videoTopics.length > 0) {
              Row({ space: 8 }) {
                Text("已选话题：").fontSize(14).fontColor("#666");
                ForEach(this.videoTopics, (t: string) => {
                  Text(`#${t}`)
                    .backgroundColor("#E8F3FF")
                    .fontColor("#007AFF")
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .borderRadius(12);
                });
              }
              .width('100%')
              .padding(16);
            }

            Blank()
              .height(300)
          }
          .width('100%')
          .padding({ left: 20, right: 20, top: 12 })
          .backgroundColor(Color.White)
        }
        .layoutWeight(1)

        // 底部栏
        this.buildBottomBar()
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#FFFFFF')

      // 话题弹窗
      if (this.showTopicDialog) {
        Column() {
          Column() {
            Text("选择话题")
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 16 });

            Scroll() {
              Column({ space: 12 }) {
                ForEach(this.allTopics, (item: TopicItem) => {
                  Text(item.name)
                    .fontSize(16)
                    .fontColor(item.isChecked ? "#007AFF" : "#333")
                    .backgroundColor("#fff")
                    .width("100%")
                    .padding(12)
                    .borderRadius(8)
                    .onClick(() => {
                      const uiContext = this.getUIContext();
                      const prompt = uiContext.getPromptAction();

                      // 🔥 修复：不使用 ... 展开
                      let newArr: TopicItem[] = [];
                      for (let i = 0; i < this.allTopics.length; i++) {
                        let old = this.allTopics[i];
                        if (old.id === item.id) {
                          newArr.push({
                            id: old.id,
                            name: old.name,
                            isChecked: !old.isChecked
                          });
                        } else {
                          newArr.push(old);
                        }
                      }
                      this.allTopics = newArr;
                      this.refreshSelectedTopics();

                      if (item.isChecked) {
                        prompt.showToast({ message: "添加成功" });
                      } else {
                        prompt.showToast({ message: "已取消" });
                      }
                    });
                });
              }
              .width("100%");
            }
            .height(280);

            Button("确定")
              .width('100%')
              .backgroundColor("#007AFF")
              .fontColor("#fff")
              .margin({ top: 16 })
              .onClick(() => {
                this.showTopicDialog = false;
              });
          }
          .width('90%')
          .backgroundColor("#fff")
          .borderRadius(16)
          .padding(20)
        }
        .width('100%')
        .height('100%')
        .backgroundColor("rgba(0,0,0,0.5)")
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
  }

  // 刷新已选话题
  refreshSelectedTopics(): void {
    this.videoTopics = this.allTopics
      .filter((v: TopicItem) => v.isChecked)
      .map((v: TopicItem) => v.name);
  }

  // 顶部导航栏
  @Builder
  buildNavBar() {
    Row() {
      Image($r('app.media.u695'))
        .width(16)
        .height(16)
        .margin({ left: 16 })
        .onClick(() => {
          router.back()
        })

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
          const uiContext: UIContext = this.getUIContext();
          const prompt: PromptAction = uiContext.getPromptAction();
          prompt.showToast({ message: "草稿已保存" });
        })

      // 发布
      Text('发布')
        .fontSize(16)
        .fontColor('#007AFF')
        .margin({ right: 16 })
        .onClick(() => {
          const uiContext: UIContext = this.getUIContext();
          const prompt: PromptAction = uiContext.getPromptAction();
          prompt.showToast({ message: "发布成功" });

          setTimeout(() => {
            router.pushUrl({ url: 'pages/HomePages/MyCreationPage' });
          }, 200);
        })
    }
    .width('100%')
    .height(56)
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
  }

  // 视频播放器
  @Builder
  buildVideoPlayer() {
    Stack({ alignContent: Alignment.Center }) {
      Video({
        src: 'https://cdn8.axureshop.com/demo2024/1306719/demo_video.mp4',
      })
        .width('100%')
        .height(220)
        .borderRadius(12)
        .autoPlay(true)
        .loop(true)
        .muted(true)
        .controls(true)
        .objectFit(ImageFit.Cover)

      Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E5%8F%91%E5%B8%83_%E7%BC%96%E8%BE%91%E8%A7%86%E9%A2%91/u4391.png')
        .width(50)
        .height(50)
        .fillColor('#FFFFFF')
        .opacity(0.8)
    }
    .width('100%')
    .margin({ bottom: 20 })
  }

  // 底部栏
  @Builder
  buildBottomBar() {
    Row() {
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
        this.showTopicDialog = true;
      })

      Blank()

      Text(`${this.videoDesc.length}`)
        .fontSize(14)
        .fontColor('#999999')
        .margin({ right: 20 })
    }
    .width('100%')
    .height(60)
    .backgroundColor(Color.White)
    .margin({ top: 1 })
    .border({ color: '#EEEEEE' })
    .alignItems(VerticalAlign.Center)
  }
}