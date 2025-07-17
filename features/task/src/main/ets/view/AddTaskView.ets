
@Preview
@CustomDialog
@Component
export struct AddTaskView {
  controller:CustomDialogController
  onCancel: () => void = ()=>{};
  onConfirm: (title: string, minutes: number) => void = ()=>{};

  @State title: string = '';
  @State minutes: string = '25'; // 默认番茄钟时长

  build() {
    Column() {
      Text('添加新任务')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FF6B6B')
        .margin({ bottom: 30 })

      // 输入区域
      Column() {
        Text('任务名称')
          .fontSize(18)
          .fontColor('#666666')
          .margin({ bottom: 8, left: 8 })

        TextInput({ placeholder: '输入任务内容' })
          .width('100%')
          .height(56)
          .padding(12)
          .fontSize(18)
          .backgroundColor('#FFF8F8')
          .borderRadius(12)
          .onChange(value => this.title = value)
      }
      .margin({ bottom: 24 })

      Column() {
        Text('预计时长（分钟）')
          .fontSize(18)
          .fontColor('#666666')
          .margin({ bottom: 8, left: 8 })

        TextInput({ text: this.minutes })
          .type(InputType.Number)
          .width('100%')
          .height(56)
          .padding(12)
          .fontSize(18)
          .backgroundColor('#FFF8F8')
          .borderRadius(12)
          .onChange(value => this.minutes = value)
      }
      .margin({ bottom: 40 })

      // 按钮组
      Row() {
        Button('取消', { type: ButtonType.Normal })
          .layoutWeight(1) // 等分空间
          .height(45)
          .fontSize(16)
          .fontColor('#606266')
          .backgroundColor('#f0f0f0')
          .borderRadius(8)
          .onClick(() => this.onCancel?.())

        // 按钮间距
        Blank()
          .width(16)

        // 确认按钮
        Button('确认', { type: ButtonType.Capsule })
          .layoutWeight(1) // 等分空间
          .height(45)
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#FF6B6B')
          .opacity(this.title.trim() ? 1 : 0.6) // 无内容时降低不透明度
          .enabled(!!this.title.trim()) // 无内容时禁用
          .onClick(() => {
            const minutesValue = parseInt(this.minutes) || 25;
            this.onConfirm?.(this.title, minutesValue);
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('80%')
    .padding(30)
    .backgroundColor(Color.White)
    .borderRadius(24)
    .shadow({ radius: 24, color: '#00000030' })
  }
}