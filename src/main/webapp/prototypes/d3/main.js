var data = {
    meta: {
	vehicleTypes: ["car"],
	dt: 300,
	startTime: 0,
	stdDevAdd: 75,
	stdDevMult: 1,
	knob: 1,
    },

    steps: [
	169.200000, 143.400000, 144.600000, 125.850000, 114.450000,
	90.150000, 98.625000, 119.850000, 108.450000, 92.925000,
	87.225000, 95.550000, 116.925000, 99.525000, 89.700000,
	84.450000, 68.925000, 77.850000, 86.925000, 81.225000,
	60.300000, 62.625000, 78.000000, 66.300000, 59.850000,
	57.225000, 36.300000, 47.400000, 60.300000, 48.000000,
	62.625000, 72.150000, 45.525000, 35.700000, 53.850000,
	51.225000, 42.000000, 33.225000, 29.850000, 41.850000,
	39.225000, 30.000000, 38.775000, 42.150000, 47.700000,
	77.550000,63.825000,65.100000,84.450000,45.525000,35.700000,
	42.150000,36.000000,38.925000,39.075000,62.325000,95.850000,
	96.150000,90.000000,81.225000,83.700000,113.550000,123.225000,
	102.300000,128.025000,138.750000,146.025000,177.225000,168.000000,
	179.700000,206.625000,216.150000,233.400000,278.475000,264.900000,
	216.300000,227.400000,257.850000,322.500000,392.775000,393.225000,
	407.400000,464.175000,533.100000,584.625000,538.575000,544.200000,
	597.525000,646.200000,687.825000,735.900000,848.325000,852.600000,
	866.025000,865.050000,775.200000,807.900000,812.100000,702.600000,
	657.525000,700.350000,677.325000,579.075000,611.100000,662.625000,
	733.575000,756.900000,687.825000,610.125000,578.625000,585.225000,
	540.900000,547.875000,599.850000,585.525000,593.250000,530.400000,
	475.875000,568.800000,591.675000,552.300000,499.050000,409.200000,
	462.375000,555.375000,592.650000,665.550000,663.525000,662.475000,
	648.900000,635.400000,624.900000,561.675000,621.750000,673.050000,
	659.250000,587.625000,482.925000,632.250000,762.600000,781.875000,
	787.050000,741.075000,726.300000,757.875000,853.725000,832.875000,
	706.275000,744.675000,831.225000,699.150000,640.200000,734.475000,
	779.400000,739.650000,765.600000,881.550000,812.250000,822.375000,
	830.550000,784.500000,863.550000,835.200000,786.000000,856.200000,
	848.100000,811.725000,869.850000,925.725000,901.950000,848.325000,
	864.300000,813.975000,797.400000,862.950000,979.125000,953.625000,
	857.700000,913.875000,886.875000,827.550000,843.075000,837.075000,
	828.150000,807.375000,765.675000,778.950000,842.475000,852.300000,
	822.450000,736.725000,695.250000,796.200000,808.575000,738.150000,
	761.250000,756.900000,714.150000,728.475000,750.000000,709.050000,
	701.100000,673.650000,644.025000,751.275000,862.950000,838.725000,
	750.450000,740.775000,720.750000,754.350000,816.150000,789.525000,
	738.750000,708.000000,710.925000,816.375000,888.900000,837.375000,
	789.825000,753.075000,858.225000,872.550000,817.725000,899.250000,
	877.350000,810.300000,838.950000,902.475000,929.850000,909.675000,
	902.475000,853.800000,791.700000,812.775000,816.150000,742.725000,
	730.500000,824.175000,790.725000,737.550000,829.125000,853.350000,
	692.700000,690.225000,745.500000,672.300000,706.800000,747.225000,
	749.700000,703.500000,671.250000,751.725000,730.875000,592.575000,
	592.350000,575.175000,503.550000,533.700000,528.450000,477.825000,
	455.700000,485.550000,530.325000,528.750000,521.400000,507.975000,
	494.325000,448.875000,357.375000,400.500000,432.750000,355.200000,
	335.250000,386.475000,405.075000,375.675000,309.975000,278.775000,
	267.525000,246.000000,292.800000,303.975000,237.675000,186.600000,
	179.550000,148.275000,46.275000
    ],
};

data.steps1 = data.steps.slice();
data.steps1.reverse();

