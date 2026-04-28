import { BroadcastMessageEntity, PatientEntity } from '../model/PatientEntities';
import { MemoryPatientRepository } from '../repository/MemoryPatientRepository';
import { PatientRepository } from '../repository/PatientRepository';
import { PatientDatabaseBootstrap } from '../database/PatientDatabaseBootstrap';
import common from '@ohos.app.ability.common';

class BroadcastService {
  private readonly repository: PatientRepository = new MemoryPatientRepository();
  private fallbackMessages: BroadcastMessageEntity[] = this.repository.listBroadcastMessages();

  async listHistory(context: common.UIAbilityContext): Promise<BroadcastMessageEntity[]> {
    if (this.fallbackMessages.length > 0) {
      return this.fallbackMessages.slice().sort((a: BroadcastMessageEntity, b: BroadcastMessageEntity) => b.id - a.id);
    }
    try {
      const store = await PatientDatabaseBootstrap.ensureInitialized(context);
      const resultSet = await store.querySql('SELECT id, content, sent_at FROM broadcast_message ORDER BY id DESC');
      const list: BroadcastMessageEntity[] = [];
      if (resultSet.goToFirstRow()) {
        do {
          const id = resultSet.getLong(resultSet.getColumnIndex('id'));
          const content = resultSet.getString(resultSet.getColumnIndex('content'));
          const sentAt = resultSet.getString(resultSet.getColumnIndex('sent_at'));
          const recipients = await this.queryRecipientsByMessageId(context, id);
          list.push(new BroadcastMessageEntity(id, content, sentAt, recipients));
        } while (resultSet.goToNextRow());
      }
      resultSet.close();
      if (list.length > 0) {
        this.fallbackMessages = list;
        return list;
      }
    } catch (_e) {
      // ignore and fallback to in-memory history for preview stability
    }
    return this.fallbackMessages.slice().sort((a: BroadcastMessageEntity, b: BroadcastMessageEntity) => b.id - a.id);
  }

  async searchHistory(context: common.UIAbilityContext, keyword: string): Promise<BroadcastMessageEntity[]> {
    const text: string = keyword.trim().toLowerCase();
    if (text.length === 0) {
      return this.listHistory(context);
    }
    const list = await this.listHistory(context);
    return list.filter((item: BroadcastMessageEntity) => item.content.toLowerCase().indexOf(text) >= 0);
  }

  async getMessageDetail(context: common.UIAbilityContext, messageId: number): Promise<BroadcastMessageEntity | null> {
    const fallbackMessage = this.fallbackMessages.find((item: BroadcastMessageEntity) => item.id === messageId);
    if (fallbackMessage) {
      return fallbackMessage;
    }

    try {
      const store = await PatientDatabaseBootstrap.ensureInitialized(context);
      const resultSet = await store.querySql(
        'SELECT id, content, sent_at FROM broadcast_message WHERE id = ?',
        [messageId]
      );
      let result: BroadcastMessageEntity | null = null;
      if (resultSet.goToFirstRow()) {
        const id = resultSet.getLong(resultSet.getColumnIndex('id'));
        const content = resultSet.getString(resultSet.getColumnIndex('content'));
        const sentAt = resultSet.getString(resultSet.getColumnIndex('sent_at'));
        const recipients = await this.queryRecipientsByMessageId(context, id);
        result = new BroadcastMessageEntity(id, content, sentAt, recipients);
      }
      resultSet.close();
      if (result) {
        return result;
      }
    } catch (_e) {
      // ignore and fallback to in-memory history for preview stability
    }
    return null;
  }

  async getRecipientsByMessage(context: common.UIAbilityContext, messageId: number): Promise<PatientEntity[]> {
    const message = await this.getMessageDetail(context, messageId);
    if (!message) {
      return [];
    }
    const allPatients = this.repository.listAllPatients();
    return allPatients.filter((patient: PatientEntity) => message.recipientPatientIds.indexOf(patient.id) >= 0);
  }

  getTodayQuotaText(): string {
    // 第二阶段先保持演示逻辑，后续可切 preferences / relationalStore
    return '每日发送上限为10条，今日还可发送6条';
  }

  async createAndSendMessage(
    context: common.UIAbilityContext | null,
    content: string,
    patientIds: number[]
  ): Promise<number> {
    const text = content.trim();
    if (text.length === 0 || patientIds.length === 0) {
      return 0;
    }

    // 演示优先：先写入内存历史，保证跳转后立即可见
    const maxId = this.fallbackMessages.reduce((acc: number, item: BroadcastMessageEntity) => {
      return item.id > acc ? item.id : acc;
    }, 0);
    const messageId = maxId + 1;
    const sentAt = this.nowString();
    this.fallbackMessages = [new BroadcastMessageEntity(messageId, text, sentAt, patientIds), ...this.fallbackMessages];

    try {
      if (context === null) {
        throw new Error('context unavailable');
      }
      const store = await PatientDatabaseBootstrap.ensureInitialized(context);
      await store.executeSql(
        'INSERT INTO broadcast_message(content, sent_at) VALUES (?, ?)',
        [text, sentAt]
      );
      const idSet = await store.querySql('SELECT last_insert_rowid() AS id');
      let dbMessageId = 0;
      if (idSet.goToFirstRow()) {
        dbMessageId = idSet.getLong(idSet.getColumnIndex('id'));
      }
      idSet.close();
      for (const patientId of patientIds) {
        await store.executeSql(
          'INSERT INTO broadcast_recipient(message_id, patient_id) VALUES (?, ?)',
          [dbMessageId, patientId]
        );
      }
      if (dbMessageId > 0 && dbMessageId !== messageId) {
        this.fallbackMessages = this.fallbackMessages.map((item: BroadcastMessageEntity) => {
          if (item.id === messageId && item.content === text && item.sentAt === sentAt) {
            return new BroadcastMessageEntity(dbMessageId, item.content, item.sentAt, item.recipientPatientIds);
          }
          return item;
        });
        return dbMessageId;
      }
      return messageId;
    } catch (_e) {
      // 演示模式：数据库失败不影响页面展示
      return messageId;
    }
  }

  private async queryRecipientsByMessageId(context: common.UIAbilityContext, messageId: number): Promise<number[]> {
    const store = await PatientDatabaseBootstrap.ensureInitialized(context);
    const resultSet = await store.querySql(
      'SELECT patient_id FROM broadcast_recipient WHERE message_id = ?',
      [messageId]
    );
    const list: number[] = [];
    if (resultSet.goToFirstRow()) {
      do {
        list.push(resultSet.getLong(resultSet.getColumnIndex('patient_id')));
      } while (resultSet.goToNextRow());
    }
    resultSet.close();
    return list;
  }

  private nowString(): string {
    const now = new Date();
    const yyyy = now.getFullYear().toString();
    const mm = (now.getMonth() + 1).toString().padStart(2, '0');
    const dd = now.getDate().toString().padStart(2, '0');
    const hh = now.getHours().toString().padStart(2, '0');
    const mi = now.getMinutes().toString().padStart(2, '0');
    return `${yyyy}-${mm}-${dd} ${hh}:${mi}`;
  }
}

export const broadcastService: BroadcastService = new BroadcastService();

