import { TabsButton } from '../view/TabsButton';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

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
  aboutToAppear() {
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    reqPermissionsFromUser(permissions, context);
  }

  build() {
    RelativeContainer() {
      TabsButton()
    }
    .height('100%')
    .width('100%')
  }
}