function every(count, arr) {
    return _.filter(arr, function(e,i) { return (i % count == 0);});
}

function boxYVal(yScale, height, d, stdDev) {
    return height - yScale(d+stdDev);
}

function addLines(data, graphObj, xScale, yScale, padding, height, name, boxColor) {
    var wrapSteps = d3.svg.line().
	x(function(d, idx) { return xScale(idx) + padding; }).
	y(function(d) { return height + padding - yScale(d); }).
	interpolate('step-after');

    graphObj.append("svg:path").
	attr("d", wrapSteps(data[name])).
	attr("fill", 'none').
	attr("stroke", 'currentColor');

    graphObj.selectAll("stdDevBoxes").
	data(data[name]).
	enter().
	append("svg:rect").
	attr("x", function (d, idx) { return xScale(idx) + padding; }).
	attr("y", function (d) { return boxYVal(yScale, height, d, data.meta.stdDevAdd) + padding; }).
	attr("width", xScale(1)).
	attr("height", function (d) {
	    var maxHeight = yScale(2*data.meta.stdDevAdd);
	    var topY = boxYVal(yScale, height, d, data.meta.stdDevAdd) + padding;
	    if(maxHeight > height - topY + padding - 10) {
	    	return (height - topY) + padding - 10;
	    } else {
		return maxHeight;
	    }
	}).
	attr("fill", boxColor).
	attr("opacity", "0.4");
}

function makeGraph(data, graphId) {
    var width = 750, height = 450;

    var padding = 40;
    var xScale = d3.scale.linear().
	domain([data.meta.startTime, data.steps.length]).
	range([0,width]);

    var domainMax = Math.max.apply(null, data.steps);
    var yMax = domainMax + data.meta.stdDevAdd;
    var yScale = d3.scale.linear().
	domain([0, yMax]).range([0,height]);

    var graph = d3.select(graphId).
	append("svg:svg").
	attr("width", width + padding).
	attr("height", height + padding);

    var axisGroup = graph.append("svg:g").
	attr("transform", "translate(" + padding + "," +padding + ")");
    
    var xAxisSampleInterval = Math.ceil(3000 * Math.log(data.steps.length/Math.E) / width);
    var yAxisSampleInterval = yMax*height/10000;

    axisGroup.selectAll("lines.xAxis").
	data(data.steps).
	enter().
	append("svg:line").
	attr("x1", function(d,i) { return xScale(i) ; }).
	attr("x2", function(d,i) { return xScale(i) ; }).
	attr("y1", -padding).
	attr("y2", height-10).
	attr("stroke", function(d,i) {
	    if(i % xAxisSampleInterval == 0) {
		return "darkGray";
	    } else {
		return "lightGray";
	    }
	});

    axisGroup.selectAll("lines.yAxis").
	data(d3.range(yAxisSampleInterval, 
		      yMax + yAxisSampleInterval, 
		      yAxisSampleInterval)).
	enter().
	append("svg:line").
	attr("x1", 0).
	attr("x2", width).
	attr("y1", function(d) { return yScale(d) - padding; }).
	attr("y2", function(d) { return yScale(d) - padding; }).
	attr("stroke", function(d,i) {
	    if(i % 3 == 0) {
		return "darkGray";
	    } else {
		return "lightGray";
	    }
	});

    var xAxisText = axisGroup.selectAll("text.xAxis").
	data(every(xAxisSampleInterval,data.steps)).
	enter().
	append("svg:text").
	attr("x", function(d,i) { return xScale(xAxisSampleInterval*i); }).
	attr("y", height).
	attr("text-anchor","middle").
	style("font-size", "10px").
	text(function(d,i) {
	    var s = data.meta.startTime + xAxisSampleInterval * i * data.meta.dt;
	    var h = s/3600;
	    return Math.round(h*10)/10 + "h";
	});

    var yAxisText = axisGroup.selectAll("text.yAxis").
	data(d3.range(yAxisSampleInterval, yMax + yAxisSampleInterval, yAxisSampleInterval)).
	enter().
	append("svg:text").
	attr("x", -padding).
	attr("y", function(d) { return yScale(yMax-d); }).
	style("font-size", "10px").
	text(function(d) { return Math.round(d*10)/10; });

    addLines(data,graph,xScale,yScale,padding,height,'steps', "yellow");
    addLines(data,graph,xScale,yScale,padding,height,'steps1', "cyan");
}