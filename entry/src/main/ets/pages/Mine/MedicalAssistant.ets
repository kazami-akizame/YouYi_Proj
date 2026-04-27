import router from '@ohos.router';
import http from '@ohos.net.http';

interface ChatMessage {
  id: number;
  content: string;
  role: 'user' | 'assistant';
  time: string;
}

interface ChatResponse {
  reply: string;
}

@Entry
@Component
struct MedicalAssistant {
  @State inputText: string = "";
  @State messages: ChatMessage[] = [];
  @State isSending: boolean = false;

  scroller: Scroller = new Scroller();
  private httpRequest = http.createHttp();

  onPageShow() {
    if (this.messages.length === 0) {
      this.addMessage("您好，这里是医生助手，请问有什么可以帮您？", 'assistant');
    }
  }

  getSystemTime(): string {
    const now = new Date();
    const pad = (n: number) => n < 10 ? '0' + n : n;
    return `${pad(now.getHours())}:${pad(now.getMinutes())}`;
  }

  addMessage(content: string, role: 'user' | 'assistant') {
    this.messages.push({
      id: Date.now(),
      content: content,
      role: role,
      time: this.getSystemTime()
    });
    setTimeout(() => {
      this.scroller.scrollToIndex(this.messages.length - 1);
    }, 100);
  }

  async sendRequest() {
    if (this.inputText.trim() === "") return;
    this.addMessage(this.inputText, 'user');
    let currentQuestion = this.inputText;
    this.inputText = "";
    this.isSending = true;

    try {
      let url = 'http://10.110.116.46:8888/api/chat';
      this.httpRequest.request(url, {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify({ prompt: currentQuestion })
      }).then((response: http.HttpResponse) => {
        let result = response.result;
        let replyContent = "";
        try {
          if (typeof result === 'string') {
            const data = JSON.parse(result) as ChatResponse;
            replyContent = data.reply ?? data.toString();
          } else {
            replyContent = result?.toString() || "服务异常";
          }
        } catch (e) {
          replyContent = result?.toString() || "解析失败";
        }
        this.addMessage(replyContent, 'assistant');
      }).catch((err: Error) => {
        this.addMessage("网络异常，请稍后再试", 'assistant');
      }).finally(() => {
        this.isSending = false;
      });
    } catch (e) {
      this.addMessage("系统异常", 'assistant');
      this.isSending = false;
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.u695')).width(20).onClick(() => router.back());
        Text("医生助手").fontSize(30).textAlign(TextAlign.Center).layoutWeight(1);
        Blank().width(20);
      }
      .height(50).width('100%').padding({ left: 15, right: 15 })
      .backgroundColor("#fff").alignItems(VerticalAlign.Center);

      // 聊天列表
      List({ scroller: this.scroller }) {
        ForEach(this.messages, (item: ChatMessage) => {
          ListItem() {
            Column() {
              // 时间：屏幕正中间
              Text(item.time)
                .fontSize(10).fontColor("#999")
                .width('100%').textAlign(TextAlign.Center)
                .margin({ bottom: 4 });

              // 消息气泡 + 头像
              Row() {
                // 助手消息：左侧头像
                if (item.role === 'assistant') {
                  Image($r('app.media.u5936'))
                    .width(40).height(40).borderRadius(20).margin({ right: 10 });
                }

                // 气泡
                Text(item.content)
                  .fontSize(14).padding(12)
                  .backgroundColor(item.role === 'user' ? "#cce5ff" : "#fff")
                  .constraintSize({ maxWidth: '70%' })
                  .borderRadius(16);

                // 用户消息：右侧头像
                if (item.role === 'user') {
                  Image($r('app.media.u5936'))
                    .width(40).height(40).borderRadius(20).margin({ left: 10 });
                }
              }
              .width('100%')
              .justifyContent(item.role === 'user' ? FlexAlign.End : FlexAlign.Start);
            }
            .width('100%').padding({ left: 10, right: 10, top: 8, bottom: 8 });
          }
        })
      }
      .width('100%').layoutWeight(1).backgroundColor("#f5f5f5").padding(10)
      .onAppear(() => {
        this.scroller.scrollToIndex(this.messages.length - 1);
      });

      // 底部输入栏
      Row() {
        Image($r('app.media.u2887')).width(24).height(24).margin({ right: 10 });

        TextInput({ text: this.inputText, placeholder: "请输入您的问题" })
          .layoutWeight(1).height(40).borderRadius(20)
          .backgroundColor("#f5f5f5").padding({ left: 15, right: 15 })
          .onChange(v => this.inputText = v);

        // ✅ 发送按钮：输入有内容 → 蓝色
        Button("发送")
          .width(80).height(40).margin({ left: 10 }).borderRadius(20)
          .backgroundColor(
            this.isSending
              ? "#a0a0a0"
              : this.inputText.trim().length > 0
              ? "#007AFF" // 有内容 → 蓝色
              : "#cce5ff" // 无内容 → 淡蓝色
          )
          .onClick(() => !this.isSending && this.sendRequest());
      }
      .width('100%').height(60).padding({ left: 15, right: 15 })
      .backgroundColor("#fff").alignItems(VerticalAlign.Center);
    }
    .width('100%').height('100%').backgroundColor("#f5f5f5");
  }
}