import { TaskData,TaskModel } from '../model/TaskModel';
import { TaskItem } from './TaskItem';



/**
 * TaskList: Displays a list of tasks
 * Manages task selection and provides callbacks for task interactions
 */
@Preview
@Component
export struct TaskList {
  @Prop taskList: TaskData[] = [];
  @Prop targetDate: string = '';

  build() {
    Column() {
      // 日期标题
      Text(this.targetDate)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .width('100%')
        .padding({ bottom: 12 });

      // 任务列表
      Column() {
        ForEach(this.taskList, (task: TaskData) => {
          TaskItem({
            task: task,
            isSelected: false
          })
            .margin({ bottom: 8 })
        })
      }
      .width('100%')
    }
    .width('100%')
    .padding(12)
    .borderRadius(12)
    .backgroundColor('#FFFFFF')
    .shadow({ radius: 4, color: '#00000010', offsetX: 1, offsetY: 1 })
  }
}