/**
 * setup telemetry with incoming data from database
 * @file src/plugins/sensordata.js
 * @author Pavan Dayal
 */

var data = {
    sensors: null,
    fetch_sensor_list: function() {
        var url = settings.database_url + "/sensors";
        console.log("checking for list of sensors at " + url);
        new Promise(function(call) {
            $.get(url, {}, call);
        }).then(function(resp) {
            data.sensors = resp["data"]["sensors"];
            data.sensors.forEach(function(s) {
                console.log("sensor found: " + s.name + " (" + s.key + ")");
            });
        });
    }
}

function SensorData() {
    return function install(openmct) {
        openmct.objects.addRoot({
            namespace: "liquidrocketry.sensor",
            key: "datasensors"
        })

        openmct.objects.addProvider("liquidrocketry.sensor", {
            get: function(identifier) {
                if (identifier.key == "datasensors") {
                    return Promise.resolve({
                        identifier: identifier,
                        location: "ROOT",
                        type: "folder",
                        name: "Sensor Data",
                        notes: settings.database_url,
                    });
                } else if (identifier.key.substr(0,7) === "sensor-") {
                    var sensor = data.sensors.filter(function(x) {
                        return identifier.key === x.key;
                    })[0];
                    return Promise.resolve({
                        identifier: identifier,
                        location: "liquidrocketry.sensor.datasensors",
                        type: "liquidrocketry.telemetry",
                        name: sensor.name
                        //telemetry: {
                        //    values: {}
                        //}
                    });
                }
            }
        });

        openmct.composition.addProvider({
            appliesTo: function(domainObj) {
                var id = domainObj.identifier;
                return id.namespace === "liquidrocketry.sensor"
                    && id.key == "datasensors"
                    && domainObj.type === "folder";
            },
            load: function(domainObj) {
                var aa = [
                    {
                        "name": "A",
                        "key": "prop.A",
                        "values":[
                            {"key": "value", "name": "A", "format": "float"},
                            {"key": "utc", "name": "t", "format": "utc"}
                        ]
                    }
                ];
                var a = new Array();
                for (var sensor in data.sensors) {
                    a.push(sensor.identifier);
                }
                return Promise.resolve(aa);
            }
        });

        openmct.types.addType("liquidrocketry.telemetry", {
            name: "Liquid Rocketry Telemetry",
            description: "stored history of data",
            cssClass: "icon-telemetry"
        });

        //openmct.telemetry.addProvider({
        //    supportsSubscribe: function(domainOb) {
        //        return false;
        //    }
        //    subscribe: function(domainObj, callback) {
        //        return function() {

        //        }
        //    }
        //});

        var check_if_url = setInterval(function() {
            if (settings.got_database_url) {
                if (!data.sensors) {
                    data.fetch_sensor_list();
                } else {
                    clearInterval(check_if_url);
                    //TODO set interval to check for sensor updates every 5min
                }
            }
        }, 2000);

        console.log("installed sensordata plugin");
    };
}
