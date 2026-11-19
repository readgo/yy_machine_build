# yy_machine_build

> GitHub Actions 自动构建 Windows portable release & 发布到 GitHub Releases

## 项目说明

本仓库**不含源代码**，仅用于 CI/CD 持续集成。构建流程：

```
打 release tag（GitHub）
    ↓
GitHub Actions（windows-latest runner）
    ↓
从 Gitee（master 分支）克隆源代码
    ↓
JDK 17 + Gradle → Compose Desktop distribution
    ↓
ZIP 打包（便携版，免安装）
    ↓
gh release create → 上传 ZIP 到 GitHub Releases
```

源代码托管在 Gitee: `https://gitee.com/jing1984/yy_machine.git`（`master` 分支）

---

## 触发构建

### 方式一：打标签触发（推荐）

```bash
# 使用脚本（在任意目录执行都可以，脚本会自己切到本仓库根）
bash yy_machine_build/scripts/publish-release.sh

# 或手动（须在本仓库根目录内执行）
git tag release-<年月日时分秒>
git push origin release-<年月日时分秒>
```

示例：

```bash
git tag release-20260713153000
git push origin release-20260713153000
```

标签以 `release-` 开头才会触发，推荐接年月日时分秒作为唯一标识。

### 方式二：手动触发

GitHub 页面 → Actions → **Build Windows Portable & Release** → **Run workflow** → 填写参数 → 点击 Run

---

## 查看构建状态

```
https://github.com/readgo/yy_machine_build/actions
```

---

## 查看构建产物

每次发布对应的 Release 页面：

```
https://github.com/readgo/yy_machine_build/releases
```

产物为 ZIP 文件，命名与 yy-light 统一：

```
yy-printer-windows-<架构>-v<版本>.zip
例：yy-printer-windows-x86_64-v1.0.0.zip
```

### 版本号怎么走

| 环节 | 行为 |
|---|---|
| 版本来源 | 源码 `apps/appPrinter/config/prod.properties` 的 `app.version.name`，唯一一处 |
| 构建 | 直接用它拼产物名，不带时间戳 |
| 构建成功 | 最后一步把 patch + 1（`1.0.0` → `1.0.1`）写回源码仓并推送到 `master` |
| 构建失败 | 不写回，版本号不消耗，下次仍用同一个号 |

- 架构取 CI runner 的 `RUNNER_ARCH`（`X64` → `x86_64`）
- tag 仍是 `release-<年月日时分秒>`，只作构建触发与批次标识，不参与版本号
- **写回依赖 `GITEE_TOKEN` 有 `yy_machine` 的写权限**；若只有读权限，这步会标红失败
- 本地改完 `prod.properties` 后推送前需先 `git pull`，否则会被 CI 的版本提交挡住

---

## GitHub Secrets（需配置）

以下 2 个密钥需在 GitHub 仓库 Settings → Secrets and variables → Actions 中配置：

| Secret | 说明 |
|--------|------|
| `GITEE_USERNAME` | Gitee 用户名 |
| `GITEE_TOKEN` | Gitee Personal Access Token |

配置位置：

```
https://github.com/readgo/yy_machine_build/settings/secrets/actions
```

---

## 本地测试构建

在 Windows 机器上：

```bash
git clone https://gitee.com/jing1984/yy_machine.git
cd yy_machine
package-prod-portable.bat
```

打包产物在 `apps/appPrinter/build/compose/binaries/main/app/YYMachinePrinter/`
