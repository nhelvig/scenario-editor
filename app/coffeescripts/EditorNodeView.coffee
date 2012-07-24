# This creates the editor dialogs for all elements
class window.sirius.EditorNodeView extends window.sirius.EditorView 
  $a = window.sirius
  events : {
    'blur #name, #description, #type' : 'save'
    'blur #lat, #lng, #elevation' : 'saveGeo'
  }    
  
  initialize: (elem, model, templateData) ->
    templateData = {
          name: @model.get('name'), 
          description: @model.get('description'),
          lat: @model.get('position').get('point')[0].get('lat')
          lng: @model.get('position').get('point')[0].get('lng')
          elevation: @model.get('position').get('point')[0].get('elevation')
          lock: if @model.get('lock')? and model.get('lock') is true then 'checked' else ''
        }
    super elem, model, templateData

    #set selected type element
    elem = _.filter($("#node-dialog-form select option"), (item) => $(item).val() is @model.get('type'))
    $(elem[0]).attr('selected', true)

    #generate tabs
    $('#dialog-form').tabs();
    $('#dialog-form').dialog('open')
    
  
  render: ->
    super @elem
    @

  save: (e) ->
    id = e.currentTarget.id
    @model.set(id, $("##{id}").val())

  saveGeo: (e) ->
    @model.get('position').get('point')[0].set(id, $("##{id}").val())
    