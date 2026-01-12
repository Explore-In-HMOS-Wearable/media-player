import { DocsPageBuilder, DOCS_PAGE } from '../pages/others/Docs';
import { ImagesPageBuilder, IMAGES_PAGE } from '../pages/others/Images';
import { NotesPageBuilder, NOTES_PAGE } from '../pages/others/Notes';
import { VideoPlayerPageBuilder, VIDEO_PLAYER_PAGE } from '../pages/video/VideoPlayerPage';
import { VideosPageBuilder, VIDEOS_PAGE } from '../pages/video/Videos';
import { FileFormat, tabs } from '../viewmodel/TabsViewmodel';

@Component
export struct TabsButton {
  @Provide('NavPathStack') pageStack: NavPathStack = new NavPathStack()
  message: string = 'Images';
  urlPath: string = '';

  @Builder
  PagesMap(name: string) {
    if (name === DOCS_PAGE) {
      DocsPageBuilder();
    } else if (name === IMAGES_PAGE) {
      ImagesPageBuilder();
    } else if (name === NOTES_PAGE) {
      NotesPageBuilder();
    } else if (name === VIDEOS_PAGE) {
      VideosPageBuilder();
    } else if (name === VIDEO_PLAYER_PAGE) {
      VideoPlayerPageBuilder();
    }
  }

  build() {
    Navigation(this.pageStack) {
      Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
        ForEach(tabs, (fileData: FileFormat) => {
          Column() {
            Image(fileData.img)
              .width('40%')
              .onClick(() => {
                switch (fileData.index) {
                  case 0:
                    this.urlPath = IMAGES_PAGE;
                    break;
                  case 1:
                    this.urlPath = VIDEOS_PAGE;
                    break;
                  case 2:
                    this.urlPath = DOCS_PAGE;
                    break;
                  case 3:
                    this.urlPath = NOTES_PAGE;
                    break;
                  default:
                    break;
                }
                this.pageStack.pushPath({
                  name: this.urlPath
                })
              });
            Text(fileData.name.toString())
          }
        }, (item: string, index: number) => item);
      }.width('70%').height('100%').margin({ left: 35 })
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PagesMap)
    .hideBackButton(true)
    .ignoreLayoutSafeArea()
  }
}