import { BannerClass } from '../model/BannerClass';
import { bufferToString } from '../util/BufferUtil';
@Component
export struct Banner{
  // @State bannerList: Array<BannerClass> = [
  //   new BannerClass('pic0',$r('app.media.banner_pic0'),
  //     'https://developer.huawei.com/consumer/cn/training/course/video/C101718352529709527'),
  //   new BannerClass('pic1', $r('app.media.banner_pic1'),
  //     'https://developer.huawei.com/consumer/cn/'),
  //   new BannerClass('pic2', $r('app.media.banner_pic2'),
  //     'https://developer.huawei.com/consumer/cn/deveco-studio/'),
  //   new BannerClass('pic3', $r('app.media.banner_pic3'),
  //     'https://developer.huawei.com/consumer/cn/arkts/'),
  //   new BannerClass('pic4', $r('app.media.banner_pic4'),
  //     'https://developer.huawei.com/consumer/cn/arkui/'),
  //   new BannerClass('pic5', $r('app.media.banner_pic5'),
  //     'https://developer.huawei.com/consumer/cn/sdk')
  // ]
  @State bannerList: BannerClass[] = [];
  @Consume('articlePathStack') articlePathStack: NavPathStack;


  //回调函数，创建新实例后，在build之前执行,所以在这里获取数据
  aboutToAppear(): void {
    this.getBannerDataFromJson();
  }

  getBannerDataFromJson(){
    this.getUIContext().getHostContext()?.resourceManager.getRawFileContent('BannerData.json').then(value=>{
      // 获取buffer内容并转换为字符串
      let res: string = bufferToString(value);
      // 解析为数据结构
      this.bannerList = JSON.parse(res) as BannerClass[];
    })
  }

  build() {
    Swiper(){
      ForEach(this.bannerList,(item: BannerClass)=>{
        Image($r(item.imageSrc))
        //保持宽高比缩小或放大，适应容器
          .objectFit(ImageFit.Cover)
          .width('100%')
          .padding({ top: 11, left: 16, right: 16 })
          .borderRadius(16)
          .onClick(() => {
            this.articlePathStack.pushPathByName('bannerDetailPage', item);
          })
      },(item: BannerClass)=>item.id)
    }
    .autoPlay(true)
    .loop(true)
    .indicator(
      new DotIndicator()
        .color('#1a000000')
        .selectedColor('#0A59F7')
    )
  }
}