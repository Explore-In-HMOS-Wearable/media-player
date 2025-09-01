export class FileFormat {
  index: number;
  img: Resource;
  name: String;

  constructor(index: number, img: Resource, name: string) {
    this.index = index;
    this.img = img;
    this.name = name;
  }
}

const tabs: FileFormat[] = [
  new FileFormat(0, $r('app.media.images'), 'Images'),
  new FileFormat(1, $r('app.media.videos'), 'Videos'),
  new FileFormat(2, $r('app.media.docs'), 'Docs'),
  new FileFormat(3, $r('app.media.notes'), 'Notes')
];

export { tabs }