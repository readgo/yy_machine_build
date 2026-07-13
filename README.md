# yy_machine_build

> GitHub Actions 自动构建 Windows portable release & 发布到 GitHub Releases

## 项目说明

本仓库**不含源代码**，仅用于 CI/CD 持续集成。构建流程：

```
打 release tag（GitHub）
    ↓
GitHub Actions（windows-latest runner）
    ↓
从 Gitee（main 分支）克隆源代码
    ↓
JDK 17 + Gradle → Compose Desktop distribution
    ↓
ZIP 打包（便携版，免安装）
    ↓
gh release create → 上传 ZIP 到 GitHub Releases
```

源代码托管在 Gitee: `https://gitee.com/jing1984/yy_machine.git`（`main` 分支）

---

## 触发构建

### 方式一：打标签触发（推荐）

```bash
# 使用脚本
bash scripts/publish-release.sh

# 或手动
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

产物为 ZIP 文件：`YYMachinePrinter_<时间戳>.zip`

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
