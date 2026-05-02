import { ArcList, ArcListItem, LengthMetrics } from '@kit.ArkUI';
import { NoteItem, NoteService } from '../../service/NoteService';
import { common } from '@kit.AbilityKit';

export const NOTES_PAGE = 'NotesPage';
export const NOTE_EDITOR_PAGE = 'NoteEditorPage';

@Builder
export function NotesPageBuilder() {
  Notes();
}

@Builder
export function NoteEditorPageBuilder() {
  NoteEditorPage();
}

@Component
struct Notes {
  @Consume('NavPathStack') private pageStack: NavPathStack;
  @State notesList: NoteItem[] = [];
  private noteService: NoteService = NoteService.getInstance();

  async aboutToAppear(): Promise<void> {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await this.noteService.init(context);
    this.notesList = this.noteService.getNotes();
  }

  build() {
    NavDestination() {
      Stack() {
        ArcList({ initialIndex: 0 }) {
          ArcListItem() {
            Button({ type: ButtonType.Capsule }) {
              Row() {
                Text('+')
                  .fontSize(13)
                  .fontColor('#4FC3F7')
                  .fontWeight(FontWeight.Bold)
                  .margin({ right: 3 })
                Text('New Note')
                  .fontSize(8)
                  .fontColor('#4FC3F7')
              }
            }
            .backgroundColor('#1a3344')
            .width(110)
            .height(30)
            .onClick(() => {
              this.noteService.currentEditId = '';
              this.noteService.currentEditTitle = '';
              this.noteService.currentEditContent = '';
              this.pageStack.pushPath({ name: NOTE_EDITOR_PAGE });
            })
          }.align(Alignment.Center)

          ForEach(this.notesList, (note: NoteItem) => {
            ArcListItem() {
              Button({ type: ButtonType.Capsule }) {
                Column() {
                  Text(note.title)
                    .fontSize(8)
                    .fontColor('#d0d0d4')
                    .fontWeight(FontWeight.Medium)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .width('100%')
                  Text(note.content)
                    .fontSize(7)
                    .fontColor('#888888')
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .width('100%')
                    .margin({ top: 1 })
                }
                .width('100%')
                .padding({ left: 4, right: 4 })
              }
              .backgroundColor('#252529')
              .width(125)
              .height(32)
              .onClick(() => {
                this.noteService.currentEditId = note.id;
                this.noteService.currentEditTitle = note.title;
                this.noteService.currentEditContent = note.content;
                this.pageStack.pushPath({ name: NOTE_EDITOR_PAGE });
              })
              .gesture(
                LongPressGesture()
                  .onAction(async () => {
                    await this.noteService.deleteNote(note.id);
                    this.notesList = this.noteService.getNotes();
                  })
              )
            }.align(Alignment.Center)
          }, (note: NoteItem) => note.id)
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
struct NoteEditorPage {
  @State title: string = '';
  @State content: string = '';
  private noteService: NoteService = NoteService.getInstance();
  @Consume('NavPathStack') private pageStack: NavPathStack;

  aboutToAppear(): void {
    this.title = this.noteService.currentEditTitle;
    this.content = this.noteService.currentEditContent;
  }

  build() {
    NavDestination() {
      Column() {
        TextInput({ placeholder: 'Title', text: this.title })
          .width('55%')
          .height(22)
          .fontSize(8)
          .margin({ top: 28, bottom: 3 })
          .backgroundColor('#222226')
          .fontColor('#FFFFFF')
          .borderRadius(8)
          .onChange((value: string) => {
            this.title = value;
          })

        TextArea({ placeholder: 'Write your note...', text: this.content })
          .width('55%')
          .height(50)
          .fontSize(8)
          .backgroundColor('#222226')
          .fontColor('#FFFFFF')
          .borderRadius(8)
          .onChange((value: string) => {
            this.content = value;
          })

        Button('Save')
          .fontSize(9)
          .fontColor('#4FC3F7')
          .backgroundColor('#1a3344')
          .width(50)
          .height(24)
          .borderRadius(12)
          .margin({ top: 3 })
          .onClick(async () => {
            if (this.title.length > 0 || this.content.length > 0) {
              if (this.noteService.currentEditId.length > 0) {
                await this.noteService.updateNote(this.noteService.currentEditId, this.title, this.content);
              } else {
                await this.noteService.addNote(this.title, this.content);
              }
              this.pageStack.pop();
            }
          })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#111113')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
