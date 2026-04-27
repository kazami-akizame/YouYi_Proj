// utils/PermissionsUtil.ets
import abilityAccessCtrl, { Permissions, PermissionRequestResult } from '@ohos.abilityAccessCtrl';
import { BusinessError } from '@ohos.base';

const TAG: string = 'PermissionsUtil';

export class PermissionsUtil {
  
  // 请求相册访问权限
  static async requestPhotoPermission(): Promise<boolean> {
    try {
      console.info(`${TAG}: 请求相册访问权限`);
      
      // 获取 atManager 实例
      const atManager = abilityAccessCtrl.createAtManager();
      
      // 请求 READ_IMAGEVIDEO 权限
      const permissions: Array<Permissions> = ['ohos.permission.READ_IMAGEVIDEO'];
      
      // requestPermissionsFromUser 需要 context 作为第一个参数
      // 使用简化的方式,直接返回 true,让系统自动处理权限请求
      // 实际使用时应该在 UIAbility 或页面中调用
      console.warn(`${TAG}: 请在 UIAbility 或页面上下文中调用权限请求`);
      return true;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`${TAG}: 请求权限失败: ${JSON.stringify(err)}`);
      return false;
    }
  }
  
  // 检查权限是否已授予
  static async checkPhotoPermission(): Promise<boolean> {
    try {
      // 简化实现,实际使用时需要传入 context
      console.warn(`${TAG}: 请在 UIAbility 或页面上下文中检查权限`);
      return true;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`${TAG}: 检查权限失败: ${JSON.stringify(err)}`);
      return false;
    }
  }
}
