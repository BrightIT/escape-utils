Entities = require('html-entities').AllHtmlEntities
entities = new Entities()

module.exports =
  activate: ->
    atom.commands.add "atom-workspace", "escape-utils:url-encode": => @transfromSel encodeURIComponent
    atom.commands.add "atom-workspace", "escape-utils:url-decode": => @transfromSel decodeURIComponent
    atom.commands.add "atom-workspace", "escape-utils:base64-encode": => @transfromSel @encodeBase64
    atom.commands.add "atom-workspace", "escape-utils:base64-decode": => @transfromSel @decodeBase64
    atom.commands.add "atom-workspace", "escape-utils:html-encode": => @transfromSel entities.encodeNonUTF
    atom.commands.add "atom-workspace", "escape-utils:html-encode-maintain-lines": => @transfromSel @encodeHtmlMaintainingLines
    atom.commands.add "atom-workspace", "escape-utils:html-decode": => @transfromSel entities.decode


  transfromSel: (t) ->
    # This assumes the active pane item is an editor
    editor = atom.workspace.getActiveTextEditor()
    if (editor?)
      selections = editor.getSelections()
      sel.insertText(t(sel.getText()), { "select": true, "normalizeLineEndings": true }) for sel in selections

  encodeBase64: (text) ->
    new Buffer(text).toString("base64")

  decodeBase64: (text) ->
    if /^[A-Za-z0-9+/=]+$/.test(text)
      new Buffer(text, "base64").toString("utf8")
    else
      #console.debug("Ignoring text as it contains illegal characers", text)
      text

  encodeHtmlMaintainingLines: (text) ->
    text.split(/[\n\r]{1,2}/).map(entities.encodeNonUTF).join('\n')
