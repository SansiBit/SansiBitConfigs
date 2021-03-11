" VimEditor.vim
" Copyright (C) 2021  TsePing Chai, SansiBit.com
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

" @author   [TsePing Chai](TsPChai@Outlook.com, SansiBit.com)
" @date     Mon 08 Mar 2021 12:03:30 AM CST
" @brief    Vim Editor 的配置文件。
"
" @details  配置文件主要面向轻量级的编辑场景，比如服务器上的文件修改，以及
" COMMIT_MESSAGE 的编辑等。配置文件主要分为两个部分：一、编辑器的核心配置参数；
" 二、文本模板。不同的文件类型应用不同的配置，极大地优化了编辑体验。
"
" @warning  配置文件在 Vim 7.x 和 Vim 8.x 的 Terminal 环境下通过测试，未在其他
" 版本的 Vim 以及 GUI 环境中测试。
"
" @see  [VIM 中文手册](http://github.com/yianwillis/vimcdoc)

" 用户的基本信息
let g:user_company  = "SansiBit.com"
let g:user_name     = "TsePing Chai"
let g:user_email    = "TsPChai@Outlook.com"

" @brief    全局状态标签。
" @warning  请勿手动修改，标签记录的状态由具体的函数管理。
let g:default_configs_switcher  = 0
let g:core_configs_switcher     = 0
let g:format_options_switcher   = 0
let g:tabstop   = 8
let g:textwidth = 0

if (has("autocmd"))
    " 如果调整 Terminal 窗口的大小，重新渲染高亮线。
    autocmd VimResized * call RenderColorColumn(g:textwidth)

    " 使用 Vim 打开、创建、切换文件，都会应用默认配置。
    autocmd BufRead,BufNewFile,TabEnter * call DefaultConfigsSwitcher(1)

    " 文本文件（*.txt, *.md）
    autocmd BufNewFile *.txt,*.md call CreatePlainTextFileConfigs()
    autocmd BufRead,BufNewFile *.txt,*.md call PlainTextConfigs()
    autocmd TabEnter *.txt,*.md call CoreConfigsSwitcher(1)

    " C/C++（*.h, *.hpp, *.hxx, *.c, *.cc, *.cpp, *.cxx）
    autocmd BufNewFile *.h call CreateANSICHeaderFileConfigs()
    autocmd BufNewFile *.hpp,*.hxx call CreateCPlusPlusHeaderFileConfigs()
    autocmd BufNewFile *.c,*.cc,*.cpp,*.cxx call CreateCAndCPlusPlusSrcFileConfigs()
    autocmd BufRead,BufNewFile *.c,*.h,*.cc,*.cpp,*.cxx,*.hpp,*.hxx call ANSICAndCPlusPlusConfigs()
    autocmd TabEnter *.c,*.h,*.cc,*.cpp,*.cxx,*.hpp,*.hxx call CoreConfigsSwitcher(1)

    " 配置文件（*.conf, *.ini）
    autocmd BufNewFile *.conf call CreateConfFileConfigs()
    autocmd BufRead,BufNewFile *.conf call ConfConfigs()
    autocmd BufNewFile *.ini call CreateIniFileConfigs()
    autocmd BufRead,BufNewFile *.ini call IniConfigs()
    autocmd TabEnter *.ini call CoreConfigsSwitcher(1)

    " VimScript（*.vim）
    autocmd BufNewFile *.vim call CreateVimScriptFileConfigs()
    autocmd BufRead,BufNewFile *.vim call VimScriptConfigs()
    autocmd TabEnter *.vim call CoreConfigsSwitcher(1)

    " JSON（*.json）
    autocmd BufRead,BufNewFile *.json call JsonConfigs()
    autocmd TabEnter *.json call CoreConfigsSwitcher(1)

    " TeX（*.tex, *.ltx）
    autocmd BufNewFile *.tex,*ltx call CreateTeXFileConfigs()
    autocmd BufRead,BufNewFile *.tex,*.ltx call TeXConfigs()
    autocmd TabEnter *.tex,*.ltx call CoreConfigsSwitcher(1)
endif

