import { TaskData, TaskModel, TaskListMap } from "../model/TaskModel";
import { TaskList } from './TaskList';
import {AddTaskView } from './AddTaskView';

@Preview
@Component
export struct TaskListView {
  @Provide('PathStack') pathStack: NavPathStack = new NavPathStack();
  @State taskListMap: TaskListMap = {
    '2024-06-25': [
      new TaskModel('task1', '写一篇发言稿', 90),
      new TaskModel('task2', '项目会议准备', 45)
    ],
    '2024-06-23': [
      new TaskModel('task3', '设计提案文档', 120)
    ]
  };

  /**
   * 按日期排序任务列表 (倒序)
   */
  private getSortedDateKeys(): string[] {
    return Object.keys(this.taskListMap)
      .sort((a, b) => new Date(b).getTime() - new Date(a).getTime());
  }

  // 跳转到添加任务页面
  private navigateToAddTask() {
    router.pushUrl({
      url: 'pages/AddTaskView' // 您的添加任务页面路径
    });
  }

  build() {
    Stack() {
      Column() {
        // 顶部应用标题+加号按钮区域
        Row() {
          Image($r('app.media.tomato_icon'))
            .width('100%')
            .height(100)
            .margin({ left: 12 })
          // 标题组
          Row() {
            Text('番茄专注')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor('#FF6B6B')

            Text('高效时间管理')
              .fontSize(16)
              .fontColor('#666666')
              .margin({ left: 8 })
          }
          .layoutWeight(1) // 占据剩余空间

        }
        .width('100%')
        .padding({ bottom: 24 })

        // 任务列表区域
        Scroll() {
          Column() {
            ForEach(this.getSortedDateKeys(), (dateKey: string) => {
              TaskList({
                taskList: this.taskListMap[dateKey],
                targetDate: dateKey
              })
            })
          }
        }
        .layoutWeight(1)
        .scrollable(ScrollDirection.Vertical)

        // 加号SVG按钮 (核心修改)
        Image($r('app.media.jiahao'))
          .width(75) // 固定尺寸确保等比缩放
          .height(75)
          .objectFit(ImageFit.Contain) // 保持原始比例[1,4](@ref)
          .padding(5)
          // .backgroundColor('#FF6B6B') // 番茄红背景
          .borderRadius(24) // 圆形按钮
          .onClick(() => this.navigateToAddTask()) // 点击跳转
        // 底部副标题
        Text('高效专注 轻松培养专注好习惯')
          .fontSize(14)
          .fontColor('#999999')
          .textAlign(TextAlign.Center)
          .margin({ top: 20 })
      }
      .padding(24)
      .width('100%')
      .height('100%')
      // .backgroundImage($r('app.media.background_gradient'), ImageRepeat.NoRepeat, ImageSize.Cover)
    }
    if (this.pathStack. === 'addTask') {
      AddTaskView()
        .transition({ type: TransitionType.Pop, opacity: 0.9 })
    }
  }
}