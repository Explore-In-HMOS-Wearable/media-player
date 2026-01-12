import { VideoService } from '../../service/VideoService';
import { PlayerList } from '../../view/VideoPlayerList';
import { VIDEO_PLAYER_PAGE } from './VideoPlayerPage';

export const VIDEOS_PAGE = 'VideosPage';

@Builder
export function VideosPageBuilder() {
  Videos();
}


@Component
struct Videos {
  @Consume('NavPathStack') private pageStack: NavPathStack;

  build() {
    NavDestination() {
      Flex() {
        PlayerList((item) => {
          VideoService.getInstance().source = item.videoLink
          VideoService.getInstance().name = item.videoName;
          this.pageStack.pushPath({
            name: VIDEO_PLAYER_PAGE
          })
        }, true)
      }
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
