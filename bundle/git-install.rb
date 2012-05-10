#!/usr/bin/env ruby
require 'fileutils'
require 'open-uri'

git_bundles = [
  "git://github.com/altercation/vim-colors-solarized.git",
  "git://github.com/bogado/file-line.git",
  "git://github.com/ervandew/supertab.git",
  "git://github.com/godlygeek/tabular.git",
  "git://github.com/gregsexton/MatchTag.git",
  "git://github.com/kien/ctrlp.vim.git",
  "git://github.com/kien/rainbow_parentheses.vim.git",
  "git://github.com/Lokaltog/vim-powerline.git",
  "git://github.com/mileszs/ack.vim.git",
  "git://github.com/msanders/snipmate.vim.git",
  "git://github.com/Raimondi/delimitMate.git",
  "git://github.com/scrooloose/syntastic.git",
  "git://github.com/sjl/splice.vim/",
  "git://github.com/tpope/vim-pathogen.git",
  "git://github.com/tpope/vim-repeat.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/tsaleh/vim-matchit.git",
  "git://github.com/tsaleh/vim-tcomment.git",
  "git://github.com/tyru/current-func-info.vim.git",
  #
  # Locally changed
  #
  # "git://github.com/ervandew/screen",
]

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  #FileUtils.rm_rf(File.join(dir, ".git"))
end

#bundles_dir = File.join(File.dirname(__FILE__), "bundle")
#puts bundles_dir
#FileUtils.cd(bundles_dir)
#puts "trashing everything (lookout!)"
#Dir["*"].each {|d| FileUtils.rm_rf d }
#vim_org_scripts = [
  #["IndexedSearch", "7062",  "plugin"],
  #["jquery",        "12107", "syntax"],
#]

#vim_org_scripts.each do |name, script_id, script_type|
#  puts "downloading #{name}"
#  local_file = File.join(name, script_type, "#{name}.vim")
#  FileUtils.mkdir_p(File.dirname(local_file))
#  File.open(local_file, "w") do |file|
#    file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
#  end
#end

#
# Not on github
#
# clewn
# conque
# lispcomplete
# personal
# pyflakes-vim
# vcscommand
# vim-latex
#
# Not used by me
#
# "git://github.com/astashov/vim-ruby-debugger.git",
# "git://github.com/hallison/vim-rdoc.git",
# "git://github.com/pangloss/vim-javascript.git",
# "git://github.com/timcharper/textile.vim.git",
# "git://github.com/tpope/vim-cucumber.git",
# "git://github.com/tpope/vim-fugitive.git",
# "git://github.com/tpope/vim-git.git",
# "git://github.com/tpope/vim-haml.git",
# "git://github.com/tpope/vim-markdown.git",
# "git://github.com/tpope/vim-rails.git",
# "git://github.com/tpope/vim-vividchalk.git",
# "git://github.com/tsaleh/taskpaper.vim.git",
# "git://github.com/tsaleh/vim-shoulda.git",
# "git://github.com/tsaleh/vim-tmux.git",
# "git://github.com/vim-ruby/vim-ruby.git",
# "git://github.com/vim-scripts/Gist.vim.git",
#

