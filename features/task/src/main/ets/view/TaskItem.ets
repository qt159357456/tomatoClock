import { TaskData } from '../model/TaskModel';

/**
 * TaskItem: Displays a single task with checkbox and title
 * Handles task completion status changes and selection
 */
// @Preview
// @Component
// export struct TaskItem {
//   @Prop task: TaskData = {
//     id: 'preview-task',
//     title: '示例任务',
//     completed: false,
//     remainingTime: 25
//   };;
//   @Prop isSelected: boolean = false;
//
//   build() {
//     Row() {
//       Column() {
//         // 任务标题
//         Text(this.task.title)
//           .fontSize(16)
//           .decoration({
//             type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
//           })
//           .opacity(this.task.completed ? 0.5 : 1)
//
//         // 剩余时间
//         Text(`剩余 ${this.task.remainingTime} 分钟`)
//           .fontSize(14)
//           .margin({ top: 4 })
//           .decoration({
//             type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
//           })
//           .opacity(this.task.completed ? 0.5 : 1)
//       }
//       .layoutWeight(1)
//       .alignItems(HorizontalAlign.Start)
//
//       // 完成状态复选框
//       Checkbox()
//         .select(this.task.completed)
//         .onChange((checked: boolean) => {
//           // 处理任务完成状态变化
//         })
//     }
//     .padding(12)
//     .backgroundColor(this.isSelected ? '#F0F0F0' : '#FFFFFF')
//     .borderRadius(8)
//     .border({ width: 1, color: '#EEEEEE' })
//   }
// }
// components/TaskItem.ets
import { TaskModel } from '../model/TaskModel';

@Component
export struct TaskItem {
  @Prop task: TaskModel;
  @Prop isSelected: boolean = false;

  build() {
    Row() {
      // 任务信息
      Column() {
        // 任务标题
        Text(this.task.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .decoration({
            type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
          })
          .opacity(this.task.completed ? 0.6 : 1)
          .margin({ bottom: 4 })

        // 预计时间
        Text(`预计${this.task.remainingTime}分钟`)
          .fontSize(14)
          .fontColor('#888888')
          .decoration({
            type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
          })
          .opacity(this.task.completed ? 0.6 : 1)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 开始按钮 (替换复选框)
      Button('开始', { type: ButtonType.Capsule })
        .backgroundColor('#FF6B6B') // 番茄红色
        .fontColor(Color.White)
        .fontSize(14)
        .opacity(this.task.completed ? 0.3 : 1)
        .enabled(!this.task.completed)
        .width(80)
        .height(36)
        .onClick(() => {
          // 启动番茄钟计时器
          console.log(`开始任务: ${this.task.title}`);
        })
    }
    .padding(16)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 2 })
    .margin({ bottom: 12 })
  }
}