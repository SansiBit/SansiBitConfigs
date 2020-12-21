# VimEditor 的自述

作者：[[TsePing Chai](mailto:TsPChai@Outlook.com), SansiBit.com]\
日期：Tue 15 Dec 2020 12:30:55 AM CST\
许可：CC BY-NC-SA 4.0\
规范：SansiBit Guideline Suite V0.0.1

## 摘要

本文首先要声明 VimEditor 项目的定位，然后再介绍安装使用方法，最后会有一份功能清
单表，包括快捷键的列表。

## 目录

1.  [简介](#简介)
1.  [安装方法](#安装方法)
1.  [使用方法](#使用方法)
    1.  [通用组合键](#通用组合键)
    1.  [其他组合键](#其他组合键)
    1.  [文件模板](#文件模板)
1.  [历史记录](#历史记录)

## 简介

VimEditor 是 SansiBitConfigs 的一个子项目，用于维护一个轻量级的 Vim 编辑器配置
文件。本项目定位在服务器终端以及 WSL 终端。因此，项目维护的配置文件（也可以看作
是一个插件）提供了一个体验良好的文本编辑器，比较适合用来修改配置文件，临时修改
代码源文件等等。VIM 是一个古老而强大的编辑器，具有极强的可定制性，配合其他插件
完全可以配置出一个功能丰富的 IDE，但是这不在本项目的目标之内。

## 安装方法

将 `VimEditor.vim` 中的所有文本复制到 VIM 的配置文件中。通常位于
`/etc/vimrc`，`/etc/vim/vimrc`，或 `~/.vimrc`。

用户还应该配置自己的用户信息：

1.  `g:user_company`：用户的公司名或网址；
1.  `g:user_name`：用户的用户名；
1.  `g:user_email`：用户的邮箱地址。

## 使用方法

配置文件使用 `;` 作为 `<Leader>`。

### 通用组合键

1.  `<Leader><C-D>`：打开或关闭默认的配置，默认打开。
1.  `<Leader><C-A>`：打开或关闭核心的配置，在特定文件类型中默认开启。
1.  `<Leader><C-W>`：在 `formatoptions` 中增加或删除 `w` 选项，状态栏同步更新。
1.  `<Leader><C-T>`：在当前位置插入格式 `%Y-%m-%d` 的当前日期。

### 其他组合键

| 组合键 | 文件类型 | 描述 |
| --- | --- | --- |
| `<Leader><C-I>` | `*.md`，`*.txt` | 插入一项 Markdown 的目录。 |
| `<Leader><C-F>` | C/C++，VimScript | 插入函数注释。|
| `<Leader><C-K>` | C/C++，VimScript，`*.conf`，`*.ini`，TeX | 注释或反注释当前行。 |

### 文件模板

本项目提供了符合《SansiBit Guideline Suite V0.0.1》的文件模板。

| 类别 | 文件后缀 |
| --- | --- |
| Plain Text | `*.md`，`*.txt` |
| C/C++ | `*.c`，`*.h`，`*.cc`，`*.cpp`，`*.cxx`，`*.hpp` |
| Configuration | `*.conf`，`*.ini` |
| VimScript | `*.vim` |
| TeX | `*.tex` |

## 历史记录

1.  [2020-12-15] [TsePing Chai] CREATE THE FILE AND START A NEW JOURNAL.
