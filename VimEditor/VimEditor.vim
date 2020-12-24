" SansiBitConfigs.VimEditor - EXPLORING WITH FUN!
" Copyright (C) 2020  TsePing Chai, SansiBit.com
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU Affero General Public License as
" published by the Free Software Foundation, either version 3 of the
" License, or (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU Affero General Public License for more details.
"
" You should have received a copy of the GNU Affero General Public License
" along with this program.  If not, see <https://www.gnu.org/licenses/>.

" 作者：[TsePing Chai](TsPChai@Outlook.com, SansiBit.com)
" 日期：Sun 15 Nov 2020 04:04:01 AM CST
" 规范：SansiBit Guideline Suite V0.0.1
" 描述：Vim Editor 的配置文件，包含核心配置参数，以及一些文件的模板。
" 配置文件将与 PuTTY，WSL，Terminal 兼容，但是没有在 GUI 界面做测试。

" 0. [2020-11-15] [TsePing Chai] CREATE THE FILE AND START A NEW JOURNAL.
" 1. [2020-11-28] [TsePing Chai] 将 GenericConfigs() 分离成 DefaultConfigs() 和
"    CoreConfigs()，同时也将 ResetGenericConfigs() 配套分离。
" 2. [2020-11-29] [TsePing Chai] 设置 showtabline 为始终显示。
" 3. [2020-11-30] [TsePing Chai] 设置 <Leader> 键，并简化快捷键。
" 4. [2020-12-01] [TsePing Chai] 增加 InsertTextAtCurrentPosition() 函数；
"    增加 formatoptions 的状态提示；增加插入当前时间的快捷方式。
" 5. [2020-12-01] [TsePing Chai] 增加纯文本的文件模板和配置。
" 6. [2020-12-02] [TsePing Chai] 增加自动补全各种括号的功能。
" 7. [2020-12-03] [TsePing Chai] 添加常用文件类型的模板。
" 8. [2020-12-14] [TsePing Chai] 增加单行注释和反注释的功能。
" 9. [2020-12-15] [TsePing Chai] T26：修复 PlainText 和 C/C++ 配置错误。
" 10. [2020-12-25] [TsePing Chai] T31：使用标签打开多个文件，可以正确应用配置。

if (has("autocmd"))
    autocmd BufRead,BufNewFile,TabEnter * call DefaultConfigsSwitcher(1)

    autocmd BufNewFile *.txt,*.md call CreatePlainTextFileConfigs()
    autocmd BufRead,BufNewFile *.txt,*.md call PlainTextConfigs()
    autocmd TabEnter *.txt,*.md call CoreConfigsSwitcher(1)

    autocmd BufNewFile *.h call CreateANSICHeaderFileConfigs()
    autocmd BufNewFile *.hpp call CreateCPlusPlusHeaderFileConfigs()
    autocmd BufNewFile *.c,*.cc,*.cpp,*.cxx call CreateCAndCPlusPlusSrcFileConfigs()
    autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.cxx,*.hpp call ANSICAndCPlusPlusConfigs()
    autocmd TabEnter *.c,*.h,*.cc,*.cpp,*.cxx,*.hpp call CoreConfigsSwitcher(1)

    autocmd BufNewFile *.conf call CreateConfFileConfigs()
    autocmd BufRead,BufNewFile *.conf call ConfConfigs()
    autocmd BufNewFile *.ini call CreateIniFileConfigs()
    autocmd BufRead,BufNewFile *.ini call IniConfigs()
    autocmd TabEnter *.ini call CoreConfigsSwitcher(1)

    autocmd BufNewFile *.vim call CreateVimScriptFileConfigs()
    autocmd BufRead,BufNewFile *.vim call VimScriptConfigs()
    autocmd TabEnter *.vim call CoreConfigsSwitcher(1)

    autocmd BufNewFile *.tex call CreateTeXFileConfigs()
    autocmd BufRead,BufNewFile *.tex call TeXConfigs()
    autocmd TabEnter *.tex call CoreConfigsSwitcher(1)
endif

