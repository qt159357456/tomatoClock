export class  TaskNumber{
  id: string = '';
  title: string = '';
  value:string = '';

  constructor(id: string,title: string,value: string) {
    this.id = id;
    this.title = title;
    this.value = value;
  }
}
@Component
export struct TaskItem{
  @Prop TaskItem: TaskNumber

  build(){
    Column(){
      Text(this.TaskItem.title)
        .height(19)
        .width('100%')
        .fontSize(14)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(400)
        .padding({ left: 12, right: 12 })
        .margin({ top: 8 })
      Text(this.TaskItem.value)
        .height(32)
        .width('100%')
        .fontSize(10)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .fontWeight(400)
        .fontColor('rgba(0, 0, 0, 0.6)')
        .padding({ left: 12, right: 12 })
    }
    .width('90%')
    .borderRadius(20)
    .backgroundColor('#F1F3F5')
  }
}

@Preview
@Component
export struct TaskColumnView {
  @State TaskList: Array<TaskNumber> = [
    new TaskNumber('1', '完成学习笔记','1小时'),
    new TaskNumber('2', '完成课后作业','1.5小时'),
    new TaskNumber('3', '完成课堂笔记','2小时'),
  ]
  build() {
    Column() {
      Text('日程安排')
        .fontColor('#182431')
        .fontSize(20)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16, right: 16,bottom:8 })
        .margin({ bottom: 8.5 })
        .width('100%')
      List({space: 4}) {
        ForEach(this.TaskList, (item: TaskNumber) => {
          ListItem() {
            TaskItem({ TaskItem: item })
          }
        }, (item: TaskNumber) => item.id)
      }
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })
    }
    .padding(16)
    .margin({ top: 18 })
  }
}