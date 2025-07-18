import { TaskListMap, TaskModel } from 'task';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
export struct TimerView {
  @Link taskListMap: TaskListMap;
  @Link @Watch('onSelectedTaskChanged') selectedTask: TaskModel | null;

  // 添加状态变量来跟踪前一个任务
  @State previousTask: TaskModel | null = null;

  @State taskName: string = "倒计时";
  @State inTime: number = 0.5;
  @State currentTime: number = this.inTime * 60;
  @State isRunning: boolean = false;
  @State set: number = 0;
  @State progress: number = 0;

  private timerId: number = -1;
  private defaultTime: number = 25 * 60; // 默认25分钟

  // 当任务变化时调用
  onSelectedTaskChanged() {
    // 保存前一个任务的进度
    if (this.previousTask !== this.selectedTask) {
      if (this.previousTask) {
        this.previousTask.remainingTime = this.currentTime;
        console.log(`保存前一个任务进度: ${this.previousTask.title} = ${this.currentTime}秒`);

        // 更新 taskListMap 中的前一个任务
        this.updateTaskInMap(this.previousTask);
      }

      // 初始化新任务的计时器
      this.initializeTimer();

      // 更新前一个任务为当前任务
      this.previousTask = this.selectedTask;
    }
  }

  // 更新任务在 taskListMap 中的状态
  updateTaskInMap(updatedTask: TaskModel) {

    // 查找任务所在的日期键
    const dateKey = updatedTask.dateKey;
    if (this.taskListMap[dateKey]) {
      // 查找任务在数组中的位置
      const taskIndex = this.taskListMap[dateKey].findIndex(t => t.id === updatedTask.id);
      if (taskIndex !== -1) {
        // 更新任务
        const newList = [...this.taskListMap[dateKey]];
        newList[taskIndex] = new TaskModel( // 创建新任务实例
          updatedTask.id,
          updatedTask.title,
          updatedTask.defaultTime,
          updatedTask.completed,
          updatedTask.completedTime,
          updatedTask.dateKey,
          updatedTask.remainingTime // 确保更新剩余时间
        );
        this.taskListMap[dateKey] = newList;
        console.log(`更新 taskListMap 中的任务: ${updatedTask.title}`);
      }
    }
  }

  // 初始化计时器
  initializeTimer() {
    this.stopTimer();

    if (this.selectedTask) {
      // 使用新任务的剩余时间
      this.defaultTime = this.selectedTask.remainingTime;
      this.currentTime = this.selectedTask.remainingTime;
      this.taskName = this.selectedTask.title;
      console.log(`初始化新任务: ${this.taskName} = ${this.currentTime}秒`);
    } else {
      // 没有选中任务时使用默认值
      this.currentTime = this.defaultTime;
      this.taskName = "倒计时";
      console.log(`初始化默认计时器: ${this.currentTime}秒`);
    }

    this.updateProgress();
    this.isRunning = false;
  }

  // 更新进度
  updateProgress() {
    if (this.defaultTime > 0) {
      this.progress = 1 - this.currentTime / this.defaultTime;
    } else {
      this.progress = 0;
    }
  }

  aboutToAppear() {
    // 初始化前一个任务
    this.previousTask = this.selectedTask;
    this.initializeTimer();
  }

  aboutToDisappear() {
    this.stopTimer();

    // 离开页面时保存当前任务进度
    if (this.selectedTask) {
      this.selectedTask.remainingTime = this.currentTime;
      console.log(`离开页面时保存任务: ${this.selectedTask.title} = ${this.currentTime}秒`);

      // 更新 taskListMap
      this.updateTaskInMap(this.selectedTask);
    }
  }

  updateset() {
    this.set = (this.set + 1) % 2;
  }

  // 开始计时
  startTimer() {
    if (this.timerId !== -1 || this.currentTime <= 0) return;

    this.isRunning = true;

    this.timerId = setInterval(() => {
      if (this.currentTime > 0) {
        this.currentTime--;
        this.updateProgress();

        // 更新当前任务的剩余时间
        // if (this.selectedTask) {
        //   this.selectedTask.remainingTime = this.currentTime;
        //
        //   // 每秒更新 taskListMap（实际项目中可能需要优化频率）
        //   this.updateTaskInMap(this.selectedTask);
        // }
      } else {
        // 计时完成
        this.stopTimer();
        console.log("计时完成");
      }
    }, 1000);
  }

  // 停止计时
  stopTimer() {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
    this.isRunning = false;
    if (this.previousTask && this.previousTask === this.selectedTask)
      this.selectedTask.remainingTime = this.currentTime;
    // 更新 taskListMap
    if (this.selectedTask) {
      this.updateTaskInMap(this.selectedTask);
    }
  }

  // 重置计时器
  resetTimer() {
    this.stopTimer();

    if (this.selectedTask) {
      // 重置为原始时间
      this.selectedTask.resetTask();
      this.defaultTime = this.selectedTask.defaultTime
      this.currentTime = this.selectedTask.defaultTime;
      console.log(`重置任务: ${this.selectedTask.title} = ${this.defaultTime}秒`);

      // 更新 taskListMap
      this.updateTaskInMap(this.selectedTask);
    } else {
      this.currentTime = this.defaultTime;
      console.log(`重置计时器: ${this.defaultTime}秒`);
    }

    this.updateProgress();
  }

  build() {
    Column() {
      // 设置按钮
      Row() {
        Button() {
          Image($r('app.media.setting'))
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

      // 任务标题
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
        Button(this.isRunning ? '暂停' : '开始', { type: ButtonType.Capsule })
          .backgroundColor(this.isRunning ? '#F67280' : '#34BFA3')
          .fontColor(Color.White)
          .width(120)
          .height(40)
          .onClick(() => {
            if (this.isRunning) {
              this.stopTimer();
            } else {
              this.startTimer();
            }
          })

        Button('重置', { type: ButtonType.Capsule })
          .backgroundColor('#F0F0F0')
          .fontColor('#333')
          .width(120)
          .height(40)
          .margin({ left: 20 })
          .onClick(() => this.resetTimer())
      }
      .margin({ top: 60 })
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}