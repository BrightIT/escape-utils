Entities = require('html-entities').AllHtmlEntities
entities = new Entities()

module.exports =
  activate: ->
    atom.workspaceView.command "escape-utils:url-encode", => @transfromSel encodeURIComponent
    atom.workspaceView.command "escape-utils:url-decode", => @transfromSel decodeURIComponent
    atom.workspaceView.command "escape-utils:base64-encode", => @transfromSel @encodeBase64
    atom.workspaceView.command "escape-utils:base64-decode", => @transfromSel @decodeBase64
    atom.workspaceView.command "escape-utils:html-encode", => @transfromSel entities.encodeNonUTF.bind(entities)
    atom.workspaceView.command "escape-utils:html-decode", => @transfromSel entities.decode.bind(entities)


  transfromSel: (t) ->
    # This assumes the active pane item is an editor
    editorView = atom.workspaceView.getActiveView()
    editor = editorView?.getEditor()
    if (editor?)
      selections = editor.getSelections()
      sel.insertText(t(sel.getText()), { "select": true}) for sel in selections

  encodeBase64: (text) ->
    new Buffer(text).toString("base64")

  decodeBase64: (text) ->
    if /^[A-Za-z0-9+/=]+$/.test(text)
      new Buffer(text, "base64").toString("utf8")
    else
      #console.debug("Ignoring text as it contains illegal characers", text)
      text
