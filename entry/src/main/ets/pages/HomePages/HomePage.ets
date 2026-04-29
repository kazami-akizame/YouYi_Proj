// HomePage.ets
import router from '@ohos.router';

// 数据模型定义
interface OrderItem {
  name: string;
  gender: string;
  age: number;
  tag: string;
  price: number;
  desc: string;
}

interface MsgItem {
  name: string;
  content: string;
  time: string;
  status: string;
  unread: number;
}

@Entry
@Component
struct HomePage {
  // 医生个人信息
  @State doctorName: string = '李明明'
  @State doctorTitle: string = '副主任医师'
  @State hospital: string = '北京积水潭医院'
  @State goodRate: string = '90.2%'
  @State serviceCount: number = 1401
  @State fansCount: number = 55

  // 抢单订单数据（滑动切换）
  @State orderList: OrderItem[] = [
    {
      name: '吴珊珊',
      gender: '女',
      age: 23,
      tag: '极速问诊',
      price: 29,
      desc: '孩子从出生后睡眠就不好，入睡困难，易醒，烦躁不安。近三个月症状加重，尤其夜里辗转难眠，情绪...'
    },
    {
      name: '张先生',
      gender: '男',
      age: 45,
      tag: '普通问诊',
      price: 19,
      desc: '最近经常头晕，血压偏高，睡眠质量差，白天精神状态不好。'
    },
    {
      name: '李女士',
      gender: '女',
      age: 32,
      tag: '加急问诊',
      price: 39,
      desc: '产后恢复不佳，腰部酸痛，手脚冰凉，希望得到调理建议。'
    }
  ]

  // 消息列表数据
  @State msgList: MsgItem[] = [
    {
      name: '吴珊珊',
      content: '头还是很痛，吃了药也不管用',
      time: '上午10:13',
      status: '进行中',
      unread: 2
    }
  ]

