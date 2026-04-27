// business/PasswordBusiness.ets
import { LoginService } from '../service/LoginService';
import prompt from '@ohos.prompt';
import router from '@ohos.router';

export class PasswordBusiness {

  /**
   * 验证手机号格式
   */
  static validatePhoneNumber(phoneNumber: string): boolean {
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    return phoneRegex.test(phoneNumber);
  }

  /**
   * 验证密码格式（6-16位）
   */
  static validatePassword(password: string): boolean {
    return password.length >= 6 && password.length <= 16;
  }

  /**
   * 验证验证码格式（6位数字）
   */
  static validateVerifyCode(code: string): boolean {
    const codeRegex: RegExp = /^\d{6}$/;
    return codeRegex.test(code);
  }

  /**
   * 处理发送验证码（找回密码用）
   */
  static async handleSendCode(phoneNumber: string): Promise<boolean> {
    if (!PasswordBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    // 先检查手机号是否已注册
    const exists = await LoginService.checkUserExists(phoneNumber);

    if (!exists) {
      console.log(`手机号未注册, 手机号: ${phoneNumber}`);
      prompt.showToast({
        message: '该手机号尚未注册',
        duration: 2000
      });
      return false;
    }

    // 已注册，发送验证码
    const success = await LoginService.sendVerifyCode(phoneNumber);

    if (success) {
      prompt.showToast({
        message: '验证码已发送',
        duration: 2000
      });
      return true;
    } else {
      prompt.showToast({
        message: '发送失败，请检查网络',
        duration: 2000
      });
      return false;
    }
  }

  /**
   * 验证找回密码的验证码
   */
  static async verifyResetCode(phoneNumber: string, verifyCode: string): Promise<boolean> {
    if (!PasswordBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    if (!PasswordBusiness.validateVerifyCode(verifyCode)) {
      prompt.showToast({
        message: '请输入6位验证码',
        duration: 2000
      });
      return false;
    }

    // 调用登录接口验证验证码（复用验证码验证逻辑）
    const result = await LoginService.loginWithCode({ phoneNumber, verifyCode });

    if (result.code === 200) {
      return true;
    } else if (result.code === 400) {
      prompt.showToast({
        message: '验证码错误或已过期',
        duration: 2000
      });
      return false;
    } else {
      prompt.showToast({
        message: result.message || '验证失败',
        duration: 2000
      });
      return false;
    }
  }

  /**
   * 处理重置密码
   */
  static async handleResetPassword(
    phoneNumber: string,
    newPassword: string
  ): Promise<boolean> {
    if (!PasswordBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '手机号格式不正确',
        duration: 2000
      });
      return false;
    }

    if (!PasswordBusiness.validatePassword(newPassword)) {
      prompt.showToast({
        message: '密码长度为6-16位',
        duration: 2000
      });
      return false;
    }

    // 检查用户是否存在
    const exists = await LoginService.checkUserExists(phoneNumber);
    if (!exists) {
      console.log(`手机号未注册, 手机号: ${phoneNumber}`);
      prompt.showToast({
        message: '该手机号尚未注册',
        duration: 2000
      });
      return false;
    }

    // 调用更新密码接口
    const success = await LoginService.updatePassword(phoneNumber, newPassword);

    if (success) {
      prompt.showToast({
        message: '密码重置成功',
        duration: 2000
      });
      return true;
    } else {
      prompt.showToast({
        message: '密码重置失败，请重试',
        duration: 2000
      });
      return false;
    }
  }

  /**
   * 处理修改密码（已登录状态）
   */
  static async handleChangePassword(
    phoneNumber: string,
    oldPassword: string,
    newPassword: string
  ): Promise<boolean> {
    if (!PasswordBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '手机号格式不正确',
        duration: 2000
      });
      return false;
    }

    if (!PasswordBusiness.validatePassword(oldPassword)) {
      prompt.showToast({
        message: '原密码格式不正确',
        duration: 2000
      });
      return false;
    }

    if (!PasswordBusiness.validatePassword(newPassword)) {
      prompt.showToast({
        message: '新密码长度为6-16位',
        duration: 2000
      });
      return false;
    }

    // 验证原密码是否正确
    const oldPasswordCorrect = await LoginService.verifyPassword(phoneNumber, oldPassword);
    if (!oldPasswordCorrect) {
      prompt.showToast({
        message: '原密码错误',
        duration: 2000
      });
      return false;
    }

    // 调用更新密码接口
    const success = await LoginService.updatePassword(phoneNumber, newPassword);

    if (success) {
      prompt.showToast({
        message: '密码修改成功',
        duration: 2000
      });
      return true;
    } else {
      prompt.showToast({
        message: '密码修改失败，请重试',
        duration: 2000
      });
      return false;
    }
  }
}
