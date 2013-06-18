#!/bin/bash
cat share/js/wappalyzer.js drivers/php/js/driver.js > app.js
echo "
var request = require('request'), fs = require('fs'), url = process.argv[2];
fs.readFile('share/apps.json', 'utf8', function (error, data) {
  if (error) {
    return console.log(error);
  }
  data = JSON.parse(data);
  w.apps = data['apps'];
  w.categories = data['categories'];
  request(url, function (error, response, body) {
    if (!error && response.statusCode == 200) {
      w.driver.data = {'host': response.request.host, 'url': url, 'html': body, 'headers': {}};
      for (line in response.headers){
        switch (line){
          case 'server':
            w.driver.data['headers']['Server'] = response.headers[line];
            break;
          default:
        }
      }
      console.log(w.driver.init());
    }
  });
});
" >> app.js

node app.js $1