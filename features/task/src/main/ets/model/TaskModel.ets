import {TaskDatabase,TABLE_NAME} from './TaskDatabase'
import { relationalStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 任务数据结构定义
 * @property id 任务唯一标识
 * @property title 任务标题
 * @property completed 任务完成状态
 * @property remainingTime 剩余时间
 * @property completedTime 任务完成时间戳（可选）
 */

export type TaskListMap = Record<string,TaskModel[]>;
export interface TaskData {
  id: string;
  title: string;
  completed: boolean;
  remainingTime: number;
  completedTime?: number;
  dateKey?: string;
}

/**
 * 任务模型类：封装番茄钟应用中的任务操作逻辑
 * 实现任务数据的创建、解析、序列化等核心功能
 */
export class TaskModel implements TaskData {
  // 基础属性
  private _id: string;          // 任务唯一ID
  private _title: string;       // 任务标题
  private _completed: boolean;  // 是否完成
  private _remainingTime: number;  // 剩余时间(秒)
  private _defaultTime: number; // 默认时间（秒）
  private _completedTime?: number; // 完成时间戳（可选）
  private _dateKey: string;     // 关联日期键
  /**
   * 构造函数
   * @param id 任务ID
   * @param title 任务标题
   * @param remainingTime 剩余时间(秒)
   * @param completed 完成状态（默认false）
   * @param completedTime 完成时间戳（可选）
   * @param dateKey 关联日期键（可选，默认当天）
   */
  constructor(
    id: string,
    title: string,
    defaultTime: number,
    completed: boolean = false,
    completedTime?: number,
    dateKey?: string,
    remainingTime?: number
  ) {
    this._id = id;
    this._title = title;
    this._defaultTime = defaultTime; // 存储默认时间
    this._remainingTime = remainingTime||defaultTime; // 初始剩余时间等于默认时间
    this._completed = completed;
    this._completedTime = completedTime;
    this._dateKey = dateKey || TaskModel.getTodayDateKey();
  }


  // =====================
  // 属性访问器（getters）
  // =====================

  get id(): string {
    return this._id;
  }

  get title(): string {
    return this._title;
  }

  get completed(): boolean {
    return this._completed;
  }

  get remainingTime(): number {
    return this._remainingTime;
  }

  get completedTime(): number | undefined {
    return this._completedTime;
  }

  get dateKey(): string {
    return this._dateKey;
  }
  get defaultTime(): number {
    return this._defaultTime;
  }
  // =====================
  // 属性修改器（setters）
  // =====================

  set title(newTitle: string) {
    if (newTitle && newTitle.trim().length > 0) {
      this._title = newTitle.trim();
      this.save().catch((e:BusinessError) => console.error("标题更新失败", e)); // ✅ 自动保存
    }
  }

  set remainingTime(seconds: number) {
    if (seconds >= 0) {
      this._remainingTime = seconds;
      // 自动保存 + 状态更新
      if (this._remainingTime === 0 && !this._completed) {
        this.markAsCompleted();
      } else {
        if (this._completed && seconds > 0) {
          this._completed = false;
          this._completedTime = undefined;
        }
        this.save().catch((e:BusinessError) => console.error("时间更新失败", e)); // ✅
      }
    }
  }

  set dateKey(newDateKey: string) {
    if (TaskModel.isValidDateKey(newDateKey)) {
      this._dateKey = newDateKey;
      this.save().catch((e:BusinessError)=> console.error("日期更新失败", e)); // ✅
    }
  }

  resetTask(): void {
    this._remainingTime = this._defaultTime;
    this._completed = false;
    this._completedTime = undefined;
    this.save().catch((e: BusinessError) => console.error("重置任务失败", e));
  }

  markAsCompleted(timestamp: number = Date.now()): void {
    if (!this._completed) {
      this._completed = true;
      this._completedTime = timestamp;
      this._remainingTime = 0;
      this.save().catch((e:BusinessError) => console.error("完成状态保存失败", e)); // ✅
    }
  }

  markAsIncomplete(): void {
    if (this._completed) {
      this._completed = false;
      this._completedTime = undefined;
      if (this._remainingTime === 0) {
        this._remainingTime = 3600;
      }
      this.save().catch((e:BusinessError) => console.error("未完成状态保存失败", e)); // ✅
    }
  }

  /**
   * 获取格式化剩余时间
   * @returns 格式化的时间字符串（HH:MM:SS）
   */
  getFormattedRemainingTime(): string {
    const hours = Math.floor(this._remainingTime / 3600);
    const minutes = Math.floor((this._remainingTime % 3600) / 60);
    const seconds = this._remainingTime % 60;

    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
  }

  /**
   * 获取任务状态描述
   * @returns 状态字符串
   */
  getStatusDescription(): string {
    if (this._completed) {
      return "已完成";
    } else if (this._remainingTime === 0) {
      return "已过期";
    } else {
      return "进行中";
    }
  }

  /**
   * 创建新任务（自动生成唯一ID）
   * @param title 任务标题
   * @returns 新任务实例
   * @说明 使用当前时间戳作为ID确保唯一性[6](@ref)
   */
  static createNew(title: string,remainingTime: number): TaskModel {
    return new TaskModel(Date.now().toString(), title,remainingTime);
  }


  /**
   * 向指定日期的任务列表添加新任务
   * @param taskMap 当前的任务映射对象
   * @param dateKey 日期字符串（格式 YYYY-MM-DD）
   * @param newTask 要添加的新任务
   * @returns 更新后的任务映射对象
   */
  static addTaskForDate(
    taskMap: TaskListMap,
    dateKey: string,
    newTask: TaskModel
  ): TaskListMap {
    const newMap: TaskListMap = JSON.parse(JSON.stringify(taskMap));
    const currentTasks = [...(newMap[dateKey] || [])];

    if (!currentTasks.some(task => task.id === newTask.id)) {
      currentTasks.push(newTask);
      newMap[dateKey] = currentTasks;
      return newMap; // ✅ 返回新引用
    }
    return newMap; // 无修改时也返回新对象
  }

  /**
   * 创建每日任务（整合日期键生成和添加操作）
   * @param taskMap 当前的任务映射对象
   * @param title 任务标题
   * @param remainingTime 初始剩余时间（秒）
   * @param targetDate 目标日期（可选，默认当天）
   * @returns [更新后的映射对象, 创建的任务实例]
   */
  static async createDailyTask(
    taskMap: TaskListMap,
    title: string,
    remainingTime: number,
    targetDate?: string,
  ): Promise<[TaskListMap, TaskModel]> {
    const dateKey = targetDate || TaskModel.getTodayDateKey();
    const newTask = TaskModel.createNew(title, remainingTime*60);
    newTask._dateKey = dateKey;

    try {
      await newTask.save();
      return [
        TaskModel.addTaskForDate(taskMap, dateKey, newTask),
        newTask
      ];
    } catch (e) {
      console.error("任务创建失败", e);
      // ✅ 类型安全转换
      throw (e instanceof Error)
        ? e
        : new Error(`任务创建失败: ${String(e)}`);
    }
  }


  static async deleteDailyTask(
    taskMap: TaskListMap,
    id: string,
    dateKey: string,
  ): Promise<TaskListMap> {
    const currentTasks = Array.from(taskMap[dateKey] || []);
    const taskToDelete = currentTasks.find(task => task.id === id);

    if (taskToDelete) {
      try {
        await taskToDelete.delete();
        taskMap[dateKey] = currentTasks.filter(task => task.id !== id);
      } catch (e) {
        console.error("任务删除失败", e);
        throw (e instanceof Error)
          ? e
          : new Error(`任务删除失败: ${String(e)}`);
      }
      // ...更新内存映射
    }
    return taskMap;
  }



  /** 获取当天日期键（YYYY-MM-DD 格式） */
  private static getTodayDateKey(): string {
    const today = new Date();
    return today.toISOString().split('T')[0];
  }

  /**
   * 验证日期键格式
   * @param dateKey 日期字符串
   * @returns 是否为有效的YYYY-MM-DD格式
   */
  static isValidDateKey(dateKey: string): boolean {
    return /^\d{4}-\d{2}-\d{2}$/.test(dateKey);
  }

  /**
   * 获取任务列表
   * @param taskMap 任务映射对象
   * @param dateKey 日期键
   * @returns 该日期的任务列表（如果没有则返回空数组）
   */
  static getTasksForDate(taskMap: TaskListMap, dateKey: string): TaskModel[] {
    return taskMap[dateKey] || [];
  }

  /**
   * 获取任务总数
   * @param taskMap 任务映射对象
   * @returns 所有任务的总数
   */
  static getTotalTaskCount(taskMap: TaskListMap): number {
    return Object.values(taskMap).reduce((count, tasks) => count + tasks.length, 0);
  }

  /**
   * 获取已完成任务数量
   * @param taskMap 任务映射对象
   * @returns 已完成任务的数量
   */
  static getCompletedTaskCount(taskMap: TaskListMap): number {
    return Object.values(taskMap).reduce(
      (count, tasks) => count + tasks.filter(task => task.completed).length,
      0
    );
  }

  /*数据库操作*/
  async save(): Promise<void> {
    const store = TaskDatabase.getStore();

    // ✅ 使用严格类型定义
    const valueBucket: relationalStore.ValuesBucket = {
      id: this._id,
      title: this._title,
      completed: this._completed ? 1 : 0,
      remaining_time: this._remainingTime,
      default_time: this._defaultTime,
      completed_time: this._completedTime ?? null, // 处理undefined->null转换
      date_key: this._dateKey
    };

    return new Promise((resolve, reject) => {
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo('id', this._id);

      // ✅ 添加显式类型声明
      store.update(valueBucket, predicates, (err: BusinessError, rows: number) => {
        if (err) {
          reject(err);
          return;
        }

        if (rows === 0) {
          store.insert(TABLE_NAME, valueBucket, (insertErr: BusinessError) => {
            insertErr ? reject(insertErr) : resolve();
          });
        } else {
          resolve();
        }
      });
    });
  }

  async delete(): Promise<void> {
    const store = TaskDatabase.getStore();

    return new Promise((resolve, reject) => {
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo('id', this._id);

      // ✅ 添加错误类型声明
      store.delete(predicates, (err: BusinessError) => {
        err ? reject(err) : resolve();
      });
    });
  }

  // 批量保存任务（事务操作）
  static async saveAll(tasks: TaskModel[]): Promise<void> {
    const store = TaskDatabase.getStore();

    return new Promise((resolve, reject) => {
      store.createTransaction().then((transaction: relationalStore.Transaction) => {
        const promises = tasks.map(task => {
          return new Promise<void>((taskResolve, taskReject) => {
            // ✅ 1. Correctly define ValuesBucket (without extraneous fields)
            const valueBucket: relationalStore.ValuesBucket = {
              id: task.id,
              title: task.title,
              completed: task.completed ? 1 : 0,
              remaining_time: task.remainingTime,
              default_time: task.defaultTime,
              completed_time: task.completedTime ?? null, // Handle undefined
              date_key: task.dateKey
            };

            const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
            predicates.equalTo('id', task.id);

            // ✅ 2. Pass parameters in correct order:
            //    (tableName, ValuesBucket, predicates)
            transaction.update(
              valueBucket,  // ValuesBucket (object)
              predicates,    // RdbPredicates
              relationalStore.ConflictResolution.ON_CONFLICT_REPLACE
            ).then((rows: number) => {
              if (rows === 0) {
                // ✅ 3. Insert uses: (tableName, ValuesBucket)
                transaction.insert(
                  TABLE_NAME,   // string
                  valueBucket   // ValuesBucket
                ).then(() => taskResolve())
                  .catch((insertErr: BusinessError) => taskReject(insertErr));
              } else {
                taskResolve();
              }
            }).catch((err: BusinessError) => taskReject(err));
          });
        });

        Promise.all(promises)
          .then(() => transaction.commit())
          .then(resolve)
          .catch((e: BusinessError) => {
            transaction.rollback();
            reject(e);
          });
      }).catch((err: BusinessError) => reject(err));
    });
  }

  static async fetchByDate(dateKey: string): Promise<TaskModel[]> {
    const store = TaskDatabase.getStore();
    return new Promise((resolve, reject) => {
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      predicates.equalTo('date_key', dateKey);

      store.query(predicates, ['id', 'title', 'completed', 'remaining_time', 'default_time','completed_time', 'date_key'],
        (err, resultSet) => {
          if (err) {
            reject(err);
            return;
          }

          const tasks: TaskModel[] = [];
          while (resultSet.goToNextRow()) {
            const task = new TaskModel(
              resultSet.getString(resultSet.getColumnIndex('id')),
              resultSet.getString(resultSet.getColumnIndex('title')),
              resultSet.getLong(resultSet.getColumnIndex('default_time')),
              Boolean(resultSet.getLong(resultSet.getColumnIndex('completed'))),
              resultSet.getLong(resultSet.getColumnIndex('completed_time')),
              resultSet.getString(resultSet.getColumnIndex('date_key')),
              resultSet.getLong(resultSet.getColumnIndex('remaining_time'))
            );
            tasks.push(task);
          }

          resultSet.close();
          resolve(tasks);
        }
      );
    });
  }


  static async getTaskListMap(): Promise<TaskListMap> {
    while (!TaskDatabase.isInitialized) {
      await new Promise<void>(resolve => setTimeout(resolve, 50)); // 轮询间隔50ms
    }
    const store = TaskDatabase.getStore();
    return new Promise((resolve, reject) => {
      const predicates = new relationalStore.RdbPredicates(TABLE_NAME);
      store.query(predicates,
        ['id', 'title', 'completed', 'remaining_time', 'default_time','completed_time', 'date_key'],
        (err: BusinessError, resultSet: relationalStore.ResultSet) => {
          if (err) {
            reject(new Error(`数据库查询失败: ${err.message}`));
            return;
          }

          // ✅ 使用 Record 类型（即 { [dateKey: string]: TaskModel[] }）
          const taskMap: TaskListMap = {};

          try {
            while (resultSet.goToNextRow()) {
              const task = new TaskModel(
                resultSet.getString(resultSet.getColumnIndex('id')),
                resultSet.getString(resultSet.getColumnIndex('title')),
                resultSet.getLong(resultSet.getColumnIndex('default_time')),
                Boolean(resultSet.getLong(resultSet.getColumnIndex('completed'))),
                resultSet.getLong(resultSet.getColumnIndex('completed_time')),
                resultSet.getString(resultSet.getColumnIndex('date_key')),
                resultSet.getLong(resultSet.getColumnIndex('remaining_time'))
              );

              const dateKey = task.dateKey;
              // ✅ 分组逻辑（Record 类型特有）
              if (!taskMap[dateKey]) {
                taskMap[dateKey] = []; // 初始化该日期的数组
              }
              taskMap[dateKey].push(task); // 添加到对应分组
            }
          } catch (e) {
            reject(new Error(`数据解析异常: ${e instanceof Error ? e.message : String(e)}`));
            return;
          } finally {
            resultSet.close(); // 确保结果集关闭
          }

          resolve(taskMap);
        }
      );
    });
  }
}