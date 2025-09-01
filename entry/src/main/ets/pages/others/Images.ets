import { PlayerList } from '../../view/VideoPlayerList';

@Entry
@Component
struct Images {
  build() {
    Flex() {
      PlayerList()
    }
  }
}