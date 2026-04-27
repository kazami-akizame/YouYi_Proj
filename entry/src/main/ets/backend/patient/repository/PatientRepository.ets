import {
  PatientEntity,
  PatientGroupEntity,
  PatientProfileAggregate,
  PatientGroupSummary,
  BroadcastMessageEntity
} from '../model/PatientEntities';

export interface PatientRepository {
  listGroupSummaries(): PatientGroupSummary[];
  listPatientsByGroup(groupId: number): PatientEntity[];
  listAllPatients(): PatientEntity[];
  searchPatients(keyword: string): PatientEntity[];
  getPatientProfile(patientId: number): PatientProfileAggregate | null;
  updatePatientBasicInfo(
    patientId: number,
    name: string,
    gender: string,
    age: number,
    province: string,
    city: string,
    remark: string
  ): void;
  getPatientGroupNames(patientId: number): string[];
  updatePatientGroupNames(patientId: number, groupNames: string[]): void;
  listBroadcastMessages(): BroadcastMessageEntity[];
  getBroadcastMessageById(messageId: number): BroadcastMessageEntity | null;
  listGroups(): PatientGroupEntity[];
}

