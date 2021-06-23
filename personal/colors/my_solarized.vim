" My own, customized, light Solarized theme
" Based on: Romain Lafourcade's 'flattened_light'

" This can be used for dynamic reloading
" augroup my_solarized
"   au!
"   au InsertLeave,TextChanged my_solarized.vim silent update | colorscheme my_solarized | echo 'reloaded'
" augroup END

highlight clear
if exists('syntax_on') | syntax reset | endif

let colors_name = 'my_solarized'
set background=light

" {{{1 Define colors
"
" In the following, the first 16 colors make out the base colorscheme, while
" the remaining colors are custom colors I've defined for various other things.
" The colorscheme should look the same in 256 colors and truecolors as long as
" the terminal colors are set correctly. The custom colors are calibrated to
" look similar in 256 colors and truecolors.
let s:colordict = {
      \ 'color00':   {'hex': '#073642', 'num': 0,   'name': 'base02'},
      \ 'color01':   {'hex': '#dc322f', 'num': 1,   'name': 'red'},
      \ 'color01d':  {'hex': '#801c1b', 'num': 1,   'name': 'redv50'},
      \ 'color01l':  {'hex': '#ff3936', 'num': 1,   'name': 'redv100'},
      \ 'color02':   {'hex': '#859900', 'num': 2,   'name': 'green'},
      \ 'color02d':  {'hex': '#586600', 'num': 2,   'name': 'greenv40'},
      \ 'color02l':  {'hex': '#b1cc00', 'num': 2,   'name': 'greenv80'},
      \ 'color03':   {'hex': '#b58900', 'num': 3,   'name': 'yellow'},
      \ 'color03d':  {'hex': '#4d3800', 'num': 3,   'name': 'yellowv30'},
      \ 'color03l':  {'hex': '#f2b600', 'num': 3,   'name': 'yellowv95'},
      \ 'color04':   {'hex': '#268bd2', 'num': 4,   'name': 'blue'},
      \ 'color04d':  {'hex': '#175480', 'num': 4,   'name': 'bluev50'},
      \ 'color05':   {'hex': '#d33682', 'num': 5,   'name': 'magenta'},
      \ 'color06':   {'hex': '#2aa198', 'num': 6,   'name': 'cyan'},
      \ 'color07':   {'hex': '#eee8d5', 'num': 7,   'name': 'base2'},
      \ 'color07d':  {'hex': '#e8e2ce', 'num': 188, 'name': 'base2v91'},
      \ 'color08':   {'hex': '#002b36', 'num': 8,   'name': 'base03'},
      \ 'color09':   {'hex': '#cb4b16', 'num': 9,   'name': 'orange'},
      \ 'color09l':  {'hex': '#e66b32', 'num': 9,   'name': 'orange'},
      \ 'color10':   {'hex': '#586e75', 'num': 10,  'name': 'base01'},
      \ 'color11':   {'hex': '#657b83', 'num': 11,  'name': 'base00'},
      \ 'color12':   {'hex': '#839496', 'num': 12,  'name': 'base0'},
      \ 'color13':   {'hex': '#6c71c4', 'num': 13,  'name': 'violet'},
      \ 'color14':   {'hex': '#93a1a1', 'num': 14,  'name': 'base1'},
      \ 'color15':   {'hex': '#fdf6e3', 'num': 15,  'name': 'base3'},
      \ 'color15d':  {'hex': '#e0dac9', 'num': 59,  'name': 'base3v88'},
      \ 'color15w':  {'hex': '#fffaed', 'num': 231, 'name': 'base3v100s7'},
      \ 'army1':     {'hex': '#878700', 'num': 100},
      \ 'army2':     {'hex': '#87875f', 'num': 101},
      \ 'black':     {'hex': '#000000', 'num': 0},
      \ 'blue1':     {'hex': '#0087ff', 'num': 33},
      \ 'blue2':     {'hex': '#00afff', 'num': 39},
      \ 'blue3':     {'hex': '#add8e6', 'num': 117},
      \ 'blue4':     {'hex': '#2222aa', 'num': 117},
      \ 'gold1':     {'hex': '#ffe055', 'num': 220},
      \ 'gray1':     {'hex': '#d2e1e0', 'num': 253},
      \ 'green1':    {'hex': '#719e07', 'num': 64},
      \ 'green2':    {'hex': '#d7ffaf', 'num': 193},
      \ 'magenta1':  {'hex': '#ff00ff', 'num': 201},
      \ 'magenta1d': {'hex': '#8b008b', 'num': 90},
      \ 'orange1':   {'hex': '#ff5f00', 'num': 202},
      \ 'pink1':     {'hex': '#f7cfbf', 'num': 217},
      \ 'purple1':   {'hex': '#8787d7', 'num': 104},
      \ 'red1':      {'hex': '#af0000', 'num': 124},
      \ 'yellow1':   {'hex': '#ffff5f', 'num': 227},
      \}