let mapleader = ";"
nnoremap <Leader><C-D> :call DefaultConfigsSwitcher(-1)<CR>
nnoremap <Leader><C-A> :call CoreConfigsSwitcher(-1)<CR>
nnoremap <Leader><C-W> :call FormatOptionsSwitcher(-1)<CR>
nnoremap <Leader><C-T> :call InsertTextAtCurrentPosition(strftime("%Y-%m-%d"))<CR>

" @brief    开启或重置 {@code DefaultConfigs} 配置。
"
" @details  如果 {@code switcher_tag} 指定了状态，则强制执行；如果没有指定，则
" 根据 {@code g:default_configs_switcher} 的值进行自动切换。
"
" @param    switcher_tag    1，强制开启默认配置集；
"                           0，强制还原默认配置集；
"                           -1，根据 {@code default_configs_switcher} 切换。
"
" @see  TurnDefaultConfigsOn()
" @see  TurnDefaultConfigsOff()
function DefaultConfigsSwitcher(switcher_tag)
    if (a:switcher_tag == 1)
        call TurnDefaultConfigsOn()
    elseif (a:switcher_tag == 0)
        call TurnDefaultConfigsOff()
    elseif (a:switcher_tag == -1)
        if (g:default_configs_switcher == 0)
            call TurnDefaultConfigsOn()
        elseif (g:default_configs_switcher == 1)
            call TurnDefaultConfigsOff()
        endif
    endif
endfunction

" @brief    开启或重置 {@code CoreConfigs} 配置。
"
" @details  如果 {@code switcher_tag} 指定了状态，则强制执行；如果没有指定，则
" 根据 {@code g:core_configs_switcher} 的值进行自动切换。
"
" @param    switcher_tag    1，强制开启核心参数配置；
"                           0，强制还原核心参数配置；
"                           -1，根据 {@code g:core_configs_switcher} 切换。
"
" @see  TurnCoreConfigsOn(table_stop, text_width)
" @see  TurnCoreConfigsOff()
function CoreConfigsSwitcher(switcher_tag)
    if (a:switcher_tag == 1)
        call TurnCoreConfigsOn(g:tabstop, g:textwidth)
    elseif (a:switcher_tag == 0)
        call TurnCoreConfigsOff()
    elseif (a:switcher_tag == -1)
        if (g:core_configs_switcher == 0)
            call TurnCoreConfigsOn(g:tabstop, g:textwidth)
        elseif (g:core_configs_switcher == 1)
            call TurnCoreConfigsOff()
        endif
    endif
endfunction

" @brief    {@code formatoptions} 是否加入 {@code w} 参数。
"
" @details  如果 {@code switcher_tag} 指定了状态，则强制执行；如果没有指定，则
" 根据 {@code g:format_options_switcher} 的值进行自动切换。
"
" 如果 {@code formatoptions} 带有 {@code w}，Vim 会将不是空白符结尾的一行视为一
" 个自然段，因此不会将下一行的文字合并上来。可是在中文编辑的时候，插入文字后，
" 如果一行文字的长度超过 {@code textwidth} 的时候，会将后面的文字挤到下一行，并
" 且每个汉字独占一行。因此，正常输入文本或删除文字的时候，需要 {@code w}；插入
" 文字的时候不需要 {@code w}。
"
" @note 默认情况，{@code formatoptions} 是没有 {@code w} 参数的。
"
" @param    switcher_tag    1，强制删除 {@code w}；
"                           0，强制增加 {@code w}；
"                           -1，根据 {@code g:format_options_switcher} 切换。
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

" @brief    根据 {@code g:format_options_switcher} 的值判断 {@code
" formatoptions} 是否有 {@code w} 参数。
"
" @return   如果 {@code formatoptions} 带有 {@code w} 参数，返回字符串 {@code
" ,+W}，否则返回字符串 {@code ,-W}。
"
" @see  FormatOptionsSwitcher()
function FormatOptionsStatus()
    if (g:format_options_switcher == 0)
        return ",+W"
    else
        return ",-W"
    endif
endfunction

