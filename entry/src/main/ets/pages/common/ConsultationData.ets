// 导入必须放顶部
import http from '@ohos.net.http';

// 枚举
export enum ConsultationType {
  SPEED = '极速',
  GRAPHIC = '图文',
  PRESCRIPTION = '开药'
}

export enum ConsultationStatus {
  WAITING = '待接诊',
  IN_PROGRESS = '进行中',
  REJECTED = '已退诊',
  FINISHED = '问诊结束'
}

// 模型
export class ConsultationItem {
  id: string = '';
  patientName: string = '';
  patientGender: string = '';
  patientAge: number = 0;
  type: ConsultationType = ConsultationType.GRAPHIC;
  status: ConsultationStatus = ConsultationStatus.WAITING;
  description: string = '';
  createTime: string = '';
  rejectReason?: string = '';
  // 新增：持久化聊天记录 + 处方
  chatMessages?: ChatMessage[];

  constructor(
    id: string,
    patientName: string,
    patientGender: string,
    patientAge: number,
    type: ConsultationType,
    status: ConsultationStatus,
    description: string,
    createTime: string,
    rejectReason?: string,
    // 新增：持久化聊天记录 + 处方
    chatMessages?: ChatMessage[]
  ) {
    this.id = id;
    this.patientName = patientName;
    this.patientGender = patientGender;
    this.patientAge = patientAge;
    this.type = type;
    this.status = status;
    this.description = description;
    this.createTime = createTime;
    this.rejectReason = rejectReason;
    // 新增：持久化聊天记录 + 处方
    this.chatMessages = chatMessages;
  }
}

// 处方
export interface Prescription {
  id: string;
  diagnosis: string;
  medicineCount: number;
  medicineList: string[];
}

// 单条聊天消息
export interface ChatMessage {
  isDoctor: boolean;
  content: string;
  time: string;
  isImage?: boolean;
  isPrescription?: boolean;
  prescriptionData?: Prescription;
}

// 【正确】从 json-server 请求 根目录下的 data.json
// 定义接口，和你 data.json 里的单条数据结构完全对应
interface ConsultationRaw {
  id: string;
  patientName: string;
  patientGender: string;
  patientAge: number;
  type: ConsultationType;
  status: ConsultationStatus;
  description: string;
  createTime: string;
  rejectReason?: string;
  chatMessages?: ChatMessage[];
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

export async function loadFromJsonServer(): Promise<ConsultationItem[]> {
  let httpConn = http.createHttp();

  try {
    // 👉 改成你电脑的局域网IP，例如：http://192.168.1.100:3000/consultations
    let resp = await httpConn.request(
      "http://10.0.2.2:8080/consultations",
      { method: http.RequestMethod.GET,
        header: { 'Content-Type': 'application/json' }
      }
    );

    if (resp.responseCode === 200) {
      console.info("响应内容: " + resp.result.toString());
      // 强转为我们定义的类型数组，彻底去掉 any
      const list = JSON.parse(resp.result.toString()) as ConsultationRaw[];
      return list.map((item: ConsultationRaw) => new ConsultationItem(
        item.id,
        item.patientName,
        item.patientGender,
        item.patientAge,
        item.type,
        item.status,
        item.description,
        item.createTime,
        item.rejectReason,
        item.chatMessages
      ));
    }
  } catch (err) {
    console.error("请求失败详情: " + JSON.stringify(err));
    console.error("请求失败", err);
  } finally {
    httpConn.destroy();
  }

  return [];
}


// ====================== 新增：保存 ======================
export async function saveToJsonServer(data: ConsultationItem[]): Promise<void> {
  let httpConn = http.createHttp();

  try {
    await httpConn.request(
      "http://10.0.2.2:8080/consultations",
      {
        method: http.RequestMethod.PUT,
        header: { 'Content-Type': 'application/json' },
        extraData: data
      }
    );
  } catch (err) {
    console.error("保存失败", err);
  } finally {
    httpConn.destroy();
  }
}

// ====================== 新增：保存单条问诊数据 ======================
export async function saveSingleItemToServer(item: ConsultationItem): Promise<void> {
  let httpConn = http.createHttp();

  try {
    await httpConn.request(
      `http://10.0.2.2:8080/consultations/${item.id}`,
      {
        method: http.RequestMethod.PUT,
        header: { 'Content-Type': 'application/json' },
        extraData: item
      }
    );
    console.log("✅ 单条保存成功：", item.id);
  } catch (err) {
    console.error("❌ 保存失败：", err);
  } finally {
    httpConn.destroy();
  }
}

