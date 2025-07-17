import { relationalStore } from '@kit.ArkData';
import { common } from '@kit.AbilityKit'; // 1. 引入明确的上下文类型[1,2](@ref)
import { BusinessError } from '@kit.BasicServicesKit';

export const TABLE_NAME = 'TASKS';
export const SQL_CREATE_TABLE = `
CREATE TABLE IF NOT EXISTS ${TABLE_NAME} (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    completed INTEGER DEFAULT 0,
    remaining_time INTEGER,
    default_time INTEGER,
    completed_time INTEGER,
    date_key TEXT
)`;

export class TaskDatabase {
  private static instance: relationalStore.RdbStore | null = null;
  static isInitialized = false;
  // ✅ 修复1: 使用明确的上下文类型替代 any
  static async init(context: common.UIAbilityContext): Promise<void> {
    const STORE_CONFIG: relationalStore.StoreConfig = {
      name: 'Tasks.db',
      securityLevel: relationalStore.SecurityLevel.S3,
      encrypt: true
    };

    return new Promise((resolve, reject) => {
      relationalStore.getRdbStore(context, STORE_CONFIG, (err, store) => {
        if (err) {
          reject(new Error(`Database init failed: ${err.code}, ${err.message}`));
          return;
        }

        // ✅ 修复2: 使用箭头函数绑定正确的作用域
        store.executeSql(SQL_CREATE_TABLE)
          .then(() => {
            TaskDatabase.instance = store;
            TaskDatabase.isInitialized = true;
            resolve();
          })
          .catch((e: BusinessError) => {
            reject(new Error(`SQL execution failed: ${e.code}, ${e.message}`));
          });
      });
    });
  }

  static getStore(): relationalStore.RdbStore {
    if (!TaskDatabase.instance) {
      throw new Error('Database not initialized. Call init() first.');
    }
    return TaskDatabase.instance;
  }

  static close(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (TaskDatabase.instance) {
        // ✅ 使用异步 close() 方法
        TaskDatabase.instance.close();
      } else {
        resolve(); // 已关闭时静默成功
      }
    });
  }
}