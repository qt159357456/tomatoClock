export class DayWeekMonth{
  id: string = '';
  title: string = '';
  value: string = '';
  route: string = ' ';

  constructor(id: string,title: string, value: string,route: string) {
    this.id = id;
    this.title = title;
    this.value = value;
    this.route = route
  }
}

@Component
export struct DataItem{
  @Prop dayweekmonth: DayWeekMonth

  build(){
    Column(){
      Text(this.dayweekmonth.title)
        .height(19)
        .width('100%')
        .fontSize(14)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(400)
        .padding({ left: 12, right: 12 })
        .margin({ top: 8 })
      Text(this.dayweekmonth.value)
        .height(32)
        .width('100%')
        .fontSize(20)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .fontWeight(400)
        .fontColor('rgba(0, 0, 0, 0.6)')
        .padding({ left: 12, right: 12 })
        .margin({ top: 2 })
    }
    .width('100%')
    .height(169)
    .borderRadius(20)
    .backgroundColor(Color.White)
  }
}

@Component
export struct WeekColumnView{
  @State Datalist: Array<DayWeekMonth> = [
    new DayWeekMonth('1', '当日', 'Day','DayDetail'),
    new DayWeekMonth('2', '当周', 'Week','WeekDetail'),
    new DayWeekMonth('3', '当月', 'Month','MonthDetail'),
  ]
  @Consume('PathStack') PathStack: NavPathStack;

  build() {
    Column() {
      Text('日程规划')
        .fontColor('#182431')
        .fontSize(16)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16, right: 16 })
        .margin({ top:36,bottom: 6 })
      Grid() {
        ForEach(this.Datalist, (item: DayWeekMonth) => {
          GridItem() {
            DataItem({ dayweekmonth: item })
              .onClick(() => {
                if (item.route) {
                  this.PathStack.pushPathByName(item.route,item);
                }
              })
          }
        }, (item: DayWeekMonth) => item.id)
      }
      .columnsTemplate('3fr 3fr 3fr')
      .columnsGap(8)
      .scrollBar(BarState.Off)
      .height('80')
      .padding({ top: 8, left: 16, right: 16,bottom:8 })
      .borderRadius(16)
    }
    .height('80')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

