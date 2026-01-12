import { VideoItem, VIDEOS } from '../viewmodel/VideosViewmodel';

@Builder
export function PlayerList(onClick?: (item: VideoItem) => void, isNameVisible: boolean = false) {

  Flex({ alignItems: ItemAlign.Center }) {
    List({space:0}) {
      ForEach(VIDEOS, (item: VideoItem) => {
        ListItem() {
          Item({
            imageSrc: item.image,
            name: isNameVisible === true ? item.videoName : $r('app.string.empty')
          })
            .onClick(() => {
              if (onClick != null) {
                onClick(item);
              }
            })
        }
      }, (item: VideoItem, index : number) => item.id.toString())
    }.width('100%').height('100%')
    .alignListItem(ListItemAlign.Center)
    .align(Alignment.Center)
    .listDirection(Axis.Vertical)
    .scrollBar(BarState.Off)

  }
  .height('100%')
  .width('100%')
  .alignSelf(ItemAlign.Center)
}

@Component
struct Item {
  imageSrc: Resource = $r('app.string.empty');
  name: ResourceStr = '';

  build() {
    Column() {
      Image(this.imageSrc)
        .width('75%')
        .height('32%')
        .margin({ bottom: 2 })
        .borderRadius(10)
      Text(this.name)
    }.width('70%')
    .margin({top:20})
    .padding({top:5})
    .alignItems(HorizontalAlign.Center)
  }
}


