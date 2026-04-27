import { GroupItem } from '../../../pages/Patient/PatientModels';
import {
  PatientEntity,
  PatientGroupEntity,
  PatientProfileAggregate,
  PatientGroupSummary
} from '../model/PatientEntities';
import { MemoryPatientRepository } from '../repository/MemoryPatientRepository';
import { PatientRepository } from '../repository/PatientRepository';

class PatientService {
  private readonly repository: PatientRepository = new MemoryPatientRepository();

  getPatientGroupItems(): GroupItem[] {
    const summaries: PatientGroupSummary[] = this.repository.listGroupSummaries();
    return summaries.map((summary: PatientGroupSummary) => {
      return new GroupItem(summary.group.name, `${summary.patientCount.toString()}人`);
    });
  }

  getPatientsByDefaultGroup(): PatientEntity[] {
    // 约定默认分组 id=1，保持现有页面逻辑稳定
    return this.repository.listPatientsByGroup(1);
  }

  getPatientsByGroup(groupId: number): PatientEntity[] {
    return this.repository.listPatientsByGroup(groupId);
  }

  getPatientProfile(patientId: number): PatientProfileAggregate | null {
    return this.repository.getPatientProfile(patientId);
  }

  updatePatientBasicInfo(
    patientId: number,
    name: string,
    gender: string,
    age: number,
    province: string,
    city: string,
    remark: string
  ): void {
    this.repository.updatePatientBasicInfo(patientId, name, gender, age, province, city, remark);
  }

  getAllPatients(): PatientEntity[] {
    return this.repository.listAllPatients();
  }

  searchPatients(keyword: string): PatientEntity[] {
    return this.repository.searchPatients(keyword);
  }

  getGroups(): PatientGroupEntity[] {
    return this.repository.listGroups();
  }

  getPatientGroupNames(patientId: number): string[] {
    return this.repository.getPatientGroupNames(patientId);
  }

  updatePatientGroupNames(patientId: number, groupNames: string[]): void {
    this.repository.updatePatientGroupNames(patientId, groupNames);
  }
}

export const patientService: PatientService = new PatientService();

