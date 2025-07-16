import {Timer} from 'clock'
import {TaskListView} from 'task'
import {DataCollection} from 'statistics'

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  private tabsController : TabsController = new TabsController();
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
    Tabs({barPosition: BarPosition.End, controller: this.tabsController}){
      TabContent() {
        Timer()
      }
      .tabBar(this.tabBarBuilder('番茄闹钟', 0, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      TabContent() {
        TaskListView()
      }
      .tabBar(this.tabBarBuilder('任务列表', 1, $r('app.media.ic_02_on'), $r('app.media.ic_02_off')))

      TabContent() {
        DataCollection()
      }
      .tabBar(this.tabBarBuilder('数据统计', 2, $r('app.media.ic_03_on'), $r('app.media.ic_03_off')))
    }
    .scrollable(false)
    .vertical(false)
    .divider({
      strokeWidth: 0.5,
      color: '#0D182431'
    })
    .backgroundColor('#F1F3F5')
    .padding({ top: 36, bottom: 28 })
  }
}
