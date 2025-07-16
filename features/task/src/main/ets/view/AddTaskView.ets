@Preview
@Component
export struct AddTaskView {
  @State title: string = '';
  @State remainingTime: string = '';

  // 确认添加任务
  private handleConfirm() {
    if (!this.title.trim()) return;

    const minutes = parseInt(this.remainingTime) || 25;
    // 实际添加到任务列表的逻辑
    console.log(`添加任务: ${this.title}, ${minutes}分钟`);
  }

  // 取消添加
  private handleCancel() {
    // 返回任务列表视图
    console.log('取消添加任务');
  }

  build() {
    Column() {
      // 任务名称输入
      Column() {
        Text('待办事项')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextInput({ text: this.title, placeholder: '输入任务名称' })
          .placeholderColor('#BBBBBB')
          .caretColor('#FF6B6B')
          .width('100%')
          .height(56)
          .padding(12)
          .fontSize(18)
          .border({ width: 1, color: '#EEEEEE', radius: 12 })
          .onChange((value) => this.title = value)
      }
      .margin({ bottom: 24 })

      // 预计时间输入
      Column() {
        Text('预计时间（分钟）')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextInput({
          text: this.remainingTime,
          placeholder: '输入分钟数'
        })
          .type(InputType.Number)
          .placeholderColor('#BBBBBB')
          .caretColor('#FF6B6B')
          .width('100%')
          .height(56)
          .padding(12)
          .fontSize(18)
          .border({ width: 1, color: '#EEEEEE', radius: 12 })
          .onChange((value) => {
            if (/^\d*$/.test(value)) this.remainingTime = value;
          })
      }
      .margin({ bottom: 36 })

      // 操作按钮
      Row() {
        // 取消按钮
        Button('取消', { type: ButtonType.Normal })
          .backgroundColor('#F0F0F0')
          .fontColor('#666666')
          .fontSize(16)
          .height(50)
          .layoutWeight(1)
          .onClick(() => this.handleCancel())

        Blank().width(20)

        // 确认按钮
        Button('确认', { type: ButtonType.Capsule })
          .backgroundColor('#FF6B6B')
          .fontColor(Color.White)
          .fontSize(16)
          .height(50)
          .layoutWeight(2)
          .opacity(this.title.trim() ? 1 : 0.6)
          .enabled(!!this.title.trim())
          .onClick(() => this.handleConfirm())
      }
    }
    .padding(32)
    .backgroundColor(Color.White)
    .borderRadius(20)
    .width('90%')
    .shadow({ radius: 16, color: '#00000020', offsetX: 0, offsetY: 4 })
  }
}