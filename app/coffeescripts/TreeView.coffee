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
      links = $a.MapNetworkModel.LINKS
      nodes = $a.MapNetworkModel.NODES
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
        nameList: links
      })
      @_createLinkChildren({
        parentList: scenario.get('controllerset')
        modelListName: 'controller'
        attachId: 'controllers'
        nameList: links
      })
      @_createDemandLinkChildren({
        parentList: scenario.get('demandprofileset')
        modelListName: 'demandprofile'
        attachId: 'demand-profiles'
        nameList: links
      })
      @_createLinkChildren({
        parentList: scenario.get('eventset')
        modelListName: 'event'
        attachId: 'events'
        nameList: links
      })
      @_createLinkChildren({
        parentList: scenario.get('fundamentaldiagramprofileset')
        modelListName: 'fundamentaldiagramprofile'
        attachId: 'fundamental-diagram-profiles'
        nameList: links
      })
      @_createLinkChildren({
        parentList: scenario.get('oddemandprofileset')
        modelListName: 'oddemandprofile'
        attachId: 'od-demand-profiles'
        nameList: links
      })
      @_createLinkChildren({
        parentList: scenario.get('downstreamboundarycapacityprofileset')
        modelListName: 'downstreamboundarycapacityprofile'
        attachId: 'downstream-boundary-profiles'
        nameList: links
      })
      @_createNodeChildren({
        parentList: scenario.get('splitratioprofileset')
        modelListName: 'splitratioprofile'
        attachId: 'split-ratio-profiles'
        nameList: nodes
      })
      @_createLinkChildren({
        parentList: scenario.get('sensorlist')
        modelListName: 'sensor'
        attachId: 'sensors'
        nameList: links
      })
      @_createNodeChildren({
        parentList: scenario.get('signallist')
        modelListName: 'signal'
        attachId: 'signals'
        nameList: nodes
      })
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
      targets = @_findTargetElements(e, params.attachId, params.nameList)
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

  # We are trying to figure out the target objects for these elements. Again, 
  # we case the type in order to appropriate access the node or link id and
  # then get its name from the node or link list
  _findTargetElements: (element, type, list) ->
    switch type
      when 'network-list', 'network-connections' then [element]
      when 'demand-profiles'
        [$a.Util.getElement(element.get('link_id_origin'), list)]
      when 'od-demand-profiles' 
        [
          $a.Util.getElement(element.get('link_id_origin'), list), 
          $a.Util.getElement(element.get('link_id_destination'), list)
        ]
      when 'controllers', 'events'
        elem = element.get('targetelements').get('scenarioelement')[0]
        [$a.Util.getElement(elem.get('id'), list)]
      when 'fundamental-diagram-profiles' or 
      'downstream-boundary-profiles' or
      'initial-density-profiles'
        [$a.Util.getElement(element.get('link_id'), list)]
      when 'split-ratio-profiles', 'signals'
        [$a.Util.getElement(element.get('node_id'), list)]
      when 'sensors'
        [$a.Util.getElement(element.get('link_reference').get('id'), list)]