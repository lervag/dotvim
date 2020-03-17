const { sources, workspace, SourceType } = require('coc.nvim')

exports.activate = async context => {
  context.subscriptions.push(
    sources.createSource({
      name: 'wiki',
      filetypes: ['wiki'],
      priority: 100,
      triggerPatterns: [
        /\[\[[^\]\|]{2,}$/,
        /zot:\w+$/
      ],
      doComplete: async opt => {
        let { nvim } = workspace
        let { line, colnr, col } = opt
        try {
          startcol = await nvim.call('wiki#complete#omnicomplete', [1, ''])
          startcol = Number(startcol)
        } catch (e) {
          workspace.showMessage(`Error from wiki#complete#omnicomplete: ${e.message}`, 'error')
          return null
        }

        // invalid startcol
        if (isNaN(startcol) || startcol < 0 || startcol > colnr) return null

        return {
          startcol: startcol,
          items: await nvim.call('wiki#complete#omnicomplete',
            [0, byteSlice(line, startcol, colnr - 1)])
        }
      }
    })
  )
}

byteSlice = function (content, start, end) {
  let buf = Buffer.from(content, 'utf8')
  return buf.slice(start, end).toString('utf8')
}
