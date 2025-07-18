import { TaskItem } from  '../view/TaskItem'
import { TaskModel, TaskListMap } from "../model/TaskModel";
@CustomDialog
@Component
export struct DeleteView{
  @Prop taskId:string = '';
  @Prop dateKey:string = '';

  controller:CustomDialogController
  onCancel: () => void = ()=>{};
  onConfirm: (id: string, dateKey: string) => void = ()=>{};
  build() {
    Column(){
      Text('是否删除该任务')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({top:15, bottom : 25})
      Row() {
        Button('取消', { type: ButtonType.Normal })
          .layoutWeight(0.6)
          .height(45)
          .fontSize(16)
          .fontColor('#606266')
          .backgroundColor('#f0f0f0')
          .margin({left:15, bottom:5})
          .borderRadius(8)
          .onClick(() => this.onCancel?.())

        // 按钮间距
        Blank()
          .width(16)

        // 确认按钮
        Button('确认', { type: ButtonType.Capsule })
          .layoutWeight(0.6) // 等分空间
          .height(45)
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#FF6B6B')
          .margin({right:15, bottom:5})
          .onClick(() => {
                 this.onConfirm(this.taskId,this.dateKey)
          })
      }

      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
       .borderRadius(10)
    }
  }
