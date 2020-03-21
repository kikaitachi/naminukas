var fs = require('fs'),
    http = require('http');

http.createServer(function (req, res) {
  let fileName = __dirname + (req.url === '/' ? '/index.html' : req.url);
  if (!fs.existsSync(fileName) || fs.lstatSync(fileName).isDirectory()) {
    fileName += '.html';
  }
  fs.readFile(fileName, function (err, data) {
    if (err) {
      res.writeHead(404);
      res.end(JSON.stringify(err));
      return;
    }
    res.writeHead(200);
    res.end(data);
  });
}).listen(8080);
