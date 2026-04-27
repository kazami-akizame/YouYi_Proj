import { router, UIContext, PromptAction } from '@kit.ArkUI';
import http from '@ohos.net.http';

// 文章接口（和数据库完全一致）
interface ArticleItem {
  id?: number;
  title: string;
  content: string;
  topics: string[];
  author: string;
  hospital: string;
  collect: string;
  like: string;
  comment: string;
}

// 草稿接口
interface DraftItem {
  id?: number;
  title: string;
  content: string;
  topics: string[];
  editTime: string;
}

// 话题选项
interface TopicItem {
  id: number;
  name: string;
  isChecked: boolean;
}

@Entry
@Component
struct EditArticlePage {
  @State title: string = '';
  @State content: string = '';
  @State showTopicDialog: boolean = false;

  // 文章话题
  @State articleTopics: string[] = [];

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

  private readonly baseUrl: string = 'http://127.0.0.1:8888/articles';
  private readonly draftUrl: string = 'http://127.0.0.1:8888/drafts';

  build() {
    Stack() {
      // 全局垂直布局
      Column() {
        // 顶部导航栏
        this.buildNavBar();

        // 中间可滚动编辑区域（占满剩余高度）
        Scroll() {
          Column() {
            // 标题输入框
            TextInput({ text: this.title, placeholder: '请输入文章标题' })
              .width('100%')
              .height(50)
              .fontSize(16)
              .borderRadius(8)
              .backgroundColor('#f5f5f5')
              .padding({ left: 12, right: 12 })
              .margin({ top: 10, bottom: 10, left: 16, right: 16 })
              .onChange((v: string) => this.title = v);

            Divider().width('100%').color('#eee').margin({ left:16,right:16 });

            // 内容输入框
            TextArea({ text: this.content, placeholder: '请输入文章内容' })
              .width('100%')
              .height(400)
              .padding(12)
              .fontSize(16)
              .borderRadius(8)
              .backgroundColor('#f5f5f5')
              .margin({ top: 10, left: 16, right: 16 })
              .onChange((v: string) => this.content = v);

            // 已选话题显示
            if (this.articleTopics.length > 0) {
              Row({ space: 8 }) {
                Text("已选话题：").fontSize(14).fontColor("#666");
                ForEach(this.articleTopics, (t: string) => {
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
          }
          .height(700)
          .width('100%');
        }
        .layoutWeight(1) // 核心：自动占满中间剩余空间
        .margin({top:0});

        // 底部栏【永久固定屏幕最底部】
        this.buildBottomBar();

      }
      .width('100%')
      .height('100%')
      .backgroundColor('#fff');

      // 话题弹窗（竖向多行排列）
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
                    // ✅ 选中变蓝色
                    .fontColor(item.isChecked ? "#007AFF" : "#333")
                    .backgroundColor("#fff")
                    .width("100%")
                    .padding(12)
                    .borderRadius(8)
                    .onClick(() => {
                      const uiContext = this.getUIContext();
                      const prompt = uiContext.getPromptAction();

                      item.isChecked = !item.isChecked;
                      this.refreshSelectedTopics();

                      // ✅ 弹出提示
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
    this.articleTopics = this.allTopics
      .filter((v: TopicItem) => v.isChecked)
      .map((v: TopicItem) => v.name);
  }

  // 导航栏
  @Builder
  buildNavBar(): void {
    Row() {
      Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%A9%BA%E6%95%B0%E6%8D%AE/u695.png')
        .width(16)
        .height(16)
        .margin(16)
        .onClick(() => router.back());

      Text('编辑文章').fontSize(17).fontWeight(FontWeight.Medium);

      Blank();

      // 保存草稿
      Text('保存草稿')
        .fontColor('#007AFF')
        .margin({ right: 16 })
        .onClick(() => {
          this.saveDraft();
        });

      // 发布
      Text('发布')
        .fontColor('#007AFF')
        .margin({ right: 16 })
        .onClick(() => {
          this.publishArticle();
        });
    }
    .width('100%')
    .height(45)
    .backgroundColor('#fff');
  }

  // 底部栏
  @Builder
  buildBottomBar(): void {
    Row() {
      // 图片按钮
      Text('📷 图片')
        .margin({left:16, top:16, bottom:16})
        .fontSize(16)
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/PhotoPickerPage' });
        });

      // 话题按钮
      Text('# 话题')
        .fontSize(16)
        .fontColor('#007AFF')
        .margin({left:20, top:16, bottom:16})
        .onClick(() => {
          this.showTopicDialog = true;
        });
    }
    .width('100%')
    .backgroundColor('#fff');
  }

  // 清空表单
  clearCache(): void {
    this.title = "";
    this.content = "";
    this.articleTopics = [];
    this.allTopics.forEach((item: TopicItem) => {
      item.isChecked = false;
    });
  }

  // 保存草稿
  saveDraft(): void {
    const uiContext: UIContext = this.getUIContext();
    const prompt: PromptAction = uiContext.getPromptAction();

    if (!this.title || !this.content) {
      prompt.showToast({ message: "内容不能为空" });
      return;
    }

    const postData: DraftItem = {
      title: this.title,
      content: this.content,
      topics: this.articleTopics,
      editTime: `上次编辑于：${this.formatDate(new Date())}`
    };

    http.createHttp().request(this.draftUrl, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(postData)
    }).then(() => {
      prompt.showToast({ message: "草稿已保存" });
      this.clearCache();
      setTimeout(() => {
        router.replaceUrl({ url: 'pages/HomePages/MyDraftPage' });
      }, 88);
    });
  }

  // 发布文章
  publishArticle(): void {
    const uiContext: UIContext = this.getUIContext();
    const prompt: PromptAction = uiContext.getPromptAction();

    if (!this.title || !this.content) {
      prompt.showToast({ message: "内容不能为空" });
      return;
    }

    const postData: ArticleItem = {
      title: this.title,
      content: this.content,
      topics: this.articleTopics,
      author: "张清北",
      hospital: "北京协和医院",
      collect: "0收藏",
      like: "0点赞",
      comment: "0评论"
    };

    http.createHttp().request(this.baseUrl, {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      extraData: JSON.stringify(postData)
    }).then(() => {
      prompt.showToast({ message: '发布成功！' });
      this.clearCache();
      setTimeout(() => {
        router.replaceUrl({ url: 'pages/HomePages/CreatCenter' });
      }, 88);
    });
  }

  formatDate(d: Date): string {
    const y: number = d.getFullYear();
    const m: string = (d.getMonth() + 1).toString().padStart(2, '0');
    const day: string = d.getDate().toString().padStart(2, '0');
    return `${y}-${m}-${day}`;
  }
}