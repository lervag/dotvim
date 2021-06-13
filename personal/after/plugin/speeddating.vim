if exists('b:did_after_plugin_speeddating') | finish | endif
let b:did_after_plugin_speeddating = 1

" Add custom speed dating formats
if exists('g:speeddating_formats')
  SpeedDatingFormat %d.%m.%y
  SpeedDatingFormat %d.%m.%Y
  SpeedDatingFormat %H.%M
  SpeedDatingFormat %H:%M
endif