" @brief    开启 {@code DefaultConfigs} 的配置（默认配置集）。
"
" @details  该函数涉及的配置项都是与具体的文件类型无关，但是提高读写体验的，主
" 要分为显示效果、自动补全、状态栏、常用快捷方式等几大类。与该函数相关的全局变
" 量有 {@code g:default_configs_switcher} 和 {@code format_options_switcher}。
"
" @note 函数 {@code TurnDefaultConfigsOff()} 可将本函数涉及的配置项还原。
" @see  TurnDefaultConfigsOff()
function TurnDefaultConfigsOn()
    let g:default_configs_switcher = 1

    " 如果发现文件在 Vim 之外修改过而在 Vim 里面没有的话，自动重新读入。
    let &autoread = 1

    " xterm             PuTTY, Xshell, GNOME Terminal
    " xterm-256color    WSL
    " 因为 Vim 将上述终端的 {@code background} 默认设置为 {@code light}，
    " 显示效果不佳，所以改为 {@code dark} 以更好地显示文本色彩。
    if (&term == "xterm" || &term == "xterm-256color")
        let &background = "dark"
    endif

    " 在一行开头按退格键如何处理，这里使用 {@code defaults.vim} 的设置。
    let &backspace  = "indent,eol,start"

    " 本选项指示补全的类型和需要扫描的位置。
    let &complete = ".,w,b,u,t,i,d"
    " 插入模式补全使用的选项。
    let &completeopt = "menu,preview,noselect"
    if (has("autocmd"))
        " 有字符键入，触发自动补全。
        autocmd InsertCharPre * call AutoOpenCompleteList()
    endif
    "将 {@code UsingTableComplete} 的返回值存入 {@code CTRL-R} 寄存器。
    inoremap <Tab> <C-R>=UsingTableComplete()<CR>
    if (&t_Co > 2)
        highlight Pmenu ctermfg=Black ctermbg=Cyan
        highlight PmenuSel ctermfg=White ctermbg=Blue
    endif

    " 一些通常因为缓冲区有未保存的改变而失败的操作，
    " 会弹出对话框，询问你是否想保存当前文件。
    let &confirm = 1

    " 用 {@code hl-CursorLine} 高亮光标所在的文本行。用于方便定位光标。
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

    " 描述自动排版如何进行的字母序列：
    " t 使用 {@code textwidth} 自动回绕文本。
    " c 使用 {@code textwidth} 自动回绕注释，自动插入当前注释前导符。
    " q 允许 {@code gq} 排版时排版注释。
    " a 自动排版段落。每当文本被插入或者删除时，段落都会自动进行排版。
    " n 在对文本排版时，识别编号的列表。
    " m 可以在任何值高于 255 的多字节字符上分行。
    " M 在连接行时，不要在多字节字符之前或之后插入空格。
    " 1 不要在单字母单词后分行。如有可能，在它之前分行。
    " j 在合适的场合，连接行时删除注释前导符。
    " p 不在句号后的单个空白上断行。
    " w 行尾的空格指示下一行继续同一个段落，非空白字符结束的行结束一个段落。
    let &formatoptions = "t,c,q,a,n,m,M,1,j,p,w"
    let g:format_options_switcher = 0

    " 如果有上一个搜索模式，高亮它的所有匹配。
    let &hlsearch = 1
    " 搜索模式里忽略大小写。也用于标签文件的查找。
    let &ignorecase = 1
    " 输入搜索命令时，显示目前输入的模式的匹配位置。
    let &incsearch = 1
    " 如果搜索模式包含大写字符，不使用 {@code ignorecase} 选项。
    let &smartcase = 1

    " 本选项的值影响最后一个窗口何时有状态行。
    let &laststatus = 2
    " 如果非空，本选项决定状态行的内容。
    " %f：缓冲区的文件路径，保持输入的形式或相对于当前目录。
    " %M：修改标志位，文本是 {@code ,+} 或 {@code ,-}。
    " %R：只读标志位，文本是 {@code ,RO}。
    " %H：帮助缓冲区标志位，文本是 {@code ,HLP}。
    " %W：预览窗口标志位，文本是 {@code ,PRV}。
    " %Y：缓冲区的文件类型，如 {@code ,VIM}。
    " %=：左对齐和右对齐项目之间的分割点。不能指定宽度域。
    " %B：同上，以十六进制表示。
    " %l：行号。
    " %L：缓冲区里的行数。
    " %c：列号。
    " %P: 行数计算在文件位置的百分比，如同 {@code CTRL-G} 给出的那样。
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

    " 每个窗口都有自己的标尺。如果窗口有状态行，标尺在那里显示。
    let &ruler = 1

    " 光标上下两侧最少保留的屏幕行数。
    let &scrolloff = 5

    " 本选项有助于避免文件信息的所有 {@code hit-enter} 提示，
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

    " 使用可视响铃代替鸣叫。显示可视响铃的终端代码由 {@code t_vb} 给出。
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

