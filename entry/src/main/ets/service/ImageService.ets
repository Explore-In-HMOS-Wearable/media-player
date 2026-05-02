export class ImageItem {
  id: string;
  image: Resource;
  imageName: string;

  constructor(id: string, image: Resource, imageName: string) {
    this.id = id;
    this.image = image;
    this.imageName = imageName;
  }
}

export class ImageService {
  static instance: ImageService;
  currentImage: Resource | null = null;
  currentName: string = '';

  static getInstance(): ImageService {
    if (!ImageService.instance) {
      ImageService.instance = new ImageService();
    }
    return ImageService.instance;
  }
}

export const IMAGES: ImageItem[] = [
  new ImageItem('0', $r('app.media.huawei'), 'Huawei Watch'),
  new ImageItem('1', $r('app.media.huawei2'), 'Huawei Device'),
  new ImageItem('2', $r('app.media.background'), 'Background'),
  new ImageItem('3', $r('app.media.foreground'), 'Foreground')
];
