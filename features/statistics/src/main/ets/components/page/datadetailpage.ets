
export class DataClass{

}

@Component
export struct DataDetailPage {
  @State message: string = 'Hello World1';
  @Consume('PathStack') PathStack: NavPathStack;
  @State DayDetail: DataClass | null = null;

  aboutToAppear(): void {
    this.DayDetail = this.PathStack.getParamByName('DayDetail')[0] as DataClass;
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
      RelativeContainer() {
        Text(this.message)
          .id('HelloWorld')
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            this.message = 'Welcome';
          })
      }
      .height('100%')
      .width('100%')
    }
    .hideTitleBar(true)
  }
}