" @brief    输入字母的时候，自动触发补全功能。
function AutoOpenCompleteList()
    " {@code v:char} 由 {@code InsertCharPre} 触发。
    if (v:char >= 'a' && v:char <= 'z') || (v:char >= 'A' && v:char <= 'Z')
        " 自动补全的窗口没有弹出，激活弹窗。
        if (pumvisible() == 0)
            " 函数 {@code feedkeys} 给预输入缓冲区加入键序列。
            " {@code <C-X><C-N>} 是自动补全菜单的快捷键。
            " {@code n} 表示不对键进行重映射。
            call feedkeys("\<C-X>\<C-N>", "n")
        endif
    endif
endfunction

" @brief    根据自动补全菜单的状态来处理 {@code <Tab>} 键。
" @return   返回代表快捷方式的字符串。
function UsingTableComplete()
    " 菜单显示，将 {@code <Tab>} 的动作解释为选择菜单中的项。
    if (pumvisible())
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfunction

" @brief    关闭还原 {@code DefaultConfigs} 的配置参数。
"
" @details  该函数执行 {@code TurnDefaultConfigsOn()} 相反的动作，也需要同时更
" 新 {@code g:default_configs_switcher} 和 {@code g:format_options_switcher}。
"
" @warning  函数无法去除已经定义的键盘映射。
" @see  TurnDefaultConfigsOn()
function TurnDefaultConfigsOff()
    let g:default_configs_switcher = 0
    set autoread&
    set background&
    set backspace="indent,eol,start"
    set complete&
    set completeopt&
    set confirm&
    set cursorline&
    set encoding&
    set fileencodings&
    set formatoptions&
    let g:format_options_switcher = 1
    set hlsearch&
    set ignorecase&
    set incsearch&
    set smartcase&
    set laststatus&
    set statusline&
    set mouse&
    set ruler&
    set scrolloff&
    set shortmess&
    set showcmd&
    set showmatch&
    set showtabline&
    set spell&
    set visualbell&
endfunction

" @brief    应用 {@code CoreConfigs} 配置（核心配置集）。
"
" @details  参数与包括影响制表符、文本长度、阅读显示等相关。函数本身与全局变量
" {@code g:core_configs_switcher} 相关。
"
" @note 函数 {@code TurnCoreConfigsOff()} 可以将本函数涉及的配置项还原。
"
" @param    table_stop  制表符显示的长度，以及对应的空格数量。
" @param    text_width  文本的宽度，超出该宽度应该换行。
"
" @see TurnCoreConfigsOff()
function TurnCoreConfigsOn(table_stop, text_width)
    let g:core_configs_switcher = 1

    " 开启新行时，从当前行复制缩进距离。
    let &autoindent = 1

    " 缩进每一步使用的空白数目。
    let &shiftwidth = a:table_stop
    " 插入 {@code <Tab>} 时使用合适数量的空格。
    let &expandtab = a:table_stop
    " 如果打开，行首的 {@code <Tab>} 根据 {@code shiftwidth} 插入空白。
    let &smarttab = 1
    " 执行编辑操作，如插入{@code <Tab>} 或者使用 {@code <BS>} 时，把
    " {@code <Tab>} 算作空格的数目。
    let &softtabstop = a:table_stop
    " 文件里的 {@code <Tab>} 代表的空格数。
    let &tabstop = a:table_stop

    " 插入文本的最大宽度。
    let &textwidth = a:text_width
    " 开启回绕行保持视觉上的缩进 (和该行开始处相同的空白数目)，
    " 从而保留文本的水平块。为了区分回绕行与正常缩进行，需要额外缩进，
    " 并显示 {@code showbreak} 的值。
    let &breakindent = 1
    " {@code nr2char(shiftwidth() + 48)}: {@code shiftwidth} 的值转换成字符串。
    " 比如 {@code shiftwidth} 的值是 4，转换后即字符串 {@code 4}。
    let &breakindentopt = "shift:" + nr2char(shiftwidth() + 48) + ",sbr"
    let &showbreak = ">"
    " 如果打开，Vim 会在 {@code breakat} 里的字符上，
    " 而不是在屏幕上可以显示的最后一个字符上回绕长行。
    let &linebreak = 1

    " 显示列高亮。
    call RenderColorColumn(a:text_width)

    " 当前窗口使用的折叠方式。
    let &foldmethod = "indent"
    " 设置屏幕行数，超过该值的折叠可以关闭。
    let &foldminlines = 2

    " 用于看到制表和空格的区别以及拖尾的空白。
    let &list = 1
    " {@code list} 模式下显示用的字符。
    let &listchars = "eol:¶,tab:→→,trail:·,extends:<,precedes:>,nbsp:+"
    if (&t_Co > 2)
        highlight NonText cterm=bold ctermfg=Black ctermbg=White
        highlight SpecialKey cterm=bold ctermfg=Black ctermbg=White
    endif

    " 在每行前面显示行号。
    let &number = 1
    " 在每行前显示相对于光标所在的行的行号。
    let &relativenumber = 1