" }}}1
function! s:highlight(group, opts) abort " {{{1
  let l:cmd = 'highlight ' . a:group

  if has_key(a:opts, 'style')
    let l:cmd .= ' cterm=' . a:opts.style
    let l:cmd .= ' gui=' . a:opts.style
  endif

  let l:special = ['NONE', 'bg', 'background', 'fg', 'foreground']
  for l:x in ['fg', 'bg']
    if has_key(a:opts, l:x)
      if index(l:special, a:opts[l:x]) >= 0
        let l:cmd .= ' cterm' . l:x . '=' . a:opts[l:x]
        let l:cmd .= ' gui' . l:x . '=' . a:opts[l:x]
      else
        let l:cmd .= ' cterm' . l:x . '=' . s:colordict[a:opts[l:x]].num
        let l:cmd .= ' gui' . l:x . '=' . s:colordict[a:opts[l:x]].hex
      endif
    endif
  endfor

  if has_key(a:opts, 'sp')
    let l:cmd .= ' guisp=' . s:colordict[a:opts.sp].hex
  endif

  execute l:cmd
endfunction

" }}}1

" {{{1 Highlight: Internal groups

call s:highlight('Normal', {'fg': 'color11', 'bg': 'color15'})
call s:highlight('ColorColumn', {'bg': 'color07'})
call s:highlight('Conceal', {'fg': 'color04', 'bg': 'NONE'})
call s:highlight('Cursor', {'fg': 'color15', 'bg': 'color11'})
call s:highlight('CursorColumn', {'bg': 'color07', 'style': 'NONE'})
call s:highlight('CursorLine', {'bg': 'color07', 'sp': 'color10', 'style': 'NONE'})
call s:highlight('CursorLineNr', {'fg': 'color14', 'style': 'NONE'})
call s:highlight('DiffAdd', {'bg': 'green2', 'sp': 'green1'})
call s:highlight('DiffChange', {'bg': 'color07', 'sp': 'color03'})
call s:highlight('DiffDelete', {'fg': 'NONE', 'bg': 'pink1', 'style': 'NONE'})
call s:highlight('DiffText', {'bg': 'gray1', 'sp': 'color04', 'style': 'NONE'})
call s:highlight('Directory', {'fg': 'color04'})
call s:highlight('ErrorMsg', {'fg': 'color01', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('FoldColumn', {'fg': 'color11', 'bg': 'color07'})
call s:highlight('Folded', {'fg': 'color11', 'bg': 'color07d', 'sp': 'color15', 'style': 'underline'})
call s:highlight('IncSearch', {'fg': 'color09', 'style': 'standout'})
call s:highlight('LineNr', {'fg': 'color14', 'bg': 'color07'})
call s:highlight('MatchParen', {'fg': 'color04', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('ModeMsg', {'fg': 'color04', 'style': 'NONE'})
call s:highlight('MoreMsg', {'fg': 'color04', 'style': 'NONE'})
call s:highlight('NonText', {'fg': 'color12', 'style': 'NONE'})
call s:highlight('Pmenu', {'fg': 'color11', 'bg': 'color15d'})
call s:highlight('PmenuSbar', {'fg': 'color00', 'bg': 'color11'})
call s:highlight('PmenuSel', {'fg': 'color14', 'bg': 'color00'})
call s:highlight('PmenuThumb', {'fg': 'color11'})
call s:highlight('Question', {'fg': 'color06', 'style': 'NONE'})
call s:highlight('RedrawDebugClear', {'bg': 'color11'})
call s:highlight('RedrawDebugComposed', {'bg': 'color02'})
call s:highlight('RedrawDebugNormal', {'style': 'reverse'})
call s:highlight('RedrawDebugRecompose', {'bg': 'color09'})
call s:highlight('Search', {'fg': 'magenta1', 'bg': 'NONE', 'style': 'bold,underline'})
call s:highlight('SignColumn', {'fg': 'color11', 'bg': 'color07'})
call s:highlight('SpecialKey', {'fg': 'color12', 'bg': 'color07'})
call s:highlight('SpellBad',   {'fg': 'red1', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('SpellCap',   {'fg': 'blue1', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('SpellLocal', {'fg': 'purple1', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('SpellRare',  {'fg': 'yellow1', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('TermCursor', {'style': 'bold'})
call s:highlight('Title', {'fg': 'color09', 'style': 'bold'})
call s:highlight('VertSplit', {'fg': 'color12', 'bg': 'color12', 'style': 'NONE'})
call s:highlight('Visual', {'fg': 'color15', 'bg': 'color14', 'style': 'NONE'})
call s:highlight('VisualNOS', {'bg': 'color07', 'style': 'reverse'})
call s:highlight('WarningMsg', {'fg': 'color09'})
call s:highlight('WildMenu', {'fg': 'color00', 'bg': 'color07', 'style': 'reverse'})
call s:highlight('Whitespace', {'fg': 'color12', 'bg': 'color07'})

" Statusline and tabline
call s:highlight('Statusline', {'fg': 'color15', 'bg': 'color10', 'style': 'NONE'})
call s:highlight('StatuslineNC', {'fg': 'color08', 'bg': 'color10', 'style': 'NONE'})
call s:highlight('SLHighlight', {'fg': 'gold1', 'bg': 'color10'})
call s:highlight('SLInfo', {'fg': 'color02l', 'bg': 'color10'})
call s:highlight('SLAlert', {'fg': 'orange1', 'bg': 'color10'})
call s:highlight('SLFZF', {'fg': 'color02'})
call s:highlight('TabLine', {'fg': 'color08', 'bg': 'color10', 'sp': 'color11', 'style': 'NONE'})
call s:highlight('TabLineFill', {'fg': 'color08', 'bg': 'color10', 'sp': 'color11', 'style': 'NONE'})
call s:highlight('TabLineSel', {'fg': 'gold1', 'bg': 'color10', 'sp': 'color11', 'style': 'NONE'})

" Cursor colors
call s:highlight('iCursor', {'bg': 'color03'})
call s:highlight('rCursor', {'bg': 'color01'})
call s:highlight('vCursor', {'bg': 'color05'})
highlight link lCursor        Cursor

" }}}1
" {{{1 Highlight: Default syntax groups (:help group-names)

call s:highlight('Comment', {'fg': 'color14', 'style': 'italic'})
call s:highlight('Constant', {'fg': 'color06'})
call s:highlight('Error', {'fg': 'color01', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('Identifier', {'fg': 'color04', 'style': 'NONE'})
call s:highlight('Ignore', {'fg': 'color15'})
call s:highlight('PreProc', {'fg': 'color08'})
call s:highlight('Special', {'fg': 'color01'})
call s:highlight('Statement', {'fg': 'color02', 'style': 'NONE'})
call s:highlight('Todo', {'fg': 'color05', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('Type', {'fg': 'color03', 'style': 'NONE'})
call s:highlight('Underlined', {'fg': 'color13', 'style': 'NONE'})

highlight link Boolean        Constant
highlight link Character      Constant
highlight link Float          Constant
highlight link Number         Constant
highlight link String         Constant
highlight link Function       Identifier
highlight link Define         PreProc
highlight link Include        PreProc
highlight link Macro          PreProc
highlight link PreCondit      PreProc
highlight link Debug          Special
highlight link Delimiter      Special
highlight link SpecialChar    Special
highlight link SpecialComment Special
highlight link Tag            Special
highlight link Conditional    Statement
highlight link Exception      Statement
highlight link Keyword        Statement
highlight link Label          Statement
highlight link Operator       Statement
highlight link Repeat         Statement
highlight link StorageClass   Type
highlight link Structure      Type
highlight link Typedef        Type

" }}}1

" {{{1 Highlight: Plugin CoC.nvim

highlight link CocErrorSign   Error
highlight link CocWarningSign WarningMsg
highlight link CocInfoSign    ModeMsg
highlight link CocHintSign    Question
highlight link CocCodeLens    codeBlockBackground

" Linked:
"   highlight default link CocErrorVirtualText   CocErrorSign
"   highlight default link CocWarningVirtualText CocWarningSign
"   highlight default link CocInfoVirtualText    CocInfoSign
"   highlight default link CocHintVirtualText    CocHintSign
"   highlight default link CocErrorHighlight     CocUnderline
"   highlight default link CocWarningHighlight   CocUnderline
"   highlight default link CocInfoHighlight      CocUnderline
"   highlight default link CocHintHighlight      CocUnderline
"   highlight default link CocHighlightText      CursorColumn
"   highlight default link CocHighlightRead      CocHighlightText
"   highlight default link CocHighlightWrite     CocHighlightText
"   highlight default link CocFloating           Pmenu
"   highlight default link CocErrorFloat         CocErrorSign
"   highlight default link CocWarningFloat       CocWarningSign
"   highlight default link CocInfoFloat          CocInfoSign
"   highlight default link CocHintFloat          CocHintSign
"   highlight default link CocCursorRange        Search
"   highlight default link CocHoverRange         Search

" Undefined:
"   CocErrorLine
"   CocWarningLine
"   CocInfoLine
"   CocHintLine

" }}}1
" {{{ Highlight: Various plugins

call s:highlight('ctrlsfSelectedLine', {'fg': 'blue2', 'style': 'bold'})
call s:highlight('OperatorSandwichBuns', {'fg': 'color05', 'style': 'bold'})

highlight link ALEErrorLine ErrorMsg
highlight link ALEWarningLine WarningMsg
highlight link ALEInfoLine ModeMsg

call s:highlight('illuminatedWord', {'style': 'underline'})

call s:highlight('codeBlockBackground', {'bg': 'color15w'})

" }}}1

" {{{1 Highlight: Filetype Vimscript

call s:highlight('vimCmdSep', {'fg': 'color04'})
call s:highlight('vimCommand', {'fg': 'color03'})
call s:highlight('vimCommentString', {'fg': 'color13'})
call s:highlight('vimGroup', {'fg': 'color04', 'style': 'underline'})
call s:highlight('vimHiGroup', {'fg': 'color04'})
call s:highlight('vimHiLink', {'fg': 'color04'})
call s:highlight('vimIsCommand', {'fg': 'color12'})
call s:highlight('vimSynMtchOpt', {'fg': 'color03'})
call s:highlight('vimSynType', {'fg': 'color06'})

" highlight link vimSet      Normal
" highlight link vimSetEqual Normal
highlight link vimFunc     Function
highlight link vimUserFunc Function
highlight link vipmVar     Identifier

" }}}1
" {{{1 Highlight: Filetype Vim help

call s:highlight('helpHyperTextEntry', {'fg': 'color02'})
call s:highlight('helpHyperTextJump', {'fg': 'color04', 'style': 'underline'})
call s:highlight('helpNote', {'fg': 'color05'})
call s:highlight('helpOption', {'fg': 'color06'})
call s:highlight('helpVim', {'fg': 'color05'})
highlight link helpExample  PreProc
highlight link helpHeader   Special
highlight link helpSpecial  Special
highlight link helpIgnore   Special
highlight link helpBacktick Special
highlight link helpBar      Special
highlight link helpStar     Special

" }}}1
" {{{1 Highlight: Filetype pandoc

call s:highlight('pandocBlockQuote',                       {'fg': 'color04'})
call s:highlight('pandocBlockQuoteLeader1',                {'fg': 'color04'})
call s:highlight('pandocBlockQuoteLeader2',                {'fg': 'color06'})
call s:highlight('pandocBlockQuoteLeader3',                {'fg': 'color03'})
call s:highlight('pandocBlockQuoteLeader4',                {'fg': 'color01'})
call s:highlight('pandocBlockQuoteLeader5',                {'fg': 'color11'})
call s:highlight('pandocBlockQuoteLeader6',                {'fg': 'color14'})
call s:highlight('pandocCitation',                         {'fg': 'color05'})
call s:highlight('pandocCitationDelim',                    {'fg': 'color05'})
call s:highlight('pandocCitationID',                       {'fg': 'color05', 'style': 'underline'})
call s:highlight('pandocCitationRef',                      {'fg': 'color05'})
call s:highlight('pandocComment',                          {'fg': 'color14', 'style': 'italic'})
call s:highlight('pandocDefinitionBlock',                  {'fg': 'color13'})
call s:highlight('pandocDefinitionIndctr',                 {'fg': 'color13'})
call s:highlight('pandocDefinitionTerm',                   {'fg': 'color13', 'style': 'standout'})
call s:highlight('pandocEmphasis',                         {'fg': 'color11', 'style': 'italic'})
call s:highlight('pandocEmphasisDefinition',               {'fg': 'color13', 'style': 'italic'})
call s:highlight('pandocEmphasisHeading',                  {'fg': 'color09'})
call s:highlight('pandocEmphasisNested',                   {'fg': 'color11'})
call s:highlight('pandocEmphasisNestedDefinition',         {'fg': 'color13'})
call s:highlight('pandocEmphasisNestedHeading',            {'fg': 'color09'})
call s:highlight('pandocEmphasisNestedTable',              {'fg': 'color04'})
call s:highlight('pandocEmphasisTable',                    {'fg': 'color04', 'style': 'italic'})
call s:highlight('pandocEscapePair',                       {'fg': 'color01'})
call s:highlight('pandocFootnote',                         {'fg': 'color02'})
call s:highlight('pandocFootnoteDefLink',                  {'fg': 'color02'})
call s:highlight('pandocFootnoteInline',                   {'fg': 'color02', 'style': 'underline'})
call s:highlight('pandocFootnoteLink',                     {'fg': 'color02', 'style': 'underline'})
call s:highlight('pandocHeading',                          {'fg': 'color09'})
call s:highlight('pandocHeadingMarker',                    {'fg': 'color03'})
call s:highlight('pandocImageCaption',                     {'fg': 'color13', 'style': 'underline'})
call s:highlight('pandocLinkDefinition',                   {'fg': 'color06', 'sp': 'color12', 'style': 'underline'})
call s:highlight('pandocLinkDefinitionID',                 {'fg': 'color04'})
call s:highlight('pandocLinkDelim',                        {'fg': 'color14'})
call s:highlight('pandocLinkLabel',                        {'fg': 'color04', 'style': 'underline'})
call s:highlight('pandocLinkText',                         {'fg': 'color04', 'style': 'underline'})
call s:highlight('pandocLinkTitle',                        {'fg': 'color12', 'style': 'underline'})
call s:highlight('pandocLinkTitleDelim',                   {'fg': 'color14', 'sp': 'color12', 'style': 'underline'})
call s:highlight('pandocLinkURL',                          {'fg': 'color12', 'style': 'underline'})
call s:highlight('pandocListMarker',                       {'fg': 'color05'})
call s:highlight('pandocListReference',                    {'fg': 'color05', 'style': 'underline'})
call s:highlight('pandocMetadata',                         {'fg': 'color04'})
call s:highlight('pandocMetadataDelim',                    {'fg': 'color14'})
call s:highlight('pandocMetadataKey',                      {'fg': 'color04'})
call s:highlight('pandocNonBreakingSpace',                 {'fg': 'color01', 'style': 'reverse'})
call s:highlight('pandocRule',                             {'fg': 'color04'})
call s:highlight('pandocRuleLine',                         {'fg': 'color04'})
call s:highlight('pandocStrikeout',                        {'fg': 'color14', 'style': 'reverse'})
call s:highlight('pandocStrikeoutDefinition',              {'fg': 'color13', 'style': 'reverse'})
call s:highlight('pandocStrikeoutHeading',                 {'fg': 'color09', 'style': 'reverse'})
call s:highlight('pandocStrikeoutTable',                   {'fg': 'color04', 'style': 'reverse'})
call s:highlight('pandocStrongEmphasis',                   {'fg': 'color11'})
call s:highlight('pandocStrongEmphasisDefinition',         {'fg': 'color13'})
call s:highlight('pandocStrongEmphasisEmphasis',           {'fg': 'color11'})
call s:highlight('pandocStrongEmphasisEmphasisDefinition', {'fg': 'color13'})
call s:highlight('pandocStrongEmphasisEmphasisHeading',    {'fg': 'color09'})
call s:highlight('pandocStrongEmphasisEmphasisTable',      {'fg': 'color04'})
call s:highlight('pandocStrongEmphasisHeading',            {'fg': 'color09'})
call s:highlight('pandocStrongEmphasisNested',             {'fg': 'color11'})
call s:highlight('pandocStrongEmphasisNestedDefinition',   {'fg': 'color13'})
call s:highlight('pandocStrongEmphasisNestedHeading',      {'fg': 'color09'})
call s:highlight('pandocStrongEmphasisNestedTable',        {'fg': 'color04'})
call s:highlight('pandocStrongEmphasisTable',              {'fg': 'color04'})
call s:highlight('pandocStyleDelim',                       {'fg': 'color14'})
call s:highlight('pandocSubscript',                        {'fg': 'color13'})
call s:highlight('pandocSubscriptDefinition',              {'fg': 'color13'})
call s:highlight('pandocSubscriptHeading',                 {'fg': 'color09'})
call s:highlight('pandocSubscriptTable',                   {'fg': 'color04'})
call s:highlight('pandocSuperscript',                      {'fg': 'color13'})
call s:highlight('pandocSuperscriptDefinition',            {'fg': 'color13'})
call s:highlight('pandocSuperscriptHeading',               {'fg': 'color09'})
call s:highlight('pandocSuperscriptTable',                 {'fg': 'color04'})
call s:highlight('pandocTable',                            {'fg': 'color04'})
call s:highlight('pandocTableStructure',                   {'fg': 'color04'})
call s:highlight('pandocTableZebraDark',                   {'fg': 'color04', 'bg':    'color07'})
call s:highlight('pandocTableZebraLight',                  {'fg': 'color04'})
call s:highlight('pandocTitleBlock',                       {'fg': 'color04'})
call s:highlight('pandocTitleBlockTitle',                  {'fg': 'color04'})
call s:highlight('pandocTitleComment',                     {'fg': 'color04'})
call s:highlight('pandocVerbatimBlock',                    {'fg': 'color03'})
call s:highlight('pandocVerbatimInline',                   {'fg': 'color03'})
call s:highlight('pandocVerbatimInlineDefinition',         {'fg': 'color13'})
call s:highlight('pandocVerbatimInlineHeading',            {'fg': 'color09'})
call s:highlight('pandocVerbatimInlineTable',              {'fg': 'color04'})

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
" {{{1 Highlight: Filetype Git

call s:highlight('gitcommitBranch',        {'fg': 'color05'})
call s:highlight('gitcommitComment',       {'fg': 'color14', 'style': 'italic'})
call s:highlight('gitcommitDiscardedFile', {'fg': 'color01'})
call s:highlight('gitcommitDiscardedType', {'fg': 'color01'})
call s:highlight('gitcommitFile',          {'fg': 'color11'})
call s:highlight('gitcommitHeader',        {'fg': 'color14'})
call s:highlight('gitcommitOnBranch',      {'fg': 'color14'})
call s:highlight('gitcommitSelectedFile',  {'fg': 'color02'})
call s:highlight('gitcommitSelectedType',  {'fg': 'color02'})
call s:highlight('gitcommitUnmerged',      {'fg': 'color02'})
call s:highlight('gitcommitUnmergedFile',  {'fg': 'color03'})
call s:highlight('gitcommitUntrackedFile', {'fg': 'color06'})

highlight link gitcommitDiscarded      gitcommitComment
highlight link gitcommitDiscardedArrow gitcommitDiscardedFile
highlight link gitcommitNoBranch       gitcommitBranch
highlight link gitcommitSelected       gitcommitComment
highlight link gitcommitSelectedArrow  gitcommitSelectedFile
highlight link gitcommitUnmergedArrow  gitcommitUnmergedFile
highlight link gitcommitUntracked      gitcommitComment

" }}}1
" {{{1 Highlight: Filetype Haskell

call s:highlight('hsImport',           {'fg': 'color05'})
call s:highlight('hsImportLabel',      {'fg': 'color06'})
call s:highlight('hsModuleName',       {'fg': 'color02', 'style': 'underline'})
call s:highlight('hsNiceOperator',     {'fg': 'color06'})
call s:highlight('hsStatement',        {'fg': 'color06'})
call s:highlight('hsString',           {'fg': 'color12'})
call s:highlight('hsStructure',        {'fg': 'color06'})
call s:highlight('hsType',             {'fg': 'color03'})
call s:highlight('hsTypedef',          {'fg': 'color06'})
call s:highlight('hsVarSym',           {'fg': 'color06'})
call s:highlight('hs_DeclareFunction', {'fg': 'color09'})
call s:highlight('hs_OpFunctionName',  {'fg': 'color03'})
call s:highlight('hs_hlFunctionName',  {'fg': 'color04'})

highlight link hsDelimTypeExport  Delimiter
highlight link hsImportParams     Delimiter
highlight link hsModuleStartLabel hsStructure
highlight link hsModuleWhereLabel hsModuleStartLabel
highlight link htmlLink           Function

" }}}1
" {{{1 Highlight: Filetype diff

highlight link diffAdded     Statement
highlight link diffBDiffer   WarningMsg
highlight link diffCommon    WarningMsg
highlight link diffDiffer    WarningMsg
highlight link diffIdentical WarningMsg
highlight link diffIsA       WarningMsg
highlight link diffLine      Identifier
highlight link diffNoEOL     WarningMsg
highlight link diffOnly      WarningMsg
highlight link diffRemoved   WarningMsg

" }}}1
" {{{1 Highlight: Filetype python (semshi)

call s:highlight('semshiImported',        {'fg': 'color08'})
call s:highlight('semshiGlobal',          {'fg': 'color05'})
call s:highlight('semshiParameter',       {'fg': 'army2'})
call s:highlight('semshiParameterUnused', {'fg': 'army1'})
call s:highlight('semshiFree',            {'fg': 'magenta1d'})
call s:highlight('semshiAttribute',       {'fg': 'blue3'})
call s:highlight('semshiSelected',        {'style': 'underline'})
highlight link semshiUnresolved Normal
highlight link semshiBuiltin Function

" }}}1
" {{{1 Highlight: Filetype tex

call s:highlight('texArg',          {'fg': 'color00'})
call s:highlight('texTodoArg',      {'fg': 'color01'})
call s:highlight('texArgNew',       {'fg': 'color05'})
call s:highlight('texCmdPart',      {'fg': 'color03'})
call s:highlight('texCmdRef',       {'fg': 'color03'})
call s:highlight('texEnvArgName',   {'fg': 'color09l'})
call s:highlight('texFootnoteArg',  {'fg': 'color14',  'style': 'italic'})
call s:highlight('texMathCmd',      {'fg': 'color01d'})
call s:highlight('texMathDelim',    {'fg': 'color08'})
call s:highlight('texMathOper',     {'fg': 'color03'})
call s:highlight('texMathZone',     {'fg': 'color01'})
call s:highlight('texOpt',          {'fg': 'color04d'})
call s:highlight('texPartArgTitle', {'fg': 'color03d'})
call s:highlight('texRefArg',       {'fg': 'color00'})
call s:highlight('texSymbol',       {'fg': 'color00'})
call s:highlight('texTitleArg',     {'fg': 'color03d', 'style': 'bold'})

highlight link texAuthorArg      texArg
highlight link texCmdBooktabs    texEnvArgName
highlight link texCmdItem        texArg
highlight link texMathEnvArgName texMathCmd
highlight link texMathSymbol     texMathCmd
highlight link texNewenvArgName  texArgNew
highlight link texPgfType        texCmd
highlight link texSpecialChar    texSymbol
highlight link texTabularChar    texMathOper

" }}}1
" {{{1 Highlight: Various filetypes

call s:highlight('cPreCondit', {'fg': 'color09'})

call s:highlight('htmlArg',            {'fg': 'color12'})
call s:highlight('htmlEndTag',         {'fg': 'color14'})
call s:highlight('htmlSpecialTagName', {'fg': 'color04', 'style': 'italic'})
call s:highlight('htmlTag',            {'fg': 'color14'})
call s:highlight('htmlTagN',           {'fg': 'color10'})
call s:highlight('htmlTagName',        {'fg': 'color04'})
call s:highlight('htmlStrike',         {'fg': 'color15d'})

call s:highlight('javaScript', {'fg': 'color03'})

call s:highlight('perlHereDoc',           {'fg': 'color10'})
call s:highlight('perlStatementFileDesc', {'fg': 'color06'})
call s:highlight('perlVarPlain',          {'fg': 'color03'})

call s:highlight('rubyDefine', {'fg': 'color10'})

" }}}1

" {{{1 Set terminal color palette

" See :help g:terminal_ansi_colors

let g:terminal_ansi_colors = []
let g:terminal_ansi_colors += [s:colordict['color00'].hex]
let g:terminal_ansi_colors += [s:colordict['color01'].hex]
let g:terminal_ansi_colors += [s:colordict['color02'].hex]
let g:terminal_ansi_colors += [s:colordict['color03'].hex]
let g:terminal_ansi_colors += [s:colordict['color04'].hex]
let g:terminal_ansi_colors += [s:colordict['color05'].hex]
let g:terminal_ansi_colors += [s:colordict['color06'].hex]
let g:terminal_ansi_colors += [s:colordict['color07'].hex]
let g:terminal_ansi_colors += [s:colordict['color08'].hex]
let g:terminal_ansi_colors += [s:colordict['color09'].hex]
let g:terminal_ansi_colors += [s:colordict['color10'].hex]
let g:terminal_ansi_colors += [s:colordict['color11'].hex]
let g:terminal_ansi_colors += [s:colordict['color12'].hex]
let g:terminal_ansi_colors += [s:colordict['color13'].hex]
let g:terminal_ansi_colors += [s:colordict['color14'].hex]
let g:terminal_ansi_colors += [s:colordict['color15'].hex]

" }}}1
