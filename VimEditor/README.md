# VimEditor

*   作者：[[TsePing Chai](mailto:TsPChai@Outlook.com), SansiBit.com]
*   日期：Fri 12 Mar 2021 12:26:05 AM CST
*   许可：CC BY-NC-SA 4.0

**【摘要】** 本文简要介绍 VimEditor 的定位和组成，提供项目的安装方法，并附有一
份包含组合键列表的功能清单。

## 目录

1.  [项目简介](#项目简介)
1.  [安装方法](#安装方法)
1.  [功能清单](#功能清单)
    1.  [文件模板](#文件模板)
    1.  [通用组合键](#通用组合键)
    1.  [特殊组合键](#特殊组合键)

## 项目简介

VimEditor 作为 SansiBitConfigs 的一个子项目，维护了一份 Vim 编辑器的配置文件。
配置文件主要面向轻量级的编辑场景，比如服务器上的文件修改，COMMIT_MESSAGE 的编辑
等等。Vim 本身是一个古老而强大的编辑器，具有极强的可定制性，配合其他第三方插件
完全可以配置出一个功能丰富的 IDE，但是这不在本项目的计划之内。

文件主要分为两个部分：一、编辑器的核心配置；二、文件模板。核心配置还可分为 *默
认参数集*（文件类型无关）、*核心参数集*（文件类型相关）。另外，文件还定义了一些
常用的字符映射，比如将 `(` 映射成 `()`。具体的实现请参考函数：

*   默认参数集：`TurnDefaultConfigsOn()`；
*   核心参数集：`TurnCoreConfigsOn()`。

## 安装方法

**第一步：** 下载最新版本的 `VimEditor.vim`。

**第二步：** 将 `VimEditor.vim` 中的所有文本复制粘贴到 Vim 的配置文件尾部。在不
同的Linux发行版中，配置文件的路径也可能不同：

*   `/etc/vimrc`（比如 Fedora、RHEL 等）；
*   `/etc/vim/vimrc`（比如 Debian、Ubuntu 等）；
*   `~/.vimrc`（用户的本地配置文件）。

**第三步：** 配置自己的用户信息：

*   `g:user_company`：公司名或网站；
*   `g:user_name`：用户名；
*   `g:user_email`：邮箱地址。

## 功能清单

### 文件模板

使用 Vim 创建指定文件类型的新文件，会应用定义好的文件模板。

| 类别 | 文件后缀 |
| --- | --- |
| Plain Text | `*.md`，`*.txt` |
| C/C++ | `*.c`，`*.h`，`*.cc`，`*.cpp`，`*.cxx`，`*.hpp`，`*.hxx` |
| Configuration | `*.conf`，`*.ini` |
| VimScript | `*.vim` |
| JSON | `*.json` |
| TeX | `*.tex`，`*.ltx` |

### 通用组合键

组合键统一使用英文冒号 `;` 作为 `<Leader>`。

*   `<Leader><C-D>`：打开或关闭默认的配置，默认打开。
*   `<Leader><C-A>`：打开或关闭核心的配置，在特定文件类型中默认开启。
*   `<Leader><C-W>`：在 `formatoptions` 中增加或删除 `w` 选项，状态栏同步更新。
*   `<Leader><C-T>`：在当前位置插入格式为 `%Y-%m-%d` 的当前日期。

### 特殊组合键

*特殊组合键* 指在部分文件类别中有效组合键。

| 组合键 | 文件类别 | 描述 |
| --- | --- | --- |
| `<Leader><C-I>` | Plain Text | 插入一项 Markdown 的目录。 |
| `<Leader><C-F>` | C/C++，VimScript | 插入函数注释。|
| `<Leader><C-K>` | C/C++，VimScript，Configuration，TeX | 注释或反注释当前行。 |
