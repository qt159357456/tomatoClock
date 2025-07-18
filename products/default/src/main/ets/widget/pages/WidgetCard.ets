import { formBindingData, FormExtensionAbility } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';

@Entry
@Component
struct WidgetCard {
  @LocalStorageProp('title') title: string = '默认任务';
  @LocalStorageProp('currentTime') currentTime: number = 0; // 以秒为单位的时间

  build() {
    Column() {
      // 任务名称
      Text(this.title)
        .fontSize(16)
        .fontColor("#F67280")
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ bottom: 8 })

      // 倒计时时间
      Text(`${Math.floor(this.currentTime / 60)}:${(this.currentTime % 60).toString().padStart(2, '0')}`)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor("#333")
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
