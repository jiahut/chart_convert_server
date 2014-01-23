### chart convert 

#### deploy

1. add line to ~/.profile

    export PATH=/path/to/phantomjs:$PATH
2. source ~/.profile

3. exec 

    phantomjs chart_convert.js -host 0.0.0.0 -p 9909
