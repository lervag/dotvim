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
      \ 'color00':  {'num': 0,   'hex': '#073642', 'name': 'base02'},
      \ 'color01':  {'num': 1,   'hex': '#dc322f', 'name': 'red'},
      \ 'color02':  {'num': 2,   'hex': '#859900', 'name': 'green'},
      \ 'color03':  {'num': 3,   'hex': '#b58900', 'name': 'yellow'},
      \ 'color04':  {'num': 4,   'hex': '#268bd2', 'name': 'blue'},
      \ 'color05':  {'num': 5,   'hex': '#d33682', 'name': 'magenta'},
      \ 'color06':  {'num': 6,   'hex': '#2aa198', 'name': 'cyan'},
      \ 'color07':  {'num': 7,   'hex': '#eee8d5', 'name': 'base2'},
      \ 'color08':  {'num': 8,   'hex': '#002b36', 'name': 'base03'},
      \ 'color09':  {'num': 9,   'hex': '#cb4b16', 'name': 'orange'},
      \ 'color10':  {'num': 10,  'hex': '#586e75', 'name': 'base01'},
      \ 'color11':  {'num': 11,  'hex': '#657b83', 'name': 'base00'},
      \ 'color12':  {'num': 12,  'hex': '#839496', 'name': 'base0'},
      \ 'color13':  {'num': 13,  'hex': '#6c71c4', 'name': 'violet'},
      \ 'color14':  {'num': 14,  'hex': '#93a1a1', 'name': 'base1'},
      \ 'color15':  {'num': 15,  'hex': '#fdf6e3', 'name': 'base3'},
      \ 'custom01': {'num': 193, 'hex': '#d7ffaf', 'name': 'lightgreen'},
      \ 'custom02': {'num': 64,  'hex': '#719e07', 'name': 'green'},
      \ 'custom03': {'num': 217, 'hex': '#f7cfbf', 'name': 'pink'},
      \ 'custom04': {'num': 253, 'hex': '#d2e1e0', 'name': 'lightgray'},
      \ 'custom05': {'num': 201, 'hex': '#ff00ff', 'name': 'magenta'},
      \ 'custom06': {'num': 124, 'hex': '#af0000', 'name': 'darkred'},
      \ 'custom07': {'num': 33,  'hex': '#0087ff', 'name': 'blue1'},
      \ 'custom08': {'num': 104, 'hex': '#8787d7', 'name': 'bluepurple'},
      \ 'custom09': {'num': 227, 'hex': '#ffff5f', 'name': 'yellow'},
      \ 'custom10': {'num': 220, 'hex': '#ffe055', 'name': 'gold'},
      \ 'custom11': {'num': 202, 'hex': '#ff5f00', 'name': 'orangered'},
      \ 'custom12': {'num': 39,  'hex': '#00afff', 'name': 'blue2'},
      \ 'custom13': {'num': 90,  'hex': '#8b008b', 'name': 'darkmagenta'},
      \ 'custom14': {'num': 117, 'hex': '#add8e6', 'name': 'lightblue'},
      \ 'custom15': {'num': 100, 'hex': '#878700', 'name': 'army1'},
      \ 'custom16': {'num': 101, 'hex': '#87875f', 'name': 'army2'},
      \ 'custom17': {'num': 59,  'hex': '#e0dac9', 'name': 'darkbase3'},
      \}

" }}}1
function! s:highlight(group, opts) abort " {{{1
  let l:cmd = 'highlight ' . a:group

  if has_key(a:opts, 'style')
    let l:cmd .= ' cterm=' . a:opts.style
    let l:cmd .= ' gui=' . a:opts.style
  endif

  for l:x in ['fg', 'bg']
    if has_key(a:opts, l:x)
      if a:opts[l:x] ==# 'NONE'
        let l:cmd .= ' cterm' . l:x . '=NONE'
        let l:cmd .= ' gui' . l:x . '=NONE'
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

" {{{1 Highlight: Default/Internal groups

