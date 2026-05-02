import { ArcList, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { ImageItem, IMAGES, ImageService } from '../../service/ImageService';

export const IMAGES_PAGE = 'ImagesPage';
export const IMAGE_VIEWER_PAGE = 'ImageViewerPage';

@Builder
export function ImagesPageBuilder() {
  Images();
}

@Builder
export function ImageViewerPageBuilder() {
  ImageViewerPage();
}

@Component
struct Images {
  @Consume('NavPathStack') private pageStack: NavPathStack;

  build() {
    NavDestination() {
      Stack() {
        ArcList({ initialIndex: 0 }) {
          ForEach(IMAGES, (item: ImageItem) => {
            ArcListItem() {
              Button({ type: ButtonType.Capsule }) {
                Row() {
                  Image(item.image)
                    .width(24)
                    .height(24)
                    .borderRadius(4)
                    .margin({ right: 6 })
                  Text(item.imageName)
                    .fontSize(8)
                    .fontColor('#d0d0d4')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .constraintSize({ maxWidth: 70 })
                }
              }
              .backgroundColor('#252529')
              .width(125)
              .height(32)
              .onClick(() => {
                ImageService.getInstance().currentImage = item.image;
                ImageService.getInstance().currentName = item.imageName;
                this.pageStack.pushPath({ name: IMAGE_VIEWER_PAGE });
              })
            }.align(Alignment.Center)
          }, (item: ImageItem) => item.id)
        }
        .height('100%')
        .width('100%')
        .space(LengthMetrics.px(3))
        .focusable(true)
        .focusOnTouch(true)
        .defaultFocus(true)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#111113')
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}

@Component
struct ImageViewerPage {
  @State scaleVal: number = 1;
  @State offsetX: number = 0;
  @State offsetY: number = 0;
  private imgService: ImageService = ImageService.getInstance();

  build() {
    NavDestination() {
      Stack() {
        Image(this.imgService.currentImage)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
          .scale({ x: this.scaleVal, y: this.scaleVal })
          .translate({ x: this.offsetX, y: this.offsetY })
          .gesture(
            PinchGesture({ fingers: 2 })
              .onActionUpdate((event: GestureEvent) => {
                this.scaleVal = Math.max(0.5, Math.min(3.0, event.scale));
              })
              .onActionEnd(() => {
                if (this.scaleVal < 1) {
                  this.scaleVal = 1;
                  this.offsetX = 0;
                  this.offsetY = 0;
                }
              })
          )
          .gesture(
            PanGesture()
              .onActionUpdate((event: GestureEvent) => {
                if (this.scaleVal > 1) {
                  this.offsetX = event.offsetX;
                  this.offsetY = event.offsetY;
                }
              })
          )

        Text(this.imgService.currentName)
          .fontSize(10)
          .fontColor('#FFFFFF')
          .backgroundColor('#80000000')
          .padding(4)
          .borderRadius(6)
          .position({ x: '30%', y: '82%' })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
