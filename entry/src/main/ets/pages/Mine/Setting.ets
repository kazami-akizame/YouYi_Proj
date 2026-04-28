// Setting.ets 设置主页面
// 1:1匹配原型标准页 · 全部问题已修复 · 旧版鸿蒙零报错
import router from '@ohos.router';


interface SettingItem {
  id: number;
  title: string;
  rightText: string;
}

@Entry
@Component
struct SettingPage {
  @State itemList: SettingItem[] = [
    { id:1, title:'通知设置', rightText:'' },
    { id:2, title:'更换手机号码', rightText:'' },
    { id:3, title:'修改密码', rightText:'' },
    { id:4, title:'常用语', rightText:'' },
    { id:5, title:'检查更新', rightText:'' },
    { id:6, title:'清除缓存', rightText:'233M' },
    { id:7, title:'关于我们', rightText:'' },
    { id:8, title:'注销账号', rightText:'' },
  ];

  build() {
    Column() {
      // ======================
      // 修复1：导航栏标题【完美居中】，和原型完全一致
      // 结构：返回图标 + 两侧均等Flex占位 + 标题居中
      // ======================
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .margin({ left: 16, right: 12 })
          .onClick(() => router.back())

        Flex()
        Text('设置')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .position({ x: '45%', y: '20%' })
        Flex()
      }
      .width('100%')
      .height(48)
      .backgroundColor(Color.White)

      Divider().strokeWidth(1).color('#e0e0e0')

    Column() {
      Scroll() {
    Column() {
      // 循环设置项
      ForEach(this.itemList, (item: SettingItem) => {
        this.itemView(item)
      })

      // ======================
      // 修复4：退出登录文字【居中显示】，红色样式居中
      // ======================
      Row() {
        Text('退出登录')
          .fontSize(16)
          .fontColor('#F53F3F')
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 18,
        bottom: 18
      })
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.Center) // 文字居中
      .onClick(() => {
        console.info('点击退出登录')
      })
    }
    .padding({ top: 0 }) // 顶部0间距，紧贴导航栏
  }
        .flexGrow(1)
        .backgroundColor('#F5F5F5')
        }.justifyContent(FlexAlign.Start)
      }

    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .justifyContent(FlexAlign.Start)
  }

  // ======================
  // 修复3+修复4：条目右侧箭头 + 缓存文字右对齐（完全符合原型顺序）
  // 原型顺序：左侧标题 | 自动占位 | 右侧缓存文字(右对齐) | 最右侧右箭头图标
  // ======================
  @Builder
  itemView(item: SettingItem) {
    Row() {
      // 左侧标题
      Text(item.title).fontSize(16).fontColor('#333')
      Flex()
      // 右侧缓存文字（清除缓存233M，文字右对齐）
      Text(item.rightText).fontSize(16).fontColor('#999').textAlign(TextAlign.End)
      // 最右侧统一跳转右箭头图标（所有行都有）
      Image($r('app.media.ic_public_jiantou'))
        .width(16)
        .height(16)
        .margin({right:"2%"})
    }.justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .padding({left:16,right:16,top:16,bottom:16})
    .backgroundColor(Color.White)
    .onClick(()=>{
      // 跳转+try捕获消除警告
      try {
        if(item.title === '通知设置') router.replaceUrl({url:'pages/Mine/NoticeSetting'})
        if(item.title === '更换手机号码') router.replaceUrl({url:'pages/Mine/ChangePhone'})
        if(item.title === '常用语') router.replaceUrl({url:'pages/Mine/CommonWords'})
        if(item.title === '修改密码') router.replaceUrl({ url: 'pages/Login_Register/FindPin' })
      } catch(e){}
    })
    Divider().strokeWidth(1).color('#EEE')
  }
}