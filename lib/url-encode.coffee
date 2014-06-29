module.exports =
  activate: ->
    atom.workspaceView.command "url-encode:encode", => @transfromSel encodeURIComponent
    atom.workspaceView.command "url-encode:decode", => @transfromSel decodeURIComponent


  transfromSel: (t) ->
    # This assumes the active pane item is an editor
    editorView = atom.workspaceView.getActiveView()
    editor = editorView?.getEditor()
    if (editor?)
      selections = editor.getSelections()
      sel.insertText(t(sel.getText()), { "select": true}) for sel in selections
