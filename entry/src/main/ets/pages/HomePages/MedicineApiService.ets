// MedicineApiService.ets
import http from '@ohos.net.http';

export interface MyMedicine {
  id: string;
  name: string;
  manufacturer: string;
  price: number;
  specification: string;
}

export interface PrescriptionMedicine {
  id?: string;
  name: string;
  specification: string;
  quantity: number;
  usageMethod?: string;
  frequency?: string;
  singleDose?: string;
  remark?: string;
}

export interface Prescription {
  id: string;
  patientName: string;
  patientGender: string;
  patientAge: number;
  clinicalDiagnosis: string;
  medicineCount: number;
  medicines: PrescriptionMedicine[];
  createDate: string;
  isCommon: boolean;
}

// 服务器地址（模拟器用10.0.2.2）
const BASE_URL: string = 'http://localhost:8080';

export class MedicineApiService {
  // ========== 常用药品 API ==========
  static async getMyMedicines(): Promise<MyMedicine[]> {
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(`${BASE_URL}/myMedicines`, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000
      });

      if (response.responseCode === 200) {
        const result = response.result as string;
        return JSON.parse(result) as MyMedicine[];
      }
      return [];
    } catch (error) {
      console.error('获取常用药品失败:', JSON.stringify(error));
      return [];
    } finally {
      httpRequest.destroy();
    }
  }

  static async addMyMedicine(medicine: MyMedicine): Promise<boolean> {
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(`${BASE_URL}/myMedicines`, {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(medicine)
      });
      return response.responseCode === 201;
    } catch (error) {
      console.error('添加常用药品失败:', JSON.stringify(error));
      return false;
    } finally {
      httpRequest.destroy();
    }
  }

  static async deleteMyMedicine(medicineId: string): Promise<boolean> {
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(`${BASE_URL}/myMedicines/${medicineId}`, {
        method: http.RequestMethod.DELETE
      });
      return response.responseCode === 200;
    } catch (error) {
      console.error('删除常用药品失败:', JSON.stringify(error));
      return false;
    } finally {
      httpRequest.destroy();
    }
  }

  // ========== 常用处方 API ==========
  static async getCommonPrescriptions(): Promise<Prescription[]> {
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(`${BASE_URL}/commonPrescriptions`, {
        method: http.RequestMethod.GET,
        connectTimeout: 60000,
        readTimeout: 60000
      });

      if (response.responseCode === 200) {
        const result = response.result as string;
        return JSON.parse(result) as Prescription[];
      }
      return [];
    } catch (error) {
      console.error('获取常用处方失败:', JSON.stringify(error));
      return [];
    } finally {
      httpRequest.destroy();
    }
  }

  // ✅ 修复：参数类型改为 Prescription
  static async addCommonPrescription(prescription: Prescription): Promise<boolean> {
    console.log('=== addCommonPrescription 开始 ===');
    console.log('保存处方:', JSON.stringify(prescription));

    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(`${BASE_URL}/commonPrescriptions`, {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: JSON.stringify(prescription)
      });
      console.log('POST 响应码:', response.responseCode);
      return response.responseCode === 201;
    } catch (error) {
      console.error('添加常用处方失败:', JSON.stringify(error));
      return false;
    } finally {
      httpRequest.destroy();
    }
  }

  static async deleteCommonPrescription(prescriptionId: string): Promise<boolean> {
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(`${BASE_URL}/commonPrescriptions/${prescriptionId}`, {
        method: http.RequestMethod.DELETE
      });
      return response.responseCode === 200;
    } catch (error) {
      console.error('删除常用处方失败:', JSON.stringify(error));
      return false;
    } finally {
      httpRequest.destroy();
    }
  }}







