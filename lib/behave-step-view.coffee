{View} = require 'atom'

module.exports =
class BehaveStepView extends View
  @content: ->
    @div class: 'behave-step overlay from-top', =>
      @div "The BehaveStep package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "behave-step:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "BehaveStepView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
