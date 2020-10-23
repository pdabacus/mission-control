/**
 * basic clock nothing else
 * @file src/plugins/clock.js
 * @author Pavan Dayal
 */

function Clock() {
    return function install(openmct) {
        openmct.objects.addRoot({
            namespace: "liquidrocketry.clock",
            key: "utc_clock"
        });

        openmct.objects.addProvider("liquidrocketry.clock", {
            get: function(identifier) {
                if (identifier.key == "utc_clock") {
                    return Promise.resolve({
                        identifier: identifier,
                        id: "utc_clock",
                        location: "ROOT",
                        type: "clock",
                        name: "1.Clock",
                        notes: "utc clock",
                        timezone: "UTC",
                        clockFormat: ["YYYY/MM/DD hh:mm:ss", "clock24"]
                    });
                }
            }
        });

        console.log("installed clock plugin");
    };
}
