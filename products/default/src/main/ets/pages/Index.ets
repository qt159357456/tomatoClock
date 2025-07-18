import { QuickStartPage } from 'quickstart';
import { CourseLearning } from 'learning';
import { KnowledgeMap } from 'map';
import {TaskListView,TaskListMap,TaskModel} from 'task'
import {TimerView} from 'timer'
import { DataCollection } from 'statistics';

@Entry
@Component
struct Index {
  @State taskListMap: TaskListMap = {};
  @State currentIndex: number = 0;
  @State selectedTask: TaskModel | null = null;
  private tabsController : TabsController = new TabsController();

  aboutToAppear(): void {
    this.loadTaskData()
  }
  async loadTaskData() {
    try {
      const data = await TaskModel.getTaskListMap();
      this.taskListMap = data;
      console.info('任务数据加载成功');
    } catch (error) {
      console.error('数据加载失败:', error);
    }
  }
  switchToTimer(task: TaskModel) {
    this.selectedTask = task; // 存储要传递的任务
    this.currentIndex = 0; // 切换到倒计时页
    this.tabsController.changeIndex(0); // 更新 Tab 控制器
  }
  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
        .height(24)
      Text(title)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(10)
        .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
        .textAlign(TextAlign.Center)
        .lineHeight(14)
        .fontWeight(500)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      // 1. 倒计时页 - 深蓝色渐变背景
      TabContent() {
        Stack() {
          TimerView({
            taskListMap: this.taskListMap,
            selectedTask: this.selectedTask
          })
        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.bg_gradient'))
        .backgroundImageSize(ImageSize.Cover)
      }
      .tabBar(this.tabBarBuilder('倒计时', 0, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      // 2. 任务管理页 - 浅灰色背景
      TabContent() {
        Stack() {
          TaskListView({
            taskListMap: this.taskListMap,
            onSwitchToTimer: this.switchToTimer.bind(this)
          })
        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.bg_gradient'))
        .backgroundImageSize(ImageSize.Cover)
      }
      .tabBar(this.tabBarBuilder('任务管理', 1, $r('app.media.ic_02_on'), $r('app.media.ic_02_off')))

      // 3. 成就页 - 浅灰色背景
      TabContent() {
        Stack() {
          DataCollection()
        }
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.bg_gradient'))
        .backgroundImageSize(ImageSize.Cover)
      }
      .tabBar(this.tabBarBuilder('成就', 2, $r('app.media.ic_03_on'), $r('app.media.ic_03_off')))

    }
    .scrollable(false)
    .vertical(false)
    .divider({
      strokeWidth: 0.5,
      color: '#0D182431'
    })
    .padding({ top: 36, bottom: 28 })
  }
}
