// service/LocalDataService.ets - 本地数据存储服务
import fs from '@ohos.file.fs';
import util from '@ohos.util';
import { BusinessError } from '@ohos.base';
import { DoctorCertificationRequest } from '../pages/common/Doctor';
import { common } from '@kit.AbilityKit';

const TAG: string = 'LocalDataService';

export class LocalDataService {
  private static DATA_FILE_NAME = 'data.json';
  
  // 保存医生认证数据到本地文件
  static async saveDoctorCertification(certData: DoctorCertificationRequest): Promise<boolean> {
    try {
      console.info(`${TAG}: 开始保存医生认证数据到本地`);
      
      // 获取应用文件路径
      const context = GlobalContext.get().getAbilityContext();
      if (!context) {
        console.error(`${TAG}: 上下文未初始化`);
        return false;
      }
      const filesDir = context.filesDir;
      const dataFilePath = `${filesDir}/${LocalDataService.DATA_FILE_NAME}`;
      console.info(`${TAG}: 数据文件路径: ${dataFilePath}`);
      
      // 读取现有数据
      let existingData: Record<string, Object[]> = {};
      try {
        if (fs.accessSync(dataFilePath)) {
          console.info(`${TAG}: 读取现有数据文件`);
          const file = fs.openSync(dataFilePath, fs.OpenMode.READ_ONLY);
          const stat = fs.statSync(dataFilePath);
          const buffer = new ArrayBuffer(stat.size);
          fs.readSync(file.fd, buffer);
          fs.closeSync(file);
          
          const textDecoder = util.TextDecoder.create('utf-8');
          const uint8Array = new Uint8Array(buffer);
          const jsonStr = textDecoder.decodeWithStream(uint8Array);
          existingData = JSON.parse(jsonStr) as Record<string, Object[]>;
          console.info(`${TAG}: 现有数据加载成功`);
        } else {
          console.info(`${TAG}: 数据文件不存在，将创建新文件`);
        }
      } catch (error) {
        const err = error as BusinessError;
        console.warn(`${TAG}: 读取现有数据失败，创建新文件: ${err.message}`);
      }
      
      // 确保 doctorCertifications 数组存在
      if (!existingData['doctorCertifications']) {
        existingData['doctorCertifications'] = [];
      }
      
      // 添加新的认证数据
      const certArray = existingData['doctorCertifications'] as Object[];
      certArray.push(certData as Object);
      console.info(`${TAG}: 已添加新的认证数据，当前总数: ${certArray.length}`);
      
      // 写入文件
      const jsonData = JSON.stringify(existingData, null, 2);
      console.info(`${TAG}: 准备写入数据: ${jsonData.substring(0, 200)}...`);
      
      const textEncoder = util.TextEncoder.create('utf-8');
      const encodedData = textEncoder.encodeInto(jsonData);
      
      const file = fs.openSync(dataFilePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE | fs.OpenMode.TRUNC);
      const writeBuffer = new Uint8Array(encodedData.buffer);
      fs.writeSync(file.fd, writeBuffer.buffer);
      fs.closeSync(file);
      
      console.info(`${TAG}: 医生认证数据已成功保存到: ${dataFilePath}`);
      return true;
    } catch (error) {
      const err = error as BusinessError;
      console.error(`${TAG}: 保存数据失败: ${err.message}`);
      console.error(`${TAG}: 错误详情: ${JSON.stringify(err)}`);
      return false;
    }
  }
  
  // 获取所有医生认证数据
  static async getDoctorCertifications(): Promise<DoctorCertificationRequest[]> {
    try {
      const context = GlobalContext.get().getAbilityContext();
      if (!context) {
        console.error(`${TAG}: 上下文未初始化`);
        return [];
      }
      const filesDir = context.filesDir;
      const dataFilePath = `${filesDir}/${LocalDataService.DATA_FILE_NAME}`;
      
      if (!fs.accessSync(dataFilePath)) {
        return [];
      }
      
      const file = fs.openSync(dataFilePath, fs.OpenMode.READ_ONLY);
      const stat = fs.statSync(dataFilePath);
      const buffer = new ArrayBuffer(stat.size);
      fs.readSync(file.fd, buffer);
      fs.closeSync(file);
      
      const textDecoder = util.TextDecoder.create('utf-8');
      const uint8Array = new Uint8Array(buffer);
      const jsonStr = textDecoder.decodeWithStream(uint8Array);
      const data = JSON.parse(jsonStr) as Record<string, Object[]>;
      
      const certifications = data['doctorCertifications'] as DoctorCertificationRequest[] || [];
      return certifications;
    } catch (error) {
      const err = error as BusinessError;
      console.error(`${TAG}: 读取数据失败: ${JSON.stringify(err)}`);
      return [];
    }
  }
}

// 全局上下文管理
export class GlobalContext {
  private static instance: GlobalContext;
  private abilityContext: common.UIAbilityContext | null = null;
  
  static get(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }
  
  setAbilityContext(context: common.UIAbilityContext): void {
    this.abilityContext = context;
  }
  
  getAbilityContext(): common.UIAbilityContext | null {
    return this.abilityContext;
  }
}
