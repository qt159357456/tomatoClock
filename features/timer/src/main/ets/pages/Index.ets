@Entry
@Component
export struct TimerView {
  @State taskName: string = "我是任务";
  @State inTime: number = 0.5;
  @State @Watch('updateProgress') currentTime: number = this.inTime * 60;  // 默认25分钟
  @State isRunning: boolean = false;
  @State beInterrupted: boolean = false;
  @State set:number = 0;
  //@State sliderValue: number = 25;  // 滑杆默认值（分钟）
  //@State showCustomTime: boolean = false;  // 控制自定义时间设置的显示
  private timerId: number = -1;
  private defaultTime: number = this.inTime * 60;  // 保存默认时间，用于重置
  @State progress: number = 0;

  updateset() {
    if(this.set < 1)
      this.set = 1 + this.set;
    else
      this.set = 0;
  }

  updateProgress() {
    this.progress = 1 - this.currentTime / this.defaultTime
  }

  aboutToDisappear() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
    }
  }

  startTimer() {
    if (this.timerId !== -1) {
      return;
    }
    this.isRunning = true;
    this.timerId = setInterval(() => {
      if (this.currentTime > 0) {
        this.currentTime--;
      } else {
        this.stopTimer();
      }
    }, 1000);
  }

  stopTimer() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    this.isRunning = false;
    this.beInterrupted = true;
    this.resetTimer();
  }

  resetTimer() {
    //this.stopTimer();
    this.currentTime = this.defaultTime;
  }

  // 更新默认时间
  updateDefaultTime(minutes: number) {
    this.defaultTime = minutes * 60;
    if (!this.isRunning) {
      this.currentTime = this.defaultTime;
    }
  }

  build() {
    Column() {
      Row() {
        Button(){
          Image($r('app.media.setting')) // 使用资源图片
            .width(24)
            .height(24)
        }
        .backgroundColor(Color.Transparent)
          .width(30)
          .height(30)
          .onClick(() => this.updateset())
      }
      .margin({ top: 0 })
      .width('100%')
      .justifyContent(FlexAlign.End)

      Text("目标任务")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })
        .fontColor("#F67280")

      Text(this.taskName)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 0, bottom: 80 })
        .fontColor("#F67280")

      // 番茄钟卡片
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

      // 操作按钮
      Row() {
        Button(this.isRunning ? '提前结束' : '开始', { type: ButtonType.Capsule })
          .backgroundColor(this.isRunning ? '#F67280' : '#34BFA3')
          .fontColor(Color.White)
          .width(120)
          .height(40)
          .onClick(this.isRunning ? () => this.stopTimer(): () => this.startTimer())


        /*Button('重置', { type: ButtonType.Capsule })
          .backgroundColor('#F0F0F0')
          .fontColor('#333')
          .width(120)
          .height(40)
          .onClick(() => this.resetTimer())*/
      }
      .margin({ top: 60 })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#F5F7FA')
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
  /*build() {
    Column() {
      Text("目标任务")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 0, bottom: 0 })
        .fontColor("#F67280")

      Text(this.taskName)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 0, bottom: 30 })
        .fontColor("#F67280")

      Stack() {
        // 卡片背景
        Column() {
          // 留空给进度条
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius(20)
        .padding(20)
        .shadow({
          radius: 10,
          color: Color.Gray,
          offsetX: 0,
          offsetY: 5
        })

        // 进度条
        /*Progress({
          value: 100*this.progressValue,
          style: ProgressStyle.Ring
        })
          .width(200)
          .height(200)
          .color(`rgb(${this.progressValue*255}%,${(1-this.progressValue)*255}%,0)`)

        // 倒计时显示

          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor("#333")
          .margin({ top: 20 })
      }
      Row() {
        Button(this.isRunning ? '暂停' : '开始')
          .width(120)
          .height(48)
          .fontSize(18)
          .backgroundColor(this.isRunning ? '#FF4081' : '#4CAF50')
          .margin({ right: 16 })
          .onClick(() => {
            if (this.isRunning) {
              this.stopTimer();
            } else {
              this.startTimer();
            }
          })

        Button('重置')
          .width(120)
          .height(48)
          .fontSize(18)
          .backgroundColor('#607D8B')
          .onClick(() => {
            this.resetTimer();
          })
      }
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#F5F7FA')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)


        // 添加时间设置选择器
        /*Row() {
          Column() {
            Text('25分钟')
              .fontSize(14)
              .fontColor(Color.White)
          }
          .width(80)
          .height(36)
          .backgroundColor(this.defaultTime === 25 * 60 ? '#4CAF50' : 'rgba(255, 255, 255, 0.2)')
          .borderRadius(18)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12 })
          .onClick(() => {
            this.showCustomTime = false;
            this.updateDefaultTime(25);
          })

          Column() {
            Text('45分钟')
              .fontSize(14)
              .fontColor(Color.White)
          }
          .width(80)
          .height(36)
          .backgroundColor(this.defaultTime === 45 * 60 ? '#4CAF50' : 'rgba(255, 255, 255, 0.2)')
          .borderRadius(18)
          .justifyContent(FlexAlign.Center)
          .margin({ right: 12 })
          .onClick(() => {
            this.showCustomTime = false;
            this.updateDefaultTime(45);
          })

          Column() {
            Text('自定义')
              .fontSize(14)
              .fontColor(Color.White)
          }
          .width(80)
          .height(36)
          .backgroundColor(this.showCustomTime ? '#4CAF50' : 'rgba(255, 255, 255, 0.2)')
          .borderRadius(18)
          .justifyContent(FlexAlign.Center)
          .onClick(() => {
            this.showCustomTime = !this.showCustomTime;
            if (this.showCustomTime) {
              this.sliderValue = Math.floor(this.defaultTime / 60);
            }
          })
        }
        .margin({ top: 30 })
        .justifyContent(FlexAlign.Center)*/

        // 自定义时间滑杆
        /*if (this.showCustomTime) {
          Column() {
            Text(`${this.sliderValue}分钟`)
              .fontSize(16)
              .fontColor(Color.White)
              .margin({ top: 20, bottom: 10 })

            Slider({
              value: this.sliderValue,
              min: this.minTime,
              max: this.maxTime,
              step: 1,
              style: SliderStyle.OutSet
            })
              .width('90%')
              .trackThickness(6)
              .showSteps(true)
              .showTips(true)
              .selectedColor('#4CAF50')
              .backgroundColor('rgba(255, 255, 255, 0.3)')
              .onChange((value: number) => {
                this.sliderValue = value;
              })

            Button('确定')
              .width(100)
              .height(36)
              .fontSize(14)
              .backgroundColor('#4CAF50')
              .margin({ top: 20 })
              .onClick(() => {
                this.updateDefaultTime(this.sliderValue);
                this.showCustomTime = false;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor('rgba(0, 0, 0, 0.2)')
          .borderRadius(8)
          .margin({ top: 20 })
        }
      }
      .width('100%')
      .height('100%')
      .padding(20)
    .width('100%')
    .height('100%')
  }*/

}