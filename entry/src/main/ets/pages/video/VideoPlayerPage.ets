import { VideoPlayerPlayer } from "../../view/VideoPlayerPlayer";

@Entry
@Component
struct VideoPlayerPage {
  build() {
    Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
      VideoPlayerPlayer()
    }
  }
}
