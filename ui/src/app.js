/**
 * mission control webserver
 * @file src/app.js
 * @author Pavan Dayal
 */

const options = require("minimist")(process.argv.slice(2));
const express = require("express");
const request = require("request");
const https = require("https");
const fs = require("fs");

// default options
options.port = options.port || options.p || 8080;
options.host = options.host || "0.0.0.0";
options.directory = options.directory || options.D || ".";

// cmd line help
if (options.help || options.h) {
    console.log("\nUsage: node app.js [options]\n");
    console.log("Options:");
    console.log("  --help, -h                 Show this message.");
    console.log("  --host <host>              Specify host.");
    console.log("  --port, -p <number>        Specify port.");
    console.log("  --directory, -D <bundle>   Serve files from specified directory.");
    console.log("  --cert <cert>              Cert for https.");
    console.log("  --priv <privkey>           Priv key for https.");
    console.log("");
    process.exit(0);
}

// read https certs
var cert = fs.readFileSync(options.cert);
var priv = fs.readFileSync(options.priv);

// create express app
var app = express();
app.disable("x-powered-by");

// formatted date time str
function _date() {
    var d = new Date();
    var s = "";
    s += d.getUTCFullYear() + "/" + d.getUTCMonth() + "/" + d.getUTCDate() +" ";
    s += d.getUTCHours() + ":" + d.getUTCMinutes() + ":" + d.getUTCSeconds();
    return s;
}

// proxy thru webserver (https://0.0.0.0:8080/proxyUrl?url=https://google.com)
app.use("/proxy", function proxyRequest(req, res, next) {
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    console.log("%s: proxying (%s) to: %s", _date(), ip, req.query.url);
    req.pipe(
        request({
            url: req.query.url,
            strictSSL: true
        }, function(err, resp, body) {
                next(err);
        })
    ).pipe(res);
});

// serve openmct.js and css static stuff
app.use("/openmct", express.static("openmct/dist"));

// give index.html
app.get("/", function(req, res) {
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    console.log("%s: index.html (%s)", _date(), ip);
    fs.createReadStream("index.html").pipe(res);
});

// launch web server
https.createServer({cert: cert, key: priv}, app).listen(
    options.port,
    options.host,
    function() {
        console.log("Open MCT running at %s:%s", options.host, options.port);
    }
);
