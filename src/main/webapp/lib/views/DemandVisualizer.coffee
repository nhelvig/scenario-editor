every = (count, arr) ->
  _.filter(arr, (e,i) -> i % count == 0)

maxDev = (demand, demandProfile) ->
  stdDevAdd = demandProfile.get('std_dev_add') or 0
  stdDevMult = demandProfile.get('std_dev_mult') or 0
  knob = demandProfile.get('knob') or 1

  knob * Math.max(stdDevAdd, (demand * stdDevMult))

topYVal = (height, yScale, demand, demandProfile) ->
  stdDevAdd = demandProfile.get('std_dev_add') or 0
  stdDevMult = demandProfile.get('std_dev_mult') or 0
  knob = demandProfile.get('knob') or 1
  boxMax = knob * Math.max(demand + stdDevAdd, demand + (demand * stdDevMult))

  return height - yScale(boxMax)

padValueArray = (arr) -> arr.push(_.last(arr))

class window.beats.DemandVisualizer extends Backbone.View
  vehicleTypeColors = [
    '#cc0000', '#cccc00', '#3300ff', '#33cc00', '#ccff00'
    '#333300', '#00ffff', '#66ccff', '#996600', '#9933ff'
  ]

  renderConstDemands: (sel) ->
    content = _.map @demand.demands_by_vehicle_type(), (demand, idx) =>      
      vehicleType = @typeOrder.get('vehicle_type')[idx].get('name')
      args =
        elemId: @link.id
        demandVehicleIndex: idx
        demandVehicleType: vehicleType
        demandVehicleCount: demand[0]
        deviates: false
        demandDeviation: 0

      if maxDev(demand, @demand) > 0
        args['deviates'] = true
        args['demandDeviation'] = maxDev(demand, @demand)

      @constDemand args

    constNotice = "<div class='const-notice'>Demands Constant Over Time</div>"
    table = "<table>#{content.join("\n")}</table>"
    windowContent = constNotice + table
    @$el.html @vizWindow(elemId: @link.id, content: windowContent)

  renderLegend: (graphEl) ->
    titleFontSize = 20
    titleWidth = titleFontSize * 5
    textY = titleFontSize + 10
    labelFontSize = titleFontSize * 7 / 10
    legendTitleWidth = 100
    legendLabelWidth = 75

    graphEl.append('svg:text').
      attr('x', 10).
      attr('y', textY).
      style('font-size', "#{titleFontSize}px").
      text('Legend')

    _.each @typeOrder.get('vehicle_type'), (vtype, idx) =>
      name = vtype.get('name')

      graphEl.append('svg:text').
        attr('x', legendTitleWidth + legendLabelWidth*idx).
        attr('y', textY).
        style('font-size', "#{labelFontSize}px").
        style('background-color', vehicleTypeColors[idx]).
        text(name)

      graphEl.append('svg:rect').
        attr('id', "legend-#{idx}").
        attr('x', titleWidth + legendLabelWidth*idx).
        attr('y', 10).
        attr('width', legendLabelWidth).
        attr('height', textY).
        attr('opacity', '0.4').
        attr('enabled', true).
        attr('fill', vehicleTypeColors[idx]).
        on 'click', ->
          el = $(@)
          if el.attr('enabled') == 'true'
            el.attr('opacity', '0.0')
            el.attr('enabled', false)
            d3.selectAll(".vehicle-graph-#{idx}").style('visibility','hidden')
          else
            el.attr('opacity', '0.4')
            el.attr('enabled', true)
            d3.selectAll(".vehicle-graph-#{idx}").style('visibility','visible')

  renderGraph: (sel) ->
    labelFontSize = 10
    textSizeImprecisionOffset = Math.ceil(.2 * labelFontSize)
    width = 450
    height = 400
    padding = 50
    minHighlight = 3
    @$el.dialog 'option', 'width', 510
    @$el.dialog 'option', 'height', 510

    @graph = d3.select(sel).append('svg:svg').
      attr('width', width + padding).
      attr('height', height + padding)

    @graph.append('svg:rect').
      attr('width', width + padding).
      attr('height', height + padding).
      attr('fill', 'white')

    @graph.append('svg:rect').
      attr('id', 'legend').
      attr('x', 5).
      attr('y', 5).
      attr('width', width + padding - labelFontSize).
      attr('height', padding - labelFontSize - textSizeImprecisionOffset).
      attr('fill', 'white').
      attr('stroke', 'lightGray')

    @renderLegend(@graph)

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

      yMaxGlobal = knob * Math.max(valMax + stdDevAdd, valMax + valMax * stdDevMult)

      xScale = d3.scale.linear().
        domain([0, timeSteps]).range([0, width])
      yScale = d3.scale.linear().
        domain([0, yMaxGlobal]).range([0, height])

      axisGroup = @graph.append('svg:g').
      	attr('transform', "translate(#{padding}, #{padding})")

      xAxisSampleInterval = 20
      yAxisSampleInterval = yMaxGlobal/20;

      axisGroup.selectAll('lines.xAxis').
      	data(vals[0]).
        enter().
      	append('svg:line').
      	attr('x1', (d,i) -> xScale(i)).
      	attr('x2', (d,i) -> xScale(i)).
      	attr('y1', 0).
      	attr('y2', height - labelFontSize - textSizeImprecisionOffset).
      	attr('stroke', (d,i) ->
    	    if i % xAxisSampleInterval == 0 then 'darkGray' else 'lightGray'
        )

      axisGroup.selectAll('lines.yAxis').
        data(d3.range(yAxisSampleInterval,yMaxGlobal + yAxisSampleInterval,yAxisSampleInterval)).
      	enter().
      	append('svg:line').
      	attr('x1', 0).
      	attr('x2', width).
      	attr('y1', (d) -> yScale(d)).
      	attr('y2', (d) -> yScale(d)).
      	attr 'stroke', (d,i) ->
          if(i % 3 == 0) then 'darkGray' else 'lightGray'

      xAxisText = axisGroup.selectAll('text.xAxis').
        data(every(xAxisSampleInterval,vals[0])).
        enter().
        append('svg:text').
        attr('x', (d,i) -> xScale(xAxisSampleInterval*i)).
      	attr('y', height-2).
      	attr('text-anchor','middle').
      	style('font-size', "#{labelFontSize}px").
      	text (d,i) ->
          s = startTime + xAxisSampleInterval * i * dt
          h = s/3600
          Math.round(h*10)/10 + 'h'

      axisGroup.selectAll('text.yAxis').
      	data(d3.range(yAxisSampleInterval, yMaxGlobal + yAxisSampleInterval, yAxisSampleInterval)).
      	enter().
      	append('svg:text').
      	attr('x', -padding + textSizeImprecisionOffset).
      	attr('y', (d) -> yScale(yMaxGlobal-d) + textSizeImprecisionOffset).
      	style('font-size', "#{labelFontSize}px").
      	text((d) -> Math.round(d*10)/10)

      wrapSteps = d3.svg.line().
        x((d, idx) -> xScale(idx) + padding).
      	y((d) -> height + padding - yScale(d) - 2).
      	interpolate('step-after')
      _.each vals, (vehicleTypeVals, i) =>
        vehicleType = @typeOrder.get('vehicle_type')[i].get('name')
        padValueArray(vehicleTypeVals)

        @graph.append('svg:path').
          attr('d', wrapSteps(vehicleTypeVals)).
        	attr('fill', 'none').
          attr('class', "vehicle-graph-#{i}").
        	attr('stroke', 'black')

        @graph.selectAll('stdDevBoxes').
          data(vehicleTypeVals).
          enter().
          append('svg:rect').
          attr('x', (d, idx) -> xScale(idx) + padding).
          attr('y', (d) => topYVal(height, yScale, d, @demand) +
            padding - textSizeImprecisionOffset).
          attr('width', xScale(1)).
          attr('fill', vehicleTypeColors[i]).
          attr('opacity', '0.4').
          attr('class', "vehicle-graph-#{i}").
          attr 'height', (d) =>
            maxHeight = yScale(Math.max(2*stdDevAdd, 2*stdDevMult*d))
            topY = topYVal(height, yScale, d, @demand) +
              padding - textSizeImprecisionOffset
            if maxHeight > height - topY + padding - labelFontSize
              height - topY + padding - labelFontSize
            else
              # Enforce coloring even if stddev. not present to distinguish
              # vehicle types
              Math.max(maxHeight,minHighlight)

  initialize: (@demand) ->
    @profileSet = window.beats.models.get('demandprofileset')
    @typeOrder = @profileSet.get('vehicletypeorder')
    @link = @demand.get('link')
    @vizWindow = _.template($('#demand-visualizer-window-template').html())
    if @demand.is_constant()
      @constDemand = _.template($('#constant-demand-template').html())
    else
      @dataDisplay = _.template($('#demand-graph-template').html())
      @$el.html @vizWindow(elemId: @link.id, content: @dataDisplay(elemId: @link.id))
    @$el.attr 'title', "Demand - Link #{@link.get('name')}"
  
  # render the dialog box. The calling function has responsability for
  # appending it as well as calling el.tabs and el.diaload('open')
  render: ->
    @$el.dialog
      autoOpen: false,
      modal: false,
      close: =>
        @link.set_show_demands(false)
        @$el.remove()
    if @demand.is_constant()
      @renderConstDemands()
    else
      @renderGraph("#demand-graph-#{@link.id}")
    @