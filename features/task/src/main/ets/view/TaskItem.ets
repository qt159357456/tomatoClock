// import { TaskModel  } from '../model/TaskModel';
//
//
// @Component
// export struct TaskItem {
//   @Prop count:number = 0;
//   @Prop task: TaskModel;
//   @Prop isSelected: boolean = false;
//   onSwitchToTimer?: (task: TaskModel) => void;
//
//   build() {
//     Row() {
//       // 任务信息
//       Column() {
//         // 任务标题
//         Text(this.task.title)
//           .fontSize(18)
//           .fontWeight(FontWeight.Medium)
//           .fontColor('#333333')
//           .decoration({
//             type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
//           })
//           .opacity(this.task.completed ? 0.6 : 1)
//           .margin({ bottom: 4 })
//
//         // 预计时间
//         Text(`预计${this.task.remainingTime/60}分钟`)
//           .fontSize(14)
//           .fontColor('#888888')
//           .decoration({
//             type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
//           })
//           .opacity(this.task.completed ? 0.6 : 1)
//       }
//       .layoutWeight(1)
//       .alignItems(HorizontalAlign.Start)
//
//       // 开始按钮 (替换复选框)
//       Button('开始', { type: ButtonType.Capsule })
//         .backgroundColor('#FF6B6B') // 番茄红色
//         .fontColor(Color.White)
//         .fontSize(14)
//         .opacity(this.task.completed ? 0.3 : 1)
//         .enabled(!this.task.completed)
//         .width(80)
//         .height(36)
//         .onClick(() => {
//           // 启动番茄钟计时器
//           if (this.onSwitchToTimer) {
//             this.onSwitchToTimer(this.task); // 使用 this.task
//           }
//           console.log(`开始任务: ${this.task.title}`);
//         })
//
//     }
//
//     .padding(16)
//     .backgroundColor(Color.White)
//     .borderRadius(12)
//     .shadow({ radius: 8, color: '#00000010', offsetX: 0, offsetY: 2 })
//     .margin({ bottom: 12 })
//   }
// }

import { TaskModel } from '../model/TaskModel';

@Component
export struct TaskItem {
  @Prop task: TaskModel;
  @Prop count: number = 0;
  @Prop isSelected: boolean = false;


  onSwitchToTimer?: (task: TaskModel) => void;

  build() {
    Row() {
      Column() {
        // 使用 localTask 而不是原始 task
        Text(this.task.title)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .decoration({
            type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
          })
          .opacity(this.task.completed ? 0.6 : 1)
          .margin({ bottom: 4 })

        // 显示剩余时间
        Text(`预计${Math.floor(this.task.remainingTime / 60.0)}分钟`)
          .fontSize(14)
          .fontColor('#888888')
          .decoration({
            type: this.task.completed ? TextDecorationType.LineThrough : TextDecorationType.None
          })
          .opacity(this.task.completed ? 0.6 : 1)
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      Button('开始', { type: ButtonType.Capsule })
        .backgroundColor('#FF6B6B')
        .fontColor(Color.White)
        .fontSize(14)
        .opacity(this.task.completed ? 0.3 : 1)
        .enabled(!this.task.completed)
        .width(80)
        .height(36)
        .onClick(() => {
          if (this.onSwitchToTimer) {
            this.onSwitchToTimer(this.task);
          }
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