// service/LoginService.ets
import http from '@ohos.net.http';
import { LoginRequest, LoginResponse, UserItem, VerifyCodeItem, CreateVerifyCodeData, RegisterUserData, UserUpdateData } from '../pages/common/User';

export class LoginService {
  // 模拟器使用: 10.0.2.2:8080
  // 真机使用: 电脑实际IP (如 192.168.1.100:8080)
  private static BASE_URL: string = 'http://10.0.2.2:8080';

  // 发送验证码
  static async sendVerifyCode(phoneNumber: string): Promise<boolean> {
    try {
      const verifyCode: string = Math.floor(100000 + Math.random() * 900000).toString();
      const httpRequest: http.HttpRequest = http.createHttp();

      const requestData: CreateVerifyCodeData = {
        phoneNumber: phoneNumber,
        code: verifyCode,
        timestamp: Date.now()
      };

      const response: http.HttpResponse = await httpRequest.request(`${LoginService.BASE_URL}/verifyCodes`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(requestData),
        connectTimeout: 10000,
        readTimeout: 10000
      });

      if (response.responseCode === 201) {
        console.log(`验证码: ${verifyCode}, 手机号: ${phoneNumber}`);
        return true;
      }
      return false;
    } catch (error) {
      console.error('发送验证码失败:', JSON.stringify(error));
      return false;
    }
  }

  // 检查用户是否已注册
  static async checkUserExists(phoneNumber: string): Promise<boolean> {
    try {
      const httpRequest: http.HttpRequest = http.createHttp();
      
      // 添加时间戳避免缓存
      const timestamp = Date.now();
      const url = `${LoginService.BASE_URL}/users`;
      
      const response: http.HttpResponse = await httpRequest.request(
        url,
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const responseText: string = response.result as string;

        console.log("responseText"+responseText);

        const users: UserItem[] = JSON.parse(responseText) as UserItem[];

        console.log("users"+users.toString());
        
        if (!users || users.length === 0) {
          console.log("用户为空或不存在");
          return false;
        }
        
        // 本地查找匹配的手机号（使用 trim 去除空格）
        const trimmedPhone = phoneNumber.trim();
        for (let i = 0; i < users.length; i++) {
          if (users[i].phoneNumber && users[i].phoneNumber.trim() === trimmedPhone) {
            return true;
          }
        }
        console.log("手机号不存在");
        return false;
      }
      return false;
    } catch (error) {
      console.error('检查用户失败:', JSON.stringify(error));
      return false;
    }
  }

  // 获取用户信息（包括密码）
  static async getUserInfo(phoneNumber: string): Promise<UserItem | null> {
    try {
      const httpRequest: http.HttpRequest = http.createHttp();
      
      // 添加时间戳避免缓存
      const timestamp = Date.now();
      const response: http.HttpResponse = await httpRequest.request(
        `${LoginService.BASE_URL}/users?_t=${timestamp}`,
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const responseText: string = response.result as string;
        const users: UserItem[] = JSON.parse(responseText) as UserItem[];
        
        if (users && users.length > 0) {
          // 本地查找匹配的手机号（使用 trim 去除空格）
          const trimmedPhone = phoneNumber.trim();
          for (let i = 0; i < users.length; i++) {
            if (users[i].phoneNumber && users[i].phoneNumber.trim() === trimmedPhone) {
              return users[i];
            }
          }
        }
        
        return null;
      }
      return null;
    } catch (error) {
      console.error('获取用户信息失败:', JSON.stringify(error));
      return null;
    }
  }

  // 验证码登录
  static async loginWithCode(loginData: LoginRequest): Promise<LoginResponse> {
    try {
      const phoneNumber: string = loginData.phoneNumber;
      const verifyCode: string = loginData.verifyCode;
      const httpRequest: http.HttpRequest = http.createHttp();

      // 1. 先获取所有验证码
      const allCodesResponse: http.HttpResponse = await httpRequest.request(`${LoginService.BASE_URL}/verifyCodes`, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
        }
      });

      let codes: VerifyCodeItem[] = [];
      if (allCodesResponse.responseCode === 200) {
        const allCodesText: string = allCodesResponse.result as string;
        codes = JSON.parse(allCodesText) as VerifyCodeItem[];
      }

      // 2. 查找匹配的验证码
      let validCode: VerifyCodeItem | undefined = undefined;
      const now: number = Date.now();

      for (let i: number = 0; i < codes.length; i++) {
        const item: VerifyCodeItem = codes[i];
        if (item.phoneNumber === phoneNumber && 
            item.code === verifyCode && 
            (now - item.timestamp) < 300000) { // 5分钟有效
          validCode = item;
          break;
        }
      }

      if (!validCode) {
        const errorResponse: LoginResponse = {
          code: 400,
          message: '验证码错误或已过期',
          data: null
        };
        return errorResponse;
      }

      // 3. 删除已使用的验证码
      if (validCode.id !== undefined) {
        await httpRequest.request(`${LoginService.BASE_URL}/verifyCodes/${validCode.id}`, {
          method: http.RequestMethod.DELETE
        });
      }

      // 4. 查询用户
      const timestamp = Date.now();
      const userResponse: http.HttpResponse = await httpRequest.request(
        `${LoginService.BASE_URL}/users`,
        { method: http.RequestMethod.GET }
      );

      let user: UserItem | null = null;
      if (userResponse.responseCode === 200) {
        const userText: string = userResponse.result as string;
        const users: UserItem[] = JSON.parse(userText) as UserItem[];
        
        if (users && users.length > 0) {
          // 本地查找匹配的用户（使用 trim 去除空格）
          const trimmedPhone = phoneNumber.trim();
          for (let i = 0; i < users.length; i++) {
            if (users[i].phoneNumber && users[i].phoneNumber.trim() === trimmedPhone) {
              user = users[i];
              break;
            }
          }
        }
      }

      // 5. 返回结果
      if (user !== null) {
        const successResponse: LoginResponse = {
          code: 200,
          message: '登录成功',
          data: {
            userId: user.id,
            token: `token_${Date.now()}`,
            phoneNumber: user.phoneNumber
          }
        };
        return successResponse;
      } else {
        const errorResponse: LoginResponse = {
          code: 401,
          message: '该手机号尚未注册，请先注册',
          data: null
        };
        return errorResponse;
      }
    } catch (error) {
      console.error(`登录失败, 手机号: ${loginData.phoneNumber}, 错误:`, JSON.stringify(error));
      const errorResponse: LoginResponse = {
        code: 500,
        message: '网络错误',
        data: null
      };
      return errorResponse;
    }
  }

  // 密码登录
  static async loginWithPassword(phoneNumber: string, password: string): Promise<LoginResponse> {
    try {
      const httpRequest: http.HttpRequest = http.createHttp();
      const response: http.HttpResponse = await httpRequest.request(
        `${LoginService.BASE_URL}/users?phoneNumber=${phoneNumber}&password=${password}`,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json'
          }
        }
      );

      if (response.responseCode === 200) {
        const responseText: string = response.result as string;
        const users: UserItem[] = JSON.parse(responseText) as UserItem[];

        if (users.length > 0) {
          const user: UserItem = users[0];
          const successResponse: LoginResponse = {
            code: 200,
            message: '登录成功',
            data: {
              userId: user.id,
              token: `token_${Date.now()}`,
              phoneNumber: user.phoneNumber
            }
          };
          return successResponse;
        }
      }

      const failResponse: LoginResponse = {
        code: 400,
        message: '手机号或密码错误',
        data: null
      };
      return failResponse;
    } catch (error) {
      console.error(`密码登录失败, 手机号: ${phoneNumber}, 错误:`, JSON.stringify(error));
      const errorResponse: LoginResponse = {
        code: 500,
        message: '网络错误',
        data: null
      };
      return errorResponse;
    }
  }

  // 注册新用户
  static async register(phoneNumber: string, password: string, nickname: string): Promise<LoginResponse> {
    try {
      const httpRequest: http.HttpRequest = http.createHttp();

      // 1. 先检查用户是否已存在
      // 获取所有用户，本地查找
      const timestamp = Date.now();
      const checkResponse: http.HttpResponse = await httpRequest.request(
        `${LoginService.BASE_URL}/users`,
        { method: http.RequestMethod.GET }
      );

      if (checkResponse.responseCode === 200) {
        const checkText: string = checkResponse.result as string;
        const existingUsers: UserItem[] = JSON.parse(checkText) as UserItem[];

        if (existingUsers && existingUsers.length > 0) {
          // 本地查找匹配的手机号（使用 trim 去除空格）
          const trimmedPhone = phoneNumber.trim();
          for (let i = 0; i < existingUsers.length; i++) {
            if (existingUsers[i].phoneNumber && existingUsers[i].phoneNumber.trim() === trimmedPhone) {
              return {
                code: 409,
                message: '该手机号已注册，请直接登录',
                data: null
              };
            }
          }
        }
      }

      // 2. 创建新用户（包含密码）
      const newUserData: RegisterUserData = {
        phoneNumber: phoneNumber,
        password: password,
        nickname: nickname,
        createTime: new Date().toISOString()
      };

      const createResponse: http.HttpResponse = await httpRequest.request(`${LoginService.BASE_URL}/users`, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: JSON.stringify(newUserData)
      });

      if (createResponse.responseCode === 201) {
        const createUserText: string = createResponse.result as string;
        const user: UserItem = JSON.parse(createUserText) as UserItem;
        return {
          code: 200,
          message: '注册成功',
          data: {
            userId: user.id,
            token: `token_${Date.now()}`,
            phoneNumber: user.phoneNumber
          }
        };
      }

      return {
        code: 500,
        message: '注册失败，请重试',
        data: null
      };
    } catch (error) {
      console.error(`注册失败, 手机号: ${phoneNumber}, 错误:`, JSON.stringify(error));
      return {
        code: 500,
        message: '网络错误',
        data: null
      };
    }
  }

  // 验证密码是否正确
  static async verifyPassword(phoneNumber: string, password: string): Promise<boolean> {
    try {
      const httpRequest: http.HttpRequest = http.createHttp();
      const timestamp = Date.now();
      
      // 获取所有用户，本地查找
      const response: http.HttpResponse = await httpRequest.request(
        `${LoginService.BASE_URL}/users`,
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const responseText: string = response.result as string;
        const users: UserItem[] = JSON.parse(responseText) as UserItem[];

        if (users && users.length > 0) {
          // 查找匹配的用户（使用 trim 去除空格）
          const trimmedPhone = phoneNumber.trim();
          for (let i = 0; i < users.length; i++) {
            if (users[i].phoneNumber && users[i].phoneNumber.trim() === trimmedPhone) {
              // 验证密码
              if (users[i].password === password) {
                return true;
              } else {
                return false;
              }
            }
          }
        }

        return false;
      }
      return false;
    } catch (error) {
      console.error(`验证密码失败, 手机号: ${phoneNumber}, 错误:`, JSON.stringify(error));
      return false;
    }
  }

  // 更新密码
  static async updatePassword(phoneNumber: string, newPassword: string): Promise<boolean> {
    try {
      const httpRequest: http.HttpRequest = http.createHttp();
      const timestamp = Date.now();
      
      // 获取所有用户
      const response: http.HttpResponse = await httpRequest.request(
        `${LoginService.BASE_URL}/users`,
        { method: http.RequestMethod.GET }
      );

      if (response.responseCode === 200) {
        const responseText: string = response.result as string;
        const users: UserItem[] = JSON.parse(responseText) as UserItem[];

        if (users && users.length > 0) {
          // 查找匹配的用户（使用 trim 去除空格）
          const trimmedPhone = phoneNumber.trim();
          for (let i = 0; i < users.length; i++) {
            if (users[i].phoneNumber && users[i].phoneNumber.trim() === trimmedPhone) {
              const userId = users[i].id;
              
              // 更新用户密码（使用 PUT 请求）
              const updateData : UserUpdateData= {
                phoneNumber: users[i].phoneNumber,
                password: newPassword,
                nickname: users[i].nickname,
                createTime: users[i].createTime
              };

              const updateResponse: http.HttpResponse = await httpRequest.request(
                `${LoginService.BASE_URL}/users/${userId}`,
                {
                  method: http.RequestMethod.PUT,
                  header: {
                    'Content-Type': 'application/json'
                  },
                  extraData: JSON.stringify(updateData)
                }
              );

              if (updateResponse.responseCode === 200) {
                return true;
              } else {
                return false;
              }
            }
          }
        }

        return false;
      }
      return false;
    } catch (error) {
      console.error(`更新密码失败, 手机号: ${phoneNumber}, 错误:`, JSON.stringify(error));
      return false;
    }
  }
}