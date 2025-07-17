@Entry
@Component
struct HitTestBehaviorExample {
  build() {
    // outer stack
    Stack() {
      Button('outer button')
        .onTouch((event) => {
        console.info('outer button touched type: ' + (event as TouchEvent).type)
      })
      // inner stack
      Stack() {
        Button('inner button')
          .onTouch((event) => {
          console.info('inner button touched type: ' + (event as TouchEvent).type)
        })
      }
      .width("100%").height("100%")
      .hitTestBehavior(HitTestMode.Block)
      .onTouch((event) => {
        console.info('stack touched type: ' + (event as TouchEvent).type)
      })
      Text('Transparent')
        .hitTestBehavior(HitTestMode.Transparent)
        .width("100%").height("100%")
        .onTouch((event) => {
        console.info('text touched type: ' + (event as TouchEvent).type)
      })
    }.width(300).height(300)
  }
}