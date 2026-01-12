export const DOCS_PAGE = 'DocsPage';

@Builder
export function DocsPageBuilder() {
  Docs();
}


@Component
struct Docs {
  build() {
    NavDestination() {
      Flex() {
      }
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}