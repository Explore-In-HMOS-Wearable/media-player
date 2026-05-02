import { TabsButton } from '../view/TabsButton';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { FavoritesService } from '../service/FavoritesService';
import { PlaybackResumeService } from '../service/PlaybackResumeService';
import { RecentlyPlayedService } from '../service/RecentlyPlayedService';
import { NoteService } from '../service/NoteService';

const permissions: Array<Permissions> = ['ohos.permission.INTERNET'];

function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
      } else {
        return;
      }
    }
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
}

@Entry
@Component
struct Index {
  async aboutToAppear(): Promise<void> {
    const context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
    reqPermissionsFromUser(permissions, context);
    await FavoritesService.getInstance().init(context);
    await PlaybackResumeService.getInstance().init(context);
    await RecentlyPlayedService.getInstance().init(context);
    await NoteService.getInstance().init(context);
  }

  build() {
    RelativeContainer() {
      TabsButton()
    }
    .height('100%')
    .width('100%')
  }
}
