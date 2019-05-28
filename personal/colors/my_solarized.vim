"
" My own, customized, light Solarized theme
" Based on: Romain Lafourcade's 'flattened_light'
"

highlight clear

if exists('syntax_on')
  syntax reset
endif

let colors_name = 'my_solarized'

set background=light

highlight   Normal                                   cterm=NONE                gui=NONE                ctermfg=11     ctermbg=15      guifg=#657b83   guibg=#fdf6e3
highlight   ColorColumn                              cterm=NONE                gui=NONE                ctermbg=7      guibg=#eee8d5
highlight   Comment                                  cterm=italic              gui=italic              ctermfg=14     guifg=#93a1a1
highlight   ConId                                    cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   Conceal                                  cterm=NONE                gui=NONE                ctermfg=4      ctermbg=NONE    guifg=#268bd2   guibg=NONE
highlight   Constant                                 cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   Cursor                                   cterm=NONE                gui=NONE                ctermfg=15     ctermbg=11      guifg=#fdf6e3   guibg=#657b83
highlight   CursorColumn                             cterm=NONE                gui=NONE                ctermbg=7      guibg=#eee8d5
highlight   CursorLine                               cterm=NONE                gui=NONE                ctermbg=7      guibg=#eee8d5   guisp=#586e75 guifg=black
highlight   CursorLineNr                             cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   DiffAdd                                  cterm=NONE                gui=NONE                ctermfg=NONE   ctermbg=193     guifg=NONE   guibg=#ebe8c1   guisp=#719e07
highlight   DiffChange                               cterm=NONE                gui=NONE                ctermfg=NONE   ctermbg=7       guifg=NONE   guibg=#ecdbab   guisp=#b58900
highlight   DiffDelete                               cterm=NONE                gui=NONE                ctermfg=NONE   ctermbg=217     guifg=NONE   guibg=#f7cfbf
highlight   DiffText                                 cterm=NONE                gui=NONE                ctermfg=NONE   ctermbg=193     guifg=NONE   guibg=#d2e1e0   guisp=#268bd2
highlight   Directory                                cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   Error                                    cterm=NONE                gui=NONE                ctermfg=1      ctermbg=NONE    guifg=#dc322f   guibg=#fdf6e3
highlight   ErrorMsg                                 cterm=reverse             gui=reverse             ctermfg=1      ctermbg=NONE    guifg=#dc322f   guibg=NONE
highlight   FoldColumn                               cterm=NONE                gui=NONE                ctermfg=11     ctermbg=7       guifg=#657b83   guibg=#eee8d5
highlight   Folded                                   cterm=NONE,underline      gui=NONE,underline      ctermfg=11     ctermbg=7       guifg=#657b83   guibg=#eee8d5   guisp=#fdf6e3
highlight   HelpExample                              cterm=NONE                gui=NONE                ctermfg=8      guifg=#839496
highlight   Identifier                               cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   IncSearch                                cterm=standout            gui=standout            ctermfg=9      guifg=#cb4b16
highlight   LineNr                                   cterm=NONE                gui=NONE                ctermfg=14     ctermbg=7       guifg=#93a1a1   guibg=#eee8d5
highlight   MatchParen                               cterm=NONE                gui=NONE                ctermfg=1      ctermbg=14      guifg=#dc322f   guibg=#93a1a1
highlight   ModeMsg                                  cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   MoreMsg                                  cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   NonText                                  cterm=NONE                gui=NONE                ctermfg=12     guifg=#839496
highlight   Whitespace                               cterm=NONE                gui=NONE                ctermfg=12     ctermbg=7       guifg=#839496   guibg=#eee8d5
highlight   Pmenu                                    cterm=reverse             gui=reverse             ctermfg=11     ctermbg=7       guifg=#657b83   guibg=#eee8d5
highlight   PmenuSbar                                cterm=reverse             gui=reverse             ctermfg=0      ctermbg=11      guifg=#073642   guibg=#657b83
highlight   PmenuSel                                 cterm=reverse             gui=reverse             ctermfg=14     ctermbg=0       guifg=#93a1a1   guibg=#073642
highlight   PmenuThumb                               cterm=reverse             gui=reverse             ctermfg=11     ctermbg=15      guifg=#657b83   guibg=#fdf6e3
highlight   PreProc                                  cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   Question                                 cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   Search                                   cterm=reverse             gui=reverse             ctermfg=3      ctermbg=NONE    guifg=#b58900   guibg=NONE
highlight   SignColumn                               cterm=NONE                gui=NONE                ctermfg=11     ctermbg=7       guifg=#657b83   guibg=#eee8d5
highlight   Special                                  cterm=NONE                gui=NONE                ctermfg=1      guifg=#dc322f
highlight   SpecialKey                               cterm=NONE                gui=NONE                ctermfg=12     ctermbg=7       guifg=#839496   guibg=#eee8d5
highlight   SpellBad                                 cterm=undercurl           gui=undercurl           ctermfg=NONE   ctermbg=NONE    guisp=#dc322f
highlight   SpellCap                                 cterm=undercurl           gui=undercurl           ctermfg=NONE   ctermbg=NONE    guisp=#6c71c4
highlight   SpellLocal                               cterm=undercurl           gui=undercurl           ctermfg=NONE   ctermbg=NONE    guisp=#b58900
highlight   SpellRare                                cterm=undercurl           gui=undercurl           ctermfg=NONE   ctermbg=NONE    guisp=#2aa198
highlight   Statement                                cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   StatusLine                               cterm=reverse             gui=reverse             ctermfg=10     ctermbg=15      guifg=#586e75   guibg=#fdf6e3
highlight   StatusLineNC                             cterm=reverse             gui=reverse             ctermfg=12     ctermbg=7       guifg=#839496   guibg=#eee8d5
highlight   TabLine                                  cterm=underline           gui=underline           ctermfg=11     ctermbg=7       guifg=#657b83   guibg=#eee8d5   guisp=#657b83
highlight   TabLineFill                              cterm=underline           gui=underline           ctermfg=11     ctermbg=7       guifg=#657b83   guibg=#eee8d5   guisp=#657b83
highlight   TabLineSel                               cterm=underline,reverse   gui=underline,reverse   ctermfg=14     ctermbg=0       guifg=#93a1a1   guibg=#073642   guisp=#657b83
highlight   Title                                    cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   Todo                                     cterm=bold                gui=bold                ctermfg=5      ctermbg=NONE    guifg=#d33682   guibg=NONE
highlight   Type                                     cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   Underlined                               cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   VarId                                    cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   VertSplit                                cterm=NONE                gui=NONE                ctermfg=12     ctermbg=12      guifg=#839496   guibg=#839496
highlight   Visual                                   cterm=reverse             gui=reverse             ctermfg=14     ctermbg=15      guifg=#93a1a1   guibg=NONE
highlight   VisualNOS                                cterm=reverse             gui=reverse             ctermbg=7      guibg=NONE
highlight   WarningMsg                               cterm=NONE                gui=NONE                ctermfg=9      guifg=#dc322f
highlight   WildMenu                                 cterm=reverse             gui=reverse             ctermfg=0      ctermbg=7       guifg=#073642   guibg=#eee8d5
highlight   cPreCondit                               cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   gitcommitBranch                          cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   gitcommitComment                         cterm=italic              gui=italic              ctermfg=14     guifg=#93a1a1
highlight   gitcommitDiscardedFile                   cterm=NONE                gui=NONE                ctermfg=1      guifg=#dc322f
highlight   gitcommitDiscardedType                   cterm=NONE                gui=NONE                ctermfg=1      guifg=#dc322f
highlight   gitcommitFile                            cterm=NONE                gui=NONE                ctermfg=11     guifg=#657b83
highlight   gitcommitHeader                          cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   gitcommitOnBranch                        cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   gitcommitSelectedFile                    cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   gitcommitSelectedType                    cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   gitcommitUnmerged                        cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   gitcommitUnmergedFile                    cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   gitcommitUntrackedFile                   cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   helpHyperTextEntry                       cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   helpHyperTextJump                        cterm=underline           gui=underline           ctermfg=4      guifg=#268bd2
highlight   helpNote                                 cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   helpOption                               cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   helpVim                                  cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   hsImport                                 cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   hsImportLabel                            cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   hsModuleName                             cterm=underline           gui=underline           ctermfg=2      guifg=#719e07
highlight   hsNiceOperator                           cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   hsStatement                              cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   hsString                                 cterm=NONE                gui=NONE                ctermfg=12     guifg=#839496
highlight   hsStructure                              cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   hsType                                   cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   hsTypedef                                cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   hsVarSym                                 cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   hs_DeclareFunction                       cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   hs_OpFunctionName                        cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   hs_hlFunctionName                        cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   htmlArg                                  cterm=NONE                gui=NONE                ctermfg=12     guifg=#839496
highlight   htmlEndTag                               cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   htmlSpecialTagName                       cterm=italic              gui=italic              ctermfg=4      guifg=#268bd2
highlight   htmlTag                                  cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   htmlTagN                                 cterm=NONE                gui=NONE                ctermfg=10     guifg=#586e75
highlight   htmlTagName                              cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   javaScript                               cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   pandocBlockQuote                         cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocBlockQuoteLeader1                  cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocBlockQuoteLeader2                  cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198
highlight   pandocBlockQuoteLeader3                  cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   pandocBlockQuoteLeader4                  cterm=NONE                gui=NONE                ctermfg=1      guifg=#dc322f
highlight   pandocBlockQuoteLeader5                  cterm=NONE                gui=NONE                ctermfg=11     guifg=#657b83
highlight   pandocBlockQuoteLeader6                  cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   pandocCitation                           cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   pandocCitationDelim                      cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   pandocCitationID                         cterm=underline           gui=underline           ctermfg=5      guifg=#d33682
highlight   pandocCitationRef                        cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   pandocComment                            cterm=italic              gui=italic              ctermfg=14     guifg=#93a1a1
highlight   pandocDefinitionBlock                    cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocDefinitionIndctr                   cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocDefinitionTerm                     cterm=standout            gui=standout            ctermfg=13     guifg=#6c71c4
highlight   pandocEmphasis                           cterm=italic              gui=italic              ctermfg=11     guifg=#657b83
highlight   pandocEmphasisDefinition                 cterm=italic              gui=italic              ctermfg=13     guifg=#6c71c4
highlight   pandocEmphasisHeading                    cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocEmphasisNested                     cterm=NONE                gui=NONE                ctermfg=11     guifg=#657b83
highlight   pandocEmphasisNestedDefinition           cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocEmphasisNestedHeading              cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocEmphasisNestedTable                cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocEmphasisTable                      cterm=italic              gui=italic              ctermfg=4      guifg=#268bd2
highlight   pandocEscapePair                         cterm=NONE                gui=NONE                ctermfg=1      guifg=#dc322f
highlight   pandocFootnote                           cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   pandocFootnoteDefLink                    cterm=NONE                gui=NONE                ctermfg=2      guifg=#719e07
highlight   pandocFootnoteInline                     cterm=NONE,underline      gui=NONE,underline      ctermfg=2      guifg=#719e07
highlight   pandocFootnoteLink                       cterm=underline           gui=underline           ctermfg=2      guifg=#719e07
highlight   pandocHeading                            cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocHeadingMarker                      cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   pandocImageCaption                       cterm=NONE,underline      gui=NONE,underline      ctermfg=13     guifg=#6c71c4
highlight   pandocLinkDefinition                     cterm=underline           gui=underline           ctermfg=6      guifg=#2aa198   guisp=#839496
highlight   pandocLinkDefinitionID                   cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocLinkDelim                          cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   pandocLinkLabel                          cterm=underline           gui=underline           ctermfg=4      guifg=#268bd2
highlight   pandocLinkText                           cterm=NONE,underline      gui=NONE,underline      ctermfg=4      guifg=#268bd2
highlight   pandocLinkTitle                          cterm=underline           gui=underline           ctermfg=12     guifg=#839496
highlight   pandocLinkTitleDelim                     cterm=underline           gui=underline           ctermfg=14     guifg=#93a1a1   guisp=#839496
highlight   pandocLinkURL                            cterm=underline           gui=underline           ctermfg=12     guifg=#839496
highlight   pandocListMarker                         cterm=NONE                gui=NONE                ctermfg=5      guifg=#d33682
highlight   pandocListReference                      cterm=underline           gui=underline           ctermfg=5      guifg=#d33682
highlight   pandocMetadata                           cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocMetadataDelim                      cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   pandocMetadataKey                        cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocNonBreakingSpace                   cterm=reverse             gui=reverse             ctermfg=1      ctermbg=NONE    guifg=#dc322f   guibg=NONE
highlight   pandocRule                               cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocRuleLine                           cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocStrikeout                          cterm=reverse             gui=reverse             ctermfg=14     ctermbg=NONE    guifg=#93a1a1   guibg=NONE
highlight   pandocStrikeoutDefinition                cterm=reverse             gui=reverse             ctermfg=13     ctermbg=NONE    guifg=#6c71c4   guibg=NONE
highlight   pandocStrikeoutHeading                   cterm=reverse             gui=reverse             ctermfg=9      ctermbg=NONE    guifg=#cb4b16   guibg=NONE
highlight   pandocStrikeoutTable                     cterm=reverse             gui=reverse             ctermfg=4      ctermbg=NONE    guifg=#268bd2   guibg=NONE
highlight   pandocStrongEmphasis                     cterm=NONE                gui=NONE                ctermfg=11     guifg=#657b83
highlight   pandocStrongEmphasisDefinition           cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocStrongEmphasisEmphasis             cterm=NONE                gui=NONE                ctermfg=11     guifg=#657b83
highlight   pandocStrongEmphasisEmphasisDefinition   cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocStrongEmphasisEmphasisHeading      cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocStrongEmphasisEmphasisTable        cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocStrongEmphasisHeading              cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocStrongEmphasisNested               cterm=NONE                gui=NONE                ctermfg=11     guifg=#657b83
highlight   pandocStrongEmphasisNestedDefinition     cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocStrongEmphasisNestedHeading        cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocStrongEmphasisNestedTable          cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocStrongEmphasisTable                cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocStyleDelim                         cterm=NONE                gui=NONE                ctermfg=14     guifg=#93a1a1
highlight   pandocSubscript                          cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocSubscriptDefinition                cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocSubscriptHeading                   cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocSubscriptTable                     cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocSuperscript                        cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocSuperscriptDefinition              cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocSuperscriptHeading                 cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocSuperscriptTable                   cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocTable                              cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocTableStructure                     cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocTableZebraDark                     cterm=NONE                gui=NONE                ctermfg=4      ctermbg=7       guifg=#268bd2   guibg=#eee8d5
highlight   pandocTableZebraLight                    cterm=NONE                gui=NONE                ctermfg=4      ctermbg=15      guifg=#268bd2   guibg=#fdf6e3
highlight   pandocTitleBlock                         cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocTitleBlockTitle                    cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocTitleComment                       cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   pandocVerbatimBlock                      cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   pandocVerbatimInline                     cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   pandocVerbatimInlineDefinition           cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   pandocVerbatimInlineHeading              cterm=NONE                gui=NONE                ctermfg=9      guifg=#cb4b16
highlight   pandocVerbatimInlineTable                cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   perlHereDoc                              cterm=NONE                gui=NONE                ctermfg=10     ctermbg=15      guifg=#586e75   guibg=#fdf6e3
highlight   perlStatementFileDesc                    cterm=NONE                gui=NONE                ctermfg=6      ctermbg=15      guifg=#2aa198   guibg=#fdf6e3
highlight   perlVarPlain                             cterm=NONE                gui=NONE                ctermfg=3      ctermbg=15      guifg=#b58900   guibg=#fdf6e3
highlight   rubyDefine                               cterm=NONE                gui=NONE                ctermfg=10     ctermbg=15      guifg=#586e75   guibg=#fdf6e3
highlight   vimCmdSep                                cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   vimCommand                               cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   vimCommentString                         cterm=NONE                gui=NONE                ctermfg=13     guifg=#6c71c4
highlight   vimGroup                                 cterm=NONE,underline      gui=NONE,underline      ctermfg=4      guifg=#268bd2
highlight   vimHiGroup                               cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   vimHiLink                                cterm=NONE                gui=NONE                ctermfg=4      guifg=#268bd2
highlight   vimIsCommand                             cterm=NONE                gui=NONE                ctermfg=12     guifg=#839496
highlight   vimSynMtchOpt                            cterm=NONE                gui=NONE                ctermfg=3      guifg=#b58900
highlight   vimSynType                               cterm=NONE                gui=NONE                ctermfg=6      guifg=#2aa198

