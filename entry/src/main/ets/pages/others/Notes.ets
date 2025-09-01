@Entry
@Component
struct Notes {
  build() {
    RelativeContainer() {
      TextArea({placeholder:'You can take notes'}).width('100%').height('100%').padding({left:40,top:50})
    }
  }
}

