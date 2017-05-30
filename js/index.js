
////////////////////////////////////////////////////////////
//////////////////// FINDER FUNCTIONS //////////////////////
////////////////////////////////////////////////////////////
// Copy and pasted from an online demo sorry

function startsWith(haystack, needle) {
    return haystack.slice(0, needle.length) == needle;
}

$(function() {
var demo11 = $('#demo11').finderSelect({children:"tr.expanded"});
        var activeSegments = [""];
        function expandActive(els) {
            els.each(function() {
                var el = $(this);
                var segments = el.attr('data-path').split("/");
                segments.pop();
                var padding = (segments.length - 1) * 20;
                if($.inArray(segments.join("/"), activeSegments)  > -1) {
                    el.find('td').first().css('padding-left',padding);
                    el.removeClass('hidden')
                    el.addClass('expanded');
                } else {
                    el.addClass('hidden');
                    el.removeClass('expanded');
                }
            });

        }

        expandActive($('#demo11').find('tr'));

        $( "#demo11").find("tr.folder").click(function() {
            if($.inArray($(this).attr('data-path'), activeSegments)  > -1) {
                for(var i = activeSegments.length - 1; i >= 0; i--) {
                    if(startsWith(activeSegments[i], $(this).attr('data-path'))) {
                        activeSegments.splice(i, 1);
                    }
                }
                $(this).find('.icon-folder-open').removeClass('icon-folder-open').addClass('icon-folder-close');
                $(this).find('.icon-angle-down').removeClass('icon-angle-down').addClass('icon-angle-right');
            } else {
                activeSegments.push($(this).attr('data-path'));
                $(this).find('.icon-folder-close').removeClass('icon-folder-close').addClass('icon-folder-open');
                $(this).find('.icon-angle-right').removeClass('icon-angle-right').addClass('icon-angle-down');
            }

            expandActive($('#demo11').find('tr'));
        });
});


////////////////////////////////////////////////////////////
/////////////////// TIMELINE FUNCTIONS /////////////////////
////////////////////////////////////////////////////////////

// Load Google timeline API stuff
google.charts.load("current", {packages:["timeline"]});
google.charts.setOnLoadCallback(drawChart);

// Draw the timeline
function drawChart() {
	
    // Define the timeline params
    var container = document.getElementById('timeline');
    var chart = new google.visualization.Timeline(container);
    var dataTable = new google.visualization.DataTable();
    dataTable.addColumn({ type: 'string', id: 'Position' });
    dataTable.addColumn({ type: 'string', id: 'Name' });
    dataTable.addColumn({ type: 'date', id: 'Start' });
    dataTable.addColumn({ type: 'date', id: 'End' });
	dataTable.insertColumn(2, {type: 'string', role: 'tooltip', p: {html: true}});

    // For each line in the planner, break it down to the relevant parts
    // and add it in the correct format to the datatable for the timeline
    function plannerLineToDict(plannerLine) {
        
		var start = parseFloat(plannerLine.split(":")[0]);
        var duration = parseFloat(plannerLine.split("[")[1].split("]")[0]);
        var end = start + duration;
	
		// Using regular expression
		var patt = /\(([\w\s\_]+)\)/
		var action_string = patt.exec(plannerLine)[1];
		var items = action_string.split(" ");
		var action = items[0].toLowerCase();
		var agent = items[1].toLowerCase();
		var objects = items.slice(2).join(", ");
		var action_object = action + " (" + objects + ")";
		actions.push(action);
		
		
        dataTable.addRows([ 
        ]);
    }
    
    // Get the planner output to display, break it down, and send it to
    // be added to the datatable
    var plannerOutput = $("#plannerOutput").val().split("\n");
	var actions = [];
    for (var i=0;i<plannerOutput.length-1;i++){
        plannerLineToDict(plannerOutput[i]);
    }
	
	//Controlling colors manually
	// var a = actions;
	// a.forEach(function(item, i) { if (item == "moveto") a[i] = '#cbb69d'; });
	// a.forEach(function(item, i) { if (item == "pickup") a[i] = '#ffffff'; });
	// a.forEach(function(item, i) { if (item == "putdown") a[i] = '#ffffff'; });
	// a.forEach(function(item, i) { if (item == "assemble") a[i] = '#ffffff'; });
	// a.forEach(function(item, i) { if (item == "rotate") a[i] = '#ffffff'; });
	// console.log(a)
	// var options = {colors: a, width:1000};

	
	// Customizing tooltip
	var dateFormat = new google.visualization.DateFormat({
    });

    for (var i = 0; i < dataTable.getNumberOfRows(); i++) {
      var tooltip = '<div class="ggl-tooltip"><span>' +
        dataTable.getValue(i, 2) + '</span></div><div class="ggl-tooltip"><span>' +
        'duration:' + '</span>: ' +
        dateFormat.formatValue(dataTable.getValue(i, 3)) + ' - ' +
        dateFormat.formatValue(dataTable.getValue(i, 4)) + '</div>';

      dataTable.setValue(i, 2, tooltip);
    }
	
  
    // Draw the timeline!
	var options = {tooltip: {isHtml: true}};
    chart.draw(dataTable, options);
}


function getAllIndexes(arr, val) {
    var indexes = [], i = -1;
    while ((i = arr.indexOf(val, i+1)) != -1){
        indexes.push(i);
    }
    return indexes;
}
