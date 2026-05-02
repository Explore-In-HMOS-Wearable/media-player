import { VideoService } from '../service/VideoService';
import { PlaybackResumeService } from '../service/PlaybackResumeService';
import { common } from '@kit.AbilityKit';

@Component
export struct VideoPlayerPlayer {
  @State volumeVal: number = 50;
  @State brightnessVal: number = 50;
  @State currentTime: number = 0;
  private controller: VideoController = new VideoController();
  private video: VideoService = VideoService.getInstance();
  private resumeService: PlaybackResumeService = PlaybackResumeService.getInstance();
  private saveTimer: number = -1;

  async aboutToAppear(): Promise<void> {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    await this.resumeService.init(context);
    const pos = this.resumeService.getPosition(this.video.videoId);
    if (pos > 0) {
      this.currentTime = pos;
    }
    this.video.isPlaying = true;
  }

  aboutToDisappear(): void {
    this.video.isPlaying = false;
    if (this.saveTimer >= 0) {
      clearInterval(this.saveTimer);
    }
  }

  build() {
    NavDestination() {
      Column() {
        Video({
          src: this.video.source,
          currentProgressRate: PlaybackSpeed.Speed_Forward_1_00_X,
          controller: this.controller
        })
          .width('90%')
          .height('55%')
          .autoPlay(true)
          .controls(true)
          .borderRadius(8)
          .onStart(() => {
            if (this.currentTime > 0) {
              this.controller.setCurrentTime(this.currentTime / 1000);
            }
            this.saveTimer = setInterval(async () => {
              await this.resumeService.savePosition(this.video.videoId, this.currentTime);
            }, 3000);
          })
          .onUpdate((event) => {
            if (event) {
              this.currentTime = event.time * 1000;
            }
          })
          .onFinish(async () => {
            await this.resumeService.savePosition(this.video.videoId, 0);
            this.video.isPlaying = false;
          })
          .onPause(async () => {
            await this.resumeService.savePosition(this.video.videoId, this.currentTime);
            this.video.isPlaying = false;
          })

        Text(this.video.name as string)
          .fontSize(12)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .padding({ top: 4 })
          .maxLines(1)
          .constraintSize({ maxWidth: 120 })
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Row() {
          Text('Vol')
            .fontSize(8)
            .fontColor('#AAAAAA')
            .width(20)
          Slider({
            value: this.volumeVal,
            min: 0,
            max: 100,
            step: 5,
            style: SliderStyle.InSet
          })
            .width('50%')
            .blockColor('#4FC3F7')
            .trackColor('#333333')
            .selectedColor('#4FC3F7')
            .onChange((value: number) => {
              this.volumeVal = value;
            })
        }
        .width('70%')
        .height(24)
        .justifyContent(FlexAlign.Center)
        .margin({ top: 2 })

        Row() {
          Text('Brt')
            .fontSize(8)
            .fontColor('#AAAAAA')
            .width(20)
          Slider({
            value: this.brightnessVal,
            min: 0,
            max: 100,
            step: 5,
            style: SliderStyle.InSet
          })
            .width('50%')
            .blockColor('#FFD700')
            .trackColor('#333333')
            .selectedColor('#FFD700')
            .onChange((value: number) => {
              this.brightnessVal = value;
            })
        }
        .width('70%')
        .height(24)
        .justifyContent(FlexAlign.Center)
      }
      .backgroundColor('#18181a')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .mode(NavDestinationMode.STANDARD)
  }
}
