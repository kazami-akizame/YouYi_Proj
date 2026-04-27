// business/DoctorCertificationBusiness.ets
import { DoctorCertificationService } from '../service/DoctorCertificationService';
import { DoctorInfo, DoctorCertImages, DoctorCertificationRequest, DoctorCertificationResponse } from '../pages/common/Doctor';
import prompt from '@ohos.prompt';
import router from '@ohos.router';
import { BusinessError } from '@ohos.base';

const TAG: string = 'DoctorCertificationBusiness';

export class DoctorCertificationBusiness {

  // 验证医生信息是否完整
  static validateDoctorInfo(doctorInfo: DoctorInfo): boolean {
    if (!doctorInfo) {
      return false;
    }
    
    // 直接验证字段，而不是调用 isComplete() 方法
    // 这样可以兼容普通对象和类实例
    return !!(
      doctorInfo.name &&
      doctorInfo.hospital &&
      doctorInfo.department &&
      doctorInfo.title &&
      doctorInfo.specialty
    );
  }

  // 验证图片是否上传完整
  static validateImages(images: DoctorCertImages): boolean {
    if (!images) {
      return false;
    }
    
    // 直接验证字段，而不是调用 isComplete() 方法
    // 这样可以兼容普通对象和类实例
    return !!(
      images.avatar &&
      images.idCardFront &&
      images.idCardBack &&
      images.cert
    );
  }

  // 提交认证
  static async submitCertification(
    phoneNumber: string,
    doctorInfo: DoctorInfo,
    images: DoctorCertImages
  ): Promise<boolean> {
    try {
      // 验证医生信息
      
      if (!DoctorCertificationBusiness.validateDoctorInfo(doctorInfo)) {
        prompt.showToast({
          message: '请填写完整的个人信息',
          duration: 2000
        });
        return false;
      }

      // 验证图片
      if (!DoctorCertificationBusiness.validateImages(images)) {
        prompt.showToast({
          message: '请上传完整的认证图片',
          duration: 2000
        });
        return false;
      }

      // 构建认证请求数据
      const certData: DoctorCertificationRequest = DoctorCertificationRequest.from(
        doctorInfo,
        images,
        phoneNumber
      );

      // 调用服务提交认证
      const result: DoctorCertificationResponse = await DoctorCertificationService.submitCertification(certData);

      if (result.isSuccess()) {
        
        prompt.showToast({
          message: '认证提交成功，请等待审核',
          duration: 2000
        });
        return true;
      } else {
        console.error(`${TAG}: 认证失败: ${result.message}`);
        
        prompt.showToast({
          message: result.message || '认证提交失败',
          duration: 3000
        });
        return false;
      }
    } catch (error) {
      const err = error as BusinessError;
      console.error(`${TAG}: 提交认证异常: ${err.message}`);
      
      prompt.showToast({
        message: `提交认证时发生错误: ${err.message || '未知错误'}`,
        duration: 3000
      });
      return false;
    }
  }

  // 检查是否已认证
  static async checkCertification(phoneNumber: string): Promise<boolean> {
    try {
      const exists = await DoctorCertificationService.checkCertificationExists(phoneNumber);
      
      if (exists) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      console.error(`${TAG}: 检查认证状态失败:`, JSON.stringify(error));
      return false;
    }
  }
}
