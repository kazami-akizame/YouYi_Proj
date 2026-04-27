// CommonWords.ets 常用语页面
// 旧版鸿蒙兼容 · 零报错 · 添加+编辑+删除完整实现
import router from '@ohos.router';

interface WordItem {
  id: number;
  content: string;
  type: string; // 系统自定义/我的
}

@Entry
@Component
struct CommonWordsPage {
  @State systemList: WordItem[] = [
    {id:1,content:'您好，请问有什么能帮助您的？',type:'系统自定义'},
    {id:2,content:'您好，请问有什么能帮助您的？',type:'系统自定义'},
    {id:3,content:'您好，请问有什么能帮助您的？',type:'系统自定义'},
    {id:4,content:'您好，请问有什么能帮助您的？',type:'系统自定义'},
    {id:5,content:'您好，请问有什么能帮助您的？',type:'系统自定义'},
  ];
  @State myList: WordItem[] = [
    {id:6,content:'请问目前有什么症状呢？',type:'我的'},
    {id:7,content:'请问目前有什么症状呢？',type:'我的'},
  ];

  // 新增弹窗数据
  @State showEditDialog: boolean = false;
  @State editContent: string = '';
  @State editIndex: number = -1;
  @State editType: string = '';

  // 右上角添加按钮点击事件
  addNewWord() {
    this.editContent = '';
    this.editIndex = -1;
    this.editType = '我的';
    this.showEditDialog = true;
  }

  // 点击编辑条目
  editWord(item: WordItem, index: number) {
    if(item.type === '我的') {
      this.editContent = item.content;
      this.editIndex = index;
      this.editType = item.type;
      this.showEditDialog = true;
    }
  }

  // 保存编辑/新增
  saveWord() {
    if(this.editContent.trim() === '') return;
    if(this.editIndex === -1) {
      const newId = this.systemList.length + this.myList.length + 10;
      this.myList.push({
        id: newId,
        content: this.editContent,
        type: '我的'
      });
    } else {
      this.myList[this.editIndex].content = this.editContent;
    }
    this.showEditDialog = false;
  }

  // 删除常用语
  deleteWord(index: number) {
    this.myList.splice(index, 1);
    this.showEditDialog = false;
  }

  build() {
    // 🔥 整个页面只有 1 个根节点 Column
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left:16, right:12 })
          .onClick(()=>router.back())
        Text('常用语设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .textAlign(TextAlign.Center)
        Text('添加')
          .fontSize(16)
          .fontColor('#007AFF')
          .margin({right:16})
          .onClick(()=>this.addNewWord())
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')
      // 列表内容（已优化：无顶部空白，整体上移）
      Column() {
        Scroll() {
          Column() {
            // 🔥 系统自定义：顶部间距从 12 → 4，大幅上移，更紧凑
            Text('系统自定义')
              .fontSize(15)
              .fontColor('#999')
              .width('100%')
              .padding({ left: 16, top: 4, bottom: 8 })
              .backgroundColor('#F5F5F5')
            ForEach(this.systemList, (item: WordItem) => {
              this.wordItemView(item, -1)
            })

            // 🔥 我的常用语：顶部间距从 16 → 8，整体上移
            Text('我的')
              .fontSize(15)
              .fontColor('#999')
              .width('100%')
              .padding({ left: 16, top: 8, bottom: 8 })
              .backgroundColor('#F5F5F5')
            ForEach(this.myList, (item: WordItem, index: number) => {
              this.wordItemView(item, index)
            })
          }
        }
        .flexGrow(1)
        .backgroundColor('#F5F5F5')
      }.justifyContent(FlexAlign.Start)
      // 弹窗放进根节点 Column 内部
      if(this.showEditDialog) {
        Column() {
          Text(this.editIndex === -1 ? '新增常用语' : '编辑常用语')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({top:20,bottom:20})

          TextInput({text:this.editContent,placeholder:'请输入常用语内容'})
            .width('85%')
            .height(50)
            .padding({left:12,right:12})
            .onChange((val)=>{this.editContent=val})

          Row() {
            Text('取消')
              .fontSize(16)
              .fontColor('#333')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .padding({top:16,bottom:16})
              .onClick(()=>{this.showEditDialog=false})

            if(this.editIndex !== -1) {
              Text('删除')
                .fontSize(16)
                .fontColor('#F53F3F')
                .layoutWeight(1)
                .textAlign(TextAlign.Center)
                .padding({top:16,bottom:16})
                .onClick(()=>{this.deleteWord(this.editIndex)})
            }

            Text('保存')
              .fontSize(16)
              .fontColor('#007AFF')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
              .padding({top:16,bottom:16})
              .onClick(()=>{this.saveWord()})
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

  // 常用语条目
  @Builder
  wordItemView(item: WordItem, index: number) {
    Text(item.content)
      .fontSize(16)
      .fontColor('#333')
      .width('100%')
      .padding({left:16,right:16,top:16,bottom:16})
      .backgroundColor(Color.White)
      .onClick(()=>{
        if(index !== -1) {
          this.editWord(item, index);
        }
      })
    Divider().strokeWidth(1).color('#EEE')
  }
}