let mapleader = ";"
nnoremap <Leader><C-D> :call DefaultConfigsSwitcher(-1)<CR>
nnoremap <Leader><C-A> :call CoreConfigsSwitcher(-1)<CR>
nnoremap <Leader><C-W> :call FormatOptionsSwitcher(-1)<CR>
nnoremap <Leader><C-T> :call InsertTextAtCurrentPosition(strftime("%Y-%m-%d"))<CR>

" 用户的基本信息
let g:user_company  = "SansiBit.com"
let g:user_name     = "TsePing Chai"
let g:user_email    = "TsPChai@Outlook.com"

" 全局变量。
let g:default_configs_switcher  = 0
let g:core_configs_switcher     = 0
let g:format_options_switcher   = 0
let g:tabstop   = 4
let g:textwidth = 79

" 函数：DefaultConfigsSwitcher
" 参数：switcher_tag: 1 表示强制开启；0 表示强制关闭，-1 表示自动匹配。
" 返回：N/A
" 异常：N/A
" 描述：开启或重置 DefaultConfigs 配置。
function DefaultConfigsSwitcher(switcher_tag)
    if (a:switcher_tag == 1)
        call TurnDefaultConfigsOn()
        let g:default_configs_switcher = 1
    elseif (a:switcher_tag == 0)
        call TurnDefaultConfigsOff()
        let g:default_configs_switcher = 0
    elseif (a:switcher_tag == -1)
        if (g:default_configs_switcher == 0)
            call TurnDefaultConfigsOn()
            let g:default_configs_switcher = 1
        elseif (g:default_configs_switcher == 1)
            call TurnDefaultConfigsOff()
            let g:default_configs_switcher = 0
        endif
    endif
endfunction

" 函数：CoreConfigsSwitcher
" 参数：switcher_tag: 1 表示强制开启；0 表示强制关闭，-1 表示自动匹配。
" 返回：N/A
" 异常：N/A
" 描述：开启或重置 CoreConfigs 配置。
function CoreConfigsSwitcher(switcher_tag)
    if (a:switcher_tag == 1)
        call TurnCoreConfigsOn(g:tabstop, g:textwidth)
        let g:core_configs_switcher = 1
    elseif (a:switcher_tag == 0)
        call TurnCoreConfigsOff()
        let g:core_configs_switcher = 0
    elseif (a:switcher_tag == -1)
        if (g:core_configs_switcher == 0)
            call TurnCoreConfigsOn(g:tabstop, g:textwidth)
            let g:core_configs_switcher = 1
        elseif (g:core_configs_switcher == 1)
            call TurnCoreConfigsOff()
            let g:core_configs_switcher = 0
        endif
    endif
endfunction

" 函数：FormatOptionsSwitcher
" 参数：switcher_tag: 1 表示强制开启；0 表示强制关闭，-1 表示自动匹配。
" 返回：N/A
" 异常：N/A
" 描述：formatoptions 是否加入 w 参数，formatoptions 初始值是有 w 参数的。
function FormatOptionsSwitcher(switcher_tag)
    if (a:switcher_tag == 1)
        set formatoptions-=w
        let g:format_options_switcher = 1
    elseif (a:switcher_tag == 0)
        set formatoptions+=w
        let g:format_options_switcher = 0
    elseif (a:switcher_tag == -1)
        if (g:format_options_switcher == 0)
            set formatoptions-=w
            let g:format_options_switcher = 1
        elseif (g:format_options_switcher == 1)
            set formatoptions+=w
            let g:format_options_switcher = 0
        endif
    endif
endfunction

" 函数：FormatOptionsStatus
" 参数：N/A
" 返回：如果 formatoptions 带有“w”，返回“,+W”，否则返回“,-W”。
" 异常：N/A
" 描述：formatoptions 是否加入 w 参数。
function FormatOptionsStatus()
    if (g:format_options_switcher == 0)
        return ",+W"
    else
        return ",-W"
    endif
endfunction

