const { sources, workspace, SourceType } = require('coc.nvim')

byteSlice = function (content, start, end) {
  let buf = Buffer.from(content, 'utf8')
  return buf.slice(start, end).toString('utf8')
}

exports.activate = async context => {
  let config = workspace.getConfiguration('coc.source.wiki')
  let { nvim } = workspace

  let pattern = /\[\[[^\]\|]{2,}$/

  function convertItems(list) {
    let res = []
    for (let item of list) {
      res.push(Object.assign({
        word: item,
        menu: '[W]',
      }))
    }
    return res
  }

  let source = {
    name: 'wiki',
    enable: config.get('enable', true),
    priority: config.get('priority', 2),
    shortcut: 'test',
    filetypes: ['wiki'],
    sourceType: SourceType.Remote,
    triggerPatterns: [pattern],
    doComplete: async opt => {
      let { nvim } = workspace
      let func = 'wiki#complete#omnicomplete'
      let { line, colnr, col } = opt
      let startcol = col
      try {
        startcol = await nvim.call(func, [1, ''])
        startcol = Number(startcol)
      } catch (e) {
        workspace.showMessage(`vim error from ${func} :${e.message}`, 'error')
        return null
      }
      // invalid startcol
      if (isNaN(startcol) || startcol < 0 || startcol > colnr) return null
      let text = byteSlice(line, startcol, colnr - 1)
      let words = await nvim.call(func, [0, text])
      let res = { items: convertItems(words) }
      res.startcol = startcol
      return res
    }
  }

  sources.addSource(source)
  context.subscriptions.push({
    dispose: () => {
      sources.removeSource(source)
    }
  })
}