  build() {
    Column() {
      // 顶部蓝色头部
      this.buildHeader()

      Scroll() {
        Column({ space: 12 }) {
          this.buildFuncEntrance()
          this.buildGrabOrderArea() // 上下滑动抢单中心
          this.buildMsgListArea()
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')

      this.buildTabBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  // 顶部蓝色头部
  @Builder
  buildHeader() {
    Column() {
      Row() {
        Text('首页')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)

        Blank()

        Stack() {
          Image($r('sys.symbol.bell'))
            .width(24)
            .height(24)
            .fillColor(Color.White)
          Circle()
            .width(8)
            .height(8)
            .fill(Color.Red)
            .margin({ top: -2, right: -2 })
        }
      }
      .width('100%')
      .margin({ bottom: 20 })

      Row() {
        Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E9%A6%96%E9%A1%B5/u2585.png')
          .width(64)
          .height(64)
          .borderRadius(32)
          .backgroundColor('#ffffff')

        Column() {
          Row() {
            Text(this.doctorName)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
            Text(this.doctorTitle)
              .fontSize(14)
              .fontColor('#EEFFFF')
              .margin({ left: 6 })
          }
          Text(this.hospital)
            .fontSize(14)
            .fontColor('#EEFFFF')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .margin({ left: 12 })
        .alignItems(HorizontalAlign.Start)

        Text('已认证')
          .fontSize(13)
          .fontColor(Color.White)
          .border({ width:1, color:Color.White })
          .padding({ left:12, right:12, top:4, bottom:4 })
          .borderRadius(12)
      }
      .width('100%')
      .alignItems(VerticalAlign.Top)
      .margin({ bottom:24 })

      Row() {
        Column() {
          Text(this.goodRate)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('好评率')
            .fontSize(14)
            .fontColor('#EEFFFF')
            .margin({ top:6 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text(this.serviceCount.toString())
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('服务次数')
            .fontSize(14)
            .fontColor('#EEFFFF')
            .margin({ top:6 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        Column() {
          Text(this.fansCount.toString())
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
          Text('粉丝')
            .fontSize(14)
            .fontColor('#EEFFFF')
            .margin({ top:6 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#4096FF')
    .borderRadius({ bottomLeft:16, bottomRight:16 })
  }

  // ====================== ✅ 修复：图片正常显示 + 点击跳转 ======================
  @Builder
  buildFuncEntrance() {
    Row() {
      // 我的问诊
      Column() {
        Column(){
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1321.png')
            .width(30)
            .height(30)
            .margin({top:5
            })
        }.backgroundColor('#ff2166bc')
        .width(40)
        .height(40)
        .borderRadius(5)

        Text('我的问诊')
          .fontSize(13)
          .fontColor('#333')
          .margin({ top:6 })
      }
      .layoutWeight(1)
      .onClick(() => {
        router.pushUrl({ url: 'pages/HomePages/OnlineConsultationPage' })
      })

      // 私人医生
      Column() {
        Column(){
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1333.png')
            .width(30)
            .height(30)
            .margin({top:5
            })
        }.backgroundColor('#ff2166bc')
        .width(40)
        .height(40)
        .borderRadius(5)
        Text('私人医生')
          .fontSize(13)
          .fontColor('#333')
          .margin({ top:6 })
      }
      .layoutWeight(1)
      .onClick(() => {
        router.pushUrl({ url: 'pages/HomePages/PrivatedoctorPage' })
      })

      // 我的药房
      Column() {
        Column(){
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1325.png')
            .width(30)
            .height(30)
            .margin({top:5
            })
        }.backgroundColor('#ff2166bc')
        .width(40)
        .height(40)
        .borderRadius(5)
        Text('我的药房')
          .fontSize(13)
          .fontColor('#333')
          .margin({ top:6 })
      }
      .layoutWeight(1)
      .onClick(() => {
        router.pushUrl({ url: 'pages/HomePages/MypharmacyPage' })
      })

      // 创作中心
      Column() {
        Column(){
          Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1329.png')
            .width(30)
            .height(30)
            .margin({top:5
            })
        }.backgroundColor('#ff2166bc')
        .width(40)
        .height(40)
        .borderRadius(5)
        Text('创作中心')
          .fontSize(13)
          .fontColor('#333')
          .margin({ top:6 })
      }
      .layoutWeight(1)
      .onClick(() => {
        router.pushUrl({ url: 'pages/HomePages/CreatCenter' })
      })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left:16, right:16 })
  }

  // ====================== ✅ 已修复：上下滑动抢单中心 ======================
  @Builder
  buildGrabOrderArea() {
    Column() {
      Row() {
        Text('抢单中心')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#222')
        Blank()
        Text('全部 >')
          .fontSize(14)
          .fontColor('#999')
          .onClick(()=>{
            router.pushUrl({ url: 'pages/HomePages/GrabOrderPage' })
          })
      }
      .width('100%')
      .margin({ bottom:12 })

      // 垂直上下滑动 Swiper
      Swiper() {
        ForEach(this.orderList, (item: OrderItem) => {  // ✅ 这里修复了类型
          Column() {
            Row() {
              Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E9%A6%96%E9%A1%B5/__80px_u2624.png')
                .width(44)
                .height(44)
                .borderRadius(22)

              Column() {
                Row() {
                  Text(item.name)
                    .fontSize(15)
                    .fontColor('#333')
                  Text(`${item.gender} ${item.age}岁`)
                    .fontSize(14)
                    .fontColor('#666')
                    .margin({ left:4 })
                }
                Row() {
                  Text(item.tag)
                    .fontSize(12)
                    .backgroundColor('#FFF2CC')
                    .fontColor('#CC9900')
                    .padding({ left:6, right:6, top:2, bottom:2 })
                    .borderRadius(4)
                }
                .margin({ top:6 })
              }
              .layoutWeight(1)
              .margin({ left:10 })
              .alignItems(HorizontalAlign.Start)

              Text(`¥${item.price.toFixed(2)}`)
                .fontSize(18)
                .fontColor('#FF3B30')
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .alignItems(VerticalAlign.Top)

            Text(`病情描述：${item.desc}`)
              .fontSize(14)
              .fontColor('#666')
              .margin({ top:12, bottom:16 })

            Row() {
              Blank()
              Button('抢单')
                .width(80)
                .height(32)
                .fontSize(14)
                .backgroundColor('#4096FF')
                .fontColor(Color.White)
                .borderRadius(16)
            }
          }
          .width('100%')
        })
      }
      .autoPlay(true)
      .vertical(true)
      .height(160)
      .interval(3000)
      .indicator(false)
      .width('100%')

      Divider()
        .width('100%')
        .height(1)
        .color('#EEEEEE')
        .margin({ top:12 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left:16, right:16 })
  }

  // 消息列表
  @Builder
  buildMsgListArea() {
    Column() {
      Text('消息列表')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor('#222')
        .width('100%')
        .margin({ bottom:12 })

      ForEach(this.msgList, (msg: MsgItem) => {
        Row() {
          Stack() {
            Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/__80px_u1116.png')
              .width(48)
              .height(48)
              .borderRadius(24)

            if(msg.unread > 0) {
              Circle()
                .width(15)
                .height(15)
                .fill(Color.Red)
                .align(Alignment.TopEnd)
                .margin({ top:-20, right:-20 })

              Text(msg.unread.toString())
                .fontSize(11)
                .fontColor(Color.White)
                .margin({ top:-20, right:-20 })
            }
          }

          Column() {
            Text(msg.name)
              .fontSize(15)
              .fontColor('#333')
            Text(msg.content)
              .fontSize(13)
              .fontColor('#999')
              .margin({ top:4 })
          }
          .layoutWeight(1)
          .margin({ left: 10 })
          .alignItems(HorizontalAlign.Start)

          Column() {
            Text(msg.time)
              .fontSize(12)
              .fontColor('#999')
            Text(msg.status)
              .fontSize(13)
              .fontColor('#34C759')
              .margin({ top:6 })
          }
          .alignItems(HorizontalAlign.End)
        }
        .width('100%')
        .height(64)
        .alignItems(VerticalAlign.Center)
        .margin({ bottom: 10 })
      })
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ left:16, right:16 })
  }

  // 底部导航
  @Builder
  buildTabBar() {
    // Row() {
    //   Column() {
    //     Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1073.png')
    //       .width(24)
    //       .height(24)
    //       .fillColor('#007AFF')
    //     Text('首页')
    //       .fontSize(12)
    //       .fontColor('#007AFF')
    //       .margin({ top:3 })
    //   }
    //   .layoutWeight(1)
    //
    //   Column() {
    //     Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1071.png')
    //       .width(24)
    //       .height(24)
    //       .fillColor('#999999')
    //     Text('患者')
    //       .fontSize(12)
    //       .fontColor('#999999')
    //       .margin({ top:3 })
    //       .onClick(()=>{
    //         router.pushUrl({ url: 'pages/Patient/Index' })
    //       })
    //   }
    //   .layoutWeight(1)
    //
    //   Column() {
    //     Image('https://cdn8.axureshop.com/demo2024/1306719/images/%E7%BB%84%E4%BB%B6_%E8%A7%84%E8%8C%83/u1072.png')
    //       .width(24)
    //       .height(24)
    //       .fillColor('#999999')
    //     Text('我的')
    //       .fontSize(12)
    //       .fontColor('#999999')
    //       .margin({ top:3 })
    //       .onClick(()=>{
    //         router.pushUrl({ url: 'pages/Mine/Index' })
    //       })
    //   }
    //   .layoutWeight(1)
    // }
    // .width('100%')
    // .height(64)
    // .backgroundColor(Color.White)
    // .justifyContent(FlexAlign.SpaceAround)


    Row() {
      // 首页
      Column({ space: 4 }) {
        Image($r('app.media.u1073')).width(20).height(20)
        Text("首页").fontColor("#1A73E8").fontSize(12)
      }
      .flexGrow(1)
      // .onClick(() => {
      //   router.pushUrl({ url: "pages/HomePages/HomePage" });
      // })

      // 患者
      Column({ space: 4 }) {
        Image($r('app.media.u1071')).width(20).height(20)
        Text("患者").fontColor("#999").fontSize(12)
      }
      .flexGrow(1)
      .onClick(() => {
        router.pushUrl({ url: "pages/Patient/Index" });
      })

      // 我的
      Column({ space: 4 }) {
        Image($r('app.media.u1072')).width(20).height(20)
        Text("我的").fontColor("#999").fontSize(12)
      }
      .flexGrow(1)
      .onClick(()=>{
        router.pushUrl({url: "pages/Mine/MePage"});
      })
    }
    .width('100%')
    .height(56)
    .backgroundColor("#ffffff")
  }
}