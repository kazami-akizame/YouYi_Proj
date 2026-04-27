// PatientEvaluate.ets 患者评价页面
// 已完整实现：医生回复患者评价功能 + 弹窗编辑 + 回复展示 + 零报错兼容旧版鸿蒙
import router from '@ohos.router';

// 定义单条评价数据接口（强类型）
interface EvaluateItem {
  userName: string;
  starCount: number;
  content: string;
  time: string;
  replyContent: string; // 新增：医生回复内容
}

@Entry
@Component
struct PatientEvaluatePage {
  // 顶部统计数据
  @State totalCount: number = 230;
  @State goodRate: string = "98.1%";
  // 评价列表数据（默认无回复）
  @State evaluateList: EvaluateItem[] = [
    {
      userName: "Daisy",
      starCount: 5,
      content: "谢谢廖医生的详细讲解 一步步指导的很好 我们已经都做过检测了在准备手术了。",
      time: "2018-10-15 10:15",
      replyContent: ""
    },
    {
      userName: "Daisy",
      starCount: 5,
      content: "谢谢廖医生的详细讲解 一步步指导的很好 我们已经都做过检测了在准备手术了。",
      time: "2018-10-15 10:15",
      replyContent: ""
    },
    {
      userName: "Daisy",
      starCount: 5,
      content: "谢谢廖医生的详细讲解 一步步指导的很好 我们已经都做过检测了在准备手术了。",
      time: "2018-10-15 10:15",
      replyContent: ""
    },
    {
      userName: "Daisy",
      starCount: 5,
      content: "谢谢廖医生的详细讲解 一步步指导的很好 我们已经都做过检测了在准备手术了。",
      time: "2018-10-15 10:15",
      replyContent: ""
    },
    {
      userName: "Daisy",
      starCount: 5,
      content: "谢谢廖医生的详细讲解 一步步指导的很好 我们已经都做过检测了在准备手术了。",
      time: "2018-10-15 10:15",
      replyContent: ""
    }
  ];
  // 加载状态
  @State isLoading: boolean = true;

  // ========== 回复弹窗相关状态 ==========
  @State showReplyDialog: boolean = false;
  @State currentEditIndex: number = -1;
  @State editReplyText: string = '';

  // 点击回复按钮，打开弹窗
  openReplyDialog(index: number) {
    this.currentEditIndex = index;
    // 回显当前已有回复内容
    this.editReplyText = this.evaluateList[index].replyContent;
    this.showReplyDialog = true;
  }

  // 提交保存回复
  saveReply() {
    if (this.currentEditIndex === -1 || this.editReplyText.trim() === '') return;
    // 保存回复到对应评价
    this.evaluateList[this.currentEditIndex].replyContent = this.editReplyText;
    this.showReplyDialog = false;
  }

  build() {
    // ✅ 唯一根节点Column，彻底解决根节点报错
    Column() {
      // 顶部导航栏（标题完美居中）
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16, right: 12 })
          .onClick(() => router.back())

        Flex()
        Text('患者评价')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .position({ x: '40%', y: '20%' })
        Flex()
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')

      // 顶部统计栏
      Row() {
        Text(`共 ${this.totalCount} 条评价，好评率 `)
          .fontSize(16)
          .fontColor('#333333')
        Text(this.goodRate)
          .fontSize(16)
          .fontColor('#FF4444')
          .fontWeight(FontWeight.Medium)
      }
      .width('100%')
      .height(44)
      .padding({ left: 16 })
      .backgroundColor('#F5F5F5')

      // 评价列表滚动区域
      Scroll() {
        Column() {
          // 循环渲染每条评价
          ForEach(this.evaluateList, (item: EvaluateItem, index: number) => {
            this.evaluateItem(item, index)
          })

          // 底部加载更多
          if (this.isLoading) {
            Row() {
              LoadingProgress()
                .width(20)
                .height(20)
                .color('#999999')
              Text('数据正在加载中')
                .fontSize(14)
                .fontColor('#999999')
                .margin({ left: 8 })
            }
            .width('100%')
            .height(60)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#F5F5F5')
          }
        }
      }
      .flexGrow(1)
      .backgroundColor('#F5F5F5')

      // ✅ 回复编辑弹窗（放在根节点内部，无报错）
      if (this.showReplyDialog) {
        Column() {
          Text('回复患者评价')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 20 })

          // 回复输入框
          TextInput({ text: this.editReplyText, placeholder: '请输入医生回复内容' })
            .width('85%')
            .height(120)
            .padding({ left: 12, right: 12 })
            .onChange((val) => { this.editReplyText = val })

          // 取消+保存按钮
          Row() {
            Text('取消')
              .fontSize(16)
              .fontColor('#333')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .padding({ top: 16, bottom: 16 })
              .onClick(() => { this.showReplyDialog = false })

            Text('发送回复')
              .fontSize(16)
              .fontColor('#007AFF')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .padding({ top: 16, bottom: 16 })
              .onClick(() => { this.saveReply() })
          }
          .width('100%')
        }
        .width('80%')
        .backgroundColor(Color.White)
        .borderRadius(12)
        .position({ left: '10%', top: '30%' })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
  }

  // 封装单条评价Item组件（完全匹配截图样式+新增回复展示）
  @Builder
  evaluateItem(item: EvaluateItem, index: number) {
    Column() {
      // 用户名+星级
      Row() {
        Row() {
          Text(item.userName)
            .fontSize(17)
            .fontWeight(FontWeight.Bold)
            .fontColor('#222222')

          // 星级评分
          Row() {
            ForEach([1, 2, 3, 4, 5], (starIndex: number) => {
              Image($r('app.media.ic_star_filled'))
                .width(18)
                .height(18)
                .margin({ left: 4 })
                .fillColor(starIndex <= item.starCount ? '#FFCC00' : '#EEEEEE')
            })
          }
          .margin({ left: 12 })
        }
        Flex()
        // 右侧回复按钮（点击打开弹窗）
        Text('回复')
          .fontSize(15)
          .fontColor('#007AFF')
          .onClick(() => { this.openReplyDialog(index) })
      }.justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .padding({ left: 16, right: 16, top: 12 })

      // 患者评价内容
      Text(item.content)
        .fontSize(15)
        .fontColor('#333333')
        .lineHeight(22)
        .width('100%')
        .padding({ left: 16, right: 16, top: 8 })

      // ========== 新增：医生回复内容展示 ==========
      if (item.replyContent !== '') {
        Column() {
          Text('医生回复：')
            .fontSize(14)
            .fontColor('#666')
            .width('100%')
          Text(item.replyContent)
            .fontSize(15)
            .fontColor('#007AFF')
            .lineHeight(22)
            .width('100%')
            .margin({ top: 4 })
        }
        .width('100%')
        .padding({ left: 16, right: 16, top: 8 })
        .backgroundColor('#F2F8FF')
      }


        // 时间
        Text(item.time)
          .fontSize(13)
          .fontColor('#999999')
          .width('100%')
          .padding({
            left: 16,
            right: 16,
            top: 8,
            bottom: 12
          })


      // 底部分割线
      Divider()
        .strokeWidth(1)
        .color('#EEEEEE')
    }
    .backgroundColor(Color.White)
  }
}