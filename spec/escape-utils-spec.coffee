{WorkspaceView} = require 'atom'
UrlEncode = require '../lib/escape-utils'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "EscapeUtils", ->
  [activationPromise, editor] = []

  beforeEach ->
    atom.workspaceView = new WorkspaceView

    waitsForPromise ->
      atom.workspaceView.open().then (ed) ->
        editor = ed

    activationPromise = atom.packages.activatePackage("escape-utils")

  trigger = (t, cb) ->
    atom.workspaceView.trigger t
    waitsForPromise -> activationPromise
    runs ->
      cb()

  describe "escape-utils:url-encode", ->
    it "still works even if the editor is not set", ->
      atom.workspaceView.destroyActivePaneItem()
      trigger 'escape-utils:url-encode', ->
        expect(atom.workspaceView.getActiveView()).not.toBeDefined()

    it "does nothing when nothing is selected", ->
      editor.setText "text with spaces\nanother line with special chars%=!+"
      trigger 'escape-utils:url-encode', ->
         expect(editor.getText()).
           toBe "text with spaces\nanother line with special chars%=!+"

    it "encodes just the selected text", ->
      editor.setText "text with a lot of spaces\nanother line with special chars%=!+"
      editor.setSelectedBufferRange([[0,8], [0,16]])
      trigger 'escape-utils:url-encode', ->
         expect(editor.getText()).
           toBe "text with%20a%20lot%20of spaces\nanother line with special chars%=!+"

    it "encodes the multiple selected blocks of text", ->
      editor.setText "text with a lot of spaces\nanother line with special chars%=!+"
      editor.setSelectedBufferRanges([[[0,8], [0,16]], [[1,30], [1,35]]])
      trigger 'escape-utils:url-encode', ->
         expect(editor.getText()).
           toBe "text with%20a%20lot%20of spaces\nanother line with special chars%25%3D!%2B"

  describe "escape-utils:base64-*", ->
    it "encode just the selected text", ->
      editor.setText "text with a lot of spaces\nanother line"
      editor.setSelectedBufferRange([[0,4], [0,16]])
      trigger 'escape-utils:base64-encode', ->
         expect(editor.getText()).
           toBe "textIHdpdGggYSBsb3Qgof spaces\nanother line"

  describe "escape-utils:base64-encode", ->
    it "decodes just the selected text", ->
      editor.setText "text with a lot of spaces\nanother line"
      editor.setSelectedBufferRange([[0,4], [0,16]])
      trigger 'escape-utils:base64-encode', ->
         expect(editor.getText()).
           toBe "textIHdpdGggYSBsb3Qgof spaces\nanother line"

  describe "escape-utils:base64-decode", ->
    it "decodes just the selected text", ->
      editor.setText "textIHdpdGggYSBsb3Qgof spaces\nanother line"
      editor.setSelectedBufferRange([[0,4], [0,20]])
      trigger 'escape-utils:base64-decode', ->
         expect(editor.getText()).
           toBe "text with a lot of spaces\nanother line"

    it "recognize the base64 padding", ->
      editor.setText "dGV4dCB3aXRoIGEgbG90IG9mIHNwYWNlcw=="
      editor.setSelectedBufferRange([[0,0], [0,37]])
      trigger 'escape-utils:base64-decode', ->
         expect(editor.getText()).
           toBe "text with a lot of spaces"

    it "adds the missing padding to match base64 requirements", ->
      editor.setText "dGV4dCB3aXRoIGEgbG90IG9mIHNwYWNlcw"
      editor.setSelectedBufferRange([[0,0], [0,35]])
      trigger 'escape-utils:base64-decode', ->
         expect(editor.getText()).
           toBe "text with a lot of spaces"

    it "ignores the text that cannot be decoded", ->
      editor.setText "text with a lot of spaces\nanother line"
      editor.setSelectedBufferRange([[0,0], [1,10]])
      trigger 'escape-utils:base64-decode', ->
         expect(editor.getText()).
           toBe "text with a lot of spaces\nanother line"
