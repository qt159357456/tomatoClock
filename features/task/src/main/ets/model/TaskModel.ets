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
}

/**
 * 任务模型类：封装番茄钟应用中的任务操作逻辑
 * 实现任务数据的创建、解析、序列化等核心功能
 */
export class TaskModel implements TaskData {
  // 基础属性
  id: string;          // 任务唯一ID
  title: string;       // 任务标题
  completed: boolean;  // 是否完成
  remainingTime: number;  //剩余时间
  completedTime?: number; // 完成时间戳（仅当任务完成时存在）

  /**
   * 构造函数
   * @param id 任务ID
   * @param title 任务标题
   * @param completed 完成状态（默认false）
   * @property remainingTime 剩余时间
   * @param completedTime 完成时间戳（可选）
   */
  constructor(
    id: string,
    title: string,
    remainingTime: number,
    completed: boolean = false,
    completedTime?: number
  ) {
    this.id = id;
    this.title = title;
    this.completed = completed;
    this.remainingTime = remainingTime;
    this.completedTime = completedTime;
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
   * 从JSON数据重建任务对象
   * @param data 符合TaskData结构的对象
   * @returns 重构的任务实例
   * @用途 用于反序列化存储数据[5](@ref)
   */
  static fromJSON(data: TaskData): TaskModel {
    return new TaskModel(
      data.id,
      data.title,
      data.remainingTime,
      data.completed,
      data.completedTime
    );
  }

  /**
   * 将任务列表序列化为JSON字符串
   * @param tasks 任务实例数组
   * @returns JSON格式字符串
   * @用途 本地存储数据持久化[3](@ref)
   */
  static toJSONString(tasks: TaskModel[]): string {
    return JSON.stringify(tasks);
  }

  /**
   * 从JSON字符串解析任务列表
   * @param jsonString JSON格式的字符串
   * @returns 任务实例数组
   * @安全机制 错误时返回空数组避免崩溃[6](@ref)
   */
  static fromJSONString(jsonString: string): TaskModel[] {
    try {
      const data: TaskData[] = JSON.parse(jsonString);
      // 校验并转换数组元素
      return Array.isArray(data) ?
      data.map(item => TaskModel.fromJSON(item)) : [];
    } catch (error) {
      console.error('JSON解析失败:', error);
      return [];  // 故障安全设计：返回空数组
    }
  }

  /**
   * 更新剩余时间（安全方法）
   */
  updateRemainingTime(seconds: number): void {
    this.remainingTime = Math.max(0, seconds);

    // 如果时间为0，自动标记为完成
    if (this.remainingTime === 0 && !this.completed) {
      this.completed = true;
      this.completedTime = Date.now();
    }
  }

  /**
   * 向指定日期的任务列表添加新任务
   * @param taskMap 当前的任务映射对象
   * @param dateKey 日期字符串（格式 YYYY-MM-DD）
   * @param newTask 要添加的新任务
   * @returns 更新后的任务映射对象
   */
  // static addTaskForDate(
  //   taskMap: TaskListMap,
  //   dateKey: string,
  //   newTask: TaskModel
  // ): TaskListMap {
  //   // 创建当前日期的任务数组副本（避免直接修改原数组）
  //   const currentTasks = [...(taskMap[dateKey] || [])];
  //
  //   // 检查任务是否已存在（防止重复添加）
  //   if (!currentTasks.some(task => task.id === newTask.id)) {
  //     currentTasks.push(newTask);
  //     return { ...taskMap, [dateKey]: currentTasks };
  //   }
  //   return taskMap; // 如果已存在则返回原对象
  // }
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

      // 类型断言确保接口匹配[3,7](@ref)
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
    targetDate?: string
  ): [TaskListMap, TaskModel] {
    const dateKey = targetDate || TaskModel.getTodayDateKey();
    const newTask = TaskModel.createNew(title, remainingTime);
    return [
      TaskModel.addTaskForDate(taskMap, dateKey, newTask),
      newTask
    ];
  }

  /** 获取当天日期键（YYYY-MM-DD 格式） */
  private static getTodayDateKey(): string {
    const today = new Date();
    return today.toISOString().split('T')[0];
  }
}