page = require('webpage').create()
fs   = require('fs')
sys  = require('system')
{getTypes, getCategories} = require('./config')
args = sys.args

#mapCLArguments = ->
  #map = {}
  #for i in [1...args.length]
    #if args[i].charAt(0) is '-'
      #key = args[i].substr(1, i.length)
      #map[key] = args[i + 1]
  #map

#page.onConsoleMessage = (msg) -> console.log msg

try
  #params = mapCLArguments()
  params = JSON.parse(decodeURI(args[1]))
  chart_id = getCategories()[params.chart_no - 1].id
  url = "http://192.168.88.110:9297/#chart/" + chart_id
  params.type = getTypes(chart_id)
  page.open url, (status) ->
    if status is "success"
      #page.includeJs "http://ajax.googleapis.com/ajax/libs/jquery/0.7.2/jquery.min.js", ->
      #if page.injectJs "do.js"
      getFilename =  (params)->
        page.evaluate (params) ->
          filename = undefined
          svg       = undefined
          $         = window.jQuery
          #for name,value of params.data
          for name,value of JSON.parse(params.data)
            $("input[name='#{name}']").val("#{value}")

          $("form").submit()

          if params.type is '3pie'
            chart1 = $("#chart1").highcharts()
            chart2 = $("#chart2").highcharts()
            chart3 = $("#chart3").highcharts()
            svg = window.Highcharts.getSVG([chart1,chart2,chart3])
          else
            svg = $("#chart").highcharts().getSVG()

          $.ajax(
            url: params.url + "/fromHighcharts",
            async: false,
            method: 'POST',
            data:
              svg: svg,
              filename: params.filename
          ).done (data) ->
            filename = data
          filename
        ,params
      console.log getFilename(params)
      #sys.stdout.write getFilename(params)
    #fs.write "temp", svg
    #sys.stdout.write(svg)
    phantom.exit()
catch e
  console.log(e)
  #sys.stderr.writeLine(e)
  #sys.stderr.flush()
  #sys.stderr.close()
  phantom.exit()
