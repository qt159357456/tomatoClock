// import { preferences } from '@kit.ArkData';
// import { TaskModel } from '../model/TaskModel'; // 导入任务模型
//
// /**
//  * 存储工具类：基于preferences实现轻量级数据持久化
//  * 严格遵循HarmonyOS首选项开发规范，包含存储模式选择和同步API使用
//  */
// export class StorageUtil {
//   // === 常量定义 - 存储键名 ===
//   static readonly STORE_NAME: string = 'tomato_clock'; // 存储文件名
//   static readonly TASK_LIST_KEY: string = 'taskList'; // 任务列表键
//   static readonly COMPLETED_COUNT_KEY: string = 'completedCount'; // 完成次数键
//   static readonly THEME_KEY: string = 'currentTheme'; // 主题键（'light'或'dark'）
//   static readonly TIMER_REMAINING_KEY: string = 'timerRemaining'; // 计时剩余时间键
//   static readonly WIDGET_TIME_REMAINING_KEY: string = 'widget_time_remaining'; // 小组件剩余时间键
//   static readonly WIDGET_CURRENT_TASK_KEY: string = 'widget_current_task'; // 小组件当前任务键
//
//   private static _instance: preferences.Preferences | null = null; // 单例实例
//   private static _storageType: preferences.StorageType; // 存储模式（XML或GSKV）
//
//   /**
//    * 初始化存储实例（必须在UIAbility生命周期调用）
//    * @param context 应用上下文
//    */
//   static init(context: Context): void {
//     // 1. 检测支持的存储模式
//     const isGskvSupported = preferences.isStorageTypeSupported(
//       preferences.StorageType.GSKV
//     );
//
//     // 2. 根据支持情况选择存储模式
//     StorageUtil._storageType = isGskvSupported
//       ? preferences.StorageType.GSKV
//       : preferences.StorageType.XML;
//
//     console.info(`使用存储模式: ${StorageUtil._storageType}`);
//
//     // 3. 同步创建首选项实例
//     StorageUtil._instance = preferences.getPreferencesSync(context, {
//       name: StorageUtil.STORE_NAME,
//       storageType: StorageUtil._storageType
//     });
//   }
//
//   /**
//    * 保存任务列表（使用同步API）
//    * @param {TaskModel[]} tasks - 任务对象数组
//    */
//   static saveTasks(tasks: TaskModel[]): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     // 序列化为JSON字符串
//     const tasksJson = TaskModel.toJSONString(tasks);
//
//     // 同步写入数据
//     StorageUtil._instance!.putSync(StorageUtil.TASK_LIST_KEY, tasksJson);
//
//     // 如果是XML模式，需要手动刷盘
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 加载任务列表（使用同步API）
//    * @returns {TaskModel[]} 任务对象数组
//    */
//   static loadTasks(): TaskModel[] {
//     if (!StorageUtil._validateInstance()) return [];
//
//     // 读取数据（带默认值）
//     const tasksStr = StorageUtil._instance!.getSync(
//       StorageUtil.TASK_LIST_KEY,
//       '[]'
//     ) as string;
//
//     // 反序列化
//     return TaskModel.fromJSONString(tasksStr);
//   }
//
//   /**
//    * 保存完成次数（使用同步API）
//    * @param {number} count - 完成的任务数量
//    */
//   static saveCompletedCount(count: number): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     StorageUtil._instance!.putSync(StorageUtil.COMPLETED_COUNT_KEY, count);
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 加载完成次数（使用同步API）
//    * @returns {number} 完成的任务数量
//    */
//   static loadCompletedCount(): number {
//     if (!StorageUtil._validateInstance()) return 0;
//
//     return StorageUtil._instance!.getSync(
//       StorageUtil.COMPLETED_COUNT_KEY,
//       0
//     ) as number;
//   }
//
//   /**
//    * 保存主题设置（使用同步API）
//    * @param {string} theme - 主题名称（'light'/'dark'）
//    */
//   static saveTheme(theme: string): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     StorageUtil._instance!.putSync(StorageUtil.THEME_KEY, theme);
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 加载主题设置（使用同步API）
//    * @returns {string} 当前主题名称
//    */
//   static loadTheme(): string {
//     if (!StorageUtil._validateInstance()) return 'light';
//
//     return StorageUtil._instance!.getSync(
//       StorageUtil.THEME_KEY,
//       'light'
//     ) as string;
//   }
//
//   /**
//    * 保存计时器剩余时间（使用同步API）
//    * @param {number} timeRemaining - 剩余时间（秒）
//    */
//   static saveTimerRemaining(timeRemaining: number): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     StorageUtil._instance!.putSync(StorageUtil.TIMER_REMAINING_KEY, timeRemaining);
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 加载计时器剩余时间（使用同步API）
//    * @param {number} [defaultValue=1500] - 默认值（25分钟）
//    * @returns {number} 剩余时间（秒）
//    */
//   static loadTimerRemaining(defaultValue: number = 25 * 60): number {
//     if (!StorageUtil._validateInstance()) return defaultValue;
//
//     return StorageUtil._instance!.getSync(
//       StorageUtil.TIMER_REMAINING_KEY,
//       defaultValue
//     ) as number;
//   }
//
//   /**
//    * 更新小组件数据（原子操作，使用同步API）
//    * @param {number} timeRemaining - 剩余时间（秒）
//    * @param {TaskModel} currentTask - 当前任务对象
//    */
//   static updateWidgetData(
//     timeRemaining: number,
//     currentTask: TaskModel
//   ): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     // 同时保存两个关联数据
//     StorageUtil._instance!.putSync(
//       StorageUtil.WIDGET_TIME_REMAINING_KEY,
//       timeRemaining
//     );
//     StorageUtil._instance!.putSync(
//       StorageUtil.WIDGET_CURRENT_TASK_KEY,
//       JSON.stringify(currentTask) // 对象需序列化
//     );
//
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 删除指定键值
//    * @param key 要删除的键名
//    */
//   static deleteKey(key: string): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     StorageUtil._instance!.deleteSync(key);
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 释放存储资源
//    * @param context 应用上下文
//    */
//   static dispose(context: Context): void {
//     if (StorageUtil._instance) {
//       preferences.deletePreferences(context, {
//         name: StorageUtil.STORE_NAME,
//         storageType: StorageUtil._storageType
//       });
//       StorageUtil._instance = null;
//     }
//   }
//
//   // === 私有辅助方法 ===
//
//   /**
//    * 验证实例是否初始化
//    * @returns 是否已初始化
//    */
//   private static _validateInstance(): boolean {
//     if (!StorageUtil._instance) {
//       console.error('错误：存储实例未初始化，请先调用StorageUtil.init()');
//       return false;
//     }
//     return true;
//   }
//
//   /**
//    * 根据需要刷盘（XML模式需要手动刷盘）
//    */
//   private static _flushIfNeeded(): void {
//     if (StorageUtil._storageType === preferences.StorageType.XML) {
//       StorageUtil._instance!.flushSync();
//     }
//     // GSKV模式自动持久化，无需手动刷盘
//   }
// }

