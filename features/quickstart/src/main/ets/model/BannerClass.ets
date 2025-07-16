export class BannerClass{
  id: string = '';
  imageSrc: string = '';//资源地址
  url: string = '';//跳转
  constructor(id: string, imageSrc: string, url: string) {
    this.id = id;
    this.imageSrc = imageSrc;
    this.url = url;
  }
}