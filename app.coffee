express = require "express"
http    = require "http"
{spawn, exec}  = require 'child_process'

app = express()
app.set "port", 9909
app.use express.urlencoded()
app.use express.json()
app.use express.multipart()

app.use express.methodOverride()

app.post "/", (req, res)->
  #console.dir(req.body)
  res.writeHead "200", 'Content-Type': 'text/plain'
  #child = spawn 'phantomjs', ["test.coffee", "| echo"]
  #child.stdout.on 'data',(data) ->
    #console.log data.toString()
    #res.write data.toString()
    #res.end("ok")
  vo = req.body
  #vo =
    #type: 12,
    #filename: "test111",
    #url: "http://192.168.88.103:8196/export/"
  params = encodeURI(JSON.stringify(vo))
  command = "phantomjs convert_handler.coffee '" + params + "'"
  console.log command
  exec command, (err, stdout, stderr) ->
    res.write stdout.toString()
    res.end()

app.post "/v2", (req, res)->
  #console.dir(req.body)
  res.writeHead "200", 'Content-Type': 'text/plain'
  #child = spawn 'phantomjs', ["test.coffee", "| echo"]
  #child.stdout.on 'data',(data) ->
    #console.log data.toString()
    #res.write data.toString()
    #res.end("ok")
  vo = req.body
  #vo =
    #type: 12,
    #filename: "test111",
    #url: "http://192.168.88.103:8196/export/"
  params = encodeURI(JSON.stringify(vo))
  command = "phantomjs convert_handler_v2.coffee '" + params + "'"
  console.log "-------------"
  console.log command
  console.log vo
  exec command, (err, stdout, stderr) ->
    #ret = {}
    #if err || stderr.toString() != ""
      #ret.status = 'err'
      #ret.message= stderr.toString()
    #else
      #ret.status = 'ok'
      #ret.filename = stdout.toString()
    #res.write JSON.stringify(ret)
    res.write stdout.toString()
    res.end()

http.createServer(app).listen app.get("port"), ->
  console.log "express server listening on port " + app.get("port")
