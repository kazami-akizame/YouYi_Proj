import { PatientMainPage } from './PatientMainPage'
import { ManageGroupPage, ModifyGroupPage } from './PatientGroupPages'
import { DefaultGroupPage, PatientProfilePage } from './PatientDetailPages'
import { SearchPatientPage } from './PatientSearchPage'
import { PersonalInfoPage, EditPersonalInfoPage, EditRemarkInfoPage, EditPersonalAgePage } from './PatientInfoPages'
import {
  CreateBroadcastPage,
  BroadcastHistoryPage,
  SelectPatientPage,
  MyPatientsPage,
  SearchMessagePage,
  MessageDetailPage
} from './PatientMessagingPages'
import router from '@ohos.router'

@Component
export struct PatientModulePreview {
  @State private activeTab: string = '患者';
  @State private activePage: string = '患者';
  /** 搜索患者页点「取消」时回到的页面（患者主页 / 选择患者等） */
  @State private searchReturnPage: string = '患者';
  /** 个人信息 / 修改分组 等子页返回时的页面（通常为「患者资料」） */
  @State private profileReturnPage: string = '患者资料';
  /** 编辑姓名 / 编辑备注 / 编辑个人年龄 左上角返回时回到的页面（通常为「个人信息」） */
  @State private personalInfoSubReturnPage: string = '个人信息';
  /** 个人信息页「年龄」与编辑年龄页共用 */
  @State private patientAgeDisplay: string = '23';
  /** 个人信息页「患者姓名」与编辑姓名页共用 */
  @State private patientNameDisplay: string = '吴珊珊';
  /** 个人信息页「备注」与编辑备注页共用 */
  @State private patientRemarkDisplay: string = '该患者需要于下月5号询问用药情况....';
  /** 个人信息页「地区」展示（省 + 空格 + 市） */
  @State private patientRegionDisplay: string = '北京 朝阳';
  /** 患者资料 / 修改分组：已选分组名（多选，展示时用「、」连接） */
  @State private patientGroupSelection: string[] = ['默认分组'];
  /** 当前查看的分组 */
  @State private currentGroupId: number = 1;
  @State private currentGroupName: string = '默认分组';
  /** 当前查看的患者 */
  @State private currentPatientId: number = 1;
  /** 群发模块当前选中的消息ID（历史/搜索到详情） */
  @State private selectedMessageId: number = 0;
  /** 群发模块当前选中的接收人患者ID列表 */
  @State private selectedRecipientIds: number[] = [];
  /** 消息详情页返回目标页面（默认返回群发历史，可由外部路由参数覆盖） */
  @State private messageDetailReturnPage: string = '群发历史';
  /** 群发模块当前选中的分组 */
  @State private selectedRecipientGroupId: number = 1;
  @State private selectedRecipientGroupName: string = '默认分组';

  aboutToAppear() {
    const params = router.getParams() as Record<string, string | number | undefined>;
    if (!params) {
      return;
    }

    const targetPage = params.targetPage;
    if (typeof targetPage === 'string' && targetPage.length > 0) {
      this.activePage = targetPage;
      this.activeTab = '患者';
    }

    const patientId = params.currentPatientId;
    if (typeof patientId === 'number' && Number.isFinite(patientId) && patientId > 0) {
      this.currentPatientId = patientId;
    }

    const groupId = params.currentGroupId;
    if (typeof groupId === 'number' && Number.isFinite(groupId) && groupId > 0) {
      this.currentGroupId = groupId;
    }

    const groupName = params.currentGroupName;
    if (typeof groupName === 'string' && groupName.length > 0) {
      this.currentGroupName = groupName;
    }

    const messageId = params.selectedMessageId;
    if (typeof messageId === 'number' && Number.isFinite(messageId) && messageId > 0) {
      this.selectedMessageId = messageId;
    }

    const detailReturnPage = params.messageDetailReturnPage;
    if (typeof detailReturnPage === 'string' && detailReturnPage.length > 0) {
      this.messageDetailReturnPage = detailReturnPage;
      this.profileReturnPage = detailReturnPage;
    }
  }

