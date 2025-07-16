import { TaskData,TaskModel } from '../model/TaskModel';
import { TaskItem } from './TaskItem';



/**
 * TaskList: Displays a list of tasks
 * Manages task selection and provides callbacks for task interactions
 */
// @Preview
// @Component
// export struct TaskList {
//   @Prop taskList: TaskData[] = [];
//   @Prop targetDate: string = '';
//
//   build() {
//     Column() {
//       // 日期标题
//       Text(this.targetDate)
//         .fontSize(18)
//         .fontWeight(FontWeight.Medium)
//         .textAlign(TextAlign.Start)
//         .width('100%')
//         .padding({ bottom: 12 });
//
//       // 任务列表
//       Column() {
//         ForEach(this.taskList, (task: TaskData) => {
//           TaskItem({
//             task: task,
//             isSelected: false
//           })
//             .margin({ bottom: 8 })
//         })
//       }
//       .width('100%')
//     }
//     .width('100%')
//     .padding(12)
//     .borderRadius(12)
//     .backgroundColor('#FFFFFF')
//     .shadow({ radius: 4, color: '#00000010', offsetX: 1, offsetY: 1 })
//   }
// }

@Component
export struct TaskList {
  @Prop taskList: TaskModel[] = [];
  @Prop targetDate: string = '';

  /**
   * 格式化显示日期 (今天/昨天/其他)
   */
  private formatDisplayDate(dateStr: string): string {
    const today = new Date();
    const todayStr = today.toISOString().split('T')[0];

    if (dateStr === todayStr) return '今天';

    const yesterday = new Date(today);
    yesterday.setDate(today.getDate() - 1);
    const yesterdayStr = yesterday.toISOString().split('T')[0];

    if (dateStr === yesterdayStr) return '昨天';

    // 其他日期返回 YYYY-MM-DD 格式
    return dateStr;
  }

  build() {
    Column() {
      // 日期标题
      Row() {
        Text(this.formatDisplayDate(this.targetDate))
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .layoutWeight(1)
      }
      .padding({ bottom: 16 })

      // 任务列表
      Column() {
        ForEach(this.taskList, (task: TaskModel) => {
          TaskItem({
            task: task,
            isSelected: false
          })
        })
      }
    }
    .width('100%')
    .margin({ bottom: 24 })
  }
}