highlight link Boolean                    Constant
highlight link Character                  Constant
highlight link Conditional                Statement
highlight link Debug                      Special
highlight link Define                     PreProc
highlight link Delimiter                  Special
highlight link Exception                  Statement
highlight link Float                      Number
highlight link Function                   Identifier
highlight link Include                    PreProc
highlight link Keyword                    Statement
highlight link Label                      Statement
highlight link Macro                      PreProc
highlight link Number                     Constant
highlight link Operator                   Statement
highlight link PreCondit                  PreProc
highlight link Repeat                     Statement
highlight link SpecialChar                Special
highlight link SpecialComment             Special
highlight link StorageClass               Type
highlight link String                     Constant
highlight link Structure                  Type
highlight link SyntasticError             SpellBad
highlight link SyntasticErrorSign         Error
highlight link SyntasticStyleErrorLine    SyntasticErrorLine
highlight link SyntasticStyleErrorSign    SyntasticErrorSign
highlight link SyntasticStyleWarningLine  SyntasticWarningLine
highlight link SyntasticStyleWarningSign  SyntasticWarningSign
highlight link SyntasticWarning           SpellCap
highlight link SyntasticWarningSign       Todo
highlight link Tag                        Special
highlight link Typedef                    Type

highlight link texMathMatcher ConId
highlight link texStatement   Number
highlight link texCmdArgs     Identifier

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

