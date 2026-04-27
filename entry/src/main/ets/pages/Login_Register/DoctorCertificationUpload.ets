import router from '@ohos.router';
import promptAction from '@ohos.promptAction';

const TAG: string = 'DoctorCertificationUpload';
// 定义要上传的图片类型
type UploadType = 'avatar' | 'idCardFront' | 'idCardBack' | 'cert';

@Entry
@Component
struct DoctorCertificationUpload {
  // 已上传图片的资源路径
  @State avatarUri: string = '';
  @State idCardFrontUri: string = '';
  @State idCardBackUri: string = '';
  @State certUri: string = '';

  // 当前要上传的图片类型（控制弹窗选择的目标）
  @State currentUploadType: UploadType | null = null;
  // 控制底部弹窗显示/隐藏
  @State showActionSheet: boolean = false;

  // 👉 从相册选择图片（占位）
  private async pickImageFromGallery(): Promise<string | null> {
    console.info(`${TAG}: 选择相册图片`);
    promptAction.showToast({ message: '相册选择功能开发中', duration: 2000 });
    return null;
  }

  // 👉 拍照（占位）
  private async takePhoto(): Promise<string | null> {
    console.info(`${TAG}: 调用相机拍照`);
    promptAction.showToast({ message: '拍照功能开发中', duration: 2000 });
    return null;
  }

  // 👉 处理图片选择
  private async handleImageSelect(isCamera: boolean) {
    console.info(`${TAG}: 处理图片选择: ${isCamera ? '拍照' : '相册'}`);
    this.showActionSheet = false;

    const imageUri = isCamera ? await this.takePhoto() : await this.pickImageFromGallery();
    if (!imageUri || !this.currentUploadType) return;

    switch (this.currentUploadType) {
      case 'avatar': this.avatarUri = imageUri; break;
      case 'idCardFront': this.idCardFrontUri = imageUri; break;
      case 'idCardBack': this.idCardBackUri = imageUri; break;
      case 'cert': this.certUri = imageUri; break;
    }
    promptAction.showToast({ message: '上传成功', duration: 1000 });
  }

  // ------------------------------
  // 上传卡片组件（文字在组件下方）
  // ------------------------------
  @Builder
  private CardUpload(label: string, type: UploadType, exampleImg: Resource, uploadUri: string) {
    Column() {
      // 点击区域：图片/上传区域
      Stack() {
        if (!uploadUri) {
          Image(exampleImg)
            .width('100%')
            .height(120)
            .objectFit(ImageFit.Contain)
            .opacity(0.6)

          Image($r('app.media.Carmen'))
            .width(40)
            .height(40)
            .fillColor('#FF9500')
        } else {
          Image(uploadUri)
            .width('100%')
            .height(120)
            .borderRadius(8)
            .objectFit(ImageFit.Cover)
        }
      }
      .width('100%')
      .height(120)
      .alignContent(Alignment.Center)
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .onClick(() => {
        this.currentUploadType = type;
        this.showActionSheet = true;
      })

      // 文字标签移到下方
      Text(label)
        .fontSize(14)
        .fontColor('#666')
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Center)
    .width('48%') // 两个卡片各占48%宽度，加上间距刚好适配手机屏幕
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Scroll() {
        Column() {
          // 导航栏
          Row() {
            Image($r('app.media.img_4'))
              .width(24)
              .height(24)
              .onClick(() => router.back())
            Text('医师认证')
              .fontSize(19)
              .fontWeight(FontWeight.Medium)
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .padding({ top: 15, bottom: 15, left: 15, right: 15 })

          // 提示文本栏
          Row() {
            Image($r('app.media.img_8'))
              .width(20)
              .height(20)
              .margin({ left: 16 })
            Text('请如实上传您的资料')
              .fontSize(14)
              .fontColor('#333')
              .layoutWeight(1)
          }
          .width('100%')
          .backgroundColor('#F5F5F5')
          .padding({ top: 12, bottom: 12, right: 16 })
          .margin({ bottom: 10 })

          // 表单区域
          Column() {
            // 1. 医生头像
            Column() {
              Text('* 医生头像')
                .fontSize(16)
                .fontColor('#333')
                .width('100%')
                .margin({ top: 12, bottom: 12 })

              this.CardUpload('上传头像', 'avatar', $r('app.media.img11'), this.avatarUri)
            }
            .width('100%')
            .padding(16)
            .alignItems(HorizontalAlign.Start)

            Divider().color('#EEE').width('100%')

            // 2. 身份证件（正反面，屏幕内完整显示）
            Column() {
              Text('* 身份证件（正反面均需上传）')
                .fontSize(16)
                .fontColor('#333')
                .width('100%')
                .margin({ bottom: 12 })

              Row({ space: '4%' }) {
                this.CardUpload('身份证国徽面', 'idCardFront', $r('app.media.nation'), this.idCardFrontUri)
                this.CardUpload('身份证人像面', 'idCardBack', $r('app.media.person'), this.idCardBackUri)
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
            }
            .width('100%')
            .padding(16)
            .alignItems(HorizontalAlign.Start)

            Divider().color('#EEE').width('100%')

            // 3. 执业证书
            Column() {
              Text('* 胸牌/执业证/资格证/职称证，至少上传一项')
                .fontSize(16)
                .fontColor('#333')
                .width('100%')
                .margin({ top: 12, bottom: 12 })

              this.CardUpload('上传证书', 'cert', $r('app.media.ic_upload'), this.certUri)
            }
            .width('100%')
            .padding(16)
            .alignItems(HorizontalAlign.Start)

            // 隐私提示
            Text('照片仅用作认证，平台会保护您的隐私，不会泄漏给第三方')
              .fontSize(13)
              .fontColor('#999')
              .width('100%')
              .padding({ left: 16, right: 16, bottom: 16 })

            // 提交按钮
            Button('提交认证')
              .width('90%')
              .height(50)
              .margin({ top: 20, bottom: 30 })
              .backgroundColor('#007DFF')
              .fontColor('#FFF')
              .fontSize(16)
              .borderRadius(25)
              .onClick(() => {
                console.log(`提交认证: ${this.avatarUri}, ${this.idCardFrontUri}, ${this.idCardBackUri}, ${this.certUri}`);
              })
          }
          .width('100%')
          .backgroundColor('#FFF')
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)
      .scrollable(ScrollDirection.Vertical)

      // 底部弹窗
      if (this.showActionSheet) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('rgba(0,0,0,0.5)')
            .onClick(() => this.showActionSheet = false)

          Column() {
            Button('拍照')
              .width('100%')
              .height(55)
              .backgroundColor('#FFF')
              .fontColor('#007DFF')
              .fontSize(17)
              .borderRadius(0)
              .onClick(() => this.handleImageSelect(true))

            Divider().color('#EEE')

            Button('相册')
              .width('100%')
              .height(55)
              .backgroundColor('#FFF')
              .fontColor('#007DFF')
              .fontSize(17)
              .borderRadius(0)
              .onClick(() => this.handleImageSelect(false))

            Divider().color('#EEE')

            Button('取消')
              .width('100%')
              .height(55)
              .backgroundColor('#FFF')
              .fontColor('#007DFF')
              .fontSize(17)
              .borderRadius(0)
              .margin({ top: 10 })
              .onClick(() => this.showActionSheet = false)
          }
          .width('90%')
          .borderRadius(12)
        }
        .width('100%')
        .height('100%')
        .alignContent(Alignment.Bottom)
      }
    }
  }
}