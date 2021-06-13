if exists('b:did_after_syntax_markdown') | finish | endif
let b:did_after_syntax_markdown = 1

syntax match mkdEnvvar "\$\w\{2,}"
syntax cluster mkdNonListItem add=mkdEnvvar

highlight default link mkdEnvvar ModeMsg
