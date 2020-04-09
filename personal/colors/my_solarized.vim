" My own, customized, light Solarized theme
" Based on: Romain Lafourcade's 'flattened_light'

highlight clear
if exists('syntax_on') | syntax reset | endif

let colors_name = 'my_solarized'
set background=light

let s:colordict = {
      \ 'base02':  {'hex': '#073642', 'num': 0},
      \ 'red':     {'hex': '#dc322f', 'num': 1},
      \ 'green':   {'hex': '#859900', 'num': 2},
      \ 'yellow':  {'hex': '#b58900', 'num': 3},
      \ 'blue':    {'hex': '#268bd2', 'num': 4},
      \ 'magenta': {'hex': '#d33682', 'num': 5},
      \ 'cyan':    {'hex': '#2aa198', 'num': 6},
      \ 'base2':   {'hex': '#eee8d5', 'num': 7},
      \ 'base03':  {'hex': '#002b36', 'num': 8},
      \ 'orange':  {'hex': '#cb4b16', 'num': 9},
      \ 'base01':  {'hex': '#586e75', 'num': 10},
      \ 'base00':  {'hex': '#657b83', 'num': 11},
      \ 'base0':   {'hex': '#839496', 'num': 12},
      \ 'violet':  {'hex': '#6c71c4', 'num': 13},
      \ 'base1':   {'hex': '#93a1a1', 'num': 14},
      \ 'base3':   {'hex': '#fdf6e3', 'num': 15},
      \}

function! s:highlight(group, opts) abort " {{{1
  let l:cmd = 'highlight ' . a:group

  if has_key(a:opts, 'style')
    let l:cmd .= ' cterm=' . a:opts.style
    let l:cmd .= ' gui=' . a:opts.style
  endif

  if has_key(a:opts, 'fg')
    if type(a:opts.fg) == type([])
      let l:cmd .= ' ctermfg=' . a:opts.fg[0]
      let l:cmd .= ' guifg=' . a:opts.fg[1]
    elseif a:opts.fg =~# '\vNONE|#[0-9a-f]{6}|bg'
      let l:cmd .= ' ctermfg=' . a:opts.fg
      let l:cmd .= ' guifg=' . a:opts.fg
    else
      let l:cmd .= ' ctermfg=' . s:colordict[a:opts.fg].num
      let l:cmd .= ' guifg=' . s:colordict[a:opts.fg].hex
    endif
  endif

  if has_key(a:opts, 'bg')
    if type(a:opts.bg) == type([])
      let l:cmd .= ' ctermbg=' . a:opts.bg[0]
      let l:cmd .= ' guibg=' . a:opts.bg[1]
    elseif a:opts.bg =~# '\vNONE|#[0-9a-f]{6}|fg'
      let l:cmd .= ' ctermbg=' . a:opts.bg
      let l:cmd .= ' guibg=' . a:opts.bg
    else
      let l:cmd .= ' ctermbg=' . s:colordict[a:opts.bg].num
      let l:cmd .= ' guibg=' . s:colordict[a:opts.bg].hex
    endif
  endif

  if has_key(a:opts, 'sp')
    let l:cmd .= ' guisp=' . a:opts.sp
  endif

  execute l:cmd
endfunction

" }}}1

" {{{1 Default/Internal groups

