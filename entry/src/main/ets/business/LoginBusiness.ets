// business/LoginBusiness.ets
import { LoginService } from '../service/LoginService';
import { LoginResponse } from '../pages/common/User';
import prompt from '@ohos.prompt';
import router from '@ohos.router';

export class LoginBusiness {

  static validatePhoneNumber(phoneNumber: string): boolean {
    const phoneRegex: RegExp = /^1[3-9]\d{9}$/;
    return phoneRegex.test(phoneNumber);
  }

  static validateVerifyCode(code: string): boolean {
    const codeRegex: RegExp = /^\d{6}$/;
    return codeRegex.test(code);
  }

  static async handleSendCode(phoneNumber: string): Promise<boolean> {
    if (!LoginBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    // 先检查用户是否已注册
    const exists = await LoginService.checkUserExists(phoneNumber);

    if (!exists) {
      console.log(`手机号未注册, 手机号: ${phoneNumber}`);
      prompt.showToast({
        message: '当前用户不存在，请前往注册',
        duration: 2000
      });
      return false;
    }

    // 已注册，发送验证码
    const success: boolean = await LoginService.sendVerifyCode(phoneNumber);

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

  static async handleLogin(phoneNumber: string, verifyCode: string): Promise<boolean> {
    if (!LoginBusiness.validatePhoneNumber(phoneNumber)) {
      prompt.showToast({
        message: '请输入正确的手机号码',
        duration: 2000
      });
      return false;
    }

    if (!LoginBusiness.validateVerifyCode(verifyCode)) {
      prompt.showToast({
        message: '请输入6位验证码',
        duration: 2000
      });
      return false;
    }

    const result: LoginResponse = await LoginService.loginWithCode({ phoneNumber, verifyCode });

    if (result.code === 200) {
      prompt.showToast({
        message: '登录成功',
        duration: 2000
      });
      return true;
    } else if (result.code === 401) {
      // 用户未注册，跳转到注册页面
      prompt.showToast({
        message: result.message,
        duration: 2000
      });
      // 跳转到注册页面，并传递手机号
      router.pushUrl({
        url: 'pages/Register',
        params: {
          phoneNumber: phoneNumber,
          needPassword: true  // 标记需要设置密码
        }
      });
      return false;
    } else {
      prompt.showToast({
        message: result.message || '登录失败',
        duration: 2000
      });
      return false;
    }
  }
}