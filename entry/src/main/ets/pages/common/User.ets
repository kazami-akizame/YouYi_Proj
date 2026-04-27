// pages/common/User.ets - 用户相关数据模型

/*** 登录请求接口*/
export interface LoginRequest {
  phoneNumber: string;
  verifyCode: string;
}

/*** 用户信息接口*/
export interface Userinfo {
  userId: string;
  token: string;
  phoneNumber: string;
  nickname?: string;
}

/*** 登录响应接口*/
export interface LoginResponse {
  code: number;
  message: string;
  data?: Userinfo | null;
}

/*** 用户数据项接口（对应 data.json 中的用户记录）*/
export interface UserItem {
  id: string;
  phoneNumber: string;
  nickname: string;
  createTime: string;
  password?: string;
}

/*** 验证码数据项接口*/
export interface VerifyCodeItem {
  phoneNumber: string;
  code: string;
  timestamp: number;
  id?: string;
}

/*** 创建验证码请求数据接口*/
export interface CreateVerifyCodeData {
  phoneNumber: string;
  code: string;
  timestamp: number;
}

/*** 注册用户数据接口*/
export interface RegisterUserData {
  phoneNumber: string;
  password: string;
  nickname: string;
  createTime: string;
}

/*** 用户更新数据接口*/
export interface UserUpdateData {
  phoneNumber: string;
  password: string;
  nickname: string;
  createTime: string;
}