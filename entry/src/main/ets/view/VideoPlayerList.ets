import { ArcList, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { VideoItem, VIDEOS } from '../viewmodel/VideosViewmodel';

@Builder
export function PlayerList(onClick?: (item: VideoItem) => void, isNameVisible: boolean = false) {
  Stack() {
    ArcList({ initialIndex: 0 }) {
      ForEach(VIDEOS, (item: VideoItem) => {
        ArcListItem() {
          Button({ type: ButtonType.Capsule }) {
            Row() {
              Image(item.image)
                .width(24)
                .height(18)
                .borderRadius(3)
                .objectFit(ImageFit.Cover)
                .margin({ right: 5 })
              if (isNameVisible) {
                Text(item.videoName)
                  .fontSize(8)
                  .fontColor('#d0d0d4')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .constraintSize({ maxWidth: 70 })
              }
            }
          }
          .backgroundColor('#252529')
          .width(125)
          .height(32)
          .onClick(() => {
            if (onClick != null) {
              onClick(item);
            }
          })
        }.align(Alignment.Center)
      }, (item: VideoItem, index: number) => item.id.toString())
    }
    .height('100%')
    .width('100%')
    .space(LengthMetrics.px(3))
    .focusable(true)
    .focusOnTouch(true)
    .defaultFocus(true)
  }
  .height('100%')
  .width('100%')
}
