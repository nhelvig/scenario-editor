# This class Creates the TreeView by going through the appropriate lists
# and making parent and child nodes for the tree
class window.sirius.TreeView extends Backbone.View
  $a = window.sirius
  tagName: 'ol'
  id: 'tree'

  # The args contains the scenario models as well as what parent div it 
  # should attach the tree too.
  initialize: (args) ->
      scenario = args.scenario
      @parent = args.attach
      @_createParentNodes $a.main_tree_elements
      @_createNetworkChildren(scenario.get('networklist'), 'network', "network-list")
      @_createChildren(scenario.get('networkconnections'), 'network', "network-connections", null)
      @_createLinkChildren(scenario.get('initialdensityset'), 'density', "initial-density-profiles",links)
      @_createLinkChildren(scenario.get('controllerset'), 'controller', "controllers", links)
      @_createChildren(scenario.get('demandprofileset'), 'demandprofile', "demand-profiles", @scenario.get('demandprofileset').get('demandprofile'))
      @_createLinkChildren(scenario.get('eventset'), 'event', "events", links)
      @_createLinkChildren(scenario.get('fundamentaldiagramprofileset'), 'fundamentaldiagramprofile', "fundamental-diagram-profiles", links)
      @_createLinkChildren(scenario.get('oddemandprofileset'), 'oddemandprofile', "od-demand-profiles", links)
      @_createLinkChildren(scenario.get('downstreamboundarycapacityprofileset'), 'downstreamboundarycapacityprofile', "downstream-boundary-profiles", links)
      @_createNodeChildren(scenario.get('splitratioprofileset'), 'splitratioprofile', "split-ratio-profiles",  nodes)
      @_createLinkChildren(scenario.get('sensorlist'), 'sensor', "sensors", links)
      @_createNodeChildren(scenario.get('signallist'), 'signal', "signals", nodes)
      $a.broker.on('app:main_tree', @render, @)

  # Attach itself as well as trigger events for the parent and child 
  # nodes to be rendered
  render: ->
    $(@parent).append(@el)
    $a.broker.trigger('app:parent_tree')
    $a.broker.trigger('app:child_trees')
    @

  # Creates all the parents nodes and prepares them for rendering
  _createParentNodes: (list) ->
    _.each list, (e) ->  new $a.TreeParentItemView(e)

  # Called by initialize to create the child nodes. If no nodes are defined
  # we add an empty child
  _createChildren: (params) ->
    pList = params.parentList
    mList = params.modelListName
    if pList? and pList.get(mList)? and pList.get(mList).length != 0
      @_createChildNodes(params)
    else
      @_createEmptyChild(params.attachId)

  # creates link tree items by passing 'link' argument to _createChildren
  _createLinkChildren: (params) ->
    @_createChildren(params,'link')

  # creates link tree items by passing 'demandlink' argument to _createChildren
  _createDemandLinkChildren: (params) ->
    @_createChildren(params,'demandlink')

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
  _createChildNodes: (params) ->
    _.each(params.parentList.get(params.modelListName), (e) =>
      targets = @_findTargetElements(e, params.attachId)
      name = targets[0].get('name')
      # for OD Profiles
      name = "#{name} -> #{targets[1].get('name')}" if targets.length > 1
      
      attrs = {
        e : e
        targets: targets
        name: name
        attach: params.attachId
      }
      # We create create link and node tree items by calling their respective
      # tree view classes All others are just tree items
      switch params.type
        when 'demandlink' then new $a.TreeChildItemDemandLinkView(attrs)
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
        [
          element.get('begin_node'),
          element.get('end_node')
        ]
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
