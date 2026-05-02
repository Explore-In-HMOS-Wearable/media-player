import { ArcList, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { DocItem, DOCS, DocService } from '../../service/DocService';

export const DOCS_PAGE = 'DocsPage';
export const DOC_READER_PAGE = 'DocReaderPage';

@Builder
export function DocsPageBuilder() {
  DocsListPage();
}

@Builder
export function DocReaderPageBuilder() {
  DocReaderPage();
}

@Component
struct DocsListPage {
  @Consume('NavPathStack') private pageStack: NavPathStack;

  build() {
    NavDestination() {
      Stack() {
        ArcList({ initialIndex: 0 }) {
          ForEach(DOCS, (doc: DocItem) => {
            ArcListItem() {
              Button({ type: ButtonType.Capsule }) {
                Row() {
                  Image(doc.icon)
                    .width(16)
                    .height(16)
                    .margin({ right: 5 })
                  Text(doc.docName)
                    .fontSize(8)
                    .fontColor('#d0d0d4')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .constraintSize({ maxWidth: 80 })
                }
              }
              .backgroundColor('#252529')
              .width(125)
              .height(32)
              .onClick(() => {
                DocService.getInstance().currentDoc = doc;
                this.pageStack.pushPath({ name: DOC_READER_PAGE });
              })
            }.align(Alignment.Center)
          }, (doc: DocItem) => doc.id)
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

@Component
struct DocReaderPage {
  private docService: DocService = DocService.getInstance();

  build() {
    NavDestination() {
      Column() {
        Text(this.docService.currentDoc?.docName ?? '')
          .fontSize(10)
          .fontColor('#4FC3F7')
          .fontWeight(FontWeight.Bold)
          .margin({ top: 28, bottom: 3 })
          .textAlign(TextAlign.Center)
          .constraintSize({ maxWidth: 100 })

        Scroll() {
          Text(this.docService.currentDoc?.content ?? '')
            .fontSize(8)
            .fontColor('#b0b0b4')
            .width('58%')
            .padding({ bottom: 28 })
        }
        .scrollBar(BarState.Off)
        .layoutWeight(1)
        .width('100%')
        .align(Alignment.Top)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#111113')
      .alignItems(HorizontalAlign.Center)
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
