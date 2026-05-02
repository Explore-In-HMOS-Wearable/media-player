import { ArcList, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { VideoService } from '../../service/VideoService';
import { FavoritesService } from '../../service/FavoritesService';
import { RecentlyPlayedService } from '../../service/RecentlyPlayedService';
import { VideoItem, VIDEOS } from '../../viewmodel/VideosViewmodel';
import { VIDEO_PLAYER_PAGE } from './VideoPlayerPage';
import { common } from '@kit.AbilityKit';

export const VIDEOS_PAGE = 'VideosPage';

@Builder
export function VideosPageBuilder() {
  Videos();
}

@Component
struct Videos {
  @Consume('NavPathStack') private pageStack: NavPathStack;
  @State searchText: string = '';
  @State showFavoritesOnly: boolean = false;
  @State favoriteIds: string[] = [];
  @State filteredVideos: VideoItem[] = VIDEOS;
  private favService: FavoritesService = FavoritesService.getInstance();
  private recentService: RecentlyPlayedService = RecentlyPlayedService.getInstance();

  async aboutToAppear(): Promise<void> {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await this.favService.init(context);
    await this.recentService.init(context);
    this.favoriteIds = this.favService.getFavoriteIds();
    this.applyFilter();
  }

  applyFilter(): void {
    let list: VideoItem[] = [];
    for (let i = 0; i < VIDEOS.length; i++) {
      list.push(VIDEOS[i]);
    }
    if (this.showFavoritesOnly) {
      list = list.filter(v => this.favService.isFavorite(v.id.toString()));
    }
    if (this.searchText.length > 0) {
      const query = this.searchText.toLowerCase();
      list = list.filter(v => (v.videoName as string).toLowerCase().includes(query));
    }
    this.filteredVideos = list;
  }

  build() {
    NavDestination() {
      Stack() {
        ArcList({ initialIndex: 0 }) {
          ArcListItem() {
            Row() {
              TextInput({ placeholder: 'Search...', text: this.searchText })
                .height(22)
                .fontSize(8)
                .backgroundColor('#222226')
                .fontColor('#FFFFFF')
                .borderRadius(11)
                .width(85)
                .onChange((value: string) => {
                  this.searchText = value;
                  this.applyFilter();
                })

              Text(this.showFavoritesOnly ? '★' : '☆')
                .fontSize(13)
                .fontColor(this.showFavoritesOnly ? '#FFD700' : '#666666')
                .margin({ left: 5 })
                .onClick(() => {
                  this.showFavoritesOnly = !this.showFavoritesOnly;
                  this.applyFilter();
                })
            }
          }.align(Alignment.Center)

          ForEach(this.filteredVideos, (item: VideoItem) => {
            ArcListItem() {
              Button({ type: ButtonType.Capsule }) {
                Row() {
                  Image(item.image)
                    .width(24)
                    .height(18)
                    .borderRadius(3)
                    .margin({ right: 5 })

                  Text(item.videoName as string)
                    .fontSize(8)
                    .fontColor('#d0d0d4')
                    .layoutWeight(1)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(this.favService.isFavorite(item.id.toString()) ? '★' : '☆')
                    .fontSize(11)
                    .fontColor(this.favService.isFavorite(item.id.toString()) ? '#FFD700' : '#444444')
                    .width(18)
                    .textAlign(TextAlign.Center)
                    .onClick(async () => {
                      await this.favService.toggleFavorite(item.id.toString());
                      this.favoriteIds = this.favService.getFavoriteIds();
                      this.applyFilter();
                    })
                }
                .width('100%')
              }
              .backgroundColor('#252529')
              .borderWidth(0.5)
              .borderColor('#3a3a40')
              .width(125)
              .height(32)
              .onClick(async () => {
                VideoService.getInstance().source = item.videoLink;
                VideoService.getInstance().name = item.videoName;
                VideoService.getInstance().videoId = item.id.toString();
                VideoService.getInstance().isPlaying = true;
                await this.recentService.addRecent(item.id.toString(), item.videoName as string);
                this.pageStack.pushPath({ name: VIDEO_PLAYER_PAGE });
              })
            }.align(Alignment.Center)
          }, (item: VideoItem) => item.id.toString() + this.favoriteIds.length.toString())
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