call s:highlight('Normal', {'fg': 'base00', 'bg': 'base3'})
call s:highlight('ColorColumn', {'bg': 'base2'})
call s:highlight('Comment', {'fg': 'base1', 'style': 'italic'})
call s:highlight('Conceal', {'fg': 'blue', 'bg': 'NONE'})
call s:highlight('Constant', {'fg': 'cyan'})
call s:highlight('Cursor', {'fg': 'base3', 'bg': 'base00'})
call s:highlight('CursorColumn', {'bg': 'base2'})
call s:highlight('CursorLine', {'bg': 'base2', 'sp': '#586e75', 'style': 'NONE'})
call s:highlight('CursorLineNr', {'fg': 'base1', 'style': 'NONE'})
call s:highlight('DiffAdd', {'bg': [193, '#ebe8c1'], 'sp': '#719e07'})
call s:highlight('DiffChange', {'bg': 'base2', 'sp': '#b58900'})
call s:highlight('DiffDelete', {'fg': 'NONE', 'bg': [217, '#f7cfbf'], 'style': 'NONE'})
call s:highlight('DiffText', {'bg': [193, '#d2e1e0'], 'sp': '#268bd2', 'style': 'NONE'})
call s:highlight('Directory', {'fg': 'blue'})
call s:highlight('Error', {'fg': 'red', 'bg': 'base3'})
call s:highlight('ErrorMsg', {'fg': 'red', 'bg': 'NONE', 'style': 'reverse'})
call s:highlight('FoldColumn', {'fg': 'base00', 'bg': 'base2'})
call s:highlight('Folded', {'fg': 'base00', 'bg': 'base2', 'sp': '#fdf6e3', 'style': 'underline'})
call s:highlight('Identifier', {'fg': 'blue'})
call s:highlight('Ignore', {'fg': 'base3'})
call s:highlight('IncSearch', {'fg': 'orange', 'style': 'standout'})
call s:highlight('LineNr', {'fg': 'base1', 'bg': 'base2'})
call s:highlight('MatchParen', {'fg': [33, 'Blue'], 'style': 'bold'})
call s:highlight('ModeMsg', {'fg': 'blue', 'style': 'NONE'})
call s:highlight('MoreMsg', {'fg': 'blue', 'style': 'NONE'})
call s:highlight('NonText', {'fg': 'base0', 'style': 'NONE'})
call s:highlight('NvimInternalError', {'fg': 'orange', 'bg': 'red'})
call s:highlight('Pmenu', {'fg': 'base00', 'bg': 'base2'}) " TODO: ctermbg=188
call s:highlight('PmenuSbar', {'fg': 'base02', 'bg': 'base00'})
call s:highlight('PmenuSel', {'fg': 'base1', 'bg': 'base02'})
call s:highlight('PmenuThumb', {'fg': 'base00', 'bg': 'base3'})
call s:highlight('PreProc', {'fg': 'orange'})
call s:highlight('Question', {'fg': 'cyan', 'style': 'NONE'})
call s:highlight('RedrawDebugClear', {'bg': 'base00'})
call s:highlight('RedrawDebugComposed', {'bg': 'green'})
call s:highlight('RedrawDebugNormal', {'style': 'reversed'})
call s:highlight('RedrawDebugRecompose', {'bg': 'orange'})
call s:highlight('Search', {'fg': [201, 'Magenta'], 'bg': 'NONE', 'style': 'bold,underline'})
call s:highlight('SignColumn', {'fg': 'base00', 'bg': 'base2'})
call s:highlight('Special', {'fg': 'red'})
call s:highlight('SpecialKey', {'fg': 'base0', 'bg': 'base2'})
call s:highlight('SpellBad',   {'fg': [124, 'Red'], 'bg': 'NONE', 'sp': '#dc322f', 'style': 'bold'})
call s:highlight('SpellCap',   {'fg': [33, 'Blue'], 'bg': 'NONE', 'sp': '#dc322f', 'style': 'bold'})
call s:highlight('SpellLocal', {'fg': [104, 'Purple'], 'bg': 'NONE', 'sp': '#dc322f', 'style': 'bold'})
call s:highlight('SpellRare',  {'fg': [227, 'Green'], 'bg': 'NONE', 'sp': '#dc322f', 'style': 'bold'})
call s:highlight('Statement', {'fg': 'green', 'style': 'NONE'})
call s:highlight('Statusline', {'fg': 'base01', 'bg': 'base3', 'style': 'reverse'})
call s:highlight('StatuslineNC', {'fg': 'base01', 'bg': 'base03', 'style': 'reverse'})
call s:highlight('TabLine', {'fg': 'base03', 'bg': 'base0', 'sp': 'base00', 'style': 'NONE'})
call s:highlight('TabLineFill', {'fg': 'base03', 'base0': 'base2', 'sp': 'base00', 'style': 'underline'})
call s:highlight('TabLineSel', {'fg': 'base3', 'bg': 'base0', 'sp': 'base00', 'style': 'underline,reverse'})
call s:highlight('TermCursor', {'style': 'bold'})
call s:highlight('Title', {'fg': 'orange', 'style': 'bold'})
call s:highlight('Todo', {'fg': 'magenta', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('Type', {'fg': 'yellow', 'style': 'NONE'})
call s:highlight('Underlined', {'fg': 'violet', 'style': 'NONE'})
call s:highlight('VertSplit', {'fg': 'base0', 'bg': 'base0', 'style': 'NONE'})
call s:highlight('Visual', {'fg': 'base1', 'bg': 'base3', 'style': 'reverse'})
call s:highlight('VisualNOS', {'bg': 'base2', 'style': 'reverse'})
call s:highlight('WarningMsg', {'fg': 'orange'})
call s:highlight('WildMenu', {'fg': 'base02', 'bg': 'base2', 'style': 'reverse'})
call s:highlight('Whitespace', {'fg': 'base0', 'bg': 'base2'})
call s:highlight('iCursor', {'fg': '#b58900'})
call s:highlight('rCursor', {'fg': '#dc322f'})
call s:highlight('vCursor', {'fg': '#d33682'})
call s:highlight('SLHighlight', {'fg': [220, '#ffe055'], 'bg': 'base01'})
call s:highlight('SLAlert', {'fg': [202, '#ff8888'], 'bg': 'base01'})
call s:highlight('SLFZF', {'fg': 'green'})

highlight link lCursor        Cursor

highlight link Boolean        Constant
highlight link Character      Constant
highlight link Conditional    Statement
highlight link Debug          Special
highlight link Define         PreProc
highlight link Delimiter      Special
highlight link Exception      Statement
highlight link Float          Number
highlight link Function       Identifier
highlight link Include        PreProc
highlight link Keyword        Statement
highlight link Label          Statement
highlight link Macro          PreProc
highlight link Number         Constant
highlight link Operator       Statement
highlight link PreCondit      PreProc
highlight link Repeat         Statement
highlight link SpecialChar    Special
highlight link SpecialComment Special
highlight link StorageClass   Type
highlight link String         Constant
highlight link Structure      Type
highlight link Tag            Special
highlight link Typedef        Type

" }}}1

" {{{ Various plugins

highlight ctrlsfSelectedLine    cterm=bold           gui=bold           ctermfg=39  guifg=#00afff
highlight OperatorSandwichBuns  cterm=bold           gui=bold           ctermfg=5   guifg=Magenta

highlight link ALEErrorLine ErrorMsg
highlight link ALEWarningLine WarningMsg
highlight link ALEInfoLine ModeMsg

highlight illuminatedWord cterm=underline gui=underline

" }}}1

" {{{1 ftsyntax: various

call s:highlight('cPreCondit', {'fg': 'orange'})

call s:highlight('htmlArg',            {'fg': 'base0'})
call s:highlight('htmlEndTag',         {'fg': 'base1'})
call s:highlight('htmlSpecialTagName', {'fg': 'blue', 'style': 'italic'})
call s:highlight('htmlTag',            {'fg': 'base1'})
call s:highlight('htmlTagN',           {'fg': 'base01'})
call s:highlight('htmlTagName',        {'fg': 'blue'})

call s:highlight('javaScript', {'fg': 'yellow'})

call s:highlight('perlHereDoc',           {'fg': 'base01', 'bg': 'base3'})
call s:highlight('perlStatementFileDesc', {'fg': 'cyan',   'bg': 'base3'})
call s:highlight('perlVarPlain',          {'fg': 'yellow', 'bg': 'base3'})

call s:highlight('rubyDefine', {'fg': 'base01', 'bg': 'base3'})

call s:highlight('texMathMatcher', {'fg': 'yellow'})
highlight link texStatement   Number
highlight link texCmdArgs     Identifier

" }}}1
" {{{1 ftsyntax: Vimscript

call s:highlight('vimCmdSep', {'fg': 'blue'})
call s:highlight('vimCommand', {'fg': 'yellow'})
call s:highlight('vimCommentString', {'fg': 'violet'})
call s:highlight('vimGroup', {'fg': 'blue', 'style': 'underline'})
call s:highlight('vimHiGroup', {'fg': 'blue'})
call s:highlight('vimHiLink', {'fg': 'blue'})
call s:highlight('vimIsCommand', {'fg': 'base0'})
call s:highlight('vimSynMtchOpt', {'fg': 'yellow'})
call s:highlight('vimSynType', {'fg': 'cyan'})

highlight link vimFunc                    Function
highlight link vimSet                     Normal
highlight link vimSetEqual                Normal
highlight link vimUserFunc                Function
highlight link vipmVar                    Identifier

" }}}1
" {{{1 ftsyntax: Vimdoc

call s:highlight('helpExample', {'fg': 'base03'})
call s:highlight('helpHyperTextEntry', {'fg': 'green'})
call s:highlight('helpHyperTextJump', {'fg': 'blue', 'style': 'underline'})
call s:highlight('helpNote', {'fg': 'magenta'})
call s:highlight('helpOption', {'fg': 'cyan'})
call s:highlight('helpVim', {'fg': 'magenta'})
highlight link helpSpecial Special
highlight clear helpLeadBlank
highlight clear helpNormal

" }}}1
" {{{1 ftsyntax: pandoc

call s:highlight('pandocBlockQuote',                       {'fg': 'blue'})
call s:highlight('pandocBlockQuoteLeader1',                {'fg': 'blue'})
call s:highlight('pandocBlockQuoteLeader2',                {'fg': 'cyan'})
call s:highlight('pandocBlockQuoteLeader3',                {'fg': 'yellow'})
call s:highlight('pandocBlockQuoteLeader4',                {'fg': 'red'})
call s:highlight('pandocBlockQuoteLeader5',                {'fg': 'base00'})
call s:highlight('pandocBlockQuoteLeader6',                {'fg': 'base1'})
call s:highlight('pandocCitation',                         {'fg': 'magenta'})
call s:highlight('pandocCitationDelim',                    {'fg': 'magenta'})
call s:highlight('pandocCitationID',                       {'fg': 'magenta', 'style': 'underline'})
call s:highlight('pandocCitationRef',                      {'fg': 'magenta'})
call s:highlight('pandocComment',                          {'fg': 'base1',   'style': 'italic'})
call s:highlight('pandocDefinitionBlock',                  {'fg': 'violet'})
call s:highlight('pandocDefinitionIndctr',                 {'fg': 'violet'})
call s:highlight('pandocDefinitionTerm',                   {'fg': 'violet',  'style': 'standout'})
call s:highlight('pandocEmphasis',                         {'fg': 'base00',  'style': 'italic'})
call s:highlight('pandocEmphasisDefinition',               {'fg': 'violet',  'style': 'italic'})
call s:highlight('pandocEmphasisHeading',                  {'fg': 'orange'})
call s:highlight('pandocEmphasisNested',                   {'fg': 'base00'})
call s:highlight('pandocEmphasisNestedDefinition',         {'fg': 'violet'})
call s:highlight('pandocEmphasisNestedHeading',            {'fg': 'orange'})
call s:highlight('pandocEmphasisNestedTable',              {'fg': 'blue'})
call s:highlight('pandocEmphasisTable',                    {'fg': 'blue',    'style': 'italic'})
call s:highlight('pandocEscapePair',                       {'fg': 'red'})
call s:highlight('pandocFootnote',                         {'fg': 'green'})
call s:highlight('pandocFootnoteDefLink',                  {'fg': 'green'})
call s:highlight('pandocFootnoteInline',                   {'fg': 'green',   'style': 'underline'})
call s:highlight('pandocFootnoteLink',                     {'fg': 'green',   'style': 'underline'})
call s:highlight('pandocHeading',                          {'fg': 'orange'})
call s:highlight('pandocHeadingMarker',                    {'fg': 'yellow'})
call s:highlight('pandocImageCaption',                     {'fg': 'violet',  'style': 'underline'})
call s:highlight('pandocLinkDefinition',                   {'fg': 'cyan',    'sp':    '#839496', 'style': 'underline'})
call s:highlight('pandocLinkDefinitionID',                 {'fg': 'blue'})
call s:highlight('pandocLinkDelim',                        {'fg': 'base1'})
call s:highlight('pandocLinkLabel',                        {'fg': 'blue',    'style': 'underline'})
call s:highlight('pandocLinkText',                         {'fg': 'blue',    'style': 'underline'})
call s:highlight('pandocLinkTitle',                        {'fg': 'base0',   'style': 'underline'})
call s:highlight('pandocLinkTitleDelim',                   {'fg': 'base1',   'sp':    '#839496', 'style': 'underline'})
call s:highlight('pandocLinkURL',                          {'fg': 'base0',   'style': 'underline'})
call s:highlight('pandocListMarker',                       {'fg': 'magenta'})
call s:highlight('pandocListReference',                    {'fg': 'magenta', 'style': 'underline'})
call s:highlight('pandocMetadata',                         {'fg': 'blue'})
call s:highlight('pandocMetadataDelim',                    {'fg': 'base1'})
call s:highlight('pandocMetadataKey',                      {'fg': 'blue'})
call s:highlight('pandocNonBreakingSpace',                 {'fg': 'red',     'style': 'reverse'})
call s:highlight('pandocRule',                             {'fg': 'blue'})
call s:highlight('pandocRuleLine',                         {'fg': 'blue'})
call s:highlight('pandocStrikeout',                        {'fg': 'base1',   'style': 'reverse'})
call s:highlight('pandocStrikeoutDefinition',              {'fg': 'violet',  'style': 'reverse'})
call s:highlight('pandocStrikeoutHeading',                 {'fg': 'orange',  'style': 'reverse'})
call s:highlight('pandocStrikeoutTable',                   {'fg': 'blue',    'style': 'reverse'})
call s:highlight('pandocStrongEmphasis',                   {'fg': 'base00'})
call s:highlight('pandocStrongEmphasisDefinition',         {'fg': 'violet'})
call s:highlight('pandocStrongEmphasisEmphasis',           {'fg': 'base00'})
call s:highlight('pandocStrongEmphasisEmphasisDefinition', {'fg': 'violet'})
call s:highlight('pandocStrongEmphasisEmphasisHeading',    {'fg': 'orange'})
call s:highlight('pandocStrongEmphasisEmphasisTable',      {'fg': 'blue'})
call s:highlight('pandocStrongEmphasisHeading',            {'fg': 'orange'})
call s:highlight('pandocStrongEmphasisNested',             {'fg': 'base00'})
call s:highlight('pandocStrongEmphasisNestedDefinition',   {'fg': 'violet'})
call s:highlight('pandocStrongEmphasisNestedHeading',      {'fg': 'orange'})
call s:highlight('pandocStrongEmphasisNestedTable',        {'fg': 'blue'})
call s:highlight('pandocStrongEmphasisTable',              {'fg': 'blue'})
call s:highlight('pandocStyleDelim',                       {'fg': 'base1'})
call s:highlight('pandocSubscript',                        {'fg': 'violet'})
call s:highlight('pandocSubscriptDefinition',              {'fg': 'violet'})
call s:highlight('pandocSubscriptHeading',                 {'fg': 'orange'})
call s:highlight('pandocSubscriptTable',                   {'fg': 'blue'})
call s:highlight('pandocSuperscript',                      {'fg': 'violet'})
call s:highlight('pandocSuperscriptDefinition',            {'fg': 'violet'})
call s:highlight('pandocSuperscriptHeading',               {'fg': 'orange'})
call s:highlight('pandocSuperscriptTable',                 {'fg': 'blue'})
call s:highlight('pandocTable',                            {'fg': 'blue'})
call s:highlight('pandocTableStructure',                   {'fg': 'blue'})
call s:highlight('pandocTableZebraDark',                   {'fg': 'blue',    'bg':    'base2'})
call s:highlight('pandocTableZebraLight',                  {'fg': 'blue',    'bg':    'base3'})
call s:highlight('pandocTitleBlock',                       {'fg': 'blue'})
call s:highlight('pandocTitleBlockTitle',                  {'fg': 'blue'})
call s:highlight('pandocTitleComment',                     {'fg': 'blue'})
call s:highlight('pandocVerbatimBlock',                    {'fg': 'yellow'})
call s:highlight('pandocVerbatimInline',                   {'fg': 'yellow'})
call s:highlight('pandocVerbatimInlineDefinition',         {'fg': 'violet'})
call s:highlight('pandocVerbatimInlineHeading',            {'fg': 'orange'})
call s:highlight('pandocVerbatimInlineTable',              {'fg': 'blue'})

highlight link pandocCodeBlock         pandocVerbatimBlock
highlight link pandocCodeBlockDelim    pandocVerbatimBlock
highlight link pandocEscapedCharacter  pandocEscapePair
highlight link pandocLineBreak         pandocEscapePair
highlight link pandocMetadataTitle     pandocMetadata
highlight link pandocTableStructureEnd pandocTableStructure
highlight link pandocTableStructureTop pandocTableStructure
highlight link pandocVerbatimBlockDeep pandocVerbatimBlock

highlight clear pandocTableStructure

" }}}1
" {{{1 ftsyntax: Git

call s:highlight('gitcommitBranch', {'fg': 'magenta'})
call s:highlight('gitcommitComment', {'fg': 'base1', 'style': 'italic'})
call s:highlight('gitcommitDiscardedFile', {'fg': 'red'})
call s:highlight('gitcommitDiscardedType', {'fg': 'red'})
call s:highlight('gitcommitFile', {'fg': 'base00'})
call s:highlight('gitcommitHeader', {'fg': 'base1'})
call s:highlight('gitcommitOnBranch', {'fg': 'base1'})
call s:highlight('gitcommitSelectedFile', {'fg': 'green'})
call s:highlight('gitcommitSelectedType', {'fg': 'green'})
call s:highlight('gitcommitUnmerged', {'fg': 'green'})
call s:highlight('gitcommitUnmergedFile', {'fg': 'yellow'})
call s:highlight('gitcommitUntrackedFile', {'fg': 'cyan'})

highlight link gitcommitDiscarded         gitcommitComment
highlight link gitcommitDiscardedArrow    gitcommitDiscardedFile
highlight link gitcommitNoBranch          gitcommitBranch
highlight link gitcommitSelected          gitcommitComment
highlight link gitcommitSelectedArrow     gitcommitSelectedFile
highlight link gitcommitUnmergedArrow     gitcommitUnmergedFile
highlight link gitcommitUntracked         gitcommitComment

" }}}1
" {{{1 ftsyntax: Haskell

call s:highlight('hsImport', {'fg': 'magenta'})
call s:highlight('hsImportLabel', {'fg': 'cyan'})
call s:highlight('hsModuleName', {'fg': 'green', 'style': 'underline'})
call s:highlight('hsNiceOperator', {'fg': 'cyan'})
call s:highlight('hsStatement', {'fg': 'cyan'})
call s:highlight('hsString', {'fg': 'base0'})
call s:highlight('hsStructure', {'fg': 'cyan'})
call s:highlight('hsType', {'fg': 'yellow'})
call s:highlight('hsTypedef', {'fg': 'cyan'})
call s:highlight('hsVarSym', {'fg': 'cyan'})
call s:highlight('hs_DeclareFunction', {'fg': 'orange'})
call s:highlight('hs_OpFunctionName', {'fg': 'yellow'})
call s:highlight('hs_hlFunctionName', {'fg': 'blue'})

highlight link hsDelimTypeExport          Delimiter
highlight link hsImportParams             Delimiter
highlight link hsModuleStartLabel         hsStructure
highlight link hsModuleWhereLabel         hsModuleStartLabel
highlight link htmlLink                   Function

" }}}1
" {{{1 ftsyntax: diff

highlight link diffAdded                  Statement
highlight link diffBDiffer                WarningMsg
highlight link diffCommon                 WarningMsg
highlight link diffDiffer                 WarningMsg
highlight link diffIdentical              WarningMsg
highlight link diffIsA                    WarningMsg
highlight link diffLine                   Identifier
highlight link diffNoEOL                  WarningMsg
highlight link diffOnly                   WarningMsg
highlight link diffRemoved                WarningMsg

" }}}1
" {{{1 ftsyntax: python (semshi)

highlight link semshiUnresolved Normal
highlight link semshiBuiltin Function
highlight semshiImported        ctermfg=black
highlight semshiGlobal          ctermfg=magenta
highlight semshiParameter       ctermfg=101
highlight semshiParameterUnused ctermfg=100
highlight semshiFree            ctermfg=darkmagenta
highlight semshiAttribute       ctermfg=lightblue
highlight semshiSelected        cterm=underline

" }}}1
