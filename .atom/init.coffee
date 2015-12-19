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
  'ex-command:write': -> dispatch 'core:save'
  'ex-command:write-quit': -> dispatch 'core:save', 'core:close'
  'ex-command:split': -> dispatch 'pane:split-down'
  'ex-command:vertical-split': -> dispatch 'pane:split-right'

  'ex-command:controller': -> dispatch 'rails-transporter:open-controller'
  'ex-command:view-finder': -> dispatch 'rails-transporter:open-view-finder'
  'ex-command:view': -> dispatch 'rails-transporter:open-view'
  'ex-command:layout': -> dispatch 'rails-transporter:open-layout'
  'ex-command:model': -> dispatch 'rails-transporter:open-model'
  'ex-command:helper': -> dispatch 'rails-transporter:open-helper'
  'ex-command:test': -> dispatch 'rails-transporter:open-test'
  'ex-command:spec': -> dispatch 'rails-transporter:open-spec'
  'ex-command:partial-template': -> dispatch 'rails-transporter:open-partial-template'
  'ex-command:asset': -> dispatch 'rails-transporter:open-asset'
  'ex-command:migration-finder': -> dispatch 'rails-transporter:open-migration-finder'
  'ex-command:factory': -> dispatch 'rails-transporter:open-factory'

exCommandsPrefix = 'Ex Command: '
atom.commands.add 'atom-workspace',
  'user-ex-command-open': ->
    dispatch 'command-palette:toggle'
    insertToCommandPaletteEditor(exCommandsPrefix)
