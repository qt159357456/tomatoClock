export class  DataNumber{
  id: string = '';
  title: string = '';
  value: string = '';

  constructor(id: string,title: string, value: string) {
    this.id = id;
    this.title = title;
    this.value = value;
  }
}

@Component
export struct DataItem{
  @Prop dataItem: DataNumber

  build(){
    Column(){
    Text(this.dataItem.title)
      .height(19)
      .width('100%')
      .fontSize(14)
      .textAlign(TextAlign.Start)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .fontWeight(400)
      .padding({ left: 12, right: 12 })
      .margin({ top: 8 })
    Text(this.dataItem.value)
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

@Preview
@Component
export struct DataColumnView {
  @State Datalist: Array<DataNumber> = [
    new DataNumber('1', '次数', '0',),
    new DataNumber('2', '时长(分钟)', '0',),
  ]
  build() {
      Column() {
        Text('今日专注' + '  ' + new Date().toISOString().split('T')[0])
          .fontColor('#182431')
          .fontSize(16)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-medium')
          .textAlign(TextAlign.Start)
          .padding({ left: 16, right: 16 })
          .margin({ bottom: 8.5 })
        Grid() {
          ForEach(this.Datalist, (item: DataNumber) => {
            GridItem() {
              DataItem({ dataItem: item })
            }
          }, (item: DataNumber) => item.id)
        }
        .columnsTemplate('3fr 3fr')
        .columnsGap(8)
        .scrollBar(BarState.Off)
        .height('80')
        .padding({ top: 2, left: 16, right: 16,bottom:2 })
      }
      .height('80')
      .width('100%')
      .alignItems(HorizontalAlign.Start)
  }
}


