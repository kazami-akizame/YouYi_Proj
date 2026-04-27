// ImageSelectPage.ets
import router from '@ohos.router';

// 图片数据模型
interface ImageItem {
  id: number;
  selected: boolean;
}

@Entry
@Component
struct ImageSelectPage {
  // 图片列表：14张，和原图数量一致
  @State imageList: ImageItem[] = [
    {id:1, selected:true},
    {id:2, selected:false},
    {id:3, selected:false},
    {id:4, selected:false},
    {id:5, selected:false},
    {id:6, selected:false},
    {id:7, selected:false},
    {id:8, selected:false},
    {id:9, selected:false},
    {id:10, selected:false},
    {id:11, selected:false},
    {id:12, selected:false},
    {id:13, selected:false},
    {id:14, selected:false},
  ];

  build() {
    Column() {
      // 顶部深色导航栏
      this.buildNavBar()

      // 图片网格滚动区域
      Scroll() {
        Grid() {
          ForEach(this.imageList, (item: ImageItem) => {
            GridItem() {
              Stack({ alignContent: Alignment.TopStart }) {
                // 图片（正常显示）
                Image($r('app.media.u1288'))
                  .width('100%')
                  .aspectRatio(1)
                  .backgroundColor('#E8F3FF')
                  .objectFit(ImageFit.Cover)
                  .clip(true)

                // 勾选框（修复：不使用 .style()）
                Checkbox()
                  .select(item.selected)
                  .width(26)
                  .height(26)
                  .margin({ top: 8, left: 8 })
                  .selectedColor('#007AFF')
                  .onChange((isSelected: boolean) => {
                    item.selected = isSelected;
                  })
              }
              .width('100%')
            }
          })
        }
        .columnsTemplate('1fr 1fr 1fr')
        .columnsGap(1)
        .rowsGap(1)
        .width('100%')
      }
      .layoutWeight(1)
      .backgroundColor(Color.White)

      // 底部预览 + 下一步
      this.buildBottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  // 顶部导航栏
  @Builder
  buildNavBar() {
    Row() {
      Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%A9%BA%E6%95%B0%E6%8D%AE/u695.png')
        .width(22)
        .height(22)
        .fillColor(Color.White)
        .margin({ left: 16 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/EditVideoPage' })
        })
    }
    .width('100%')
    .height(56)
    .backgroundColor('#222')
    .alignItems(VerticalAlign.Center)
  }

  // 底部栏
  @Builder
  buildBottomBar() {
    Row() {
      Text('预览')
        .fontSize(16)
        .fontColor(Color.White)
        .margin({ left: 20 })

      Blank()

      Button('下一步')
        .width(100)
        .height(38)
        .backgroundColor('#007AFF')
        .fontColor(Color.White)
        .borderRadius(19)
        .margin({ right: 20 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/HomePages/EditVideoPage' })
        })
    }
    .width('100%')
    .height(70)
    .backgroundColor('#222')
    .alignItems(VerticalAlign.Center)
  }
}