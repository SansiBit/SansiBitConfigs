# SansiBitConfigs 的自述

作者：[[TsePing Chai](mailto:TsPChai@Outlook.com), SansiBit.com]\
日期：Thu 05 Nov 2020 12:05:20 AM CST\
许可：CC BY-NC-SA 4.0\
规范：SansiBit Guideline Suite V0.0.1

## 摘要

本文主要介绍 SansiBitConfigs 项目的构成和目的，以及基本属性信息。工程方面的信息
详见各自的自述文件中。

## 目录

1.  [简介](#简介)
1.  [理念指导](#理念指导)
1.  [风格选择](#风格选择)
1.  [项目列表](#项目列表)
1.  [安装使用](#安装使用)
1.  [参与贡献](#参与贡献)
1.  [许可证](#许可证)
1.  [历史记录](#历史记录)

## 简介

SansiBitConfigs（下称 “项目” ）是一个集合项目，收集了各类软件的配置文件和配置说
明。项目的初心是为了减少软件配置的错误率，提高功能性和安全性，优化服务性能。这
些配置具有通用性，可以满足一般的需求，并且已经被应用在生产环境中。确定参数的过
程中，主要参考了官方文档，以及必要的专业书籍和大量博客，还需要经过大量功能和性
能测试，最终发布。

## 理念指导

一款成熟的现代软件通常拥有大量的扩展模块和配置参数，对于功能的取舍以及参数的选
择往往让人头大。为了精简配置文件，并提高一致性，项目遵循以下理念：

1.  尊重默认值，如无必要不修改；
1.  默认值优先使用隐式声明；
1.  尽可能减少启用的扩展模块数量。

由此，对于默认值的更改，配置文件中通常以注释的形式保存默认参数，并给出更改的理
由。对于扩展模块的配置参数，应该与核心参数分离，方便用户按需开启。

## 风格选择

不同的软件有不一样的配置风格，主要分为自由派和修正派。自由派的代表是 Apache
HTTP Server，该软件拥有大量配置参数，完全需要使用者根据自己的需求进行自定义；修
正派的代表是 PHP，其提供了原始的配置文件，因此在此基础上进行修改是明智的做法。

## 项目列表

| 编号 | 子项目名 | 路径 |
| --- | --- | --- |
| 1 | GitIgnore | `GitIgnore` |
| 2 | VimEditor | `VimEditor` |

## 安装使用

详见各自的自述文件。

## 参与贡献

1.  邮件通信：[TsPChai@Outlook.com](mailto:TsPChai@Outlook.com)（推荐）
1.  发布平台：[SansiBitConfigs@GitHub](https://GitHub.com/SansiBit/SansiBitConfigs)
1.  开发平台：[SansiBit Phabricator](https://Phabricator.SansiBit.com)
1.  QQ 讨论群：926934137（SansiBit）

## 许可证

*因为项目认为配置文件定义了软件的行为，所以将配置文件看作软件的一部分。*

配置文件的许可证是 AGPLv3，配置说明及其他文档的许可证是 CC BY-NC-SA 4.0，具体以
文件内的声明为准。

## 历史记录

1.  [2020-11-05] [TsePing Chai] CREATE THE FILE AND START A NEW JOURNAL.
1.  [2020-11-14] [TsePing Chai] 增加“项目列表”，列出 SansiBitConfigs 的子项目。
