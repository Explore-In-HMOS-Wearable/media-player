import { ArcList, ArcListItem, LengthMetrics, ArcListItemAttribute } from '@kit.ArkUI';
import { DocsPageBuilder, DOCS_PAGE, DocReaderPageBuilder, DOC_READER_PAGE } from '../pages/others/Docs';
import { ImagesPageBuilder, IMAGES_PAGE, ImageViewerPageBuilder, IMAGE_VIEWER_PAGE } from '../pages/others/Images';
import { NotesPageBuilder, NOTES_PAGE, NoteEditorPageBuilder, NOTE_EDITOR_PAGE } from '../pages/others/Notes';
import { VideoPlayerPageBuilder, VIDEO_PLAYER_PAGE } from '../pages/video/VideoPlayerPage';
import { VideosPageBuilder, VIDEOS_PAGE } from '../pages/video/Videos';
import { RecentlyPlayedPageBuilder, RECENTLY_PLAYED_PAGE } from '../pages/video/RecentlyPlayed';
import { FileFormat, tabs } from '../viewmodel/TabsViewmodel';
import { VideoService } from '../service/VideoService';

@Component
export struct TabsButton {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack();
  @State nowPlayingName: string = '';
  @State isPlaying: boolean = false;
  private checkTimer: number = -1;

  aboutToAppear(): void {
    this.checkTimer = setInterval(() => {
      const vs = VideoService.getInstance();
      this.isPlaying = vs.isPlaying;
      this.nowPlayingName = vs.isPlaying ? (vs.name as string) : '';
    }, 1000);
  }

  aboutToDisappear(): void {
    if (this.checkTimer >= 0) {
      clearInterval(this.checkTimer);
    }
  }

  @Builder
  PagesMap(name: string) {
    if (name === DOCS_PAGE) {
      DocsPageBuilder();
    } else if (name === IMAGES_PAGE) {
      ImagesPageBuilder();
    } else if (name === IMAGE_VIEWER_PAGE) {
      ImageViewerPageBuilder();
    } else if (name === NOTES_PAGE) {
      NotesPageBuilder();
    } else if (name === NOTE_EDITOR_PAGE) {
      NoteEditorPageBuilder();
    } else if (name === VIDEOS_PAGE) {
      VideosPageBuilder();
    } else if (name === VIDEO_PLAYER_PAGE) {
      VideoPlayerPageBuilder();
    } else if (name === RECENTLY_PLAYED_PAGE) {
      RecentlyPlayedPageBuilder();
    } else if (name === DOC_READER_PAGE) {
      DocReaderPageBuilder();
    }
  }

  build() {
    Navigation(this.pageStack) {
      Stack() {
        ArcList({ initialIndex: 0 }) {
          if (this.isPlaying && this.nowPlayingName.length > 0) {
            ArcListItem() {
              Button({ type: ButtonType.Capsule }) {
                Row() {
                  Text('▶')
                    .fontSize(8)
                    .fontColor('#4FC3F7')
                    .margin({ right: 3 })
                  Text(this.nowPlayingName)
                    .fontSize(8)
                    .fontColor('#4FC3F7')
                    .maxLines(1)
                    .constraintSize({ maxWidth: 75 })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
              }
              .backgroundColor('#1a3344')
              .height(26)
              .width(115)
              .onClick(() => {
                this.pageStack.pushPath({ name: VIDEO_PLAYER_PAGE });
              })
            }.align(Alignment.Center)
          }

          ForEach(tabs, (fileData: FileFormat) => {
            ArcListItem() {
              Button({ type: ButtonType.Capsule }) {
                Row() {
                  Image(fileData.img)
                    .width(18)
                    .height(18)
                    .margin({ right: 5 })
                  Text(fileData.name)
                    .fontSize(10)
                    .fontColor('#d0d0d4')
                }
              }
              .backgroundColor('#252529')
              .width(120)
              .height(34)
              .onClick(() => {
                let urlPath: string = '';
                switch (fileData.index) {
                  case 0:
                    urlPath = IMAGES_PAGE;
                    break;
                  case 1:
                    urlPath = VIDEOS_PAGE;
                    break;
                  case 2:
                    urlPath = DOCS_PAGE;
                    break;
                  case 3:
                    urlPath = NOTES_PAGE;
                    break;
                  case 4:
                    urlPath = RECENTLY_PLAYED_PAGE;
                    break;
                  default:
                    break;
                }
                this.pageStack.pushPath({ name: urlPath });
              })
            }.align(Alignment.Center)
          }, (item: FileFormat) => `${item.index}-${item.name}`)
        }
        .height('100%')
        .width('100%')
        .space(LengthMetrics.px(4))
        .focusable(true)
        .focusOnTouch(true)
        .defaultFocus(true)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#111113')
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .hideBackButton(true)
    .ignoreLayoutSafeArea()
  }
}
