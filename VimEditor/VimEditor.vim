" A PROJECT FROM SANSIBIT.COM - EXPLORING WITH FUN!
" Copyright (C) 2018-2020  SansiBit.com, TsePing Chai
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

" 0. [2020-11-15] [TsePing Chai] CREATED THE FILE.

nnoremap <F7><C-A> :call GenericConfigs(2, 79)<CR>
nnoremap <F7><C-R> :call ResetGenericConfigs()<CR>
nnoremap <F7><C-E> :set formatoptions+=w<CR>i

" 函数：GenericConfigs参数：table_stop：制表符显示的长度，以及对应的空格数量。
" text_width：文本的宽度，超出该宽度应该换行。返回：N/A异常：N/A描述：应用
" SansiBitConfigs 核心的配置参数。
function GenericConfigs(table_stop, text_width)
    " 开启新行时，从当前行复制缩进距离。
    let &autoindent = 1

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

    " 缩进每一步使用的空白数目。
    let &shiftwidth = a:table_stop
    " 插入 <Tab> 时使用合适数量的空格。
    let &expandtab = a:table_stop
    " 如果打开，行首的 <Tab> 根据 ’shiftwidth’ 插入空白。
    let &smarttab = 1
    " 执行编辑操作，如插入 <Tab> 或者使用 <BS> 时，把 <Tab> 算作空格的数目。
    let &softtabstop = 1
    " 文件里的 <Tab> 代表的空格数。
    let &tabstop = a:table_stop

    " 插入文本的最大宽度。
    let &textwidth = a:text_width

    " 开启回绕行保持视觉上的缩进 (和该行开始处相同的空白数目)，
    " 从而保留文本的水平块。为了区分回绕行与正常缩进行，需要额外缩进，
    " 并显示 'showbreak' 的值。
    let &breakindent    = 1
    let &breakindentopt = "shift:" + nr2char(shiftwidth() + 48) + ",sbr"
    let &showbreak = "> "
    " 如果打开，Vim 会在 ’breakat’ 里的字符上，
    " 而不是在屏幕上可以显示的最后一个字符上回绕长行。
    let &linebreak = 1

    " 'colorcolumn' 是逗号分隔的屏幕列的列表。
    " 这些列会用 ColorColumn hl-ColorColumn 高亮。
    if (a:text_width == 79)
        let &colorcolumn = "+1,+41"
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

    " 本选项指示补全的类型和需要扫描的位置。
    let &complete = ".,w,b,u,t,i,d"
    " 插入模式补全使用的选项
    let &completeopt = "menu,preview,noselect"
    if (has("autocmd"))
        autocmd InsertCharPre * call AutoOpenCompleteList()
    endif
    inoremap <Tab> <C-R>=UsingTableComplete()<CR>
    if (&t_Co > 2)
        highlight Pmenu     ctermfg=Black ctermbg=Cyan
        highlight PmenuSel  ctermfg=White ctermbg=Blue
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

    " 当前窗口使用的折叠方式。
    let &foldmethod = "indent"
    " 设置屏幕行数，超过该值的折叠可以关闭。
    let &foldminlines = 2

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
    let &formatoptions = "t,c,q,a,n,m,M,1,j,p"

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
    \   "\ (%{strftime(\"%Y.%m.%d\ %T\", getftime(expand(\"%:p\")))})",
    \   "%=",
    \   "0x%B", "\ %l/%L", "\ %c", "\ %P"
    \]
    let &statusline = join(l:statusline_array, "")

    " 用于看到制表和空格的区别以及拖尾的空白。
    let &list = 1
    " list 模式下显示用的字符。
    let &listchars = "eol:¶,tab:→→,trail:·,extends:<,precedes:>,nbsp:+"
    if (&t_Co > 2)
        highlight NonText       cterm=bold ctermfg=White ctermbg=Black
        highlight SpecialKey    cterm=bold ctermfg=White ctermbg=Black
    endif

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

    " 如果打开，进行拼写检查。
    "let &spell = 1

    " 使用可视响铃代替鸣叫。显示可视响铃的终端代码由 ’t_vb’ 给出。
    let &visualbell = 1
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

" 函数：ResetGenericConfigs
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：还原 GenericConfigs() 的配置参数。
function ResetGenericConfigs()
    set autoindent&
    set autoread&
    set background&
    set backspace="indent,eol,start"    " 应用 defaults.vim 中的设置。
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
    set complete&
    set completeopt&
    set confirm&
    set cursorline&
    set encoding&
    set fileencodings&
    set foldmethod&
    set foldminlines&
    set formatoptions&
    set hlsearch&
    set ignorecase&
    set incsearch&
    set smartcase&
    set laststatus&
    set statusline&
    set list&
    set listchars&
    set mouse&
    set number&
    set relativenumber&
    set ruler&
    set scrolloff&
    set shortmess&
    set showcmd&
    set spell&
    set visualbell&
endfunction

" 函数：ANSICAndCPlusPlus
" 参数：N/A
" 返回：N/A
" 异常：N/A
" 描述：应用 SansiBitConfigs 核心的配置参数。
function ANSICAndCPlusPlus()
    call GenericConfigs(2, 79)

    " 开启新行时使用自动缩进。适用于 C 这样的程序，但或许也能用于其它语言。
    " 'cinoptions' 影响 'cindent' 重新缩进 C 程序行的方式。
    " 'cinoptions' 的设置符合《SansiBit Guideline Suite V0.0.1》
    let &cindent    = 1
    let &cinoptions = "l1,g0.5s,h0.5s,N-s,E-s,i2s,+2s,(0,W4"

    " 形成配对的字符。
    let &matchpairs = "(:),f:g,[:],<,>"
endfunction
