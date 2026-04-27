import { ConsultationItem, MockDataGenerator } from '../../../pages/common/ConsultationData';
import {
  PatientEntity,
  PatientGroupEntity,
  PatientGroupSummary,
  PatientProfileAggregate,
  BroadcastMessageEntity
} from '../model/PatientEntities';
import { PatientRepository } from './PatientRepository';

export class MemoryPatientRepository implements PatientRepository {
  private readonly groups: PatientGroupEntity[] = [
    new PatientGroupEntity(1, '默认分组', 1),
    new PatientGroupEntity(2, '发热门诊', 2),
    new PatientGroupEntity(3, '流行性感冒', 3),
    new PatientGroupEntity(4, '病毒性感冒', 4),
    new PatientGroupEntity(5, '咽炎', 5)
  ];

  private readonly mockConsultations: ConsultationItem[] = MockDataGenerator.generateMockData();
  private readonly patients: PatientEntity[] = this.buildPatientsFromConsultations(this.mockConsultations);
  private readonly patientGroups: Map<number, number[]> = this.buildPatientGroups(this.patients);
  private readonly patientConsultations: Map<number, ConsultationItem[]> =
    this.buildConsultationMap(this.mockConsultations, this.patients);

  private readonly broadcastMessages: BroadcastMessageEntity[] = [
    new BroadcastMessageEntity(
      1,
      '低热、咳嗽超过7天，应排除肺结核、支原体肺炎。突然寒战、高热，伴有呼吸道症状应尽快复诊。',
      '2020-01-09 12:09',
      [1, 2, 3, 4, 5]
    ),
    new BroadcastMessageEntity(
      2,
      '近期流感高发，请各位患者外出佩戴口罩，注意休息和补水。',
      '2020-01-08 18:30',
      [1, 3, 5]
    ),
    new BroadcastMessageEntity(
      3,
      '复诊提醒：本周内请完成血常规和胸片检查。',
      '2020-01-07 09:40',
      [2, 4]
    ),
    new BroadcastMessageEntity(
      4,
      '温馨提示：夜间咳嗽频繁的患者，请记录最近3天体温并及时反馈。',
      '2020-01-06 20:15',
      [1, 2, 4]
    ),
    new BroadcastMessageEntity(
      5,
      '本周门诊安排有调整，如需复诊请提前在系统内预约。',
      '2020-01-05 10:20',
      [1, 2, 3, 5]
    )
  ];

  listGroupSummaries(): PatientGroupSummary[] {
    return this.groups
      .slice()
      .sort((a: PatientGroupEntity, b: PatientGroupEntity) => a.sortNo - b.sortNo)
      .map((group: PatientGroupEntity) => new PatientGroupSummary(group, this.countPatientsInGroup(group.id)));
  }

  listPatientsByGroup(groupId: number): PatientEntity[] {
    const patientIds: number[] = this.patientGroups.get(groupId) ?? [];
    return this.patients.filter((patient: PatientEntity) => patientIds.indexOf(patient.id) >= 0);
  }

  listAllPatients(): PatientEntity[] {
    return this.patients.slice();
  }

  searchPatients(keyword: string): PatientEntity[] {
    const text: string = this.normalizeKeyword(keyword);
    if (text.length === 0) {
      return this.listAllPatients();
    }
    return this.patients.filter((patient: PatientEntity) => {
      const name = this.normalizeKeyword(patient.name);
      const phone = this.normalizeKeyword(patient.phone);
      const remark = this.normalizeKeyword(patient.remark);
      const region = this.normalizeKeyword(`${patient.province}${patient.city}`);
      const genderAge = this.normalizeKeyword(`${patient.gender}${patient.age.toString()}`);
      return name.indexOf(text) >= 0 ||
        phone.indexOf(text) >= 0 ||
        remark.indexOf(text) >= 0 ||
        region.indexOf(text) >= 0 ||
        genderAge.indexOf(text) >= 0;
    });
  }

  getPatientProfile(patientId: number): PatientProfileAggregate | null {
    const patient = this.patients.find((item: PatientEntity) => item.id === patientId);
    if (!patient) {
      return null;
    }

    const groupNames: string[] = this.groups
      .filter((group: PatientGroupEntity) => {
        const ids: number[] = this.patientGroups.get(group.id) ?? [];
        return ids.indexOf(patientId) >= 0;
      })
      .map((group: PatientGroupEntity) => group.name);
    const consultations: ConsultationItem[] = this.patientConsultations.get(patientId) ?? [];
    return new PatientProfileAggregate(patient, groupNames, consultations);
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
    const patient = this.patients.find((item: PatientEntity) => item.id === patientId);
    if (!patient) {
      return;
    }
    patient.name = name;
    patient.gender = gender;
    patient.age = age;
    patient.province = province;
    patient.city = city;
    patient.remark = remark;
  }