endfunction

" @brief    还原 {@code CoreConfigs} 的参数。
"
" @details  函数与 {@code TurnCoreConfigsOn(table_stop, text_width)} 相对，因此
" 也与全局变量 {@code g:core_configs_switcher} 相关。
"
" @see  TurnCoreConfigsOn(table_stop, text_width)
function TurnCoreConfigsOff()
    let g:core_configs_switcher = 0
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
    set number&
    set relativenumber&
endfunction

" @brief    在当前位置插入字符串。
"
" @details  插入文字后，光标在插入文字的后面。主要的实现方法是将当前行以光标为
" 界拆分成前后两个部分，并与待插入文本组成目标字符串，整体替换当前行的内容。
"
" @param    insert_text 将要插入的字符串。
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

" @brief    源代码的头部模板。
"
" @details  模板主要包括以下几个部分：一、AGPLv3 的声明；二、文件的基本属性。创
" 建文件后，光标停留在 {@code #TODO}，需要开发人员自己补充源文件的简要信息。
"
" @important    函数使用前应该初始化以下全局部变量：
"   1. {@code g:user_company}；
"   2. {@code g:user_name}；
"   3. {@code g:user_email}。
"
" @param    comment_flag    注释的标识，比如 {@code //} 等。
function InsertCodeFileHeader(comment_flag)
    call setline(1,  a:comment_flag . " " . expand("%"))
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
    call setline(17, a:comment_flag . " @author\t[" . g:user_name . "](" . g:user_email . ", " . g:user_company . ")")
    if (strlen(a:comment_flag) == 1)
        call setline(18, a:comment_flag . " @date\t\t" . strftime("%c"))
    else
        call setline(18, a:comment_flag . " @date\t" . strftime("%c"))
    endif
    call setline(19, a:comment_flag . " @brief")
    call setline(20, "")
    call cursor(19, strlen(a:comment_flag) + strlen(" @brief"))
    autocmd BufEnter * :retab
endfunction

" @brief    在光标所在行的下一行插入函数注释。
" @param    comment_flag    注释的标识，比如 {@code //} 等。
function InsertFunctionComment(comment_flag)
    call append(line(".") + 0, a:comment_flag . " @brief")
    call append(line(".") + 1, a:comment_flag . " @details")
    call append(line(".") + 2, a:comment_flag . " @param")
    call append(line(".") + 3, a:comment_flag . " @return")
    call append(line(".") + 4, a:comment_flag . " @throws")
    call cursor(line(".") + 1, strlen(getline('.')))
endfunction