" 函数：TurnDefaultConfigsOn
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：该函数配置的参数适用所有文件类型。
function TurnDefaultConfigsOn()
    " 如果发现文件在 Vim 之外修改过而在 Vim 里面没有的话，自动重新读入。
    let &autoread = 1

    " xterm             PuTTY Xshell Terminal
    " xterm-256color    WSL
    " 因为 Vim 将上述终端的 'background' 默认设置为 light，效果不佳，
    " 所以改为 dark 以更好地显示文本色彩。
    if (&term == "xterm" || &term == "xterm-256color")
        let &background = "dark"
    endif

    " 在一行开头按退格键如何处理，这里使用 defaults.vim 的设置。
    let &backspace  = "indent,eol,start"

    " 本选项指示补全的类型和需要扫描的位置。
    let &complete = ".,w,b,u,t,i,d"
    " 插入模式补全使用的选项
    let &completeopt = "menu,preview,noselect"
    if (has("autocmd"))
        autocmd InsertCharPre * call AutoOpenCompleteList()
    endif
    inoremap <Tab> <C-R>=UsingTableComplete()<CR>
    if (&t_Co > 2)
        highlight Pmenu ctermfg=Black ctermbg=Cyan
        highlight PmenuSel ctermfg=White ctermbg=Blue
    endif

    " 一些通常因为缓冲区有未保存的改变而失败的操作，
    " 会弹出对话框，询问你是否想保存当前文件。
    let &confirm = 1

    " 用 CursorLine hl-CursorLine 高亮光标所在的文本行。用于方便定位光标。
    let &cursorline = 1
    if (&t_Co > 2)
        highlight CursorLine ctermfg=White ctermbg=Blue
    endif

    " 设置 Vim 内部使用的字符编码。
    if (&encoding != "utf-8")
        let &encoding = "utf-8"
    endif

    " 这是一个字符编码的列表，开始编辑已存在的文件时，参考此选项。
    if (&fileencodings != "ucs-bom,utf-8,default,latin1")
        let &fileencodings = "ucs-bom,utf-8,default,latin1"
    endif

    " 描述自动排版如何进行的字母序列。
    " t 使用 ’textwidth’ 自动回绕文本
    " c 使用 ’textwidth’ 自动回绕注释，自动插入当前注释前导符。
    " q 允许 "gq" 排版时排版注释。
    " a 自动排版段落。每当文本被插入或者删除时，段落都会自动进行排版。
    " n 在对文本排版时，识别编号的列表。
    " m 可以在任何值高于 255 的多字节字符上分行。
    " M 在连接行时，不要在多字节字符之前或之后插入空格。
    " 1 不要在单字母单词后分行。如有可能，在它之前分行。
    " j 在合适的场合，连接行时删除注释前导符。
    " p 不在句号后的单个空白上断行。
    " w 行尾的空格指示下一行继续同一个段落，非空白字符结束的行结束一个段落。
    let &formatoptions = "t,c,q,a,n,m,M,1,j,p,w"

    " 如果有上一个搜索模式，高亮它的所有匹配。
    let &hlsearch = 1
    " 搜索模式里忽略大小写。也用于标签文件的查找。
    let &ignorecase = 1
    " 输入搜索命令时，显示目前输入的模式的匹配位置。
    let &incsearch = 1
    " 如果搜索模式包含大写字符，不使用 ’ignorecase’ 选项。
    let &smartcase = 1

    " 本选项的值影响最后一个窗口何时有状态行。
    let &laststatus = 2
    " 如果非空，本选项决定状态行的内容。
    " %f：缓冲区的文件路径，保持输入的形式或相对于当前目录。
    " %M：修改标志位，文本是 ",+" 或 ",-"。
    " %R：只读标志位，文本是 ",RO"。
    " %H：帮助缓冲区标志位，文本是 ",HLP"。
    " %W：预览窗口标志位，文本是 ",PRV"。
    " %Y：缓冲区的文件类型，如 ",VIM"。
    " %=：左对齐和右对齐项目之间的分割点。不能指定宽度域。
    " %B：同上，以十六进制表示。
    " %l：行号。
    " %L：缓冲区里的行数。
    " %c：列号。
    " %P: 行数计算在文件位置的百分比，如同 CTRL-G 给出的那样。
    let l:statusline_array = [
    \   "%f", "%M", "%R", "%H", "%W", "%Y",
    \   "%{FormatOptionsStatus()}",
    \   "\ (%{strftime(\"%Y-%m-%d\ %T\", getftime(expand(\"%:p\")))})",
    \   "%=",
    \   "0x%B", "\ %l/%L", "\ %c", "\ %P"
    \]
    let &statusline = join(l:statusline_array, "")

    " 允许使用鼠标。
    let &mouse = "a"

    " 在每行前面显示行号。
    let &number = 1
    " 在每行前显示相对于光标所在的行的行号。
    let &relativenumber = 1

    " 每个窗口都有自己的标尺。如果窗口有状态行，标尺在那里显示。
    let &ruler = 1

    " 光标上下两侧最少保留的屏幕行数。
    let &scrolloff = 5

    " 本选项有助于避免文件信息的所有 hit-enter 提示，
    " 它还用于避免或减少一些其它消息。
    let &shortmess = "atToOc"

    " 在屏幕最后一行显示 (部分的) 命令。
    let &showcmd = 1

    " 插入括号时，短暂地跳转到匹配的对应括号。
    let &showmatch = 1

    " 本选项的值指定何时显示带有标签页标签的行
    let &showtabline = 2
    if (&t_Co > 2)
        highlight TabLineSel cterm=bold ctermfg=White ctermbg=Blue
    endif

    " 如果打开，进行拼写检查。
    "let &spell = 1

    " 使用可视响铃代替鸣叫。显示可视响铃的终端代码由 ’t_vb’ 给出。
    let &visualbell = 1

    " 在·<Insert>·模式下自动补齐。
    inoremap    (           ()<ESC><Insert>
    inoremap    ()          ()<ESC><Insert>
    inoremap    ()<Left>    ()<Left>
    inoremap    {           {}<ESC><Insert>
    inoremap    {}          {}<ESC><Insert>
    inoremap    {}<Left>    {}<Left>
    inoremap    [           []<ESC><Insert>
    inoremap    []          []<ESC><Insert>
    inoremap    []<Left>    []<Left>
    inoremap    <           <><ESC><Insert>
    inoremap    <=          <=
    inoremap    <>          <><ESC><Insert>
    inoremap    <><Left>    <><Left>
endfunction

" 函数：AutoOpenCompleteList
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：输入字母的时候，自动触发补全功能，v:char 来自 InsertCharPre。
function AutoOpenCompleteList()
    if (v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z')
        if (pumvisible() == 0) " 自动补全的窗口没有弹出，激活弹窗。
            call feedkeys("\<C-X>\<C-N>", "n")
        endif
    endif
endfunction

" 函数：UsingTableComplete
" 参数：N/A
" 返回：返回代表快捷方式的字符串。
" 异常：N/A
" 描述：如果自动补全的弹窗存在，使用 <Tab> 自动补全，相当于 CTRL-N 组合键。
function UsingTableComplete()
    if (pumvisible())
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction

" 函数：TurnDefaultConfigsOff
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：关闭还原 DefaultConfigs 的配置参数。
function TurnDefaultConfigsOff()
    set autoread&
    set background&
    set backspace="indent,eol,start"    " 应用 defaults.vim 中的设置。
    set complete&
    set completeopt&
    set confirm&
    set cursorline&
    set encoding&
    set fileencodings&
    set formatoptions&
    set hlsearch&
    set ignorecase&
    set incsearch&
    set smartcase&
    set laststatus&
    set statusline&
    set mouse&
    set number&
    set relativenumber&
    set ruler&
    set scrolloff&
    set shortmess&
    set showcmd&
    set showmatch&
    set showtabline&
    set spell&
    set visualbell&
endfunction

" 函数：TurnCoreConfigsOn
" 参数：table_stop：制表符显示的长度，以及对应的空格数量。
"       text_width：文本的宽度，超出该宽度应该换行。
" 返回：N/A
" 异常：N/A
" 描述：应用 CoreConfigs 的配置参数。
function TurnCoreConfigsOn(table_stop, text_width)
    " 开启新行时，从当前行复制缩进距离。
    let &autoindent = 1

    " 缩进每一步使用的空白数目。
    let &shiftwidth = a:table_stop
    " 插入 <Tab> 时使用合适数量的空格。
    let &expandtab = a:table_stop
    " 如果打开，行首的 <Tab> 根据 ’shiftwidth’ 插入空白。
    let &smarttab = 1
    " 执行编辑操作，如插入 <Tab> 或者使用 <BS> 时，把 <Tab> 算作空格的数目。
    "let &softtabstop = 1
    " 文件里的 <Tab> 代表的空格数。
    "let &tabstop = a:table_stop

    " 插入文本的最大宽度。
    let &textwidth = a:text_width
    " 开启回绕行保持视觉上的缩进 (和该行开始处相同的空白数目)，
    " 从而保留文本的水平块。为了区分回绕行与正常缩进行，需要额外缩进，
    " 并显示 'showbreak' 的值。
    let &breakindent = 1
    " nr2char(shiftwidth() + 48) 相当于将 shiftwidth 的值转换成字符串。
    let &breakindentopt = "shift:" + nr2char(shiftwidth() + 48) + ",sbr"
    let &showbreak = ">"
    " 如果打开，Vim 会在 ’breakat’ 里的字符上，
    " 而不是在屏幕上可以显示的最后一个字符上回绕长行。
    let &linebreak = 1

    " 'colorcolumn' 是逗号分隔的屏幕列的列表。
    " 这些列会用 ColorColumn hl-ColorColumn 高亮。
    if (a:text_width == 79)
        let &colorcolumn = "+1,+21"
    elseif (a:text_width == 99)
        let &colorcolumn = "+1,+21"
    elseif (a:text_width == 119)
        let &colorcolumn = "+1"
    endif
    if (&t_Co > 2)
        highlight ColorColumn cterm=bold ctermfg=White ctermbg=Blue
    endif
    " 如果屏幕宽度小于 colorcolumn，不应该再高亮。
    if (&columns < a:text_width + 1 + &numberwidth)
        let &colorcolumn = ""
    end

    " 当前窗口使用的折叠方式。
    let &foldmethod = "indent"
    " 设置屏幕行数，超过该值的折叠可以关闭。
    let &foldminlines = 2

    " 用于看到制表和空格的区别以及拖尾的空白。
    let &list = 1
    " list 模式下显示用的字符。
    let &listchars = "eol:¶,tab:→→,trail:·,extends:<,precedes:>,nbsp:+"
    if (&t_Co > 2)
        highlight NonText cterm=bold ctermfg=Black ctermbg=White
        highlight SpecialKey cterm=bold ctermfg=Black ctermbg=White
    endif
endfunction

" 函数：TurnCoreConfigsOff
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：还原 CoreConfigs 的配置参数。
function TurnCoreConfigsOff()
    set autoindent&
    set shiftwidth&
    set expandtab&
    set smarttab&
    set softtabstop&
    set tabstop&
    set textwidth&
    set breakindent&
    set breakindentopt&
    set linebreak&
    set colorcolumn&
    set foldmethod&
    set foldminlines&
    set list&
    set listchars&
endfunction

" 函数：InsertTextAtCurrentPosition
" 参数：insert_text: 将要插入的字符串。
" 返回：N/A
" 异常：N/A
" 描述：在当前位置插入文字；插入文字后，光标在插入文字的后面。主要的实现方法是
" 将当前行以光标为界，拆分成前后两个部分，并与待插入文本组成目标字符串，整体替
" 换当前行的内容。
function InsertTextAtCurrentPosition(insert_text)
    let l:current_line_num = line('.')
    let l:current_col_num = col('.')
    let l:current_line_text = getline('.')
    let l:modified_line_text = [
    \   strpart(l:current_line_text, 0, l:current_col_num),
    \   a:insert_text,
    \   strpart(l:current_line_text, l:current_col_num)
    \]
    call setline(l:current_line_num, join(l:modified_line_text, ""))
    call cursor(l:current_line_num, l:current_col_num + strlen(a:insert_text))
endfunction

" 函数：InsertCodeFileHeader
" 参数：comment_flag: 注释的标识，比如 //（双斜线）和 "（引号）等。
" 返回：N/A
" 异常：N/A
" 描述：写入代码文件的头部，包括以下几个部分：
"
"   1. AGPLv3 的声明；
"   2. 文件的基本属性；
"   3. 文件的初始化历史。
"
" 函数使用前应该初始化 g:user_company、g:user_name、g:user_email。
function InsertCodeFileHeader(comment_flag)
    call setline(1,  a:comment_flag . "  - EXPLORING WITH FUN!")
    call setline(2,  a:comment_flag . " Copyright (C) " . strftime("%Y") . "  " . g:user_name . ", " . g:user_company)
    call setline(3,  a:comment_flag . "")
    call setline(4,  a:comment_flag . " This program is free software: you can redistribute it and/or modify")
    call setline(5,  a:comment_flag . " it under the terms of the GNU Affero General Public License as")
    call setline(6,  a:comment_flag . " published by the Free Software Foundation, either version 3 of the")
    call setline(7,  a:comment_flag . " License, or (at your option) any later version.")
    call setline(8,  a:comment_flag . "")
    call setline(9,  a:comment_flag . " This program is distributed in the hope that it will be useful,")
    call setline(10, a:comment_flag . " but WITHOUT ANY WARRANTY; without even the implied warranty of")
    call setline(11, a:comment_flag . " MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the")
    call setline(12, a:comment_flag . " GNU Affero General Public License for more details.")
    call setline(13, a:comment_flag . "")
    call setline(14, a:comment_flag . " You should have received a copy of the GNU Affero General Public License")
    call setline(15, a:comment_flag . " along with this program.  If not, see <https://www.gnu.org/licenses/>.")
    call setline(16, "")
    call setline(17, a:comment_flag . " 作者：[" . g:user_name . "](" . g:user_email . ", " . g:user_company . ")")
    call setline(18, a:comment_flag . " 日期：" . strftime("%c"))
    call setline(19, a:comment_flag . " 规范：SansiBit Guideline Suite V0.0.1")
    call setline(20, a:comment_flag . " 描述：")
    call setline(21, "")
    call setline(22, a:comment_flag . " 0. [" . strftime("%Y-%m-%d") . "] [" . g:user_name . "] CREATE THE FILE AND START A NEW JOURNAL.")
    call setline(23, "")
    call cursor(1, strlen(a:comment_flag) + 1)
endfunction

" 函数：InsertFunctionComment
" 参数：comment_flag: 注释的标识，比如 //（双斜线）和 "（引号）等。
" 返回：N/A
" 异常：N/A
" 描述：在光标所在行的下一行插入函数注释。
function InsertFunctionComment(comment_flag)
    call append(line(".") + 0, a:comment_flag . " 函数：")
    call append(line(".") + 1, a:comment_flag . " 参数：N/A")
    call append(line(".") + 2, a:comment_flag . " 返回：N/A")
    call append(line(".") + 3, a:comment_flag . " 异常：N/A")
    call append(line(".") + 4, a:comment_flag . " 描述：")
    call cursor(line(".") + 1, 10)
endfunction

" 函数：CommentCurrentLine
" 参数：comment_flag: 注释的标识，比如 //（双斜线）和 "（引号）等。
" 返回：N/A
" 异常：N/A
" 描述：如果当前行已经被注释，反注释之；否则注释该行。需要注意的是，该函数无法
" 处理注释配对的情况，比如无法处理类似 /* SOMETHING */ 的注释行。
function CommentCurrentLine(comment_flag)
    " 如果当前行是空行，或长度小于 comment_flag，那么肯定不是注释行，直接注释。
    if (strlen(getline('.')) < strlen(a:comment_flag) ||
            \match(getline('.'), '\S') == -1)
        call setline(line('.'), a:comment_flag . " " . getline('.'))
        call cursor(line('.'), strlen(a:comment_flag) + 1 + col('.'))
    else
        let l:whitespace_num = match(getline('.'), '\S')
        let l:potential_comment_tag =
                \strpart(getline('.'), l:whitespace_num, strlen(a:comment_flag))
        let l:potential_comment_tag_space =
                \strpart(getline('.'), l:whitespace_num, strlen(a:comment_flag) + 1)
        " 如果有效字符的最开始是注释标注，说明是注释行，需要反注释。
        if (l:potential_comment_tag_space ==# a:comment_flag . " ")
            let l:modified_line_text = [
            \   strpart(getline('.'), 0, l:whitespace_num),
            \   strpart(getline('.'), l:whitespace_num + strlen(a:comment_flag) + 1)
            \]
        elseif (l:potential_comment_tag ==# a:comment_flag)
            let l:modified_line_text = [
            \   strpart(getline('.'), 0, l:whitespace_num),
            \   strpart(getline('.'), l:whitespace_num + strlen(a:comment_flag))
            \]
        " 否则标识当前行不是注释行，注释之。
        else
            let l:modified_line_text = [
            \   strpart(getline('.'), 0, l:whitespace_num),
            \   a:comment_flag . " ",
            \   strpart(getline('.'), l:whitespace_num)
            \]
        endif
        call setline(line('.'), join(l:modified_line_text, ""))
    endif
endfunction

" START PLAIN TEXT FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""

" 函数：CreatePlainTextFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：适用于创建 *.txt 和 *.md 文件的配置。
" 函数使用前应该初始化 g:user_company、g:user_name、g:user_email。
function CreatePlainTextFileConfigs()
    call setline(1,  "# ")
    call setline(2,  "")
    call setline(3,  "作者：[[" . g:user_name . "](mailto:" . g:user_email . "), " . g:user_company . "]\\")
    call setline(4,  "日期：" . strftime("%c") . "\\")
    call setline(5,  "许可：CC BY-NC-SA 4.0\\")
    call setline(6,  "规范：SansiBit Guideline Suite V0.0.1")
    call setline(7,  "")
    call setline(8,  "## 摘要")
    call setline(9,  "")
    call setline(10, "TODO")
    call setline(11, "")
    call setline(12, "## 目录")
    call setline(13, "")
    call setline(14, "1.  [](#)")
    call setline(15, "1.  [历史记录](#历史记录)")
    call setline(16, "")
    call setline(17, "## ")
    call setline(18, "")
    call setline(19, "TODO")
    call setline(20, "")
    call setline(21, "## 历史记录")
    call setline(22, "")
    call setline(23, "1.  [" . strftime("%Y-%m-%d") . "] [" . g:user_name . "] CREATE THE FILE AND START A NEW JOURNAL.")
    call cursor(1, 2)
endfunction

" 函数：PlainTextConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：适用于 *.txt 和 *.md 文件的配置。
function PlainTextConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 行快速插入目录项。
    nnoremap <Leader><C-I> :call InsertTextAtCurrentPosition("1.  [](#)")<CR>
    " 适用于 Markdown 的自动补齐。
    inoremap    `           ``<ESC><Insert>
    inoremap    ``          ``<ESC><Insert>
    inoremap    ``<Left>    ``<Left>
    inoremap    ```         ```<CR>```<ESC><UP>$A
endfunction

" END PLAIN TEXT FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""

" START C/C++ FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""

" 函数：CreateANSICHeaderFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：ANSI C 头文件（*.h）的模板。
function CreateANSICHeaderFileConfigs()
    call InsertCodeFileHeader("//")

    call setline(24, "#ifndef " . toupper(expand("%:t:r")) . "_H")
    call setline(25, "#define " . toupper(expand("%:t:r")) . "_H")
    call setline(26, "")
    call setline(27, "#ifdef __cplusplus")
    call setline(28, "extern \"C\" {")
    call setline(29, "#endif")
    call setline(30, "")
    call setline(31, "")
    call setline(32, "")
    call setline(33, "#ifdef __cplusplus")
    call setline(34, "}")
    call setline(35, "#endif")
    call setline(36, "")
    call setline(37, "#endif")
endfunction

" 函数：CreateCPlusPlusHeaderFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：C++ 头文件（*.hpp）的模板。
function CreateCPlusPlusHeaderFileConfigs()
    call InsertCodeFileHeader("//")

    call setline(24, "#ifndef " . toupper(expand("%:t:r")) . "_HPP")
    call setline(25, "#define " . toupper(expand("%:t:r")) . "_HPP")
    call setline(26, "")
    call setline(27, "")
    call setline(28, "")
    call setline(29, "#endif")
endfunction

" 函数：CreateCAndCPlusPlusSrcFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：C/C++ 源码文件的模板。
function CreateCAndCPlusPlusSrcFileConfigs()
    call InsertCodeFileHeader("//")
endfunction

" 函数：ANSICAndCPlusPlusConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：应用 C/C++ 的配置参数。
function ANSICAndCPlusPlusConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 开启新行时使用自动缩进。适用于 C 这样的程序，但或许也能用于其它语言。
    " 'cinoptions' 影响 'cindent' 重新缩进 C/C++ 程序行的方式。
    " 'cinoptions' 的设置符合《SansiBit Guideline Suite V0.0.1》
    let &cindent = 1
    let &cinoptions = "l1,g0.5s,h0.5s,N-s,E-s,i2s,+2s,(0,W2s,k2s"

    " 适用于 C/C++ 的组合键。
    nnoremap <Leader><C-F> :call InsertFunctionComment("//")<CR>
    nnoremap <Leader><c-K> :call CommentCurrentLine("//")<CR>
    " 在·<Insert>·模式下自动补齐。
    inoremap    {<CR>       {<CR>}<ESC>O
    inoremap    {}<Left>    {<CR>}<ESC>O
    inoremap    <<          <<
    inoremap    <<Space>    <<Space>
    inoremap    "           ""<ESC><Insert>
    inoremap    ""          ""<ESC><Insert>
endfunction

" END C/C++ FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""""

" START CONF FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""""""

" 函数：CreateConfFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：*.conf 文件模板，比如 Apache HTTP Server 的配置文件。
function CreateConfFileConfigs()
    call InsertCodeFileHeader("#")
endfunction

" 函数：ConfConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：适用于配置文件的配置参数。
function ConfConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 # 注释符的组合键。
    nnoremap <Leader><C-K> :call CommentCurrentLine("#")<CR>
endfunction

" 函数：CreateIniFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：*.ini 文件模板，比如 PHP 的配置文件。
function CreateIniFileConfigs()
    call InsertCodeFileHeader(";")
endfunction

" 函数：IniConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：适用于配置文件的配置参数。
function IniConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 # 注释符的组合键。
    nnoremap <Leader><C-K> :call CommentCurrentLine(";")<CR>
endfunction

" END CONF FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""""""""

" START VIMSCRIPT FILE  CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""

" 函数：CreateVimScriptFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：VimScript 的文件模板。
function CreateVimScriptFileConfigs()
    call InsertCodeFileHeader("\"")
endfunction

" 函数：VimScriptConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：适用于 VimScript 的配置参数。
function VimScriptConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 VimScript 的组合键。
    nnoremap <Leader><C-F> :call InsertFunctionComment("\"")<CR>
    nnoremap <Leader><c-K> :call CommentCurrentLine("\"")<CR>
endfunction

" END VIMSCRIPT FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""

" START TEX FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""""

" 函数：CreateTeXFileConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：TeX 文件类型的模板。
" 函数使用前应该初始化 g:user_company、g:user_name、g:user_email。
function CreateTeXFileConfigs()
    call setline(1,  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    call setline(2,  "% 作者：[" . g:user_name . "](" . g:user_email . ", " . g:user_company . ")")
    call setline(3,  "% 日期：" . strftime("%c"))
    call setline(4,  "% 许可：CC BY-NC-SA 4.0")
    call setline(5,  "% 规范：SansiBit Guideline Suite V0.0.1")
    call setline(6,  "% 描述：")
    call setline(7,  "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    call setline(8,  "")
    call setline(9,  "")
    call setline(10, "")
    call setline(11, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    call setline(12, "% 1. [" . strftime("%Y-%m-%d") . "] [" . g:user_name . "] CREATE THE FILE AND START A NEW JOURNAL.")
    call setline(13, "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
    call cursor(6, 9)
endfunction

" 函数：TeXConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：使用于 TeX 的配置参数。
function TeXConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 TeX 的组合键。
    nnoremap <Leader><C-K> :call CommentCurrentLine("%")<CR>
endfunction

" END TEX FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""""""
