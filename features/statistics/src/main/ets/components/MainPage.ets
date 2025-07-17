import {DataColumnView} from './addup'
import {WeekColumnView} from  './weekmonth'
import {DataDetailPage,DataClass} from './page/datadetailpage'
import {WeekDetailPage,WeekClass} from './page/weekdetailpage'
import {MonthDetailPage,MonthClass} from './page/monthdetailpage'
interface ThemeColors {
  primary: string;
  secondary: string;
  background: string;
  cardBg: string;
  textPrimary: string;
  textSecondary: string;
}
@Preview
@Component
export struct DataCollection{
  @State totalPomodoros: number = 0;
  @State todayPomodoros: number = 0;
  @State totalTime: number = 0;
  @State todayTime: number = 0;
  @State message: string = '统计数据';
  @Provide('PathStack') PathStack: NavPathStack = new NavPathStack();

  @Builder
  quickStartRouter(name: string, param?: DataClass | WeekClass | MonthClass) {
    if (name === 'DayDetail') {
      DataDetailPage()
    }else if (name === 'WeekDetail') {
      WeekDetailPage()
    }else if (name === 'MonthDetail') {
      MonthDetailPage()
    }
  }

  readonly themeColors: ThemeColors = {
    primary: '#FF6B6B', // 番茄红
    secondary: '#4ECDC4', // 清新青
    background: '#F7F7F7', // 浅灰背景
    cardBg: '#FFFFFF', // 卡片背景
    textPrimary: '#2D3436', // 主要文字
    textSecondary: '#636E72'// 次要文字
  }

  build() {
    Navigation(this.PathStack) {
      Column() {
        Text(this.message)
          .fontSize(24)
          .fontWeight(700)
          .width('100%')
          .textAlign(TextAlign.Start)
          .padding({ top: 16, left: 16, bottom: 16 })
          .fontFamily('HarmonyHeiTi-Bold')
          .lineHeight(33)

        DataColumnView()
        WeekColumnView()

      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
    }
    .navDestination(this.quickStartRouter)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}