highlight link gitcommitDiscarded         gitcommitComment
highlight link gitcommitDiscardedArrow    gitcommitDiscardedFile
highlight link gitcommitNoBranch          gitcommitBranch
highlight link gitcommitSelected          gitcommitComment
highlight link gitcommitSelectedArrow     gitcommitSelectedFile
highlight link gitcommitUnmergedArrow     gitcommitUnmergedFile
highlight link gitcommitUntracked         gitcommitComment

highlight link helpSpecial                Special

highlight link hsDelimTypeExport          Delimiter
highlight link hsImportParams             Delimiter
highlight link hsModuleStartLabel         hsStructure
highlight link hsModuleWhereLabel         hsModuleStartLabel
highlight link htmlLink                   Function

highlight link lCursor                    Cursor

highlight link pandocCodeBlock            pandocVerbatimBlock
highlight link pandocCodeBlockDelim       pandocVerbatimBlock
highlight link pandocEscapedCharacter     pandocEscapePair
highlight link pandocLineBreak            pandocEscapePair
highlight link pandocMetadataTitle        pandocMetadata
highlight link pandocTableStructureEnd    pandocTableStructure
highlight link pandocTableStructureTop    pandocTableStructure
highlight link pandocVerbatimBlockDeep    pandocVerbatimBlock

highlight link vimFunc                    Function
highlight link vimSet                     Normal
highlight link vimSetEqual                Normal
highlight link vimUserFunc                Function
highlight link vipmVar                    Identifier

highlight clear SyntasticErrorLine
highlight clear SyntasticWarningLine
highlight clear helpLeadBlank
highlight clear helpNormal
highlight clear pandocTableStructure

if has('nvim')
  let g:terminal_color_0  = '#eee8d5'
  let g:terminal_color_1  = '#dc322f'
  let g:terminal_color_2  = '#859900'
  let g:terminal_color_3  = '#b58900'
  let g:terminal_color_4  = '#268bd2'
  let g:terminal_color_5  = '#d33682'
  let g:terminal_color_6  = '#2aa198'
  let g:terminal_color_7  = '#073642'
  let g:terminal_color_8  = '#fdf6e3'
  let g:terminal_color_9  = '#cb4b16'
  let g:terminal_color_10 = '#93a1a1'
  let g:terminal_color_11 = '#839496'
  let g:terminal_color_12 = '#657b83'
  let g:terminal_color_13 = '#6c71c4'
  let g:terminal_color_14 = '#586e75'
  let g:terminal_color_15 = '#002b36'
endif
