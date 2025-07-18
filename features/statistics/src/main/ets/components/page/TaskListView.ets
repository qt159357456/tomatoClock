import {TaskListMap,TaskModel} from 'task'
import {TaskList} from 'task/src/main/ets/view/TaskList'
import {AddTaskView} from 'task/src/main/ets/view/AddTaskView'

@Preview
@Component
export struct TaskListView1 {
  @Link taskListMap: TaskListMap;
  onSwitchToTimer?: (task: TaskModel) => void;
  dialogController: CustomDialogController = new CustomDialogController({
    builder: AddTaskView({
      onCancel: () => {
        this.dialogController.close()
      },
      onConfirm: async (title, minutes) => {
        const seconds = minutes; // 将分钟转换为秒
        const result = await TaskModel.createDailyTask(this.taskListMap, title, seconds);
        this.taskListMap = result[0];
        this.dialogController.close();
      }
    }),
    alignment: DialogAlignment.Center,
  })

  /**
   * 按日期排序任务列表 (倒序)
   */
  private getSortedDateKeys(): string[] {
    return Object.keys(this.taskListMap)
      .sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  }

  build() {
    Stack() {
      Column() {
        Row() {
          Image($r('app.media.OIP'))
            .width('100%')
            .height(150)
        }
        .width('100%')
        .padding({ bottom: 16 })

        // 任务列表区
        Scroll() {
          Column() {
            ForEach(this.getSortedDateKeys(), (dateKey: string) => {
              TaskList({
                taskListMap: this.taskListMap,
                taskList: this.taskListMap[dateKey],
                targetDate: dateKey,
                onSwitchToTimer: this.onSwitchToTimer
              })

            })
          }
        }
        .align(Alignment.TopStart)
        .layoutWeight(1)
        .scrollable(ScrollDirection.Vertical)
        }
        .width('90%')
        .height('100%')
      }
    }

}