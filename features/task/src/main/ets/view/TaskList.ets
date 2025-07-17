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
import { DeleteView } from '../view/DeleteTaskView';
import { TaskListMap } from "../model/TaskModel";
@Component
export struct TaskList {
  @Link taskListMap: TaskListMap;
  @Prop taskList: TaskModel[] = [];
  @Prop targetDate: string = '';
  @State count:number = 0;
  @State deleteID:string = '';
  @State deleteDateKey:string = '';

  deleteDailogController: CustomDialogController = new CustomDialogController({
    builder:DeleteView({
      taskId:this.deleteID,
      dateKey:this.deleteDateKey,
      onCancel: () => {this.deleteDailogController.close()},
      onConfirm: (taskId:string,dateKey:string) => {
        const result = TaskModel.deleteDialyTask(this.taskListMap,taskId,dateKey);
        this.taskListMap = result;
        this.deleteDailogController.close();
      }
    })
  })
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
            .gesture(
              LongPressGesture({ repeat: true })
              // 由于repeat设置为true，长按动作存在时会连续触发，触发间隔为duration（默认值500ms）
                .onAction((event: GestureEvent) => {
                  if (event.repeat) {
                    this.count++
                  }
                })

                // 长按动作一结束触发
                .onActionEnd(() => {
                  if (this.count > 1) {
                    this.deleteID = task.id;
                    this.deleteDateKey = task.dateKey;
                    this.deleteDailogController.open()
                  }
                  // 重置 count
                  this.count = 0
                })
            )
        })
      }
    }
    .width('100%')
    .margin({ bottom: 20 })
  }
}