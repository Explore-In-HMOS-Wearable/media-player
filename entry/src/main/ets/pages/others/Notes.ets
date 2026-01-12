export const NOTES_PAGE = 'NotesPage';

@Builder
export function NotesPageBuilder() {
  Notes();
}

@Component
struct Notes {
  build() {
    NavDestination() {
      RelativeContainer() {
        TextArea({ placeholder: 'You can take notes' }).width('100%').height('100%').padding({ left: 40, top: 50 })
      }
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}