// import { preferences } from '@kit.ArkData';
// import { TaskModel, TaskData } from '../model/TaskModel';
//
// export class StorageUtil {
//   // === 常量定义 - 存储键名 ===
//   static readonly STORE_NAME: string = 'tomato_clock';
//   static readonly TASK_LIST_KEY: string = 'taskList';
//   static readonly ACTIVE_TASK_KEY: string = 'active_task';
//
//   private static _instance: preferences.Preferences | null = null;
//   private static _storageType: preferences.StorageType;
//
//   /**
//    * 初始化存储实例
//    * @param context 应用上下文
//    */
//   static init(context: Context): void {
//     const isGskvSupported = preferences.isStorageTypeSupported(
//       preferences.StorageType.GSKV
//     );
//
//     StorageUtil._storageType = isGskvSupported
//       ? preferences.StorageType.GSKV
//       : preferences.StorageType.XML;
//
//     StorageUtil._instance = preferences.getPreferencesSync(context, {
//       name: StorageUtil.STORE_NAME,
//       storageType: StorageUtil._storageType
//     });
//   }
//
//   // === 任务管理核心方法 ===
//
//   /**
//    * 添加新任务（自动检测重复）
//    * @param task 要添加的任务对象
//    * @returns 添加是否成功
//    */
//   static addTask(task: TaskModel): boolean {
//     if (!StorageUtil._validateInstance()) return false;
//
//     const tasks = StorageUtil.loadTasks();
//
//     // 检测任务ID是否重复
//     if (tasks.some(t => t.id === task.id)) {
//       console.error(`添加失败：任务ID ${task.id} 已存在`);
//       return false;
//     }
//
//     tasks.push(task);
//     StorageUtil._saveTaskList(tasks);
//     return true;
//   }
//
//   /**
//    * 更新任务（支持部分更新）
//    * @param taskId 要更新的任务ID
//    * @param updates 更新内容（部分任务属性）
//    * @returns 更新是否成功
//    */
//   static updateTask(taskId: string, updates: Partial<TaskData>): boolean {
//     if (!StorageUtil._validateInstance()) return false;
//
//     const tasks = StorageUtil.loadTasks();
//     const index = tasks.findIndex(t => t.id === taskId);
//
//     if (index === -1) {
//       console.error(`更新失败：任务ID ${taskId} 不存在`);
//       return false;
//     }
//
//     // 应用部分更新
//     const updatedTask = {...tasks[index], ...updates};
//     tasks[index] = new TaskModel(
//       updatedTask.id,
//       updatedTask.title,
//       updatedTask.remainingTime,
//       updatedTask.completed,
//       updatedTask.completedTime
//     );
//
//     StorageUtil._saveTaskList(tasks);
//     return true;
//   }
//
//   /**
//    * 删除任务
//    * @param taskId 要删除的任务ID
//    * @returns 删除是否成功
//    */
//   static deleteTask(taskId: string): boolean {
//     if (!StorageUtil._validateInstance()) return false;
//
//     let tasks = StorageUtil.loadTasks();
//     const initialLength = tasks.length;
//
//     tasks = tasks.filter(t => t.id !== taskId);
//
//     if (tasks.length === initialLength) {
//       console.error(`删除失败：任务ID ${taskId} 不存在`);
//       return false;
//     }
//
//     StorageUtil._saveTaskList(tasks);
//     return true;
//   }
//
//   /**
//    * 设置当前活动任务
//    * @param task 活动任务对象（null表示清除）
//    */
//   static setActiveTask(task: TaskModel | null): void {
//     if (!StorageUtil._validateInstance()) return;
//
//     if (task) {
//       // 确保任务已存在于列表中
//       if (!StorageUtil._taskExists(task.id)) {
//         StorageUtil.addTask(task);
//       }
//
//       StorageUtil._instance!.putSync(
//         StorageUtil.ACTIVE_TASK_KEY,
//         JSON.stringify({
//           id: task.id,
//           remaining: task.remainingTime,
//           timestamp: Date.now()
//         })
//       );
//     } else {
//       StorageUtil._instance!.deleteSync(StorageUtil.ACTIVE_TASK_KEY);
//     }
//
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 获取当前活动任务
//    * @returns 活动任务对象或null
//    */
//   static getActiveTask(): TaskModel | null {
//     if (!StorageUtil._validateInstance()) return null;
//
//     try {
//       const data = StorageUtil._instance!.getSync(
//         StorageUtil.ACTIVE_TASK_KEY,
//         null
//       );
//
//       if (!data) return null;
//
//       const { id } = JSON.parse(data as string);
//       const tasks = StorageUtil.loadTasks();
//       return tasks.find(t => t.id === id) || null;
//     } catch (error) {
//       console.error('活动任务加载失败:', error);
//       return null;
//     }
//   }
//
//   // === 批量操作方法 ===
//
//   /**
//    * 加载所有任务
//    * @returns 任务对象数组
//    */
//   static loadTasks(): TaskModel[] {
//     if (!StorageUtil._validateInstance()) return [];
//
//     try {
//       const tasksStr = StorageUtil._instance!.getSync(
//         StorageUtil.TASK_LIST_KEY,
//         '[]'
//       ) as string;
//
//       const data: any[] = JSON.parse(tasksStr);
//
//       // 数据转换与验证
//       return data
//         .filter(item => item.id && item.title && !isNaN(item.remainingTime))
//         .map(item => new TaskModel(
//           item.id,
//           item.title,
//           Number(item.remainingTime),
//           Boolean(item.completed),
//           item.completedTime ? Number(item.completedTime) : undefined
//         ));
//     } catch (error) {
//       console.error('任务加载失败:', error);
//       return [];
//     }
//   }
//
//   /**
//    * 批量保存任务列表（覆盖模式）
//    * @param tasks 任务对象数组
//    */
//   static saveAllTasks(tasks: TaskModel[]): void {
//     if (!StorageUtil._validateInstance()) return;
//     StorageUtil._saveTaskList(tasks);
//   }
//
//   // === 私有辅助方法 ===
//
//   /**
//    * 内部保存任务列表
//    * @param tasks 任务对象数组
//    */
//   private static _saveTaskList(tasks: TaskModel[]): void {
//     const compactData = tasks.map(task => ({
//       id: task.id,
//       title: task.title.substring(0, 100), // 限制标题长度
//       remainingTime: task.remainingTime,
//       completed: task.completed,
//       completedTime: task.completedTime
//     }));
//
//     StorageUtil._instance!.putSync(
//       StorageUtil.TASK_LIST_KEY,
//       JSON.stringify(compactData)
//     );
//
//     StorageUtil._flushIfNeeded();
//   }
//
//   /**
//    * 检查任务是否存在
//    * @param taskId 任务ID
//    * @returns 是否存在
//    */
//   private static _taskExists(taskId: string): boolean {
//     const tasks = StorageUtil.loadTasks();
//     return tasks.some(t => t.id === taskId);
//   }
//
//   private static _validateInstance(): boolean {
//     if (!StorageUtil._instance) {
//       console.error('错误：存储实例未初始化');
//       return false;
//     }
//     return true;
//   }
//
//   private static _flushIfNeeded(): void {
//     if (StorageUtil._storageType === preferences.StorageType.XML) {
//       StorageUtil._instance!.flushSync();
//     }
//   }
// }