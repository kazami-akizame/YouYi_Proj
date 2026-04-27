// 问诊类型枚举
export enum ConsultationType {
  SPEED = '极速',      // 极速问诊
  GRAPHIC = '图文',     // 图文问诊
  PRESCRIPTION = '开药' // 开药问诊
}

// 问诊状态枚举
export enum ConsultationStatus {
  WAITING = '待接诊',
  IN_PROGRESS = '进行中',
  REJECTED = '已退诊',
  FINISHED = '问诊结束'
}

// 问诊数据模型
export class ConsultationItem {
  id: string = '';                          // 唯一标识
  patientName: string = '';                 // 患者姓名
  patientGender: string = '';               // 性别
  patientAge: number = 0;                  // 年龄
  type: ConsultationType = ConsultationType.GRAPHIC;              // 问诊类型
  status: ConsultationStatus = ConsultationStatus.WAITING;          // 问诊状态
  description: string = '';                 // 病情描述
  createTime: string = '';                  // 创建时间
  rejectReason?: string;

  constructor(
    id: string,
    patientName: string,
    patientGender: string,
    patientAge: number,
    type: ConsultationType,
    status: ConsultationStatus,
    description: string,
    createTime: string,
    rejectReason?: string
  ) {
    this.id = id;
    this.patientName = patientName;
    this.patientGender = patientGender;
    this.patientAge = patientAge;
    this.type = type;
    this.status = status;
    this.description = description;
    this.createTime = createTime;
    this.rejectReason = this.rejectReason;
  }
}

// 模拟数据生成器
export class MockDataGenerator {
  // 生成模拟问诊数据
  static generateMockData(): ConsultationItem[] {
    const mockData: ConsultationItem[] = [];
    const names = ['吴珊珊', '张伟', '李娜', '王磊', '刘芳', '陈晨', '赵宇', '孙丽'];
    const genders = ['男', '女'];
    const baseDescription = '早起经常头晕，恶心，有时候会咳嗽';
    const types = [ConsultationType.SPEED, ConsultationType.GRAPHIC, ConsultationType.PRESCRIPTION];
    const statuses = [ConsultationStatus.WAITING, ConsultationStatus.IN_PROGRESS,
      ConsultationStatus.REJECTED, ConsultationStatus.FINISHED];

    // 生成基础数据
    for (let i = 0; i < names.length; i++) {
      const id = `C${String(i + 1).padStart(3, '0')}`;
      const name = names[i];
      const gender = i % 2 === 0 ? '女' : '男';
      const age = 20 + Math.floor(Math.random() * 30);
      const type = types[i % types.length];
      const status = statuses[i % statuses.length];
      const desc = `${baseDescription}${i > 0 ? '（持续约' + (3 + i) + '天）' : ''}`;
      const time = `2026-04-${String(6 + i).padStart(2, '0')} 08:08`;

      mockData.push(new ConsultationItem(id, name, gender, age, type, status, desc, time));
    }

    // 额外添加一些数据确保每个状态都有足够的展示项
    mockData.push(new ConsultationItem('C009', '郑丽', '女', 25, ConsultationType.GRAPHIC,
      ConsultationStatus.WAITING, '早起经常头晕，恶心，有时候会咳嗽', '2026-02-06 08:09'));
    mockData.push(new ConsultationItem('C010', '陈明', '男', 28, ConsultationType.PRESCRIPTION,
      ConsultationStatus.IN_PROGRESS, '早起经常头晕，恶心，有时候会咳嗽', '2026-02-06 08:09'));
    mockData.push(new ConsultationItem('C011', '刘洋', '女', 22, ConsultationType.SPEED,
      ConsultationStatus.REJECTED, '早起经常头晕，恶心，有时候会咳嗽', '2026-02-06 08:09'));
    mockData.push(new ConsultationItem('C012', '周敏', '女', 31, ConsultationType.GRAPHIC,
      ConsultationStatus.FINISHED, '早起经常头晕，恶心，有时候会咳嗽', '2026-02-06 08:09'));

    return mockData;
  }
}