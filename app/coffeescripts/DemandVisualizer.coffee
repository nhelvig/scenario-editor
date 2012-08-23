every = (count, arr) ->
  _.filter(arr, (e,i) -> i % count == 0)

topYVal = (height, yScale, demand, demandProfile) ->
  stdDevAdd = demandProfile.get('std_dev_add') or 0
  stdDevMult = demandProfile.get('std_dev_mult') or 0
  knob = demandProfile.get('knob') or 1
  boxMax = knob * Math.max(demand + stdDevAdd, demand + (demand * stdDevMult))

  return height - yScale(boxMax)

padValueArray = (arr) -> arr.push(_.last(arr))

class window.sirius.DemandVisualizer extends Backbone.View
  vehicleTypeColors = [
    '#cc0000', '#cccc00', '#3300ff', '#33cc00', '#ccff00'
    '#333300', '#00ffff', '#66ccff', '#996600', '#9933ff'
  ]

  renderConstDemands: (sel) ->
    content = _.map @demand.demands_by_vehicle_type(), (demand, idx) =>
      vehicleType = @typeOrder.get('vehicle_type')[idx].get('name')
      @constDemand
        elemId: @link.id
        demandVehicleIndex: idx
        demandVehicleType: vehicleType
        demandVehicleCount: demand[0]

    @$el.html @vizWindow(elemId: @link.id, content: content)

  renderGraph: (sel) ->
    textSizeImprecisionOffset = 2
    labelFontSize = 10
    width = 450
    height = 400
    padding = 50

    @graph = d3.select(sel).append("svg:svg").
      attr("width", width + padding).
      attr("height", height + padding)

    @graph.append("svg:rect").
      attr("width", width + padding).
      attr("height", height + padding).
      attr("fill", 'white')

    vals = @demand.demands_by_vehicle_type()

    if vals.length > 0
      startTime = @demand.get('start_time') or 0
      timeSteps = vals[0].length
      dt = @demand.get('dt')
      endTime = startTime + (dt * timeSteps)
      valMax = _.max(_.flatten(vals))
      stdDevAdd = @demand.get('std_dev_add') or 0
      stdDevMult = @demand.get('std_dev_mult') or 0
      knob = @demand.get('knob') or 1

      yMaxGlobal = knob * Math.max(valMax + stdDevAdd, valMax * stdDevMult)

      xScale = d3.scale.linear().
        domain([0, timeSteps]).range([0, width])
      yScale = d3.scale.linear().
        domain([0, yMaxGlobal]).range([0, height])

      axisGroup = @graph.append("svg:g").
      	attr("transform", "translate(#{padding}, #{padding})")

      xAxisSampleInterval = 20
      yAxisSampleInterval = yMaxGlobal/20;

      axisGroup.selectAll("lines.xAxis").
      	data(vals[0]).
        enter().
      	append("svg:line").
      	attr("x1", (d,i) -> xScale(i)).
      	attr("x2", (d,i) -> xScale(i)).
      	attr("y1", 0).
      	attr("y2", height - labelFontSize - textSizeImprecisionOffset).
      	attr("stroke", (d,i) ->
    	    if i % xAxisSampleInterval == 0 then "darkGray" else "lightGray"
        )

      axisGroup.selectAll("lines.yAxis").
        data(d3.range(yAxisSampleInterval,yMaxGlobal + yAxisSampleInterval,yAxisSampleInterval)).
      	enter().
      	append("svg:line").
      	attr("x1", 0).
      	attr("x2", width).
      	attr("y1", (d) -> yScale(d)).
      	attr("y2", (d) -> yScale(d)).
      	attr "stroke", (d,i) ->
          if(i % 3 == 0) then "darkGray" else "lightGray"

      xAxisText = axisGroup.selectAll("text.xAxis").
      	data(every(xAxisSampleInterval,vals[0])).
      	enter().
      	append("svg:text").
      	attr("x", (d,i) -> xScale(xAxisSampleInterval*i)).
      	attr("y", height-2).
      	attr("text-anchor","middle").
      	style("font-size", "#{labelFontSize}px").
      	text (d,i) ->
          s = startTime + xAxisSampleInterval * i * dt
          h = s/3600
          Math.round(h*10)/10 + "h"

      axisGroup.selectAll("text.yAxis").
      	data(d3.range(yAxisSampleInterval, yMaxGlobal + yAxisSampleInterval, yAxisSampleInterval)).
      	enter().
      	append("svg:text").
      	attr("x", -padding + textSizeImprecisionOffset).
      	attr("y", (d) -> yScale(yMaxGlobal-d) + textSizeImprecisionOffset).
      	style("font-size", "#{labelFontSize}px").
      	text((d) -> Math.round(d*10)/10)

      wrapSteps = d3.svg.line().
        x((d, idx) -> xScale(idx) + padding).
      	y((d) -> height + padding - yScale(d)).
      	interpolate('step-after')

      _.each vals, (vehicleTypeVals, i) =>
        vehicleType = @typeOrder.get('vehicle_type')[i].get('name')
        padValueArray(vehicleTypeVals)

        @graph.append("svg:path").
          attr("d", wrapSteps(vehicleTypeVals)).
        	attr("fill", 'none').
        	attr("stroke", 'black')

        @graph.selectAll("stdDevBoxes").
        	data(vehicleTypeVals).
        	enter().
        	append("svg:rect").
        	attr("x", (d, idx) -> xScale(idx) + padding).
        	attr("y", (d) => topYVal(height, yScale, d, @demand) + padding).
        	attr("width", xScale(1)).
          attr("fill", vehicleTypeColors[i]).
        	attr("opacity", "0.4").
        	attr("height", (d) ->
            # Enforce coloring even if stddev. not present to distinguish
            # vehicle types
            Math.max(yScale(Math.max(2*stdDevAdd, 2*stdDevMult*d - d)),3))

  initialize: (@demand) ->
    @profileSet = window.sirius.models.get("demandprofileset")
    @typeOrder = @profileSet.get('vehicletypeorder')
    @link = @demand.get('link')
    @vizWindow = _.template($("#demand-visualizer-window-template").html())
    if @demand.is_constant()
      @constDemand = _.template($("#constant-demand-template").html())
    else
      @dataDisplay = _.template($("#demand-graph-template").html())
      @$el.html @vizWindow(elemId: @link.id, content: @dataDisplay(elemId: @link.id))

    @$el.attr 'title', "Demand Visualizer - Link #{@link.get('name')}"

  # render the dialog box. The calling function has responsability for
  # appending it as well as calling el.tabs and el.diaload('open')
  render: ->
    @$el.dialog
      autoOpen: false,
      width: 500,
      height: 500,
      modal: false,
      close: =>
        @$el.remove()
    if @demand.is_constant()
      @renderConstDemands()
    else
      @renderGraph("#demand-graph-#{@link.id}")
    @