import { VideoPlayerPlayer } from '../../view/VideoPlayerPlayer';

export const VIDEO_PLAYER_PAGE = 'VideoPlayerPage';

@Builder
export function VideoPlayerPageBuilder() {
  VideoPlayerPage();
}

@Component
struct VideoPlayerPage {
  build() {
    NavDestination() {
      Flex({ justifyContent: FlexAlign.Center, wrap: FlexWrap.Wrap, alignItems: ItemAlign.Center }) {
        VideoPlayerPlayer()
      }
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