" @brief    注释或者反注释当前行。
"
" @details  如果当前行已经被注释，反注释之；否则注释该行。有以下几种情况：
"   1. 字符数量甚至少于注释标签的长度。
"   2. 注释行，格式是“注释 + 文字”。
"   3. 注释行，格式是“注释 + 若干个空格 + 文字”。
"   4. 非注释行，定格就是非空白字符。
"   5. 非注释行，以若干个空格开始。
"
" @warning  无法处理注释配对的情况，比如无法处理类似 {@code /*...*/} 的注释行。
" @param    comment_flag    注释的标识，比如 {@code //} 等。
function CommentCurrentLine(comment_flag)
    " 如果当前行是空行，或长度小于 {@code comment_flag}，
    " 那么肯定不是注释行，直接注释。
    if (strlen(getline('.')) < strlen(a:comment_flag) ||
            \match(getline('.'), '\S') == -1)
        call setline(line('.'), a:comment_flag . " " . getline('.'))
        call cursor(line('.'), strlen(a:comment_flag) + 1 + col('.'))
    else
        " 获取行字符串开头的空格数量。
        let l:whitespace_num = match(getline('.'), '\S')
        let l:potential_comment_tag_space =
                \strpart(getline('.'), l:whitespace_num, strlen(a:comment_flag) + 1)
        let l:potential_comment_tag =
                \strpart(getline('.'), l:whitespace_num, strlen(a:comment_flag))
        " 如果有效字符的最开始是注释标注，说明是注释行，需要反注释。
        " @warning 两个判断顺序不能颠倒。
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

" @brief    根据当前终端的宽度和文本长度确定高亮的列。
" @param    text_width  指定的一行文字宽度。
function RenderColorColumn(text_width)
    " 如果屏幕宽度小于 {@code colorcolumn}，不应该再高亮。
    if (&columns < a:text_width + 1 + &numberwidth)
        let &colorcolumn = ""
        return
    endif

    " {@code colorcolumn} 是逗号分隔的屏幕列的列表。
    " 这些列会用 {@code hl-ColorColumn} 高亮。
    if (a:text_width <= 80)
        let &colorcolumn = "+1,+21"
    elseif (a:text_width <= 100)
        let &colorcolumn = "+1,+21"
    elseif (a:text_width <= 120)
        let &colorcolumn = "+1"
    endif
    if (&t_Co > 2)
        highlight ColorColumn cterm=bold ctermfg=White ctermbg=Blue
    endif
endfunction

" START PLAIN TEXT FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""

" @brief    创建 {@code *.txt} 和 {@code *.md} 文件的文件模板配置。
"
" @important    函数使用前应该初始化以下全局部变量：
"   1. {@code g:user_company}；
"   2. {@code g:user_name}；
"   3. {@code g:user_email}。
function CreatePlainTextFileConfigs()
    call setline(1,  "# ")
    call setline(2,  "")
    call setline(3,  "*   作者：[[" . g:user_name . "](mailto:" . g:user_email . "), " . g:user_company . "]")
    call setline(4,  "*   日期：" . strftime("%c"))
    call setline(5,  "*   许可：CC BY-NC-SA 4.0")
    call setline(6,  "")
    call setline(7,  "**【摘要】** #TODO")
    call setline(8,  "")
    call setline(9,  "## 目录")
    call setline(10,  "")
    call setline(11, "1.  [](#)")
    call setline(12, "")
    call setline(13, "## #TODO")
    call setline(14, "")
    call setline(15, "#TODO")
    call cursor(1, 2)
endfunction

" @brief    适用于 {@code *.txt} 和 {@code *.md} 文件的配置。
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

" @brief    ANSI C 头文件 {@code *.h} 的模板。
function CreateANSICHeaderFileConfigs()
    call InsertCodeFileHeader("//")

    call setline(21, "#ifndef " . toupper(expand("%:t:r")) . "_H")
    call setline(22, "#define " . toupper(expand("%:t:r")) . "_H")
    call setline(23, "")
    call setline(24, "#ifdef __cplusplus")
    call setline(25, "extern \"C\" {")
    call setline(26, "#endif")
    call setline(27, "")
    call setline(28, "")
    call setline(29, "")
    call setline(30, "#ifdef __cplusplus")
    call setline(31, "}")
    call setline(32, "#endif")
    call setline(33, "")
    call setline(34, "#endif")
endfunction

