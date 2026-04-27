import { ConsultationItem } from '../../../pages/common/ConsultationData';

export class PatientEntity {
  id: number;
  name: string;
  gender: string;
  age: number;
  phone: string;
  province: string;
  city: string;
  remark: string;
  avatar: Resource;
  serviceType: string;
  createdAt: string;

  constructor(
    id: number,
    name: string,
    gender: string,
    age: number,
    phone: string,
    province: string,
    city: string,
    remark: string,
    avatar: Resource,
    serviceType: string,
    createdAt: string
  ) {
    this.id = id;
    this.name = name;
    this.gender = gender;
    this.age = age;
    this.phone = phone;
    this.province = province;
    this.city = city;
    this.remark = remark;
    this.avatar = avatar;
    this.serviceType = serviceType;
    this.createdAt = createdAt;
  }
}

export class PatientGroupEntity {
  id: number;
  name: string;
  sortNo: number;

  constructor(id: number, name: string, sortNo: number) {
    this.id = id;
    this.name = name;
    this.sortNo = sortNo;
  }
}

export class PatientGroupSummary {
  group: PatientGroupEntity;
  patientCount: number;

  constructor(group: PatientGroupEntity, patientCount: number) {
    this.group = group;
    this.patientCount = patientCount;
  }
}

export class PatientProfileAggregate {
  patient: PatientEntity;
  groupNames: string[];
  consultations: ConsultationItem[];

  constructor(patient: PatientEntity, groupNames: string[], consultations: ConsultationItem[]) {
    this.patient = patient;
    this.groupNames = groupNames;
    this.consultations = consultations;
  }
}

export class BroadcastMessageEntity {
  id: number;
  content: string;
  sentAt: string;
  recipientPatientIds: number[];

  constructor(id: number, content: string, sentAt: string, recipientPatientIds: number[]) {
    this.id = id;
    this.content = content;
    this.sentAt = sentAt;
    this.recipientPatientIds = recipientPatientIds;
  }
}

