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
      autoOpen: false,
      width: 600,
      modal: false,
      close: =>
        @$el.remove()
    nodes = $a.models.get('networklist').get('network')[0].get('nodelist').get('node')
    data = _.map(nodes, (node) -> [node.get('name'),node.get('type')] )
    $('#browser_table').dataTable( {
        "aaData": data,
        "aoColumns": [
            { "sTitle": "Name","sWidth": "50%"},
            { "sTitle": "Type","sWidth": "50%"},
        ],
        "bPaginate": false,
        "bLengthChange": true,
        "bFilter": false,
        "bSort": true,
        "bInfo": false,
        "bAutoWidth": false,
        "bJQueryUI": true,
    })
    @nev.render()
    $(@nev.el).tabs()
    $('#right').append(@nev.el)
    @$el.dialog('open')
    @renderResizer()
    @

  renderResizer: (e) ->
    prevPos = 0
    handleTop = @nev.el.offsetHeight / 2 - 25
    $("#handle").css('margin-top', "#{handleTop}px")
    $("#resize").css('height', "#{@nev.el.offsetHeight}px")
    $('#resize').draggable({
      axis : 'x',
      start: (e) ->
        prevPos = e.pageX
      drag: (e) ->
        delta = (prevPos - e.pageX)
        prevPos = e.pageX
        divLeftWidth = $("#left").width() - delta
        divRightWidth = $("#right").width() + delta
        if divLeftWidth < 150 or divRightWidth < 150
          divRightWidth = $("#right").width()
          divLeftWidth = $("#left").width() 

        $("#left").css('width', divLeftWidth + 'px')
        $("#right").css('width', divRightWidth + 'px')
        $("#resize").css('position', '')
    })