import { VideoService } from '../service/VideoService';

@Component
export struct VideoPlayerPlayer {
  @State videoName: ResourceStr = '';
  private controller: VideoController | undefined = undefined;
  video: VideoService = VideoService.getInstance();

  build() {
    Column() {
      Video({
        src: this.video.source,
        controller: this.controller,
      })
        .width('99%')
        .height('75%')
      Text(this.video.name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .padding({
          top:15
        })
    }
    .backgroundColor('#18181a')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}
