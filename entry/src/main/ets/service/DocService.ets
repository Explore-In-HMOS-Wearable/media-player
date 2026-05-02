export class DocItem {
  id: string;
  docName: string;
  content: string;
  icon: Resource;

  constructor(id: string, docName: string, content: string, icon: Resource) {
    this.id = id;
    this.docName = docName;
    this.content = content;
    this.icon = icon;
  }
}

export class DocService {
  static instance: DocService;
  currentDoc: DocItem | null = null;

  static getInstance(): DocService {
    if (!DocService.instance) {
      DocService.instance = new DocService();
    }
    return DocService.instance;
  }
}

export const DOCS: DocItem[] = [
  new DocItem('0', 'User Guide', 'Welcome to the Media Player App.\n\nThis app allows you to browse and play locally stored videos, view images, take notes, and read documents — all from your wrist.\n\nSwipe through tabs on the home screen to access different media categories.\n\nTap any item to open it.', $r('app.media.docs')),
  new DocItem('1', 'Release Notes', 'Version 2.0\n\n- Image gallery with fullscreen viewer\n- Video favorites and resume playback\n- Persistent notes with save/delete\n- Document reader\n- Recently played tracking\n- Search and filter\n- Volume and brightness controls\n- Circular watch UI with ArcList', $r('app.media.docs')),
  new DocItem('2', 'About', 'Media Player App\nBuilt for HarmonyOS Next\nDesigned for circular smartwatches\n\nDeveloped as a demo project showcasing local media management on wearable devices.', $r('app.media.docs'))
];
