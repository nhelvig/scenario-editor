# This class Creates the TreeView by going through the appropriate lists
# and making parent and child nodes for the tree
class window.beats.TreeView extends Backbone.View
  $a = window.beats
  tagName: 'ol'
  id: 'tree'

  # The args contains the scenario models as well as what parent div it
  # should attach the tree too.
  initialize: (args) ->
    scenario = args.scenario
    @parent = args.attach
    @_createParentNodes $a.main_tree_elements
    @_createNetworkChildren({
      parentList: scenario.get('networklist')
      modelListName: 'network'
      attachId: 'network-list'
      nameList: null
    })
    @_createChildren({
      parentList: scenario.get('networkconnections')
      modelListName: 'network'
      attachId:  'network-connections'
      nameList: null
    })
    @_createLinkChildren({
      parentList: scenario.get('initialdensityset')
      modelListName: 'density'
      attachId: 'initial-density-profiles'
    })
    @_createLinkChildren({
      parentList: scenario.get('controllerset')
      modelListName: 'controller'
      attachId: 'controllers'
    })
    @_createLinkChildren({
      parentList: scenario.get('demandprofileset')
      modelListName: 'demandprofile'
      attachId: 'demand-profiles'
    })
    @_createLinkChildren({
      parentList: scenario.get('eventset')
      modelListName: 'event'
      attachId: 'events'
    })
    @_createLinkChildren({
      parentList: scenario.get('fundamentaldiagramprofileset')
      modelListName: 'fundamentaldiagramprofile'
      attachId: 'fundamental-diagram-profiles'
    })
    @_createLinkChildren({
      parentList: scenario.get('oddemandprofileset')
      modelListName: 'oddemandprofile'
      attachId: 'od-demand-profiles'
    })
    @_createLinkChildren({
      parentList: scenario.get('downstreamboundarycapacityprofileset')
      modelListName: 'downstreamboundarycapacityprofile'
      attachId: 'downstream-boundary-profiles'
    })
    @_createNodeChildren({
      parentList: scenario.get('splitratioprofileset')
      modelListName: 'splitratioprofile'
      attachId: 'split-ratio-profiles'
    })
    @_createLinkChildren({
      parentList: scenario.get('sensorlist')
      modelListName: 'sensor'
      attachId: 'sensors'
    })
    @_createNodeChildren({
      parentList: scenario.get('signallist')
      modelListName: 'signal'
      attachId: 'signals'
    })
    
    $a.broker.on("map:toggle_tree", @toggleTree, @)
    $a.broker.on('app:main_tree', @render, @)

  # Attach itself as well as trigger events for the parent and child
  # nodes to be rendered
  render: ->
    $(@parent).append(@el)
    @_setUpToggleAndExpand()
    $a.broker.trigger('app:parent_tree')
    $a.broker.trigger('app:child_trees')
    $a.broker.trigger('map:toggle_tree')
    @

  _setUpToggleAndExpand: () ->
    @treeOpen = false
    $("#map_canvas").append $('#toggle-tree-button-template').html()
    
    $('#collapseTree').click( ->
      $a.broker.trigger('map:toggle_tree')
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
      switch params.type
        when 'link', 'node' then name = targets[0].get_road_names()
        else name = targets[0].get('name')
  
      # for OD Profiles
      name = "#{name} -> #{targets[1].get('name')}" if targets.length > 1
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
        [element.get('link')]
  
  toggleTree: (display) =>
    button = $('#collapseTree')[0]
    if @treeOpen
      @treeOpen = false
      button.innerHTML = ' < '
      $('#right_tree').hide(200)
      align = right: '0%'
      $('#collapseTree').animate(align, 200)
    else
      @treeOpen = true
      button.innerHTML = ' > '
      $('#right_tree').show(200)
      align = right: '22%'
      $('#collapseTree').animate(align, 200)