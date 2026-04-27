// pages/common/Doctor.ets - 医生认证相关数据模型

/** 医生信息类 */
export class DoctorInfo {
  name: string = '';
  hospital: string = '';
  department: string = '';
  title: string = '';
  specialty: string = '';
  intro: string = '';
  experience: string = '';

  constructor() {}

  // 验证信息是否完整
  isComplete(): boolean {
    return !!(
      this.name &&
      this.hospital &&
      this.department &&
      this.title &&
      this.specialty
    );
  }
}

/** 医生认证图片类 */
export class DoctorCertImages {
  avatar: string = '';
  idCardFront: string = '';
  idCardBack: string = '';
  cert: string = '';

  constructor() {}

  // 验证图片是否上传完整
  isComplete(): boolean {
    return !!(
      this.avatar &&
      this.idCardFront &&
      this.idCardBack &&
      this.cert
    );
  }
}

/** 医生认证请求类（提交给后端） */
export class DoctorCertificationRequest {
  phoneNumber: string = '';
  name: string = '';
  hospital: string = '';
  department: string = '';
  title: string = '';
  specialty: string = '';
  intro: string = '';
  experience: string = '';
  avatar: string = '';
  idCardFront: string = '';
  idCardBack: string = '';
  cert: string = '';
  status: string = 'pending';
  createTime: string = '';

  constructor() {
    this.createTime = new Date().toISOString();
  }

  // 从 DoctorInfo 和 DoctorCertImages 构建
  static from(doctorInfo: DoctorInfo, images: DoctorCertImages, phoneNumber: string): DoctorCertificationRequest {
    const request = new DoctorCertificationRequest();
    request.phoneNumber = phoneNumber;
    request.name = doctorInfo.name;
    request.hospital = doctorInfo.hospital;
    request.department = doctorInfo.department;
    request.title = doctorInfo.title;
    request.specialty = doctorInfo.specialty;
    request.intro = doctorInfo.intro;
    request.experience = doctorInfo.experience;
    request.avatar = images.avatar;
    request.idCardFront = images.idCardFront;
    request.idCardBack = images.idCardBack;
    request.cert = images.cert;
    return request;
  }
}

/** 医生认证响应类 */
export class DoctorCertificationResponse {
  code: number = 0;
  message: string = '';
  data: DoctorCertificationItem | null = null;

  constructor() {}

  isSuccess(): boolean {
    return this.code === 200;
  }
}

/** 医生认证数据项类（对应后端返回的数据） */
export class DoctorCertificationItem {
  id: string = '';
  phoneNumber: string = '';
  name: string = '';
  hospital: string = '';
  department: string = '';
  title: string = '';
  specialty: string = '';
  intro: string = '';
  experience: string = '';
  avatar: string = '';
  idCardFront: string = '';
  idCardBack: string = '';
  cert: string = '';
  status: string = '';
  createTime: string = '';

  constructor() {}
}
