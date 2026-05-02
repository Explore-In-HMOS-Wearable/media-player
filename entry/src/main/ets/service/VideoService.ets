export class VideoService {
  source: ResourceStr = '';
  name: ResourceStr = '';
  videoId: string = '';
  isPlaying: boolean = false;
  static instance: VideoService;

  static getInstance(): VideoService {
    if (!VideoService.instance) {
      VideoService.instance = new VideoService();
    }
    return VideoService.instance;
  }

  getImageName(): ResourceStr {
    return this.name;
  }
}
