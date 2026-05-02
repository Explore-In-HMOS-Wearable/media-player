@Observed
export class VideoItem {
  id: String;
  image: Resource;
  videoName: ResourceStr;
  videoLink: ResourceStr;

  constructor(id: String, image: Resource, videoName: ResourceStr, videoLink: ResourceStr) {
    this.id = id;
    this.image = image;
    this.videoName = videoName;
    this.videoLink = videoLink;
  }
}

export const VIDEOS: VideoItem[] = [
  new VideoItem('0', $r('app.media.huawei'), 'Video 1', $rawfile('video1.mp4')),
  new VideoItem('1', $r('app.media.huawei2'), 'Video 2', $rawfile('video2.mp4'))
];
