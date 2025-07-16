import {DataColumnView} from './addup'
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


  readonly themeColors: ThemeColors = {
    primary: '#FF6B6B', // 番茄红
    secondary: '#4ECDC4', // 清新青
    background: '#F7F7F7', // 浅灰背景
    cardBg: '#FFFFFF', // 卡片背景
    textPrimary: '#2D3436', // 主要文字
    textSecondary: '#636E72'// 次要文字
  }

  build() {
    Column(){
      Text(this.message)
        .fontSize(24)
        .fontWeight(700)
        .width('100%')
        .textAlign(TextAlign.Start)
        .padding({ top:16,left: 16,bottom: 16 })
        .fontFamily('HarmonyHeiTi-Bold')
        .lineHeight(33)

      DataColumnView()

      /*Row() {
        Text(`今日完成：${this.todayPomodoros} 🍅`)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.primary)
          .height('36vp')

        Blank()

        Text(`专注时长：${this.todayTime} minuts`)
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor(this.themeColors.primary)
          .height('46vp')
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 12
      })
      .backgroundColor(this.themeColors.cardBg)
      .borderRadius(16)
      .margin({ top: 16 })
      .height('100vp')
      */

    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F1F3F5')
  }

}