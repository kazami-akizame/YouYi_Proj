import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import util from '@ohos.util';
import { DoctorCertificationBusiness } from '../../business/DoctorCertificationBusiness';
import { DoctorInfo, DoctorCertImages, DoctorCertificationRequest } from '../common/Doctor';
import { PermissionsUtil } from '../../utils/PermissionsUtil';
import { common } from '@kit.AbilityKit';

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

  @State refreshKey: number = 0;// 用于强制触发 UI 刷新的时间戳

  @State currentUploadType: UploadType | null = null;// 当前要上传的图片类型（控制弹窗选择的目标）

  @State showActionSheet: boolean = false; // 控制底部弹窗显示/隐藏

  @State doctorInfo: DoctorInfo = new DoctorInfo();// 医生信息

  @State phoneNumber: string = '';// 手机号(从登录状态获取)
  aboutToAppear() {
    // 接收从 DoctorCertification 页面传来的医生信息
    interface RouterParams {
      doctorInfo?: DoctorInfo;
    }
    const params = router.getParams() as RouterParams;
    if (params && params.doctorInfo) {
      this.doctorInfo = params.doctorInfo;
    }
    
    // 从 AppStorage 获取登录用户的手机号
    const storedPhone = AppStorage.get<string>('currentUserPhone');
    if (storedPhone) {
      this.phoneNumber = storedPhone;
    }
    
    // 从 AppStorage 恢复已上传的图片URI
    this.restoreUploadedImages();
  }

  // 将图片文件复制到应用沙箱目录
  private async copyImageToAppDir(sourceUri: string, fileName: string): Promise<string> {
    try {
      // 获取应用沙箱目录
      const context = getContext(this) as common.UIAbilityContext;
      const filesDir = context.filesDir;
      const targetPath = `${filesDir}/${fileName}`;
      
      // 打开源文件
      const srcFile = fs.openSync(sourceUri, fs.OpenMode.READ_ONLY);
      
      // 创建目标文件
      const destFile = fs.openSync(targetPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
      
      // 复制文件内容
      let bufferSize = 4096;
      let buffer = new ArrayBuffer(bufferSize);
      let totalBytes = 0;
      
      while (true) {
        const readLen = fs.readSync(srcFile.fd, buffer);
        if (readLen <= 0) {
          break;
        }
        fs.writeSync(destFile.fd, buffer.slice(0, readLen));
        totalBytes += readLen;
      }
      
      // 关闭文件
      fs.closeSync(srcFile);
      fs.closeSync(destFile);
            
      // 重要:HarmonyOS Image 组件需要使用 file:// 前缀来加载沙箱文件
      // 如果 targetPath 已经包含 file://,则不再添加
      let fileUri = targetPath;
      if (!targetPath.startsWith('file://')) {
        fileUri = `file://${targetPath}`;
      }
            
      return fileUri;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`${TAG}: 处理图片失败: ${err.message}`);
      // 失败时返回原始 URI
      return sourceUri;
    }
  }

  // 从相册选择图片
  private async pickImageFromGallery(): Promise<string | null> {
    try {
      
      // 注意：鸿蒙的 photoAccessHelper 会自动请求权限，不需要手动请求
      // PermissionsUtil 的权限请求需要 UIAbilityContext，这里简化处理
      
      // 创建照片选择选项
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE; // 选择图片类型
      photoSelectOptions.maxSelectNumber = 1; // 最多选择1张图片
      
      // 创建照片选择器
      const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
      
      // 调用选择器
      const photoSelectResult = await photoViewPicker.select(photoSelectOptions);
      
      if (photoSelectResult && photoSelectResult.photoUris && photoSelectResult.photoUris.length > 0) {
        return photoSelectResult.photoUris[0];
      } else {
        return null;
      }
    } catch (error) {
      const err = error as BusinessError;
      console.error(`${TAG}: 选择图片失败: ${JSON.stringify(err)}`);
      promptAction.showToast({ message: '选择图片失败', duration: 2000 });
      return null;
    }
  }

  // 拍照
  private async takePhoto(): Promise<string | null> {
    try {
      console.info(`${TAG}: 调用相机拍照`);
      promptAction.showToast({ message: '请使用相册选择图片', duration: 2000 });
      // 注意：鸿蒙相机需要使用 want 方式调用系统相机
      // 这里简化处理，建议使用相册选择
      return null;
    } catch (error) {
      const err = error as BusinessError;
      console.error(`${TAG}: 拍照失败: ${JSON.stringify(err)}`);
      promptAction.showToast({ message: '拍照失败', duration: 2000 });
      return null;
    }
  }

  // 处理图片选择
  private async handleImageSelect(isCamera: boolean) {
    this.showActionSheet = false;

    const imageUri = isCamera ? await this.takePhoto() : await this.pickImageFromGallery();
    if (!imageUri || !this.currentUploadType) {
      return;
    }
    
    try {
      // 将图片复制到应用沙箱目录
      const fileName = `${this.currentUploadType}_${Date.now()}.jpg`;
      const savedUri = await this.copyImageToAppDir(imageUri, fileName);
      
      // 使用 switch 更新对应的 @State 变量
      switch (this.currentUploadType) {
        case 'avatar':
          this.avatarUri = savedUri;
          console.info(`${TAG}: ✓ 头像 URI 已更新: ${this.avatarUri}`);
          console.info(`${TAG}:   长度: ${this.avatarUri.length}`);
          console.info(`${TAG}:   是否以 file:// 开头: ${this.avatarUri.startsWith('file://')}`);
          break;
        case 'idCardFront':
          this.idCardFrontUri = savedUri;
          console.info(`${TAG}: ✓ 身份证正面 URI 已更新: ${this.idCardFrontUri}`);
          console.info(`${TAG}:   长度: ${this.idCardFrontUri.length}`);
          console.info(`${TAG}:   是否以 file:// 开头: ${this.idCardFrontUri.startsWith('file://')}`);
          break;
        case 'idCardBack':
          this.idCardBackUri = savedUri;
          console.info(`${TAG}: ✓ 身份证反面 URI 已更新: ${this.idCardBackUri}`);
          console.info(`${TAG}:   长度: ${this.idCardBackUri.length}`);
          console.info(`${TAG}:   是否以 file:// 开头: ${this.idCardBackUri.startsWith('file://')}`);
          break;
        case 'cert':
          this.certUri = savedUri;
          console.info(`${TAG}: ✓ 证书 URI 已更新: ${this.certUri}`);
          console.info(`${TAG}:   长度: ${this.certUri.length}`);
          console.info(`${TAG}:   是否以 file:// 开头: ${this.certUri.startsWith('file://')}`);
          break;
      }
      
      // 更新时间戳,强制触发 UI 重新渲染
      this.refreshKey = Date.now();
      
      // 每次上传图片后立即更新 AppStorage，确保状态同步
      this.updateAppStorage();
      
      // 显示成功提示
      promptAction.showToast({ message: '上传成功', duration: 1500 });
    } catch (error) {
      const err = error as BusinessError;
      console.error(`${TAG}: 处理图片失败: ${err.message}`);
      promptAction.showToast({ message: '图片处理失败，请重试', duration: 2000 });
    }
  }

  // 从 AppStorage 恢复已上传的图片
  private restoreUploadedImages(): void {
    const avatarUri = AppStorage.get<string>('avatarUri') || '';
    const idCardFrontUri = AppStorage.get<string>('idCardFrontUri') || '';
    const idCardBackUri = AppStorage.get<string>('idCardBackUri') || '';
    const certUri = AppStorage.get<string>('certUri') || '';
    
    this.avatarUri = avatarUri;
    this.idCardFrontUri = idCardFrontUri;
    this.idCardBackUri = idCardBackUri;
    this.certUri = certUri;
  }

  // 更新 AppStorage 状态
  private updateAppStorage(): void {
    // 检查是否所有图片都已上传
    const allUploaded = !!(this.avatarUri && this.idCardFrontUri && this.idCardBackUri && this.certUri);
    
    // 使用 setOrCreate 确保键存在
    AppStorage.setOrCreate<boolean>('imagesUploaded', allUploaded);
    
    // 存储图片 URI (使用 setOrCreate 避免 undefined)
    AppStorage.setOrCreate<string>('avatarUri', this.avatarUri || '');
    AppStorage.setOrCreate<string>('idCardFrontUri', this.idCardFrontUri || '');
    AppStorage.setOrCreate<string>('idCardBackUri', this.idCardBackUri || '');
    AppStorage.setOrCreate<string>('certUri', this.certUri || '');
  }

  // 上传卡片组件(文字在组件下方)
  // 注意:使用 @Builder 时,必须直接访问 @State 变量,不能通过参数传递
  @Builder
  private CardUpload(label: string, type: UploadType, exampleImg: Resource) {
    Column() {
      Column() {
        if (this.getImageUri(type).length > 0) {
          Image(this.getImageUri(type))
            .key(`image_${type}_${this.refreshKey}`)
            .width('100%')
            .height('100%')
            .borderRadius(12)
            .objectFit(ImageFit.Cover)
            .alt($r('app.media.ic_upload'))
            .onClick(() => {
              this.currentUploadType = type;
              this.showActionSheet = true;
            })
        } else {
          Stack() {
            Image(exampleImg)
              .width(60)
              .height(60)
              .objectFit(ImageFit.Contain)
              .opacity(0.6)

            Image($r('app.media.ic_upload'))
              .width(24)
              .height(24)
              .position({ x: '50%', y: '50%' })
              .translate({ x: -12, y: -12 })
          }
        }
      }
      .width('100%')
      .height(120)
      .backgroundColor('#F2F2F7')
      .borderRadius(12)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {
        this.currentUploadType = type;
        this.showActionSheet = true;
      })

      Text(label)
        .fontSize(14)
        .fontColor('#8E8E93')
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 8 })
    }
    .alignItems(HorizontalAlign.Center)
    .width('48%')
  }

  private getImageUri(type: UploadType): string {
    switch (type) {
      case 'avatar':
        return this.avatarUri;
      case 'idCardFront':
        return this.idCardFrontUri;
      case 'idCardBack':
        return this.idCardBackUri;
      case 'cert':
        return this.certUri;
      default:
        return '';
    }
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Scroll() {
        Column() {
          // 导航栏
          Row() {
            Image($r('app.media.img_4')).width(24).height(24)
              .onClick(() => router.back())
            Text('医师认证').fontSize(19).fontWeight(FontWeight.Medium)
              .layoutWeight(1).textAlign(TextAlign.Center)
          }.width('100%')
          .padding({ top: 15, bottom: 15, left: 15, right: 15 })
          .backgroundColor(Color.White)

          // 提示文本栏 - 位置不变，仅改iOS黄棕色文字
          Row() {
            Image($r('app.media.img_8')).width(20).height(20).margin({ left: 16 })
            Text('请如实上传您的资料')
              .fontSize(14)
              .fontColor('#007AFF')
              .layoutWeight(1)
          }.width('100%')
          .backgroundColor('#F2F2F7')
          .padding({ top: 12, bottom: 12, right: 16 })
          .margin({ bottom: 4 }) // 仅收窄间距，位置不动

          // 表单区域 原有结构、嵌套、摆放完全不变
          Column() {
            // 1. 医生头像
            Column() {
              Text('* 医生头像').fontSize(16).fontColor('#1C1C1E')
                .width('100%').margin({ top: 12, bottom: 12 })

              this.CardUpload('上传头像', 'avatar', $r('app.media.img11'))
            }.width('100%').padding(16)
            .alignItems(HorizontalAlign.Start)

            Divider().color('#E5E5EA').width('100%')

            // 2. 身份证件
            Column() {
              Text('* 身份证件（正反面均需上传）').fontSize(16).fontColor('#1C1C1E')
                .width('100%').margin({ bottom: 12 })

              Row({ space: '4%' }) {
                this.CardUpload('身份证国徽面', 'idCardFront', $r('app.media.nation'))
                this.CardUpload('身份证人像面', 'idCardBack', $r('app.media.person'))
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
            }
            .width('100%').padding(16)
            .alignItems(HorizontalAlign.Start)

            Divider().color('#E5E5EA').width('100%')

            // 3. 执业证书
            Column() {
              Text('* 胸牌/执业证/资格证/职称证，至少上传一项')
                .fontSize(16)
                .fontColor('#1C1C1E')
                .width('100%')
                .margin({ top: 12, bottom: 12 })

              this.CardUpload('上传证书', 'cert', $r('app.media.ic_upload'))
            }
            .width('100%')
            .padding(16)
            .alignItems(HorizontalAlign.Start)

            // 隐私提示
            Text('照片仅用作认证，平台会保护您的隐私，不会泄漏给第三方')
              .fontSize(13)
              .fontColor('#B98C5B')
              .width('100%')
              .padding({ left: 16, right: 16, bottom: 16 })

            // 提交按钮 iOS风格 位置不变
            Button('提交认证')
              .width('90%').height(50)
              .margin({ top: 20, bottom: 30 })
              .backgroundColor('#007AFF')
              .fontColor('#FFF')
              .fontSize(16)
              .borderRadius(14)
              .onClick(async () => {
                // 更新 AppStorage 状态
                this.updateAppStorage();

                // 检查图片完整性

                const allImagesUploaded = !!(this.avatarUri && this.idCardFrontUri && this.idCardBackUri && this.certUri);
                if (!allImagesUploaded) {
                  promptAction.showToast({ message: '请上传完整的认证图片', duration: 2000 });
                  return;
                }

                router.back();
              })
          }
          .width('100%')
          .backgroundColor('#FFF')
        }
        .width('100%')
        .backgroundColor('#F2F2F7')
      }
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Auto)
      .scrollable(ScrollDirection.Vertical)

      // 底部弹窗 原生位置不变，仅iOS配色
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
              .fontColor('#007AFF')
              .fontSize(17)
              .borderRadius(0)
              .onClick(() => this.handleImageSelect(true))

            Divider().color('#E5E5EA')

            Button('相册')
              .width('100%')
              .height(55)
              .backgroundColor('#FFF')
              .fontColor('#007AFF')
              .fontSize(17)
              .borderRadius(0)
              .onClick(() => this.handleImageSelect(false))

            Divider().color('#E5E5EA')

            Button('取消')
              .width('100%')
              .height(55)
              .backgroundColor('#FFF')
              .fontColor('#007AFF')
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