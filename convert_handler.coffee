page = require('webpage').create()
fs   = require('fs')
sys  = require('system')
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
  url = "http://192.168.88.110:9297/#chart/" + params.type
  page.open url, (status) ->
    if status is "success"
      #page.includeJs "http://ajax.googleapis.com/ajax/libs/jquery/0.7.2/jquery.min.js", ->
      #if page.injectJs "do.js"
      getFilename =  (params)->
        page.evaluate (params) ->
          filename = undefined
          svg       = undefined
          $         = window.jQuery
          switch params.count
            when "3pie"
              $("input[name='month']").val(params.month)
              $("input[name='v_ser1']").val(params.v_ser1)
              $("input[name='v_ser2']").val(params.v_ser2)
            when "3"
              $("input[name='h_ser']").val(params.h_ser)
              $("input[name='v_ser1']").val(params.v_ser1)
              $("input[name='v_ser2']").val(params.v_ser2)
            when "2"
              $("input[name='h_ser']").val(params.h_ser)
              $("input[name='v_ser']").val(params.v_ser)
            else
              throw new Error("params.count is wrong")

          $("form").submit()

          if params.count is '3pie'
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
  phantom.exit()
