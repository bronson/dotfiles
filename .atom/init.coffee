# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"



# https://github.com/t9md/atom-vim-mode-plus/issues/52
dispatch = (commands...) ->
  editor = atom.workspace.getActiveTextEditor()
  editorElement = atom.views.getView(editor)
  for command in commands
    atom.commands.dispatch(editorElement, command)

getCommandPaletteView = () ->
  for {item} in atom.workspace.getModalPanels()
    return item if item.constructor.name is 'CommandPaletteView'

getCommandPaletteEditor = () ->
  getCommandPaletteView().filterEditorView.getModel()

insertToCommandPaletteEditor = (text) ->
  editor = getCommandPaletteEditor()
  editor.insertText(text)
  editor.moveToEndOfLine()

atom.commands.add 'atom-workspace',
  'ex-command:w': -> dispatch 'core:save'
  'ex-command:W': -> dispatch 'core:save'
  'ex-command:wq': -> dispatch 'core:save', 'core:close'
  'ex-command:s': -> dispatch 'pane:split-down'
  'ex-command:v': -> dispatch 'pane:split-right'
  'ex-command:vs': -> dispatch 'pane:split-right'

exCommandsPrefix = 'Ex Command: '
atom.commands.add 'atom-workspace',
  'user-ex-command-open': ->
    dispatch 'command-palette:toggle'
    insertToCommandPaletteEditor(exCommandsPrefix)
