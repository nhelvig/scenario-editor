# This class Creates the TreeView by going through the appropriate lists
# and making parent and child nodes for the tree
class window.beats.TreeView extends Backbone.View
  $a = window.beats
  tagName: 'ol'
  id: 'tree'
  
  broker_events : {
    'map:clear_map': 'clearMap'
    'map:toggle_tree': 'toggleTree'
    'app:main_tree': 'render'
    'map:open_view_mode' : 'viewMode'
    'map:open_network_mode' : 'networkMode'
    'map:open_scenario_mode' : 'scenarioMode'
  }
  # The args contains the @scenario models as well as what parent div it
  # should attach the tree too.
  initialize: (args) ->
    @scenario = args.scenario
    @parent = args.attach
    @_setUpTreeData()
    @_createTree()
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $(window).bind("resize", @positionHandle);

  # Attach itself as well as trigger events for the parent and child
  # nodes to be rendered
  render: ->
    $(@parent).append(@el)
    @_setUpToggleAndExpand()
    $a.broker.trigger('app:parent_tree')
    $a.broker.trigger('app:child_trees')
    @toggleTree(true)
    @
    
  # This removed the unpublishes the object from the events
  clearMap: () ->
    $('#toggle-tree-button-template').remove()
    @$el.remove()
    $a.Util.publishEvents($a.broker, @broker_events, @)
    $('#collapseTree').off('click')
    $('#expand-all').off('click')
  
  # This sets up the parent and children nodes
  _createTree: () ->
    @_createParentNodes $a.main_tree_elements
    @_createNetworkChildren(@parentNodes[0])
    @_createChildren(@parentNodes[1])
    @_createLinkChildren(@parentNodes[2])
    @_createLinkChildren(@parentNodes[3])
    @_createLinkChildren(@parentNodes[4])
    @_createLinkChildren(@parentNodes[5])
    @_createLinkChildren(@parentNodes[6])
    @_createLinkChildren(@parentNodes[7])
    @_createLinkChildren(@parentNodes[8])
    @_createNodeChildren(@parentNodes[9])
    @_createLinkChildren(@parentNodes[10])
    @_createNodeChildren(@parentNodes[11])

  # this method sets up the tree and all the events related opening and
  # closing the tree view.
  _setUpToggleAndExpand: () ->
    if $('#tree-resize').length == 0
      $("#right_tree").prepend $('#toggle-tree-handle-template').html()
    
    @positionHandle()
    $('#tree-handle').click( ->
      if ($('#tree-handle').hasClass('noClick') is false)
        $a.broker.trigger('map:toggle_tree') 
    )
    
    prevPos = 0
    $('#tree-resize').draggable({
      axis : 'x',
      start: (e) ->
        prevPos = e.pageX
      drag: (e) =>
        right = "#right_tree"
        left = "#map_canvas"
        lWidth = $(left).width()
        rWidth = $(right).width()
        total = lWidth + rWidth
        delta = (prevPos - e.pageX)
        prevPos = e.pageX
        divLeftWidth = lWidth - delta
        divRightWidth = rWidth + delta
        if divRightWidth / total >= 0.22
          divRightWidth = total * .22
          divLeftWidth = total - divRightWidth
        $(left).css('width', divLeftWidth/total * 100  + '%')
        $(right).css('width', divRightWidth/total * 100 + '%')
        $("#tree-resize").css('position', '')
      }
    )
    
    $('#expand-all').click( ->
      all_checks = $('.expand-tree')
      btn = $('#expand-all')[0]
      if btn.innerHTML == '+' and all_checks.length > 0
        checkBox.checked = true for checkBox in all_checks
        btn.innerHTML = '-'
      else if btn.innerHTML == '-' and all_checks.length > 0
        checkBox.checked = false for checkBox in all_checks
        btn.innerHTML = '+'
    )
  
  # this is called when the window resizes in order to position the handle
  # in the center of the bar
  positionHandle: ->
    height = $("#right_tree").height() - 3
    handleTop = height / 2 - 25
    $("#tree-handle").css('margin-top', "#{handleTop}px")

  # Creates all the parents nodes and prepares them for rendering
  _createParentNodes: (list) ->
    _.each list, (e) ->  new $a.TreeParentItemView(e)

  # Called by initialize to create the child nodes. If no nodes are defined
  # we add an empty child
  _createChildren: (params, type) ->
    params.type = type
    pList = params.parentList
    mList = params.modelListName
    if pList? and pList.get(mList)? and pList.get(mList).length != 0
      @_createChildNodes(params)
    else
      @_createEmptyChild(params.attachId)

  # creates link tree items by passing 'link' argument to _createChildren
  _createLinkChildren: (params) ->
    @_createChildren(params,'link')

  # creates node tree items by passing 'node' argument to _createChildren
  _createNodeChildren: (params) ->
    @_createChildren(params,'node')

  # creates node tree items by passing 'node' argument to _createChildren
  _createNetworkChildren: (params) ->
    @_createChildren(params, 'network')

  # If there are no items defined for a parent we add an empty node
  # labelled None Defined
  _createEmptyChild: (attach) ->
    new $a.TreeChildItemView({
        e: null
        targets: null
        name: 'None Defined'
        attach: attach
      })

  # Creates the child nodes and prepares the for rendering. It is slightly
  # more complex in that the different types of elements have different ways
  # of storing what node or link they are attached to
  _createChildNodes: (params, type) ->
    _.each(params.parentList.get(params.modelListName), (e) =>
      targets = @_findTargetElements(e, params.attachId)
      if targets? and !(targets.length is 0)
          switch params.type
            when 'link' then name = targets[0]?.link_name()
            when 'node' then name = targets[0]?.name()
            else name = targets[0]?.get('name')

          # if name is not defined do nothing
          if name?
            # for OD Profiles
            name = "#{name} -> #{targets[1]?.get('name')}" if targets.length > 1
            attrs =
              e: e
              targets: targets
              name: name
              attach: params.attachId

            # We create create link and node tree items by calling their
            # respective tree view classes All others are just tree items
            switch params.type
              when 'link' then new $a.TreeChildItemLinkView(attrs)
              when 'node' then new $a.TreeChildItemNodeView(attrs)
              when 'network' then new $a.TreeChildItemNetworkView(attrs)
              else new $a.TreeChildItemView(attrs)
    )

  # we case the type in order to appropriately access the node or link
  _findTargetElements: (element, type) ->
    switch type
      when 'network-list', 'network-connections' then [element]
      when 'demand-profiles'
        [element.get('link')]
      when 'od-demand-profiles'
        [ element.get('begin_node'),
          element.get('end_node') ]
      when 'controllers', 'events'
        element.get('targetreferences')
      when 'fundamental-diagram-profiles' or
      'downstream-boundary-profiles' or
      'initial-density-profiles'
        [element.get('link')]
      when 'split-ratio-profiles', 'signals'
        [element.get('node')]
      when 'sensors'
        arr = []
        if element.get('link')? 
          arr = [element.get('link')]
        arr
  
  toggleTree: (display) =>
    # colled from collapse button rather then open/close scenario
    if !display?
      display = not @treeOpen
      
    if display
      @openTree()
    else
      @closeTree()
  
  closeTree: ->
    @treeOpen = false
    $('#tree_view').hide(200)
    $('#right_tree').css('width', '1%')
    $('#map_canvas').css('width', '99.2%')
    # change location of login indicator
    $('.login-container').css('margin-left', '87%')

  openTree: ->
    @treeOpen = true
    $('#right_tree').css('width', '22%')
    $('#right_tree').show(200)
    $('#tree_view').show(200)
    $('#map_canvas').css('width', '78.2%')
    # change location of login indicator
    $('.login-container').css('margin-left', '66%')
  
  networkMode: ->
    $('#tree-handle').addClass("noClick")
    $('#tree-resize').draggable('disable')
    @closeTree()
    
  scenarioMode: ->
    $('#tree-handle').removeClass("noClick")
    $('#tree-resize').draggable('enable')
    @openTree()
    
  viewMode: ->
    $('#tree-handle').removeClass("noClick")
    $('#tree-resize').draggable('enable')
    @openTree()
    
  _setUpTreeData: ->   
    @parentNodes = [
        {
          parentList: @scenario.get('networkset')
          modelListName: 'network'
          attachId: 'network-list'
          nameList: null
        },
        {
          parentList: @scenario.get('networkconnections')
          modelListName: 'network'
          attachId:  'network-connections'
          nameList: null
        },
        {
          parentList: @scenario.get('initialdensityset')
          modelListName: 'density'
          attachId: 'initial-density-profiles'
        },
        {
          parentList: @scenario.get('controllerset')
          modelListName: 'controller'
          attachId: 'controllers'
        },
        {
          parentList: @scenario.get('demandset')
          modelListName: 'demandprofile'
          attachId: 'demand-profiles'
        },
        {
          parentList: @scenario.get('eventset')
          modelListName: 'event'
          attachId: 'events'
        },
        {
          parentList: @scenario.get('fundamentaldiagramset')
          modelListName: 'fundamentaldiagramprofile'
          attachId: 'fundamental-diagram-profiles'
        },
        {
          parentList: @scenario.get('demandset')
          modelListName: 'oddemandprofile'
          attachId: 'od-demand-profiles'
        },
        {
          parentList: @scenario.get('downstreamboundarycapacityset')
          modelListName: 'downstreamboundarycapacityprofile'
          attachId: 'downstream-boundary-profiles'
        },
        {
          parentList: @scenario.get('splitratioset')
          modelListName: 'splitratioprofile'
          attachId: 'split-ratio-profiles'
        },
        {
          parentList: @scenario.get('sensorset')
          modelListName: 'sensor'
          attachId: 'sensors'
        },
        {
          parentList: @scenario.get('signalset')
          modelListName: 'signal'
          attachId: 'signals'
        }
      ]