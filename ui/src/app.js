/**
 * mission control webserver
 * @file src/app.js
 * @author Pavan Dayal
 */

const options = require("minimist")(process.argv.slice(2));
const express = require("express");
const request = require("request");
const https = require("https");
const http = require("http");
const path = require("path");
const fs = require("fs");

// default options
options.port = options.port || options.p || 8080;
options.host = options.host || "0.0.0.0";

// cmd line help
if (options.help || options.h) {
    console.log("\nUsage: node app.js [options]\n");
    console.log("Options:");
    console.log("  --help, -h                 Show this message.");
    console.log("  --host <host>              Specify host.");
    console.log("  --port, -p <number>        Specify port.");
    console.log("  --cert <cert>              Cert for https.");
    console.log("  --priv <privkey>           Priv key for https.");
    console.log("");
    process.exit(0);
}

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

function validURL(str) {
    var pattern = new RegExp(
        '^(https?:\\/\\/)?' +               // protocol
        '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)*[a-z]{2,}|' + // domain name
        '((\\d{1,3}\\.){3}\\d{1,3}))' +     // OR ip (v4) address
        '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*' + // port and path
        '(\\?[;&a-z\\d%_.~+=-]*)?' +        // query string
        '(\\#[-a-z\\d_]*)?$','i'            // fragment locator
    );
    return !!pattern.test(str);
}

// proxy thru webserver (https://0.0.0.0:8080/proxyUrl?url=https://google.com)
app.use("/proxy", function proxyRequest(req, res, next) {
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    console.log("%s: proxying (%s) to: %s", _date(), ip, req.query.url);
    if (validURL(req.query.url)) {
        req.pipe(
            request({
                url: req.query.url,
                strictSSL: false,
                rejectUnhauthorized: false
            }, function(err, resp, body) {
                    next(err);
            })
        ).pipe(res);
    } else {
        res.status(404).send("error: bad url");
    }
});

// serve openmct.js and css static stuff
app.use("/openmct", express.static(
    path.join(__dirname, "openmct/dist")
));

// serve plugins
app.use("/plugins", express.static(
    path.join(__dirname, "plugins")
));

// give index.html
app.get("/", function(req, res) {
    var ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
    console.log("%s: index.html (%s)", _date(), ip);
    fs.createReadStream("index.html").pipe(res);
});


// read https certs
if (options.cert && options.priv) {
    var cert = fs.readFileSync(options.cert);
    var priv = fs.readFileSync(options.priv);
    var srv = https.createServer({cert: cert, key: priv}, app);
    var mode = "https";
} else {
    var srv = http.createServer(app);
    var mode = "http";
}

// launch web server
srv.listen(
    options.port,
    options.host,
    function() {
        console.log("Open MCT running at %s://%s:%s",
            mode, options.host, options.port
        );
    }
);
