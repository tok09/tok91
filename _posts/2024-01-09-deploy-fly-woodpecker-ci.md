---
title: "使用 Woodpecker CI 部署 Fly 应用程序"
---

这篇文章介绍了如何使用开源持续集成引擎Woodpecker设置到fly.io 的持续部署。Fly 文档包含有关如何使用 GitHub Actions和GitLab CI/CD设置持续部署的说明，但我找不到有关 Woodpecker 的任何信息。幸运的是，该过程与使用 GitLab CI/CD 进行设置几乎相同，因此我可以通过遵循该教程并进行微小更改来弄清楚。

我的用例是从Codeberg存储库部署，但以下说明也适用于Woodpecker 支持的任何 forge（目前是 GitHub、Gitea、Forgejo、GitLab 和 Bitbucket）。

## 将你的存储库连接到 Woodpecker永久链接
首先，您需要访问 Woodpecker 实例。只要您打算将其用于公开的、自由许可的代码， Codeberg 用户可以请求访问托管版本。否则，您可以自行托管它。Woodpecker 附带 Web 界面和命令行界面。您可以使用用户设置 → API下显示的个人访问令牌将 CLI 连接到您的 Woodpecker 实例。

一旦 Woodpecker 启动并运行，请为要部署的存储库fly.toml（即包含配置文件的存储库）激活它。请确保在项目设置中禁用“允许拉取请求”，否则任何可以发出拉取请求的人都可以访问您的 Fly 机器！

## 创建工作流文件永久链接
在您的存储库中创建.woodpecker/deploy.yml以下内容：
```yml
steps:
  deploy:
    image: golang
    commands:
      - apt-get update -qq && apt-get install -y curl
      - curl -L https://fly.io/install.sh | sh
      - /root/.fly/bin/flyctl deploy
    secrets: [ fly_access_token ]
```
这将设置一个“部署”工作流程，该工作流程下载一个 shell 脚本来安装 fly，然后运行flyctl deploy。基础镜像的选择是任意的，因为我们真正需要安装的只是 curl 和 bash。

## 设置 Fly 访问令牌永久链接
为了从 Woodpecker 创建的容器安全地部署，我们需要以某种方式使用 Fly 进行身份验证，以使凭据不会泄漏到（公共）CI 日志中。为此，我们将生成一个唯一的访问令牌，并使用 Woodpecker 的机密存储将其作为环境变量传递到容器中。

首先，使用 Fly 网页界面或命令行生成一个新的部署令牌：
```sh
flyctl tokens create deploy -n woodpecker
```
最好为 woodpecker 部署使用专用令牌，这样如果需要，您可以撤销它而不会影响您可能拥有的任何其他集成。您可能还想使用该-x选项设置更短的到期时间（默认值为二十年）。现在将您新生成的密钥复制或保存到某处，因为它只显示一次。

接下来，创建一个名为fly_access_token包含访问令牌的 secret。您可以使用 Woodpecker Web 界面或命令行执行此操作：
```sh
woodpecker secret add -name fly_access_token -event push -event manual -repository <your_repository> -value '<your_access_token>'
```
请注意，我们仅当工作流由授权贡献者向存储库推送信息触发或由有权访问 Woodpecker CI 的人员手动运行时才提供该密钥。您的用法可能有所不同，但您可能不应该在拉取请求中提供该密钥，否则粗心或恶意的拉取请求可能会泄露您的访问令牌。

## 部署永久链接
就是这样！当您将这些更改推送到远程存储库时，Woodpecker 应立即部署到 Fly。您可以在 Woodpecker CI Web 界面中监视部署状态。在 Woodpecker 存储库设置的Badge下，您还会找到一个徽章，您可以将其添加到 README 中以显示上次部署的状态。

!['Success' status badge from Woodpecker CI](/images/pipeline_success.svg)
