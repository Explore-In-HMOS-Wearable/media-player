import { ArcList, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { RecentItem, RecentlyPlayedService } from '../../service/RecentlyPlayedService';
import { VideoService } from '../../service/VideoService';
import { VideoItem, VIDEOS } from '../../viewmodel/VideosViewmodel';
import { VIDEO_PLAYER_PAGE } from './VideoPlayerPage';
import { common } from '@kit.AbilityKit';

export const RECENTLY_PLAYED_PAGE = 'RecentlyPlayedPage';

@Builder
export function RecentlyPlayedPageBuilder() {
  RecentlyPlayedPage();
}

@Component
struct RecentlyPlayedPage {
  @Consume('NavPathStack') private pageStack: NavPathStack;
  @State recentList: RecentItem[] = [];
  private recentService: RecentlyPlayedService = RecentlyPlayedService.getInstance();

  async aboutToAppear(): Promise<void> {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await this.recentService.init(context);
    this.recentList = this.recentService.getRecentList();
  }

  build() {
    NavDestination() {
      Stack() {
        if (this.recentList.length === 0) {
          Text('No recent videos')
            .fontSize(9)
            .fontColor('#666666')
        } else {
          ArcList({ initialIndex: 0 }) {
            ForEach(this.recentList, (item: RecentItem) => {
              ArcListItem() {
                Button({ type: ButtonType.Capsule }) {
                  Row() {
                    Text('▶')
                      .fontSize(8)
                      .fontColor('#4FC3F7')
                      .margin({ right: 5 })
                    Column() {
                      Text(item.videoName)
                        .fontSize(8)
                        .fontColor('#d0d0d4')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(this.formatTime(item.timestamp))
                        .fontSize(6)
                        .fontColor('#777777')
                        .margin({ top: 1 })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                  }
                  .width('100%')
                }
                .backgroundColor('#252529')
                .width(125)
                .height(32)
                .onClick(() => {
                  const video: VideoItem | undefined = VIDEOS.find(v => v.id.toString() === item.videoId);
                  if (video) {
                    VideoService.getInstance().source = video.videoLink;
                    VideoService.getInstance().name = video.videoName;
                    VideoService.getInstance().videoId = video.id.toString();
                    this.pageStack.pushPath({ name: VIDEO_PLAYER_PAGE });
                  }
                })
              }.align(Alignment.Center)
            }, (item: RecentItem) => item.videoId + item.timestamp.toString())
          }
          .height('100%')
          .width('100%')
          .space(LengthMetrics.px(3))
          .focusable(true)
          .focusOnTouch(true)
          .defaultFocus(true)
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#111113')
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }

  formatTime(ts: number): string {
    const d = new Date(ts);
    return `${d.getMonth() + 1}/${d.getDate()} ${d.getHours()}:${d.getMinutes().toString().padStart(2, '0')}`;
  }
}