  getPatientGroupNames(patientId: number): string[] {
    return this.groups
      .filter((group: PatientGroupEntity) => {
        const ids: number[] = this.patientGroups.get(group.id) ?? [];
        return ids.indexOf(patientId) >= 0;
      })
      .map((group: PatientGroupEntity) => group.name);
  }

  updatePatientGroupNames(patientId: number, groupNames: string[]): void {
    const targetGroupIds = this.groups
      .filter((group: PatientGroupEntity) => groupNames.indexOf(group.name) >= 0)
      .map((group: PatientGroupEntity) => group.id);

    this.groups.forEach((group: PatientGroupEntity) => {
      const ids: number[] = this.patientGroups.get(group.id) ?? [];
      const withoutCurrent = ids.filter((id: number) => id !== patientId);
      const shouldAdd = targetGroupIds.indexOf(group.id) >= 0;
      const nextIds = shouldAdd ? withoutCurrent.concat([patientId]) : withoutCurrent;
      this.patientGroups.set(group.id, nextIds);
    });
  }

  listBroadcastMessages(): BroadcastMessageEntity[] {
    return this.broadcastMessages.slice();
  }

  getBroadcastMessageById(messageId: number): BroadcastMessageEntity | null {
    return this.broadcastMessages.find((item: BroadcastMessageEntity) => item.id === messageId) ?? null;
  }

  listGroups(): PatientGroupEntity[] {
    return this.groups.slice().sort((a: PatientGroupEntity, b: PatientGroupEntity) => a.sortNo - b.sortNo);
  }

  private countPatientsInGroup(groupId: number): number {
    return (this.patientGroups.get(groupId) ?? []).length;
  }

  private normalizeKeyword(value: string): string {
    return value
      .trim()
      .toLowerCase()
      .replace(/\s+/g, '')
      .replace(/（/g, '(')
      .replace(/）/g, ')');
  }

  private buildPatientsFromConsultations(consultations: ConsultationItem[]): PatientEntity[] {
    const regionPairs: Array<[string, string]> = [
      ['北京', '朝阳'],
      ['北京', '海淀'],
      ['上海', '浦东'],
      ['江苏', '南京'],
      ['广东', '深圳']
    ];

    const uniquePatients = new Map<string, PatientEntity>();
    consultations.forEach((item: ConsultationItem, index: number) => {
      const key = `${item.patientName}_${item.patientGender}_${item.patientAge.toString()}`;
      if (uniquePatients.has(key)) {
        return;
      }
      const region = regionPairs[index % regionPairs.length];
      const phone = `1880000${(1000 + index).toString().slice(-4)}`;
      uniquePatients.set(
        key,
        new PatientEntity(
          uniquePatients.size + 1,
          item.patientName,
          item.patientGender,
          item.patientAge,
          phone,
          region[0],
          region[1],
          item.description,
          $r('app.media.__80px_u1228'),
          '专家问诊',
          item.createTime.split(' ')[0]
        )
      );
    });

    return Array.from(uniquePatients.values());
  }

  private buildPatientGroups(patients: PatientEntity[]): Map<number, number[]> {
    const relation = new Map<number, number[]>();
    this.groups.forEach((group: PatientGroupEntity) => {
      relation.set(group.id, []);
    });

    patients.forEach((patient: PatientEntity, index: number) => {
      // 所有患者都归属默认分组，保证基础展示稳定
      (relation.get(1) ?? []).push(patient.id);
      // 额外分配到一个业务分组，保证每个分组都有可展示患者
      const extraGroupId = 2 + (index % 4);
      (relation.get(extraGroupId) ?? []).push(patient.id);
    });

    return relation;
  }

  private buildConsultationMap(
    consultations: ConsultationItem[],
    patients: PatientEntity[]
  ): Map<number, ConsultationItem[]> {
    const patientIdByName = new Map<string, number>();
    patients.forEach((patient: PatientEntity) => {
      patientIdByName.set(patient.name, patient.id);
    });

    const map = new Map<number, ConsultationItem[]>();
    consultations.forEach((item: ConsultationItem) => {
      const pid = patientIdByName.get(item.patientName);
      if (!pid) {
        return;
      }
      const list = map.get(pid) ?? [];
      list.push(item);
      map.set(pid, list);
    });
    return map;
  }
}