" @brief    C++ 头文件 {@code *.hpp} 的模板。
function CreateCPlusPlusHeaderFileConfigs()
    call InsertCodeFileHeader("//")

    call setline(21, "#ifndef " . toupper(expand("%:t:r")) . "_HPP")
    call setline(22, "#define " . toupper(expand("%:t:r")) . "_HPP")
    call setline(23, "")
    call setline(24, "")
    call setline(25, "")
    call setline(26, "#endif")
endfunction

" @brief    C/C++ 源码文件的模板。
function CreateCAndCPlusPlusSrcFileConfigs()
    call InsertCodeFileHeader("//")
endfunction

" @brief    应用 C/C++ 的配置参数。
function ANSICAndCPlusPlusConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 开启新行时使用自动缩进。适用于 C 这样的程序，但或许也能用于其它语言。
    " {@code cinoptions} 影响 {@code cindent} 重新缩进 C/C++ 程序行的方式。
    " {@code cinoptions} 的设置符合《SansiBit Guideline Suite》
    let &cindent = 1
    let &cinoptions = "l1,g0.5s,h0.5s,N-s,E-s,i2s,+2s,(0,W2s,k2s"

    " 适用于 C/C++ 的组合键。
    nnoremap <Leader><C-F> :call InsertFunctionComment("//")<CR>
    nnoremap <Leader><c-K> :call CommentCurrentLine("//")<CR>
    " 在·{@code <Insert>}·模式下自动补齐。
    inoremap    {<CR>       {<CR>}<ESC>O
    inoremap    {}<Left>    {<CR>}<ESC>O
    inoremap    <<          <<
    inoremap    <<Space>    <<Space>
    inoremap    "           ""<ESC><Insert>
    inoremap    ""          ""<ESC><Insert>
endfunction

" END C/C++ FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""""

" START CONF FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""""""

" @brief    {@code *.conf} 文件模板，比如 Apache HTTP Server 的配置文件。
function CreateConfFileConfigs()
    call InsertCodeFileHeader("#")
endfunction

" @brief    适用于配置文件的配置参数。
function ConfConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 {@code #} 注释符的组合键。
    nnoremap <Leader><C-K> :call CommentCurrentLine("#")<CR>
endfunction

" @brief    {@code *.ini} 文件模板，比如 PHP 的配置文件。
function CreateIniFileConfigs()
    call InsertCodeFileHeader(";")
endfunction

" @brief    适用于配置文件的配置参数。
function IniConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 {@code ;} 注释符的组合键。
    nnoremap <Leader><C-K> :call CommentCurrentLine(";")<CR>
endfunction

" END CONF FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""""""""

" START VIMSCRIPT FILE  CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""

" @brief    VimScript 的文件模板。
function CreateVimScriptFileConfigs()
    call InsertCodeFileHeader("\"")
endfunction

" @brief    适用于 VimScript 的配置参数。
function VimScriptConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 VimScript 的组合键。
    nnoremap <Leader><C-F> :call InsertFunctionComment("\"")<CR>
    nnoremap <Leader><c-K> :call CommentCurrentLine("\"")<CR>
endfunction

" END VIMSCRIPT FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""

" START JSON FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""""""

" @brief    适用于 JSON 的配置参数。
function JsonConfigs()
    let g:tabstop = 4
    " JSON 文件不应该有行宽限制。
    let g:textwidth = 0
    call CoreConfigsSwitcher(1)
    " JSON 文件应该保留 {@code <Tab>} 的使用。
    set expandtab&

    " 在·{@code <Insert>}·模式下自动补齐。
    inoremap    "           ""<ESC><Insert>
    inoremap    ""          ""<ESC><Insert>
endfunction

" END JSON FILE CONFIGURATIONS """"""""""""""""""""""""""""""""""""""""""""""""

" START TEX FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""""

" @brief    TeX 文件类型的模板。
function CreateTeXFileConfigs()
    call InsertCodeFileHeader("%")
endfunction

" @brief    适用于 TeX 的配置参数。
function TeXConfigs()
    let g:tabstop = 4
    let g:textwidth = 79
    call CoreConfigsSwitcher(1)

    " 适用于 TeX 的组合键。
    nnoremap <Leader><C-K> :call CommentCurrentLine("%")<CR>
endfunction

" END TEX FILE CONFIGURATIONS """""""""""""""""""""""""""""""""""""""""""""""""
