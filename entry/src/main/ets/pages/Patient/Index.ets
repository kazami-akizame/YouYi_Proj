import { PatientModulePreview } from './PatientModulePreview'

@Entry
@Component
struct Index {
  build() {
    Column() {
      PatientModulePreview()
    }
    .width('100%')
    .height('100%')
  }
}