import {TaskColumnView} from './sim_task'
import {TaskListView,TaskListMap,TaskModel} from 'task'
import {TaskListView1} from './TaskListView'
import {TimerView} from 'timer'
import { TaskList } from 'task/src/main/ets/view/TaskList';
import { AddTaskView } from 'task/src/main/ets/view/AddTaskView';
export class DataClass{

}

@Component
export struct DataDetailPage {
  @Consume('PathStack') PathStack: NavPathStack;
  @State DayDetail: DataClass | null = null;
  @State currentIndex: number = 0;
  //@Link taskListMap: TaskListMap;
  @State selectedTask: TaskModel | null = null;
  @State taskListMap: TaskListMap = {};

  async loadTaskData() {
    try {
      const data = await TaskModel.getTaskListMap();
      this.taskListMap = data;
      console.info('任务数据加载成功');
    } catch (error) {
      console.error('数据加载失败:', error);
    }
  }

  aboutToAppear(): void {
    this.DayDetail = this.PathStack.getParamByName('DayDetail')[0] as DataClass;
    this.loadTaskData()
  }

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

  switchToTimer(task: TaskModel) {
    this.selectedTask = task; // 存储要传递的任务
    this.currentIndex = 0; // 切换到倒计时页
  }
  private getSortedDateKeys(): string[] {
    return Object.keys(this.taskListMap)
      .sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  }

  build() {
    NavDestination() {
      Row() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(40)
            .height(40)
        }
        .width('80%')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(56)
      .margin({ left: 36, top: 16 })
      .onClick(() => {
        this.PathStack.pop()
      })

      //TaskColumnView()
      TaskListView1({
        taskListMap: this.taskListMap,
        onSwitchToTimer: this.switchToTimer.bind(this) // 传递切换方法
      })
    }
    .hideTitleBar(true)
  }
}