# 患者模块后端总结（ArkTS）

这个目录是患者模块在鸿蒙端的“后端化实现”（本地业务层），核心目标是：

- 给 `pages/Patient` 提供统一的数据读写能力
- 把页面 UI 和数据逻辑分离（页面调 Service，不直接操作数据）
- 支持演示模式下稳定可见（即使数据库异常也有内存兜底）

---

## 目录结构

```text
entry/src/main/ets/backend/
└─ patient/
   ├─ model/
   │  └─ PatientEntities.ets
   ├─ repository/
   │  ├─ PatientRepository.ets
   │  └─ MemoryPatientRepository.ets
   ├─ service/
   │  ├─ PatientService.ets
   │  └─ BroadcastService.ets
   └─ database/
      └─ PatientDatabaseBootstrap.ets
```

---

## 每个文件是做什么的

## `patient/model/PatientEntities.ets`

定义患者模块的数据实体（模型层）：

- `PatientEntity`：患者基础信息（姓名、性别、年龄、地区、备注等）
- `PatientGroupEntity`：患者分组
- `PatientGroupSummary`：分组统计（分组 + 人数）
- `PatientProfileAggregate`：患者资料聚合（患者 + 分组 + 问诊记录）
- `BroadcastMessageEntity`：群发消息（内容、时间、接收人ID）

用途：统一数据结构，供 Repository 和 Service 共用。

---

## `patient/repository/PatientRepository.ets`

仓储层接口定义（“应该具备哪些数据能力”）：

- 分组列表/分组统计查询
- 按分组查询患者、全量患者、搜索患者
- 查询患者资料、更新患者基础信息
- 查询/更新患者所属分组
- 查询群发历史等

用途：约束数据访问能力，便于后续把内存实现替换为数据库实现。

---

## `patient/repository/MemoryPatientRepository.ets`

`PatientRepository` 的内存实现（当前患者模块的主要数据源）：

- 初始化患者/分组/分组关系
- 复用 `ConsultationData.ets` 的 `MockDataGenerator` 生成问诊相关数据
- 提供搜索、分组过滤、患者资料聚合
- 提供患者基础信息更新、分组关系更新
- 提供群发历史内存数据

用途：演示与开发联调时快速稳定运行，不依赖外部服务。

---

## `patient/service/PatientService.ets`

患者业务服务层（页面调用入口）：

- 封装分组统计、分组患者查询、患者资料查询
- 封装个人信息修改（姓名/年龄/性别/地区/备注）
- 封装分组修改逻辑（更新患者所属分组）

用途：给 `pages/Patient` 页面提供简洁 API，避免页面直接依赖仓储细节。

---

## `patient/service/BroadcastService.ets`

群发业务服务层：

- 群发历史列表/搜索/详情查询
- 创建群发消息并写入历史
- 查询消息接收人
- 演示模式下“内存历史优先”，确保发送后立即可见
- 数据库失败时自动降级到内存兜底

用途：保证“新建群发 -> 群发历史 -> 消息详情”链路稳定可用。

---

## `patient/database/PatientDatabaseBootstrap.ets`

数据库初始化入口（`relationalStore`）：

- 初始化 `patient_module.db`
- 建表：`broadcast_message`、`broadcast_recipient`
- 注入群发历史种子数据（不少于 5 条）

用途：为群发模块提供本地持久化能力；同时配合 `BroadcastService` 的兜底机制提升稳定性。

---

## 当前数据流（简版）

页面调用路径：

`pages/Patient/* -> PatientService/BroadcastService -> Repository -> (Memory / relationalStore)`

其中：

- 患者资料、分组、个人信息当前主要走 `MemoryPatientRepository`
- 群发历史支持 `relationalStore + 内存兜底`

---

## 你们后续维护建议

1. 如果要“完全数据库化”，下一步优先把患者相关表（patient/group/rel）落到 `relationalStore`。  
2. 保留 `PatientRepository` 接口不变，只替换实现，页面层无需大改。  
3. 演示场景建议保留兜底逻辑，避免预览环境差异影响展示。  

---

如果后续你需要，我可以再补一份 `backend/API-Style-Doc.md`，把每个 Service 方法的入参/出参/调用页面做成表格版说明，方便团队交接。
