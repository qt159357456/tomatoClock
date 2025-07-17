import { weekCalendar } from './calendar'
import {TaskColumnView} from './sim_task'
export class WeekClass{

}

@Component
export struct WeekDetailPage {
  @State message: string = 'Hello World2';
  @Consume('PathStack') PathStack: NavPathStack;
  @State WeekDetail: WeekClass | null = null;

  aboutToAppear(): void {
    this.WeekDetail = this.PathStack.getParamByName('MonthDetail')[0] as WeekClass;
  }
  build() {
    NavDestination() {
      Row(){
        Row(){
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
        }
        .width('80%')
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
      .height(56)
      .margin({left:36,top:16})
      .onClick(() => {
      this.PathStack.pop()
    })
      weekCalendar()
      TaskColumnView()
    }
    .hideTitleBar(true)
  }
}