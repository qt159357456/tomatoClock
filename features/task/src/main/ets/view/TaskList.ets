import { TaskModel } from '../model/TaskModel';
import { TaskItem } from './TaskItem';


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
  @State showDeleteDialog: boolean = false;
  onSwitchToTimer?: (task: TaskModel) => void;
  deleteDailogController: CustomDialogController = new CustomDialogController({
    builder:DeleteView({
      taskId:this.deleteID,
      dateKey:this.deleteDateKey,
      onCancel: () => {this.deleteDailogController.close()},
      onConfirm:async (taskId:string,dateKey:string) => {
        console.log('onConfirm called with:', taskId, dateKey);
        const result = await TaskModel.deleteDailyTask(this.taskListMap,taskId,dateKey);
        this.taskListMap = result;
        this.taskList = result[this.targetDate] || [];
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
    if(this.taskList.length === 0) return ''
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
          .visibility(this.formatDisplayDate(this.targetDate) ? Visibility.Visible : Visibility.None)
      }
      .padding({ bottom: 16 })

      // 任务列表
      Column() {
        ForEach(this.taskList, (task: TaskModel) => {
          TaskItem({
            task: task,
            isSelected: false,
            onSwitchToTimer: this.onSwitchToTimer
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
                  if (this.count > 0) {
                    this.deleteID = task.id;
                    this.deleteDateKey = task.dateKey||'';
                    this.showDeleteDialog = true;
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
// import { TaskModel } from '../model/TaskModel';
// import { TaskItem } from './TaskItem';
// import { DeleteView } from '../view/DeleteTaskView';
// import { TaskListMap } from "../model/TaskModel";
//
// @Component
// export struct TaskList {
//   @Link taskListMap: TaskListMap;
//   @Prop taskList: TaskModel[] = [];
//   @Prop targetDate: string = '';
//   @State count: number = 0;
//   @State deleteID: string = '';
//   @State deleteDateKey: string = '';
//   @State showDeleteDialog: boolean = false; // 添加状态控制对话框显示
//
//   // 重构对话框控制器
//   deleteDialogController: CustomDialogController = new CustomDialogController({
//     builder: this.deleteDialogBuilder(), // 使用构建器函数
//     autoCancel: true // 允许点击外部关闭
//   });
//
//   // 对话框构建器
//   @Builder
//   deleteDialogBuilder() {
//     DeleteView({
//       taskId: this.deleteID, // 使用当前状态值
//       dateKey: this.deleteDateKey, // 使用当前状态值
//       onCancel: () => {
//         this.deleteDialogController.close();
//         this.showDeleteDialog = false;
//       },
//       onConfirm: async (taskId: string, dateKey: string) => {
//         console.log('onConfirm called with:', taskId, dateKey);
//         try {
//           const result = await TaskModel.deleteDailyTask(this.taskListMap, taskId, dateKey);
//           this.taskListMap = result;
//           this.taskList = result[this.targetDate] || [];
//         } catch (e) {
//           console.error("删除任务失败", e);
//         } finally {
//           this.deleteDialogController.close();
//           this.showDeleteDialog = false;
//         }
//       }
//     })
//   }
//
//     /**
//      * 格式化显示日期 (今天/昨天/其他)
//      */
//     private formatDisplayDate(dateStr: string): string {
//       const today = new Date();
//       const todayStr = today.toISOString().split('T')[0];
//       if(this.taskList.length === 0) return ''
//       if (dateStr === todayStr) return '今天';
//
//       const yesterday = new Date(today);
//       yesterday.setDate(today.getDate() - 1);
//       const yesterdayStr = yesterday.toISOString().split('T')[0];
//
//       if (dateStr === yesterdayStr) return '昨天';
//
//       // 其他日期返回 YYYY-MM-DD 格式
//       return dateStr;
//     }
//
//   build() {
//     Column() {
//       // 日期标题
//       Row() {
//         Text(this.formatDisplayDate(this.targetDate))
//           .fontSize(20)
//           .fontWeight(FontWeight.Bold)
//           .fontColor('#333333')
//           .layoutWeight(1)
//           .visibility(this.formatDisplayDate(this.targetDate) ? Visibility.Visible : Visibility.None)
//       }
//       .padding({ bottom: 16 })
//
//       // 任务列表
//       Column() {
//         ForEach(this.taskList, (task: TaskModel) => {
//           TaskItem({
//             task: task,
//             isSelected: false
//           })
//             .gesture(
//               LongPressGesture({ repeat: true })
//                 .onAction((event: GestureEvent) => {
//                   if (event.repeat) {
//                     this.count++
//                   }
//                 })
//                 .onActionEnd(() => {
//                   if (this.count > 0) {
//                     this.deleteID = task.id; // 设置要删除的任务ID
//                     this.deleteDateKey = task.dateKey || ''; // 设置日期键
//                     this.showDeleteDialog = true; // 显示对话框
//                     this.deleteDialogController.open(); // 打开对话框
//                   }
//                   this.count = 0; // 重置计数器
//                 })
//             )
//         })
//       }
//     }
//     .width('100%')
//     .margin({ bottom: 20 })
//   }
// }