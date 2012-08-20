class window.sirius.DemandVisualizer extends Backbone.View
  initGraphSvg: (sel) ->
    width = 450
    height = 400
    padding = 40
    minVal = maxVal = 0
    @graph = d3.select(sel).append("svg:svg").
      attr("width", width + padding).
      attr("height", height + padding)

    @graph.append("svg:rect").
      attr("width", width + padding).
      attr("height", height + padding).
      attr("fill", 'white')

    dText = @demand.get('text')
    vals = window.sirius.ArrayText.parse dText, [",",":"], "Number"

    if vals.length > 0
      startTime = @demand.get('start_time') or 0
      dt = @demand.get('dt')
      endTime = startTime + (dt * vals[0].length)
      @xScale = d3.scale.linear().
        domain([0, vals[0].length]).range([0, width])

      _.each vals, (flatArray) =>
        minVal = _.min(flatArray)
        maxVal = _.max(flatArray)
        @yScale = d3.scale.linear().
          domain([minVal, maxVal]).range([0, height])

      axisGroup = @graph.append("svg:g").
      	attr("transform", "translate(#{padding}, #{padding})")

      xAxisSampleInterval = 1
      yAxisSampleInterval = maxVal*height/10000
      axisGroup.selectAll("lines.xAxis").
      	data(vals[0]).
        enter().
      	append("svg:line").
      	attr("x1", (d,i) => @xScale(i)).
      	attr("x2", (d,i) => @xScale(i)).
      	attr("y1", -padding).
      	attr("y2", height-10).
      	attr("stroke", (d,i) ->
    	    if i % xAxisSampleInterval == 0 then "darkGray" else "lightGray"
        )


  initialize: (@demand, @link) ->
    @template = _.template($("#demand-visualizer-template").html())
    @$el.html @template(elemId: @link.id)
    @$el.attr 'title', "Demand Visualizer - Link #{@link.get('name')}"

  # render the dialog box. The calling function has responsability for
  # appending it as well as calling el.tabs and el.diaload('open')
  render: ->
    @$el.dialog
      autoOpen: false,
      width: 490,
      height: 450,
      modal: false,
      close: =>
        @$el.remove()
    @initGraphSvg("#demand-graph-#{@link.id}")
    @