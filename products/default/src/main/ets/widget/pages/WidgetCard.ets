@Entry
@Component
struct WidgetCard {
  @StorageLink('progress') progress: number = 0;
  @StorageLink('currentTime') currentTime: number = 0;
  @StorageLink('set') set: number = 0;
  @StorageLink('taskName') taskName: string = '倒计时';
  build() {
    Stack() {
      // 卡片背景
      Image($r(`app.media.f${this.set}${Math.floor(this.progress*3)}`)) // 使用资源图片
        .width(`${60+Math.floor(this.progress*3)*2}%`)
        .height(`${60+Math.floor(this.progress*3)*2}%`)
        .objectFit(ImageFit.Cover)

      Column() {
        // 留空给进度条
      }
      .width('100%')
      .height('100%')
      .borderRadius(20)
      .padding(20)
      .shadow({ radius: 10, color: Color.Gray, offsetX: 0, offsetY: 5 })

      // 进度条
      Progress({
        value: 100*this.progress,
        style: ProgressStyle.Ring
      })
        .width(200)
        .height(200)
        .color(`rgb(${Math.floor(this.progress*255)},${Math.floor((1 - this.progress)*255)},0)`)

      // 倒计时显示
      Text(`${Math.floor(this.currentTime / 60)}:${(this.currentTime % 60).toString().padStart(2, '0')}`)
        .fontSize(36)
        .fontWeight(FontWeight.Bold)
        .fontColor("white")
        .margin({ top: 20 })
        .textShadow({
          radius: 5,     // 模糊半径
          color: "black",       // 阴影颜色
        })

    }
    .width('80%')
    .height(300)
    .margin({ bottom: 30 })
}