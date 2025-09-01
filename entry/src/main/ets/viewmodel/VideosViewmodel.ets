@Observed
export class VideoItem {
  image: Resource;
  videoName: ResourceStr;
  videoLink: ResourceStr;

  constructor(image: Resource, videoName: ResourceStr, videoLink: ResourceStr) {
    this.image = image;
    this.videoName = videoName;
    this.videoLink = videoLink;
  }
}

export const VIDEOS: VideoItem[] = [
  new VideoItem($r('app.media.huawei'), 'Video 1', $rawfile('video1.mp4')),
  new VideoItem($r('app.media.huawei2'), 'Video 2', $rawfile('video2.mp4')),
];