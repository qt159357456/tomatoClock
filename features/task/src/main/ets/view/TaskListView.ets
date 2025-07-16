import { TaskData,TaskModel,TaskListMap } from "../model/TaskModel";
import { TaskList } from './TaskList';

@Preview
@Component
export struct TaskListView {
  @State taskListMap: TaskListMap = {
    '2025-07-16': [
      new TaskModel('task1', '设计登录页面', 1500),
      new TaskModel('task2', 'API接口联调', 2400)
    ],
    '2025-07-15': [
      new TaskModel('task3', '用户需求评审', 1800)
    ]
  };

  /**
   * 按日期排序任务列表
   * @returns 排序后的日期键数组（倒序）
   */
  private getSortedDateKeys(): string[] {
    return Object.keys(this.taskListMap)
      .sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  }

  build() {
    Column() {
      Text('任务列表')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 16 });

      Scroll() {
        Column() {
          // 遍历所有日期（按倒序排列）
          ForEach(this.getSortedDateKeys(), (dateKey: string) => {
            // 为每个日期创建任务列表
            TaskList({
              taskList: this.taskListMap[dateKey],
              targetDate: dateKey
            })
              .margin({ bottom: 24 })
          })
        }
      }
      .layoutWeight(1)
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .padding(16)
  }
}