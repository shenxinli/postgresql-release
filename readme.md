# GitHub Actions 下载并发布 PostgreSQL 安装包

## 简介
本项目利用 GitHub Actions 实现自动下载指定版本、平台和架构的 PostgreSQL 安装包，并将其重命名后上传至 GitHub Release，便于用户获取所需的 PostgreSQL 资源。

## 功能特性
- **多版本支持**：支持 PostgreSQL 10、12、14、16 版本。
- **多平台适配**：涵盖 Linux、Windows 平台。
- **多架构兼容**：适配 amd64、arm64 架构。
- **自动化流程**：自动重命名安装包（如 `postgresql-12-linux-amd64.tar.gz` 、`postgresql-10-windows-x64.zip` ）并上传至 GitHub Release。
- **参数化配置**：通过手动触发工作流，灵活配置版本号、平台、架构、Release 标签和名称等参数。

## 使用步骤
1. **访问仓库**：进入 GitHub 仓库页面。
2. **选择工作流**：点击进入 **Actions** 选项卡，找到 **Download and Upload PostgreSQL** 工作流。
3. **触发工作流**：点击 **Run workflow** 按钮。
4. **填写参数**：
    - **versions**：需下载的 PostgreSQL 版本号，多个版本号以逗号分隔，例如 `10,12,14,16` 。
    - **platforms**：目标平台，可选 `linux` 或 `windows` ，多个平台以逗号分隔，如 `linux,windows` 。
    - **architectures**：目标架构，可选 `amd64` 或 `arm64` ，多个架构以逗号分隔，如 `amd64,arm64` 。
    - **release_tag**：Release 的标签，例如 `v1.0.0` 。
    - **release_name**：Release 的名称，例如 `PostgreSQL Binaries Release` 。
5. **执行工作流**：填写完参数后，点击 **Run workflow** 开始执行。

## 查看结果
工作流执行结束后：
- 会在 **Releases** 页面创建一个新的 Release。
- Release 中包含按指定规则命名的 PostgreSQL 安装包，可直接下载使用。

## 注意事项
1. 确保仓库中已配置好 `GITHUB_TOKEN` ，该令牌用于创建 Release 和上传安装包，由 GitHub 自动提供，无需手动创建。
2. 若某个版本、平台和架构组合的安装包下载失败，工作流会跳过该组合，继续处理其他组合，不会导致整个工作流失败。
3. 手动触发工作流时，请务必确保填写的参数符合要求，否则可能导致工作流执行错误。 


