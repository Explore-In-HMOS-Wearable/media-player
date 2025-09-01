import { router } from '@kit.ArkUI';
import { FileFormat, tabs } from '../viewmodel/TabsViewmodel';

@Component
export struct TabsButton {
  @State message: string = 'Images';
  urlPath: string = '';

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, wrap: FlexWrap.Wrap, alignContent: FlexAlign.SpaceEvenly }) {
      ForEach(tabs, (fileData: FileFormat) => {
        Column() {
          Image(fileData.img)
            .width('40%')
            .onClick(() => {
              switch (fileData.index) {
                case 0:
                  this.urlPath = 'pages/others/Images';
                  break;
                case 1:
                  this.urlPath = 'pages/video/Videos';
                  break;
                case 2:
                  this.urlPath = 'pages/others/Docs';
                  break;
                case 3:
                  this.urlPath = 'pages/others/Notes';
                  break;
                default:
                  break;
              }
              router.pushUrl({ url: this.urlPath })
            });
          Text(fileData.name.toString())
        }
      }, (item: string, index: number) => item);
    }.width('70%').height('100%').margin({ left: 35 })
  }
}