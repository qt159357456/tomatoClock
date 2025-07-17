import { monthCalendar } from './calendar'
import {CJCalendar} from 'cjcalendar'
import {TaskColumnView} from './sim_task'
export class MonthClass{

}

@Component
export struct MonthDetailPage {
  @State message: string = 'Hello World3';
  @Consume('PathStack') PathStack: NavPathStack;
  @State MonthDetail: MonthClass | null = null;

  aboutToAppear(): void {
    this.MonthDetail = this.PathStack.getParamByName('MonthDetail')[0] as MonthClass;
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
      monthCalendar()
    }
    .hideTitleBar(true)
  }
}