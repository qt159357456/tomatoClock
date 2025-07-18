import { TaskModel, TaskListMap } from "../model/TaskModel";
import { TaskList } from './TaskList';
import { AddTaskView } from './AddTaskView';

@Preview
@Component
export struct TaskListView {
  @Link taskListMap: TaskListMap;
  onSwitchToTimer?: (task: TaskModel) => void;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddTaskView({
      onCancel: () => {this.dialogController.close()},
      onConfirm: async (title, minutes) => {
        const seconds = minutes ; // 将分钟转换为秒
        const result = await TaskModel.createDailyTask(this.taskListMap, title, seconds);
        this.taskListMap = result[0];
        this.dialogController.close();
      }
    }),
    alignment: DialogAlignment.Center,
  })
  private getSortedDateKeys(): string[] {
    return Object.keys(this.taskListMap)
      .sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r('app.media.tomato_icon'))
            .width('100%')
        }
        .width('100%')

        // 任务列表区域
        Scroll() {
          Column() {
            ForEach(this.getSortedDateKeys(), (dateKey: string) => {
              TaskList({
                taskListMap:this.taskListMap,
                taskList: this.taskListMap[dateKey],
                targetDate: dateKey,
                onSwitchToTimer: this.onSwitchToTimer
              })

            })
          }
        }
        .layoutWeight(1)
        .scrollable(ScrollDirection.Vertical)
        .margin({left: 12,right: 12})

        // 加号SVG按钮
        Image($r('app.media.jiahao'))
          .width(75)
          .height(75)
          .objectFit(ImageFit.Contain)
          .padding(5)
          .borderRadius(24)
          .onClick(() => this.dialogController.open())
        // 底部副标题
        Text('高效专注 轻松培养专注好习惯')
          .fontSize(14)
          .fontColor('#999999')
          .textAlign(TextAlign.Center)
          .margin({ top: 20 })
      }
      .width('100%')
      .height('100%')
    }

  }
}