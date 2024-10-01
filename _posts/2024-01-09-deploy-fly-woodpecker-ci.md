---
title: "Deploy a Fly app with Woodpecker CI"
---

This post describes how to set up continuous deployment to [fly.io](https://fly.io) using [Woodpecker](https://woodpecker-ci.org/), an open source continuous integration engine.
The Fly documentation includes instructions on how to set up continuous deployment [with GitHub Actions](https://fly.io/docs/app-guides/continuous-deployment-with-github-actions/) and [with GitLab CI/CD](https://fly.io/blog/continuous-deployment-with-gitlab/), but I couldn't find anything for Woodpecker.
Fortunately, the process is almost identical to setting it up with GitLab CI/CD, so I could figure it out by following along that tutorial and making minor changes.

My use case was to deploy from a [Codeberg](https://codeberg.org) repository, but the instructions below should also work for any [forge supported by Woodpecker](https://woodpecker-ci.org/docs/administration/forges/overview) (currently GitHub, Gitea, Forgejo, GitLab, and Bitbucket).

## Connect your repository to Woodpecker

First things first, you'll need access to a Woodpecker instance.
Codeberg users can [request access](https://codeberg.org/Codeberg-e.V./requests) to a hosted version, as long as you intend to use it for public, freely-licensed code.
Otherwise you can [self-host it](https://woodpecker-ci.org/docs/administration/deployment/overview).
Woodpecker come with both a web interface and a [command line interface](https://woodpecker-ci.org/docs/cli).
You can connect the CLI to your Woodpecker instance using the personal access token displayed under *User Settings &rarr; API*.

Once you have Woodpecker up and running, [activate it for the repository](https://woodpecker-ci.org/docs/usage/intro) that you want to deploy, i.e. the one that contains your `fly.toml` configuration file.
Be sure to **disable 'Allow Pull Requests'** in the project settings, otherwise anybody who can make a pull request will have access to your Fly machines!

## Create a workflow file

Create `.woodpecker/deploy.yml` in your repository with the following contents:

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

This sets up a 'deploy' workflow which downloads a shell script to install fly, then runs `flyctl deploy`.
The choice of base image is arbitrary since all we really need installed is curl and bash.

## Set up a Fly access token

In order to deploy securely from the container created by Woodpecker, we need to authenticate with Fly in such a way that the credentials do not leak into the (public) CI logs.
To do this, we will generate a unique access token and pass it into the container as an environment variable using Woodpecker's [secrets store](https://woodpecker-ci.org/docs/usage/secrets).

First, generate a new deploy token using the Fly web interface or command line:

```sh
flyctl tokens create deploy -n woodpecker
```

It's a good idea to use a dedicated token for woodpecker deployments, so if you need to you can revoke it without affecting any other integrations you might have.
You might also want to set a shorter expiry time with the `-x` option (the default is twenty years).
Copy or save your newly generated secret somewhere now, because it's only shown once.

Next, create a secret named `fly_access_token` that contains your access token.
You can do this using the Woodpecker web interface or the command line:

```sh
woodpecker secret add -name fly_access_token -event push -event manual -repository <your_repository> -value '<your_access_token>'
```

Note that we only make the secret available when the workflow is triggered by a push from an authorised contributor to the repository or run manually by somebody with access to Woodpecker CI.
Your usage might vary, but you probably should not make it available on pull requests, otherwise a careless or malicious pull request could leak your access token.

## Deploy

That's it!
When you push these changes to your remote repository, Woodpecker should immediately deploy to Fly.
You can monitor the status of the deployment in the Woodpecker CI web interface.
In the Woodpecker repository settings, under *Badge*, you'll also find a badge that you can add to your README to show the status of the last deployment.

!['Success' status badge from Woodpecker CI](/images/pipeline_success.svg)
