import { VideoService } from "../../service/VideoService";
import { PlayerList } from "../../view/VideoPlayerList";
import router from "@ohos.router";

@Entry
@Component
struct Videos {
  build() {
    Flex() {
      PlayerList((item) => {
        VideoService.getInstance().source = item.videoLink
        VideoService.getInstance().name = item.videoName;
        router.pushUrl({ url: 'pages/video/VideoPlayerPage' })
      }, true)
    }
  }
}