  build() {
    Column() {
      Column() {
        this.buildCurrentPage()
      }
      .layoutWeight(1)
      .width('100%')

      Row() {
        this.buildTabItem($r('app.media.u1070'), '首页')
        this.buildTabItem($r('app.media.u1074'), '患者')
        this.buildTabItem($r('app.media.u1072'), '我的')
      }
      .width('100%')
      .height(74)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  private buildCurrentPage() {
    if (this.activePage === '管理分组') {
      ManageGroupPage({ activePage: $activePage })
    } else if (this.activePage === '默认分组') {
      DefaultGroupPage({
        activePage: $activePage,
        searchReturnPage: $searchReturnPage,
        currentGroupId: $currentGroupId,
        currentGroupName: $currentGroupName,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '患者资料') {
      PatientProfilePage({
        activePage: $activePage,
        profileReturnPage: $profileReturnPage,
        patientGroupSelection: $patientGroupSelection,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '个人信息') {
      PersonalInfoPage({
        activePage: $activePage,
        cancelReturnPage: this.profileReturnPage,
        personalInfoSubReturnPage: $personalInfoSubReturnPage,
        patientAgeDisplay: $patientAgeDisplay,
        patientNameDisplay: $patientNameDisplay,
        patientRemarkDisplay: $patientRemarkDisplay,
        patientRegionDisplay: $patientRegionDisplay,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '编辑姓名') {
      EditPersonalInfoPage({
        activePage: $activePage,
        cancelReturnPage: this.personalInfoSubReturnPage,
        patientNameDisplay: $patientNameDisplay,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '编辑备注') {
      EditRemarkInfoPage({
        activePage: $activePage,
        cancelReturnPage: this.personalInfoSubReturnPage,
        patientRemarkDisplay: $patientRemarkDisplay,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '编辑个人年龄') {
      EditPersonalAgePage({
        activePage: $activePage,
        cancelReturnPage: this.personalInfoSubReturnPage,
        patientAgeDisplay: $patientAgeDisplay,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '修改分组') {
      ModifyGroupPage({
        activePage: $activePage,
        cancelReturnPage: this.profileReturnPage,
        patientGroupSelection: $patientGroupSelection,
        currentPatientId: $currentPatientId
      })
    } else if (this.activePage === '新建群发') {
      CreateBroadcastPage({
        activePage: $activePage,
        selectedMessageId: $selectedMessageId,
        selectedRecipientIds: $selectedRecipientIds
      })
    } else if (this.activePage === '我的患者') {
      MyPatientsPage({
        activePage: $activePage,
        searchReturnPage: $searchReturnPage,
        selectedRecipientIds: $selectedRecipientIds,
        selectedRecipientGroupId: $selectedRecipientGroupId,
        selectedRecipientGroupName: $selectedRecipientGroupName
      })
    } else if (this.activePage === '选择患者') {
      SelectPatientPage({
        activePage: $activePage,
        searchReturnPage: $searchReturnPage,
        selectedRecipientIds: $selectedRecipientIds,
        selectedRecipientGroupId: $selectedRecipientGroupId,
        selectedRecipientGroupName: $selectedRecipientGroupName
      })
    } else if (this.activePage === '群发历史') {
      BroadcastHistoryPage({ activePage: $activePage, selectedMessageId: $selectedMessageId })
    } else if (this.activePage === '搜索消息') {
      SearchMessagePage({ activePage: $activePage, selectedMessageId: $selectedMessageId })
    } else if (this.activePage === '消息详情') {
      MessageDetailPage({
        activePage: $activePage,
        selectedMessageId: $selectedMessageId,
        detailReturnPage: $messageDetailReturnPage
      })
    } else if (this.activePage === '搜索患者') {
      SearchPatientPage({ activePage: $activePage, cancelReturnPage: this.searchReturnPage })
    } else {
      PatientMainPage({
        activePage: $activePage,
        searchReturnPage: $searchReturnPage,
        currentGroupId: $currentGroupId,
        currentGroupName: $currentGroupName
      })
    }
  }

  @Builder
  private buildTabItem(icon: Resource, label: string) {
    Column({ space: 4 }) {
      Image(icon)
        .width(24)
        .height(24)
        .syncLoad(true)
        .objectFit(ImageFit.Contain)
        .opacity(this.activeTab === label ? 1 : 0.55)
      Text(label)
        .fontSize(14)
        .fontColor(this.activeTab === label ? '#4A74F5' : '#C7C7C7')
    }
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.activeTab = label;
      if (label === '患者') {
        this.activePage = '患者';
      } else if (label === '首页') {
        router.pushUrl({ url: 'pages/HomePages/HomePage' });
      } else if (label === '我的') {
        router.pushUrl({ url: 'pages/Mine/MePage' });
      }
    })
  }
}
