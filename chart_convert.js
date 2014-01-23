var page = require('webpage').create(),
	system = require('system'),
	server = require('webserver').create();

var mapCLArguments = function () {
	var map = {},
		i,
		key;

	if (system.args.length < 1) {
		console.log('run PhantomJS as server: chart-convert.js -host 0.0.0.0 -port 9909');
	}

	for (i = 0; i < system.args.length; i += 1) {
		if (system.args[i].charAt(0) === '-') {
			key = system.args[i].substr(1, i.length);
			if (key === 'infile' || key === 'callback' || key === 'dataoptions' || key === 'globaloptions' || key === 'customcode') {
				// get string from file
				try {
					map[key] = fs.read(system.args[i + 1]);
				} catch (e) {
					console.log('Error: cannot find file, ' + system.args[i + 1]);
					phantom.exit();
				}
			} else {
				map[key] = system.args[i + 1];
			}
		}
	}
	return map;
};

var chartConver  = function (host, port) {
	console.log("server starting at:" + host + ":" + port )
	server.listen(host + ':' + port, function (request, response) {
			var vo = request.post,
				params,
				msg;
			try {
				params = JSON.stringify(vo);
				console.log(params);
				var url = "http://192.168.88.110:9297/#chart/" + vo.type;
				page.open(url, function (status) {
					console.log(url + ' status:' + status);
					if (params.status) {
						// for server health validation
						response.statusCode = 200;
						response.write('OK');
						response.close();
					} else {
						response.statusCode = 200;
					  //Page is loaded!
					    var filename = page.evaluate(function ( params ) {
						  var json = JSON.parse(params);
						  var $ = window.jQuery;
						  var filename = undefined;
						  switch(json.count) {
							case '2':
							  $("input[name='h_ser']").val(json.h_ser);
							  $("input[name='v_ser']").val(json.v_ser);
							  break;
							case '3':
							  $("input[name='h_ser']").val(json.h_ser);
							  $("input[name='v_ser1']").val(json.v_ser1);
							  $("input[name='v_ser2']").val(json.v_ser2);
							case '3pie':
							  $("input[name='month']").val(json.month);
							  $("input[name='v_ser1']").val(json.v_ser1);
							  $("input[name='v_ser2']").val(json.v_ser2);
							  break;
							default:
								break;
						  }
						  $("form").submit();
						  var svg = undefined;
						  if(json.count === '3pie') {
						    chart1 = $("#chart1").highcharts();
							chart2 = $("#chart2").highcharts();
							chart3 = $("#chart2").highcharts();
							svg = window.Highcharts.getSVG([chart1,chart2,chart3]);
						  } else {
						    svg = $("#chart").highcharts().getSVG();
						  }
						  $.ajax({
							url: "http://192.168.88.170:8196/export/fromHighcharts",
							async: false,
							method: 'POST',
							data: { svg: svg,
									filename: json.filename}
						  }).done(function(data){
							filename = data;
						  })
						  return filename;
					    }, params );
						response.write(filename);
						response.close();
					}
				});
			} catch (e) {
				msg = "Failed rendering: \n" + e;
				response.statusCode = 500;
				response.setHeader('Content-Type', 'text/plain');
				response.setHeader('Content-Length', msg.length);
				response.write(msg);
				response.close();
			}
		}); // end server.listen
}

var map = mapCLArguments()
//for(k in map){
	//console.log(k, map[k])
//}
chartConver(map['host'],map["port"]);
//phantom.exit();
