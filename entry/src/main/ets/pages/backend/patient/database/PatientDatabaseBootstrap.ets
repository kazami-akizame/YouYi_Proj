import relationalStore from '@ohos.data.relationalStore';
import common from '@ohos.app.ability.common';

class SeedBroadcastMessage {
  content: string;
  sentAt: string;
  recipients: number[];

  constructor(content: string, sentAt: string, recipients: number[]) {
    this.content = content;
    this.sentAt = sentAt;
    this.recipients = recipients;
  }
}

export class PatientDatabaseBootstrap {
  private static initialized: boolean = false;
  private static store: relationalStore.RdbStore | null = null;

  static async ensureInitialized(context: common.UIAbilityContext): Promise<relationalStore.RdbStore> {
    if (PatientDatabaseBootstrap.initialized && PatientDatabaseBootstrap.store) {
      return PatientDatabaseBootstrap.store;
    }

    const config: relationalStore.StoreConfig = {
      name: 'patient_module.db',
      securityLevel: relationalStore.SecurityLevel.S1
    };

    PatientDatabaseBootstrap.store = await relationalStore.getRdbStore(context, config);
    const store = PatientDatabaseBootstrap.store;

    await store.executeSql(
      `CREATE TABLE IF NOT EXISTS broadcast_message (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT NOT NULL,
        sent_at TEXT NOT NULL
      )`
    );
    await store.executeSql(
      `CREATE TABLE IF NOT EXISTS broadcast_recipient (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        message_id INTEGER NOT NULL,
        patient_id INTEGER NOT NULL
      )`
    );

    const countSet = await store.querySql('SELECT COUNT(1) AS total FROM broadcast_message');
    let total = 0;
    if (countSet.goToFirstRow()) {
      total = countSet.getLong(countSet.getColumnIndex('total'));
    }
    countSet.close();

    const seedMessages: SeedBroadcastMessage[] = [
      new SeedBroadcastMessage(
        '低热、咳嗽超过7天，应排除肺结核、支原体肺炎。突然寒战、高热，伴有呼吸道症状应尽快复诊。',
        '2020-01-09 12:09',
        [1, 2, 3, 4, 5]
      ),
      new SeedBroadcastMessage(
        '近期流感高发，请各位患者外出佩戴口罩，注意休息和补水。',
        '2020-01-08 18:30',
        [1, 3, 5]
      ),
      new SeedBroadcastMessage(
        '复诊提醒：本周内请完成血常规和胸片检查。',
        '2020-01-07 09:40',
        [2, 4]
      ),
      new SeedBroadcastMessage(
        '温馨提示：夜间咳嗽频繁的患者，请记录最近3天体温并及时反馈。',
        '2020-01-06 20:15',
        [1, 2, 4]
      ),
      new SeedBroadcastMessage(
        '本周门诊安排有调整，如需复诊请提前在系统内预约。',
        '2020-01-05 10:20',
        [1, 2, 3, 5]
      )
    ];

    if (total < seedMessages.length) {
      for (let i = total; i < seedMessages.length; i++) {
        const seed = seedMessages[i];
        await store.executeSql(
          'INSERT INTO broadcast_message(content, sent_at) VALUES (?, ?)',
          [seed.content, seed.sentAt]
        );
        const idSet = await store.querySql('SELECT last_insert_rowid() AS id');
        let messageId = 0;
        if (idSet.goToFirstRow()) {
          messageId = idSet.getLong(idSet.getColumnIndex('id'));
        }
        idSet.close();
        for (const patientId of seed.recipients) {
          await store.executeSql(
            'INSERT INTO broadcast_recipient(message_id, patient_id) VALUES (?, ?)',
            [messageId, patientId]
          );
        }
      }
    }

    PatientDatabaseBootstrap.initialized = true;
    return store;
  }
}

