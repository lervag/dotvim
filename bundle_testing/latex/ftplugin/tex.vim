" LaTeX plugin for Vim
"
" Maintainer: Karl Yngve Lervåg
" Email:      karl.yngve@gmail.com
"

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" {{{1 Set completion options
call latex#util#set_default('g:latex_complete_close_braces', 1)
call latex#util#set_default('g:latex_complete_bibtex_wild_spaces', 1)
call latex#util#set_default('g:latex_complete_cite_pattern',
      \ '\C\\\a*cite\a*\*\?\(\[[^\]]*\]\)*\_\s*{')
call latex#util#set_default('g:latex_complete_ref_pattern',
      \ '\C\\v\?\(eq\|page\|[cC]\)\?ref\*\?\_\s*{')
call latex#util#set_default('g:latex_complete_environments',
      \ [
        \ {'word': 'itemize',     'menu': 'bullet list' },
        \ {'word': 'enumerate',   'menu': 'numbered list' },
        \ {'word': 'description', 'menu': 'description' },
        \ {'word': 'center',      'menu': 'centered text' },
        \ {'word': 'figure',      'menu': 'floating figure' },
        \ {'word': 'table',       'menu': 'floating table' },
        \ {'word': 'equation',    'menu': 'equation (numbered)' },
        \ {'word': 'align',       'menu': 'aligned equations (numbered)' },
        \ {'word': 'align*',      'menu': 'aligned equations' },
        \ {'word': 'document' },
        \ {'word': 'abstract' },
      \ ])
call latex#util#set_default('g:latex_complete_commands',
      \ [
        \ {'word': '\begin{' },
        \ {'word': '\end{' },
        \ {'word': '\item' },
        \ {'word': '\label{' },
        \ {'word': '\ref{' },
        \ {'word': '\eqref{eq:' },
        \ {'word': '\cite{' },
        \ {'word': '\chapter{' },
        \ {'word': '\section{' },
        \ {'word': '\subsection{' },
        \ {'word': '\subsubsection{' },
        \ {'word': '\paragraph{' },
        \ {'word': '\nonumber' },
        \ {'word': '\bibliography' },
        \ {'word': '\bibliographystyle' },
      \ ])
call latex#util#set_default('g:latex_complete_eq_env_patterns',
      \ 'equation\|gather\|multiline\|align\|flalign\|alignat\|eqnarray')

" {{{1 Set errorformat options
call latex#util#set_default('g:latex_errorformat_show_warnings', 1)
call latex#util#set_default('g:latex_errorformat_ignore_warnings',
      \ [
        \ 'Underfull',
        \ 'Overfull',
        \ 'specifier changed to'
      \ ])

" {{{1 Set toc options
call latex#util#set_default('g:latex_toc_width', 30)
call latex#util#set_default('g:latex_toc_split_side', 'leftabove')
call latex#util#set_default('g:latex_toc_resize', 0)
call latex#util#set_default('g:latex_toc_hide_help', 0)
call latex#util#set_default('g:latex_toc_plaintext', 0)
call latex#util#set_default('g:latex_toc_fold', 0)
call latex#util#set_default('g:latex_toc_fold_levels', 1)

" {{{1 Set latexmk options
call latex#util#set_default('g:latex_latexmk_options', '')
call latex#util#set_default('g:latex_latexmk_output', 'pdf')
call latex#util#set_default('g:latex_latexmk_autojump', '0')

" {{{1 Set folding options
call latex#util#set_default('g:latex_fold_enabled', 0)
call latex#util#set_default('g:latex_fold_preamble', 1)
call latex#util#set_default('g:latex_fold_envs', 1)
call latex#util#set_default('g:latex_fold_parts',
      \ [
        \ "appendix",
        \ "frontmatter",
        \ "mainmatter",
        \ "backmatter",
      \ ])
call latex#util#set_default('g:latex_fold_sections',
      \ [
        \ "part",
        \ "chapter",
        \ "section",
        \ "subsection",
        \ "subsubsection",
      \ ])

" {{{1 Set motion options
call latex#util#set_default('g:latex_motion_open_pats',
      \ [
        \ '{',
        \ '(',
        \ '\[',
        \ '\\{',
        \ '\\(',
        \ '\\\[',
        \ '\\begin\s*{.\{-}}',
        \ '\\left\s*\%([^\\]\|\\.\|\\\a*\)',
      \ ])
call latex#util#set_default('g:latex_motion_close_pats',
      \ [
        \ '}',
        \ ')',
        \ '\]',
        \ '\\}',
        \ '\\)',
        \ '\\\]',
        \ '\\end\s*{.\{-}}',
        \ '\\right\s*\%([^\\]\|\\.\|\\\a*\)',
      \ ])
call latex#util#set_default('g:latex_motion_loaded_matchparen', 0)

" {{{1 Set miscelleneous options
call latex#util#set_default('g:latex_viewer', 'xdg-open')
call latex#util#set_default('g:latex_build_dir', '.')
call latex#util#set_default('g:latex_main_tex_candidates',
      \ [
        \ 'main',
        \ 'note',
        \ 'report',
        \ 'thesis',
        \ 'memo',
      \])
" }}}1

call latex#init()

" {{{1 Modeline
" vim:fdm=marker:ff=unix
