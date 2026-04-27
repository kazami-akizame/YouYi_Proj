# 患者模块外部跳转说明

本文档说明：**其他页面如何跳转到患者模块，以及如何直接定位到患者模块子页面**。

---

## 1. 总体设计

患者模块采用“**单入口 + 内部子页面状态切换**”模式：

- 外部页面统一跳到：`pages/Patient/Index`
- 患者模块内部通过 `PatientModulePreview.ets` 的 `activePage` 切换子页面
- 外部通过 `router.pushUrl` 的 `params` 传入目标子页面和上下文

---

## 2. 为什么不直接跳子页面文件

`pages/Patient` 下大多数 `.ets` 是组件，不是独立 `@Entry` 页面。  
所以外部不能稳定直接跳 `PatientMainPage.ets`、`PatientDetailPages.ets` 等组件文件。

正确做法是：跳 `pages/Patient/Index`，由 `PatientModulePreview` 接管内部路由。

---

## 3. 已支持的路由参数

`PatientModulePreview.ets` 的 `aboutToAppear()` 会读取以下参数：

- `targetPage`：目标子页面名称（字符串）
- `currentPatientId`：当前患者 ID（数字）
- `currentGroupId`：当前分组 ID（数字）
- `currentGroupName`：当前分组名称（字符串）
- `selectedMessageId`：群发消息 ID（数字）

---

## 4. 外部跳转示例

## 4.1 跳到患者首页

```ts
router.pushUrl({
  url: 'pages/Patient/Index',
  params: {
    targetPage: '患者'
  }
});
```

## 4.2 跳到某个分组页

```ts
router.pushUrl({
  url: 'pages/Patient/Index',
  params: {
    targetPage: '默认分组',
    currentGroupId: 2,
    currentGroupName: '发热门诊'
  }
});
```

## 4.3 跳到某个患者资料页

```ts
router.pushUrl({
  url: 'pages/Patient/Index',
  params: {
    targetPage: '患者资料',
    currentPatientId: 3
  }
});
```

## 4.4 跳到群发消息详情页

```ts
router.pushUrl({
  url: 'pages/Patient/Index',
  params: {
    targetPage: '消息详情',
    selectedMessageId: 5
  }
});
```

---

## 5. `targetPage` 可用值

请与 `PatientModulePreview.ets` 内的 `buildCurrentPage()` 分支保持一致，当前可用值包括：

- `患者`
- `管理分组`
- `默认分组`
- `患者资料`
- `个人信息`
- `编辑姓名`
- `编辑备注`
- `编辑个人年龄`
- `修改分组`
- `新建群发`
- `选择患者`
- `我的患者`
- `群发历史`
- `搜索消息`
- `消息详情`
- `搜索患者`

---

## 6. 维护建议

1. 新增患者子页面时，同步更新：
   - `PatientModulePreview.ets` 的 `buildCurrentPage()`
   - 本文档的 `targetPage` 列表
2. 外部页面统一只跳 `pages/Patient/Index`，不要直接跳内部组件文件。
3. 需要跨页定位患者/分组时，优先使用 `currentPatientId`、`currentGroupId` 参数。

