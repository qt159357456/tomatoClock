import { HmCalendar, HmCalendarController, HmCalendarType } from '@ohmos/calendar';
import dayjs from 'dayjs';
import {TaskColumnView} from './sim_task'
@Component
export struct weekCalendar {
  private calendarController: HmCalendarController = new HmCalendarController();

  build() {
    Column({ space: 16 }) {
      Row(){
        Text('当周日程')
          .fontColor('#182431')
          .fontSize(20)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-medium')
          .textAlign(TextAlign.Start)
          .padding({ left: 16, right: 16 })
          .width('60%')
        Button('上周').onClick(() => {
          this.calendarController.prevMonth();
        })
          .backgroundColor('#ffffffff')
          .fontColor('#182431')
          .fontSize(16)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-medium')
          .padding({ left: 16, right: 16 })
          .fontWeight(500)
        Button('下周').onClick(() => {
          this.calendarController.nextMonth();
        })
          .backgroundColor('#ffffffff')
          .fontColor('#182431')
          .fontSize(16)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-medium')
          .padding({ left: 16, right: 36 })
          .fontWeight(500)
      }
      HmCalendar({
        type: HmCalendarType.WEEK, // 设置为单周日历类型
        color: '#ff0060aa', // 设置选中颜色为
        selectedDays: [
          { date: dayjs().format('YYYY-MM-DD'), text: ' ' } // 默认选中当前日期，设置选中文字为空
        ],
        controller: this.calendarController,
        onClickDate: (date) => {
          console.log('点击的日期是：', date);
        }
      })
        .borderRadius(8) // 设置边框圆角为8
        .border({ width: 0.5, color: '#ededed' }) // 设置边框宽度为0.5，颜色为#ededed
        .shadow({ color: '#ededed', radius: 16 }) // 设置阴影颜色为#ededed，半径为16
    }
    .padding(16)
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

@Component
export struct monthCalendar {
  build() {
    Scroll() {
      Column({ space: 16 }) {
        Text('当月日程')
          .fontColor('#182431')
          .fontSize(20)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-medium')
          .textAlign(TextAlign.Start)
          .padding({ left: 16, right: 16, bottom: 8 })
          .margin({ bottom: 8.5 })
          .width('100%')
        HmCalendar({
          color: '#ff0060aa', // 设置选中颜色为绿色
          selectedDays: [
            { date: dayjs().format('YYYY-MM-DD'), text: ' ' }// 默认选中当前日期，设置选中文字为空
          ],
        })
          .borderRadius(8) // 设置边框圆角为8
          .border({ width: 0.5, color: '#ededed' }) // 设置边框宽度为0.5，颜色为#ededed
          .shadow({ color: '#ededed', radius: 16 }) // 设置阴影颜色为#ededed，半径为16
        TaskColumnView()
      }
      .width('100%')
      .padding(16)
      .alignItems(HorizontalAlign.Start)
      .margin({bottom:100})
    }
    .height('100%')
  }

}
