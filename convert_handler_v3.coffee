page = require('webpage').create()
fs   = require('fs')
sys  = require('system')
{getTypes, getCategories} = require('./config')
args = sys.args

#page.onConsoleMessage = (msg) -> console.log msg

loadScript = (src, cb) ->
  script = document.createElement('script')
  script.src =  src
  script.type ="text/javascript"
  document.head.appendChild(script)

inject_js = (src) ->
  page.evaluate( (src)->
    script = document.createElement('script')
    script.src =  src
    script.type ="text/javascript"
    document.head.appendChild(script)
  ,src)

try
  params = JSON.parse(decodeURI(args[1]))
  console.log(params)
  page.open params.url, (status) ->
    console.log(status)
    if status is "success"
      #inject_js "http://localhost:9909/jquery.min.js"
      #loadScript "http://localhost:9909/jquery.min.js"
      #page.injectJs("./static/jquery.min.js")
      page.includeJs "http://localhost:9909/jquery.min.js", ->
        result = page.evaluate ->
          result = undefined
          $ = window.jQuery
          #console.log($().jquery)
          ajs = []
          $(".box dd ul.detail").each ->
            $self = $(this)
            shop_name = $self.find(".shopname a").text()
            shop_id = $self.find(".shopname a").attr("href")
            address = $self.find(".address").text()
            tags = $self.find(".tags a").text()
            features = $self.find(".features a").text()
            info = $self.find(".info a").text()
            average = $self.siblings(".average").text()
            # console.log(shop_id, shop_name, address, tags, features, info, average)
            $.ajax
                url: "http://localhost:4567/save",
                async: false,
                method: 'POST',
                data: {"shop_id": shop_id, "shop_name": shop_name, "address": address, "tags": tags, "features": features, "info": info, "average": average}
            .done ->
              ajs.push("ok")
            .fail ->
              ajs.push("err")
            # $.when.apply($,ajs).done ->
            #   console.log("all done")
            # .fail ->
            #   console.log("some error")
          ajs
          #   .always ->
          #     phantom.exit()
          # ,phantom
        console.log result
        phantom.exit()
catch e
  console.log(e)
  #sys.stderr.writeLine(e)
  #sys.stderr.flush()
  #sys.stderr.close()
  phantom.exit()
