@Preview
@Component
export struct AddTaskView {
  @State title: string = '';
  @State remainingTime: string = '';

  // 按钮点击事件处理函数
  private handleConfirm() {
    // 实际应用中这里会处理确认逻辑
    console.log(`创建任务：${this.title}，预计时间：${this.remainingTime}分钟`);
    // 可以添加关闭弹窗或导航回退的逻辑
  }

  private handleCancel() {
    // 实际应用中这里会处理取消逻辑
    console.log('用户取消创建任务');
    // 可以添加关闭弹窗或导航回退的逻辑
  }

  build() {
    Column() {

      // 任务名称输入区域
      Column() {
        Text('待办事项')
          .fontSize(16)
          .fontColor('#666')
          .width('100%')

        TextInput({ text: this.title, placeholder: '输入任务名称' })
          .placeholderColor(Color.Gray)
          .caretColor(Color.Blue)
          .width('100%')
          .height(50)
          .padding(10)
          .fontSize(16)
          .border({ width: 1, color: '#ddd', radius: 8 })
          .margin({ top: 5 })
          .onChange((value: string) => {
            this.title = value;
          })
      }
      .width('100%')
      .margin({ bottom: 20 })

      // 任务时间输入区域
      Column() {
        Text('预计时间（分钟）')
          .fontSize(16)
          .fontColor('#666')
          .width('100%')

        TextInput({ text: this.remainingTime, placeholder: '输入分钟数' })
          .type(InputType.Number) // 限制只能输入数字
          .placeholderColor(Color.Gray)
          .caretColor(Color.Blue)
          .width('100%')
          .height(50)
          .padding(10)
          .fontSize(16)
          .border({ width: 1, color: '#ddd', radius: 8 })
          .margin({ top: 5 })
          .onChange((value: string) => {
            // 验证输入为数字
            if (/^\d*$/.test(value)) {
              this.remainingTime = value;
            }
          })
      }
      .width('100%')
      .margin({ bottom: 30 })

      // 按钮行
      Row() {
        // 取消按钮
        Button('取消', { type: ButtonType.Normal })
          .layoutWeight(1) // 等分空间
          .height(45)
          .fontSize(16)
          .fontColor('#606266')
          .backgroundColor('#f0f0f0')
          .borderRadius(8)
          .onClick(() => this.handleCancel())

        // 按钮间距
        Blank()
          .width(16)

        // 确认按钮
        Button('确认', { type: ButtonType.Capsule })
          .layoutWeight(1) // 等分空间
          .height(45)
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#00ffcc')
          .opacity(this.title.trim() ? 1 : 0.6) // 无内容时降低不透明度
          .enabled(!!this.title.trim()) // 无内容时禁用
          .onClick(() => this.handleConfirm())
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10 })
    }
    .padding(24)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .width('90%')
  }
}