import { PlayerList } from '../../view/VideoPlayerList';

export const IMAGES_PAGE = 'ImagesPage';

@Builder
export function ImagesPageBuilder() {
  Images();
}


@Component
struct Images {
  build() {
    NavDestination() {
      Flex() {
        PlayerList()
      }
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}