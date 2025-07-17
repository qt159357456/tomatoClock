//import { CJCalendar } from 'cjcalendar'
export class WeekClass{

}

@Component
export struct WeekDetailPage {
  @State message: string = 'Hello World2';
  @Consume('PathStack') PathStack: NavPathStack;
  @State WeekDetail: WeekClass | null = null;

 /* private getWeekStart(): Date {
    const today = new Date();
    const day = today.getDay();          // 0(Sun) … 6(Sat)
    const offset = today.getDate() - day; // 以周日为起点
    return new Date(today.setDate(offset));
  }
  private getWeekEnd(): Date {
    const startOfWeek = this.getWeekStart();
    const endOfWeek = new Date(startOfWeek.getTime() + 7 * 24 * 60 * 60 * 1000); // 加上6天
    return endOfWeek;
  }
*/
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
      /*CJCalendar({
        startDate: this.getWeekStart(),
        endDate: this.getWeekEnd()
      })*/
    }
    .hideTitleBar(true)
  }
}