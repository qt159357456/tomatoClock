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
    remainingTime: number,
    completed: boolean = false,
    completedTime?: number,
    dateKey?: string
  ) {
    this._id = id;
    this._title = title;
    this._remainingTime = remainingTime;
    this._completed = completed;
    this._completedTime = completedTime;
    this._dateKey = dateKey || TaskModel.getTodayDateKey();
  }

  // =====================
  // 属性访问器（getters）
  // =====================

  get id(): string {
    return this.id;
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
  // =====================
  // 属性修改器（setters）
  // =====================

  set title(newTitle: string) {
    if (newTitle && newTitle.trim().length > 0) {
      this._title = newTitle.trim();
    } else {
      console.warn("任务标题不能为空");
    }
  }

  set remainingTime(seconds: number) {
    if (seconds >= 0) {
      this._remainingTime = seconds;

      // 如果时间为0，自动标记为完成
      if (this._remainingTime === 0 && !this._completed) {
        this.markAsCompleted();
      }
    } else {
      console.warn("剩余时间不能为负数");
    }
  }

  set dateKey(newDateKey: string) {
    if (TaskModel.isValidDateKey(newDateKey)) {
      this._dateKey = newDateKey;
    } else {
      console.warn("无效的日期格式，应为 YYYY-MM-DD");
    }
  }

  /**
   * 标记任务为完成
   * @param timestamp 完成时间戳（可选，默认当前时间）
   */
  markAsCompleted(timestamp: number = Date.now()): void {
    if (!this._completed) {
      this._completed = true;
      this._completedTime = timestamp;
      this._remainingTime = 0; // 完成时剩余时间设为0
    }
  }

  /**
   * 标记任务为未完成
   */
  markAsIncomplete(): void {
    if (this._completed) {
      this._completed = false;
      this._completedTime = undefined;

      // 如果剩余时间为0，重置为默认值（例如1小时）
      if (this._remainingTime === 0) {
        this._remainingTime = 3600; // 默认1小时
      }
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
   * 更新剩余时间（安全方法）
   */
  updateRemainingTime(seconds: number): void {
    this._remainingTime = Math.max(0, seconds);

    // 如果时间为0，自动标记为完成
    if (this.remainingTime === 0 && !this.completed) {
      this._completed = true;
      this._completedTime = Date.now();
    }
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
    // 使用Array.from替代展开运算符
    const currentTasks = Array.from(taskMap[dateKey] || []);

    if (!currentTasks.some(task => task.id === newTask.id)) {
      currentTasks.push(newTask);

      taskMap[dateKey] = currentTasks;

      return taskMap;
    }
    return taskMap;
  }

  /**
   * 创建每日任务（整合日期键生成和添加操作）
   * @param taskMap 当前的任务映射对象
   * @param title 任务标题
   * @param remainingTime 初始剩余时间（秒）
   * @param targetDate 目标日期（可选，默认当天）
   * @returns [更新后的映射对象, 创建的任务实例]
   */
  static createDailyTask(
    taskMap: TaskListMap,
    title: string,
    remainingTime: number,
    targetDate?: string,
  ): [TaskListMap, TaskModel] {
    const dateKey = targetDate || TaskModel.getTodayDateKey();
    const newTask = TaskModel.createNew(title, remainingTime);
    newTask._dateKey = dateKey;
    return [
      TaskModel.addTaskForDate(taskMap, dateKey, newTask),
      newTask
    ];
  }
  static deleteDialyTask(
    taskMap: TaskListMap,
    id:string,
    dateKey:string,
  ):TaskListMap {
    // 使用Array.from替代展开运算符
     const currentTasks = Array.from(taskMap[dateKey] || []);
     console.log('id is:', id);
     const tmp = currentTasks.filter(task => task.id !== id)
     taskMap[dateKey] = tmp;
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
}