call s:highlight('Normal', {'fg': 'color11', 'bg': 'color15'})
call s:highlight('ColorColumn', {'bg': 'color07'})
call s:highlight('Comment', {'fg': 'color14', 'style': 'italic'})
call s:highlight('Conceal', {'fg': 'color04', 'bg': 'NONE'})
call s:highlight('Constant', {'fg': 'color06'})
call s:highlight('Cursor', {'fg': 'color15', 'bg': 'color11'})
call s:highlight('CursorColumn', {'bg': 'color07', 'style': 'NONE'})
call s:highlight('CursorLine', {'bg': 'color07', 'sp': 'color10', 'style': 'NONE'})
call s:highlight('CursorLineNr', {'fg': 'color14', 'style': 'NONE'})
call s:highlight('DiffAdd', {'bg': 'custom01', 'sp': 'custom02'})
call s:highlight('DiffChange', {'bg': 'color07', 'sp': 'color03'})
call s:highlight('DiffDelete', {'fg': 'NONE', 'bg': 'custom03', 'style': 'NONE'})
call s:highlight('DiffText', {'bg': 'custom04', 'sp': 'color04', 'style': 'NONE'})
call s:highlight('Directory', {'fg': 'color04'})
call s:highlight('Error', {'fg': 'color01', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('ErrorMsg', {'fg': 'color01', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('FoldColumn', {'fg': 'color11', 'bg': 'color07'})
call s:highlight('Folded', {'fg': 'color11', 'bg': 'color07', 'sp': 'color15', 'style': 'underline'})
call s:highlight('Identifier', {'fg': 'color04'})
call s:highlight('Ignore', {'fg': 'color15'})
call s:highlight('IncSearch', {'fg': 'color09', 'style': 'standout'})
call s:highlight('LineNr', {'fg': 'color14', 'bg': 'color07'})
call s:highlight('MatchParen', {'fg': 'color04', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('ModeMsg', {'fg': 'color04', 'style': 'NONE'})
call s:highlight('MoreMsg', {'fg': 'color04', 'style': 'NONE'})
call s:highlight('NonText', {'fg': 'color12', 'style': 'NONE'})
call s:highlight('NvimInternalError', {'fg': 'color09', 'bg': 'color01'})
call s:highlight('Pmenu', {'fg': 'color11', 'bg': 'custom17'})
call s:highlight('PmenuSbar', {'fg': 'color00', 'bg': 'color11'})
call s:highlight('PmenuSel', {'fg': 'color14', 'bg': 'color00'})
call s:highlight('PmenuThumb', {'fg': 'color11', 'bg': 'color15'})
call s:highlight('PreProc', {'fg': 'color09'})
call s:highlight('Question', {'fg': 'color06', 'style': 'NONE'})
call s:highlight('RedrawDebugClear', {'bg': 'color11'})
call s:highlight('RedrawDebugComposed', {'bg': 'color02'})
call s:highlight('RedrawDebugNormal', {'style': 'reverse'})
call s:highlight('RedrawDebugRecompose', {'bg': 'color09'})
call s:highlight('Search', {'fg': 'custom05', 'bg': 'NONE', 'style': 'bold,underline'})
call s:highlight('SignColumn', {'fg': 'color11', 'bg': 'color07'})
call s:highlight('Special', {'fg': 'color01'})
call s:highlight('SpecialKey', {'fg': 'color12', 'bg': 'color07'})
call s:highlight('SpellBad',   {'fg': 'custom06', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('SpellCap',   {'fg': 'custom07', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('SpellLocal', {'fg': 'custom08', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('SpellRare',  {'fg': 'custom09', 'bg': 'NONE', 'sp': 'color01', 'style': 'bold'})
call s:highlight('Statement', {'fg': 'color02', 'style': 'NONE'})
call s:highlight('TermCursor', {'style': 'bold'})
call s:highlight('Title', {'fg': 'color09', 'style': 'bold'})
call s:highlight('Todo', {'fg': 'color05', 'bg': 'NONE', 'style': 'bold'})
call s:highlight('Type', {'fg': 'color03', 'style': 'NONE'})
call s:highlight('Underlined', {'fg': 'color13', 'style': 'NONE'})
call s:highlight('VertSplit', {'fg': 'color12', 'bg': 'color12', 'style': 'NONE'})
call s:highlight('Visual', {'fg': 'color14', 'bg': 'color15', 'style': 'reverse'})
call s:highlight('VisualNOS', {'bg': 'color07', 'style': 'reverse'})
call s:highlight('WarningMsg', {'fg': 'color09'})
call s:highlight('WildMenu', {'fg': 'color00', 'bg': 'color07', 'style': 'reverse'})
call s:highlight('Whitespace', {'fg': 'color12', 'bg': 'color07'})

" Statusline and tabline
call s:highlight('Statusline', {'fg': 'color15', 'bg': 'color10', 'style': 'NONE'})
call s:highlight('StatuslineNC', {'fg': 'color08', 'bg': 'color10', 'style': 'NONE'})
call s:highlight('SLHighlight', {'fg': 'custom10', 'bg': 'color10'})
call s:highlight('SLAlert', {'fg': 'custom11', 'bg': 'color10'})
call s:highlight('SLFZF', {'fg': 'color02'})
call s:highlight('TabLine', {'fg': 'color08', 'bg': 'color10', 'sp': 'color11', 'style': 'NONE'})
call s:highlight('TabLineFill', {'fg': 'color08', 'bg': 'color10', 'sp': 'color11', 'style': 'NONE'})
call s:highlight('TabLineSel', {'fg': 'custom10', 'bg': 'color10', 'sp': 'color11', 'style': 'NONE'})

" Cursor colors
call s:highlight('iCursor', {'bg': 'color03'})
call s:highlight('rCursor', {'bg': 'color01'})
call s:highlight('vCursor', {'bg': 'color05'})
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
" {{{ Highlight: Various plugins

call s:highlight('ctrlsfSelectedLine', {'fg': 'custom12', 'style': 'bold'})
call s:highlight('OperatorSandwichBuns', {'fg': 'color05', 'style': 'bold'})

highlight link ALEErrorLine ErrorMsg
highlight link ALEWarningLine WarningMsg
highlight link ALEInfoLine ModeMsg

call s:highlight('illuminatedWord', {'style': 'underline'})

call s:highlight('codeBlockBackground', {'bg': 'custom17'})

" }}}1
" {{{1 Highlight: Various filetypes

call s:highlight('cPreCondit', {'fg': 'color09'})

call s:highlight('htmlArg',            {'fg': 'color12'})
call s:highlight('htmlEndTag',         {'fg': 'color14'})
call s:highlight('htmlSpecialTagName', {'fg': 'color04', 'style': 'italic'})
call s:highlight('htmlTag',            {'fg': 'color14'})
call s:highlight('htmlTagN',           {'fg': 'color10'})
call s:highlight('htmlTagName',        {'fg': 'color04'})

call s:highlight('javaScript', {'fg': 'color03'})

call s:highlight('perlHereDoc',           {'fg': 'color10', 'bg': 'color15'})
call s:highlight('perlStatementFileDesc', {'fg': 'color06', 'bg': 'color15'})
call s:highlight('perlVarPlain',          {'fg': 'color03', 'bg': 'color15'})

call s:highlight('rubyDefine', {'fg': 'color10', 'bg': 'color15'})

call s:highlight('texMathMatcher', {'fg': 'color03'})
highlight link texStatement Number
highlight link texCmdArgs   Identifier

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

highlight link vimFunc     Function
highlight link vimSet      Normal
highlight link vimSetEqual Normal
highlight link vimUserFunc Function
highlight link vipmVar     Identifier

" }}}1
" {{{1 Highlight: Filetype Vimdoc

call s:highlight('helpExample', {'fg': 'color08'})
call s:highlight('helpHyperTextEntry', {'fg': 'color02'})
call s:highlight('helpHyperTextJump', {'fg': 'color04', 'style': 'underline'})
call s:highlight('helpNote', {'fg': 'color05'})
call s:highlight('helpOption', {'fg': 'color06'})
call s:highlight('helpVim', {'fg': 'color05'})
highlight link  helpSpecial Special
highlight clear helpLeadBlank
highlight clear helpNormal

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
call s:highlight('pandocTableZebraLight',                  {'fg': 'color04', 'bg':    'color15'})
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
call s:highlight('semshiParameter',       {'fg': 'custom16'})
call s:highlight('semshiParameterUnused', {'fg': 'custom15'})
call s:highlight('semshiFree',            {'fg': 'custom13'})
call s:highlight('semshiAttribute',       {'fg': 'custom14'})
call s:highlight('semshiSelected',        {'style': 'underline'})
highlight link semshiUnresolved Normal
highlight link semshiBuiltin Function

" }}}1
