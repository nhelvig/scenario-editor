# This creates the browsers window for all element
class window.sirius.BrowserView extends Backbone.View
  $a = window.sirius
  
  # The options hash contains the type of dialog(eg. 'node'), the model
  # associated with the dialoag, and templateData
  # used to inject into the html template
  initialize: (@options) ->
    @elem = @options.elem
    title  = $a.Util.toStandardCasing(@elem)  # eg. node -> Node
    @$el.attr 'title', "#{title} Browser"
    @$el.attr 'id', "browser"
    @template = _.template($("#browser-window-template").html())
    @$el.html(@template(options.templateData))
    node = $a.models.get('networklist').get('network')[0].get('nodelist').get('node')[0]
    @nev = new $a.EditorNodeView(model: node, elem:'node', width: 300)   
    @render()

  # render the dialog box. The calling function has responsability for appending
  # it as well as calling el.tabs and el.diaload('open')
  render: ->
    @$el.dialog
      autoOpen: true,
      width: 700,
      modal: false,
      close: =>
        @$el.remove()
    $('#browser_table').dataTable( {
        "aaData": [
            [ "Trident", "Internet Explorer 4.0", "Win 95+", 4, "X" ],
            [ "Trident", "Internet Explorer 5.0", "Win 95+", 5, "C" ],
            [ "Trident", "Internet Explorer 5.5", "Win 95+", 5.5, "A" ],
            [ "Trident", "Internet Explorer 6.0", "Win 98+", 6, "A" ],
            [ "Trident", "Internet Explorer 7.0", "Win XP SP2+", 7, "A" ],
        ],
        "aoColumns": [
            { "sTitle": "Engine" },
            { "sTitle": "Browser" },
            { "sTitle": "Platform" },
            { "sTitle": "Version", "sClass": "center" },
            {"sTitle": "Grade"}
        ],
        "bPaginate": false,
        "bLengthChange": false,
        "bFilter": false,
        "bSort": false,
        "bInfo": false,
        "bAutoWidth": false,
    })
    @nev.render()
    $(@nev.el).tabs()
    $('#right').append(@nev.el)
    @$el.layout({ resizable:true });
    @
