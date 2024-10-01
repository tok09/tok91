---
title: "Git 常用命令思维导图"
tag: Git
output: 
  github_document:
    preserve_yaml: true
---


Git 是 Linux 作者 Linus 的一个作品。2002 年他还在使用 Bitkeeper 作为 Linux 内核的版本管理，但因为它是 Copyright 有版权的软件备受质疑，然后 Andrew Tridgell 对 Bitkeeper 进行逆向工程，导致 BitMover 要回收 Linux 开发者的 Bitkeeper 的免费使用权，Linus 一怒之下花了 10 天写出了 Git。

如今 Git 已经成为绝大多数开发者的选择，Tom Preston-Werner、Chris Wanstrath 和 PJ Hyett 在 2007 年 10 月推出的 Github 已经成为了全球最大的开发者网站。

## 代码仓库
创建仓库
进入需要创建代码库的文件夹：cd 文件路径
创建/初始化仓库：git init
拉取远程仓库到本地：git clone
建议使用 git clone

添加文件到仓库
添加文件到暂存区
添加单个文件变化：git add
添加所有文件：git add .
会忽略的文件
.gitignore 中指定的文件会被忽略
空目录
提交到本地仓库：git commit -m "commit message"
不建议使用 git commit -m "commit message"
建议提交遵循 commit message 规范。例如：Angular 的 Git Commit Guidelines
查看工作区状态：git status
对比工作区文件变化：git diff
建议将 beyond compare 配置为 diff 工具，用于 diff 以及 merge 冲突

## 仓库配置
配置全局用户名和邮箱
git config --global user.name "[name]" 比如：git config --global user.name "liam-i"
git config --global user.email "[email address]"
注意：若是个人开发机可以这样配置，若是公共编译机则不能这样配置

## 配置当前仓库的用户名和邮箱
git config user.name "[name]"
git config user.email "[email address]"
代码版本/提交切换
查看过去版本/提交
提交详情：git log
提交简介：git log --pretty=oneline
回退版本/提交
回退到当前最新提交：git reset --hard HEAD
回退到上次提交：git reset --hard HEAD^
回退到上 n 次提交：git reset --hard HEAD～n
回退到某次提交：git reset --hard commitid
重返未来版本
查看历史提交以及被回退的提交：git relog
注意：该记录有时限，且只在本地

回到未来版本：git reset --hard commitid
撤销修改
工作区文件被撤销（没有提交到暂存区/没有 git add）撤销修改：git checkout 文件名
暂存区文件撤销
将暂存区文件撤销到工作区：git reset HEAD 文件 # 不带 --hard
撤销修改：git checkout 文件名
提交到了版本库，参见回退版本/提交
删除文件
从版本库中删除文件：git rm 文件名
恢复删除，参见撤销修改
从版本库中删除文件，但是本地不删除该文件：git rm --cached 文件名
暂存修改
参见分支-暂存修改

忽略文件
通过 git 仓库下的 .gitignore 文件屏蔽某些中间文件/生成文件

注意：这里的版本均为本地仓库版本

分支
创建与操作分支
创建分支
仅创建：git branch 分支名
创建并切换：git branch -b 分支名 或 git switch --create 分支名
注意：在本地仓库操作，创建的都是本地分支

切换分支：git checkout 分支名 或 git switch 分支名
合并分支
git merge 分支名 合并某分支到当前分支
注意：合并分支时禁用 fast forward，git merge --no-ff 分支名

git rebase 若无特殊需求不建议使用
删除分支
删除本地分支
删除未合并分支：git branch -D 分支名
删除已合并分支：git branch -d 分支名
删除远程分支
删除远程分支
git push origin -d 分支名
git push <远程仓库名> -d 分支名
建议界面操作
查看分支
查看当前分支：git branch
查看所有分支信息：git branch -a 本地分支为本地分支名，远程分支为<远程仓库名>/分支名
合并分支，解决冲突
将要合并的分支更新到最新
切换到 main 分支
合并分支
解决合并时的 conflict
提交到版本库
合并成功
查看分支状态
git log --graph
git log --graph --pretty=oneline --abbrey-commit
开发完需要提交 PR/MR，通过 PR/MR 来合并 dev 分支与 main 分支
暂存修改
暂存工作现场：git stash
恢复工作现场
恢复：git stash apply
删除：git stash drop
恢复+删除：git stash pop
多人协作
查看远程库信息
详细：git remote -v
不详细：git remote
删除/关联/修改远程仓库地址
删除：git remote rm 远程仓库名 例如：git remote rm origin
关联：git remote add origin 远程仓库地址
修改：git remote set-url origin 新的远程仓库地址
更新/推送远程库
更新远程库信息：git fetch
将远程库最新修改更新到本地：git pull 可以认为是 git fetch + git merge
将本地修改推送到远程库
git push
git push origin 分支名
本地分支与远程分支交互
使用远程分支 A 创建本地分支
git checkout -b A origin/A，origin 是远程仓库名，若名字一样 origin/A 可以省略
将本地分支与远程分支作关联
git branch --set-upstream A origin/A
提示 no tracking information 错误
建议开发遵循或者参照 git 标准工作流，比如 git flow、github flow 或者 gitlab flow

代码标签
查看 tag
本地 tag：git tag
远程 tag：git tag -r
操作 tag
添加 tag
给当前版本添加 tag：git tag 标签名
给历史版本添加 tag：git tag 标签名 commitid
删除 tag
删除本地 tag：git tag -d 标签名
删除远程 tag：git push origin -d 标签名
推送到远端仓库
git push origin 标签名
推送所有未提交的 tag：git push origin --tags
更新到本地：git pull origin --tags
tag 与 branch 的操作基本一致，因为 tag 就是一个仅可读的 branch

其他生僻命令
git blame，用来追溯一个指定文件的历史修改记录
git bisect，过二分查找定位引入 bug 的变更
git relog，查看历史提交以及被回退的提交
可以使用 git help 查看 git 常用的命令，使用 git help -a 查看 git 可用的所有命令
可以点击 Documentation 查看 git 官方文档
思维导图
![](https://liam-i.github.io/assets/img/tools/git-cmd.png)<!-- -->
Git 常用命令思维导图

## Notes 参考链接
[^1]:原文地址：
      [Git 常用命令思维导图](https://mp.weixin.qq.com/s/Qv4MRF1pMkS9kT28QDjtaw)。
[^2]: 注：
      顶部预览图也来自此地址。
    conventions, I use `analyis/data/derived_data`.
