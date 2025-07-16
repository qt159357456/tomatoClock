import { TaskData } from '../model/TaskModel';

/**
 * TaskItem: Displays a single task with checkbox and title
 * Handles task completion status changes and selection
 */
@Preview
@Component
export struct TaskItem {
  @Prop task: TaskData = {
    id: 'preview-task',
    title: '示例任务',
    completed: false,
    remainingTime: 25
  };;
  @Prop isSelected: boolean = false;

  build() {
    Row() {
      Column() {
        // 任务标题
        Text(this.task.title)
          .fontSize(16)
          .decoration({
            type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
          })
          .opacity(this.task.completed ? 0.5 : 1)

        // 剩余时间
        Text(`剩余 ${this.task.remainingTime} 分钟`)
          .fontSize(14)
          .margin({ top: 4 })
          .decoration({
            type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
          })
          .opacity(this.task.completed ? 0.5 : 1)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 完成状态复选框
      Checkbox()
        .select(this.task.completed)
        .onChange((checked: boolean) => {
          // 处理任务完成状态变化
        })
    }
    .padding(12)
    .backgroundColor(this.isSelected ? '#F0F0F0' : '#FFFFFF')
    .borderRadius(8)
    .border({ width: 1, color: '#EEEEEE' })
  }
}