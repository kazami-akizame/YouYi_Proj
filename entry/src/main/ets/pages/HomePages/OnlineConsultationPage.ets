// pages/OnlineConsultationPage.ets
import { ConsultationItem, ConsultationStatus, ConsultationType, loadFromJsonServer } from '../common/ConsultationData';
import router from '@ohos.router';

@Entry
@Component
struct OnlineConsultationPage {
  @State currentTabIndex: number = 0;
  @State waitingData: ConsultationItem[] = [];
  @State inProgressData: ConsultationItem[] = [];
  @State finishedData: ConsultationItem[] = [];

  @State isRefreshing: boolean = false;
  @State isLoaded: boolean = false;

  aboutToAppear() {
    this.loadData();
  }

  // 把数据加载和筛选逻辑提前
  loadData() {
    loadFromJsonServer().then((data: ConsultationItem[]) => {
      const raw = [...data];
      this.waitingData = raw.filter((item: ConsultationItem) => item.status === ConsultationStatus.WAITING);
      this.inProgressData = raw.filter((item: ConsultationItem) => item.status === ConsultationStatus.IN_PROGRESS);
      this.finishedData = raw.filter((item: ConsultationItem) =>
      item.status === ConsultationStatus.FINISHED ||
        item.status === ConsultationStatus.REJECTED
      );
      this.isLoaded = true;
    });
  }

  // 获取类型标签颜色
  getTypeColor(type: ConsultationType): string {
    const map = new Map<ConsultationType, string>([
      [ConsultationType.SPEED, '#FFB347'],
      [ConsultationType.GRAPHIC, '#2196F3'],
      [ConsultationType.PRESCRIPTION, '#4ECDC4']
    ]);
    return map.get(type) ?? '#999';
  }

  // 获取状态文字颜色
  getStatusColor(status: ConsultationStatus): string {
    const map = new Map<ConsultationStatus, string>([
      [ConsultationStatus.WAITING, '#4ECDC4'],
      [ConsultationStatus.IN_PROGRESS, '#F44336'],
      [ConsultationStatus.REJECTED, '#9E9E9E'],
      [ConsultationStatus.FINISHED, '#9E9E9E']
    ]);
    return map.get(status) ?? '#9E9E9E';
  }

  // 下拉刷新
  onRefresh() {
    this.isRefreshing = true;
    loadFromJsonServer().then(data => {
      const raw = [...data];
      this.waitingData = raw.filter((item: ConsultationItem) => item.status === ConsultationStatus.WAITING);
      this.inProgressData = raw.filter((item: ConsultationItem) => item.status === ConsultationStatus.IN_PROGRESS);
      this.finishedData = raw.filter((item: ConsultationItem) =>
      item.status === ConsultationStatus.FINISHED ||
        item.status === ConsultationStatus.REJECTED
      );
      this.isRefreshing = false;
    }).catch(() => {
      this.isRefreshing = false;
    });
  }

  @Builder
  ConsultationCard(item: ConsultationItem) {
    Column() {
      // 第一行：姓名、性别年龄、类型标签
      Row() {
        Row() {
          Image($r("app.media.profile")).width(50).height(50)
          Text(item.patientName)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333')
          Text(`${item.patientGender} ${item.patientAge}岁`)
            .fontSize(14)
            .fontColor('#666')
            .margin({ left: 8 })
          Text(item.type)
            .fontSize(12)
            .fontColor(this.getTypeColor(item.type))
            .padding({
              left: 8,
              right: 8,
              top: 3,
              bottom: 3
            })
            .margin({ left: 8 })
            .border({ width: 1, color: this.getTypeColor(item.type), radius: 4 })
        }
        Blank()
        Text(item.status)
          .fontSize(13)
          .fontColor(this.getStatusColor(item.status))
      }
      .width('100%')

      Divider().color('#F2F2F2').width('100%').strokeWidth(1)

      // 第二行：病情描述
      Row() {
        Text('病情描述：')
          .fontSize(14)
          .fontColor('#333')
        Text(item.description)
          .fontSize(14)
          .fontColor('#999')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
      }
      .width('100%')
      .margin({ left:15, right:15, top:15, bottom:15 })

      Divider().color('#F2F2F2').width('100%').strokeWidth(1)
      Blank().height(10)

      // 第三行：时间
      Row() {
        Text(item.createTime)
          .fontSize(12)
          .fontColor('#999')
      }
      .width('100%')
    }
    .layoutWeight(1)
    .padding({left:15, right:15, top:10, bottom:10})
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left: 16, right: 16, bottom: 12 })
    .shadow({ radius: 6, color: '#10000000', offsetY: 2 })
    .onClick(() => {
      console.info(`点击卡片：${item.patientName} - ${item.type}`);
      // 跳转到聊天页，传递当前问诊数据
      router.pushUrl({
        url: 'pages/HomePages/ChatPage',
        params: { item: JSON.stringify(item) }   // 必须序列化
      });
    })
  }


  @Builder
  ContentList(data: ConsultationItem[]) {
    Refresh({ refreshing: $$this.isRefreshing }) {
      List() {

        ForEach(data,
          (item: ConsultationItem) => {
            ListItem() {
              this.ConsultationCard(item)
            }
          },
          (item: ConsultationItem) => item.id
        )


        ListItem() {
          Row() {
            Text(data.length > 0 ? '没有更多了~' : '暂无问诊记录')
              .fontSize(13)
              .fontColor('#999')
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .padding({ top: 20, bottom: 20 })
        }
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
      .edgeEffect(EdgeEffect.Spring)
      .padding({top: 12})
    }
    .onRefreshing(() => this.onRefresh())
  }

  @Builder
  TabBar(title: string, index: number) {
    Column() {
      Text(title)
        .fontSize(this.currentTabIndex === index ? 16 : 15)
        .fontWeight(this.currentTabIndex === index ? FontWeight.Medium : FontWeight.Normal)
        .fontColor(this.currentTabIndex === index ? '#007AFF' : '#666')
      Divider()
        .width(35)
        .height(3)
        .backgroundColor(this.currentTabIndex === index ? '#007AFF' : Color.Transparent)
        .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#FFFFFF')
  }

  build() {
    Column() {

      if (!this.isLoaded) {
        Column() {
          Text("加载中...").fontSize(20).margin(50)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        // 标题
        Row() {
          Image($r("app.media.left")).width(14).onClick(() => {
            router.pushUrl({
              url: "pages/HomePages/HomePage"
            });
          })
          Text('在线接诊')
            .fontSize(18)
            .fontColor('#333')
            .textAlign(TextAlign.Center)
            .layoutWeight(1)
          Blank().width(34)
        }
        .width('100%')
        .height(56)
        .padding({ left: 20 })
        .backgroundColor('#fff')

        // Tabs
        Tabs({ index: this.currentTabIndex }) {
          TabContent() {
            this.ContentList([...this.waitingData, ...this.inProgressData, ...this.finishedData])
          }.tabBar(this.TabBar('全部', 0))

          TabContent() {
            this.ContentList(this.waitingData)
          }.tabBar(this.TabBar('待接诊', 1))

          TabContent() {
            this.ContentList(this.inProgressData)
          }.tabBar(this.TabBar('进行中', 2))

          TabContent() {
            this.ContentList(this.finishedData)
          }.tabBar(this.TabBar('已结束', 3))
        }
        .barMode(BarMode.Fixed)
        .barWidth('100%')
        .barHeight(48)
        .onChange((index: number) => {
          this.currentTabIndex = index;
        })
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}

