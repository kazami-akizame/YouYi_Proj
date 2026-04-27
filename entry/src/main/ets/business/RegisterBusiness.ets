// business/RegisterBusiness.ets
import { LoginService } from '../service/LoginService';
import { LoginResponse } from '../pages/common/User';
import prompt from '@ohos.prompt';
import router from '@ohos.router';

export class RegisterBusiness {

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
   * 检查手机号是否已注册
   */
  static async checkPhoneNumberExists(phoneNumber: string): Promise<boolean> {
    if (!RegisterBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    const exists = await LoginService.checkUserExists(phoneNumber);
    
    if (exists) {
      prompt.showToast({
        message: '该手机号已注册，请直接登录',
        duration: 2000
      });
    }
    
    return exists;
  }

  /**
   * 处理发送验证码（注册用）
   */
  static async handleSendCode(phoneNumber: string): Promise<boolean> {
    if (!RegisterBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    // 先检查手机号是否已注册
    const exists = await RegisterBusiness.checkPhoneNumberExists(phoneNumber);
    if (exists) {
      // 已注册，不发送验证码
      return false;
    }

    // 未注册，发送验证码
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

  /*** 处理注册*/
  static async handleRegister(
    phoneNumber: string, 
    password: string, 
    verifyCode: string
  ): Promise<boolean> {
    // 验证手机号
    if (!RegisterBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    // 验证密码
    if (!RegisterBusiness.validatePassword(password)) {
      prompt.showToast({
        message: '密码长度为6-16位',
        duration: 2000
      });
      return false;
    }

    // 验证验证码
    if (!RegisterBusiness.validateVerifyCode(verifyCode)) {
      prompt.showToast({
        message: '请输入6位验证码',
        duration: 2000
      });
      return false;
    }

    // 调用注册接口
    const result: LoginResponse = await LoginService.register(phoneNumber, password, phoneNumber);

    if (result.code === 200) {
      prompt.showToast({
        message: '注册成功，请登录',
        duration: 2000
      });
      return true;
    } else if (result.code === 409) {
      prompt.showToast({
        message: '该手机号已注册，请直接登录',
        duration: 2000
      });
      return false;
    } else {
      prompt.showToast({
        message: result.message || '注册失败',
        duration: 2000
      });
      return false;
    }
  }
}
