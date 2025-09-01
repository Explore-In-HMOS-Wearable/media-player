export class VideoService {
  source: ResourceStr = '';
  name: ResourceStr = '';
  static instance: VideoService;

  static getInstance() {
    if (!VideoService.instance) {
      VideoService.instance = new VideoService()
    }
    return VideoService.instance
  }

  getImageName() {
    return this.name
  }
}