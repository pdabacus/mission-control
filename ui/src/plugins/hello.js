/**
 * notebook for greeting user and configuring settings
 * @file src/plugins/hello.js
 * @author Pavan Dayal
 */

var settings = {
    got_database_url: false,
    database_url: window.location.protocol + "//" + window.location.hostname,
    enable_database_url_listener: function() {
        setTimeout(function() {
            console.log("listening for settings.database_url");
            $("#entry6-database-url").on("keyup", function() {
                settings.database_url = $("#entry6-database-url").text();
                console.log("settings.database_url = " + settings.database_url);
                setTimeout(function(){
                    settings.got_database_url = true;
                }, 2000);
            });
        }, 1000);
    }
}

function welcome_config() {
    var url = window.location.protocol + "//" + window.location.host + "/"
    return {
        defaultSort: "oldest",
        pageTitle: "Page",
        sectionTitle: "Section",
        type: "General",
        sections: [
            {
                id: "welcome-section",
                isDefault: true,
                isSelected: true,
                name: "Welcome",
                pages: [
                    {
                        id: "welcome-page",
                        isDefault: true,
                        isSelected: true,
                        name: "OpenMCT",
                    }
                ]
            }

        ],
        entries: { "welcome-section": {
        "welcome-page": [
            {
                id: "entry1",
                createdOn: 1580608922001,
                text: "This mission control is accessible from here: \n" + url
            },
            {
                id: "entry2",
                createdOn: 1580608922002,
                text: "\n"
            },
            {
                id: "entry3",
                createdOn: 1580608922003,
                text: "CONFIGURATION\n================================\n"
                    + " * changing the values in the following cells will be"
                    + " used for configuring the mission control\n"
            },
            {
                id: "entry4",
                createdOn: 1580608922004,
                text: "\n"
            },
            {
                id: "entry5",
                createdOn: 1580608922005,
                text: "database url:\n"
                    + " * url to reach the database webapi\n"
                    + " * note: if database isn't reachable from client, then"
                    + " you can proxy through the mission control server:\n"
                    + "   " + url + "proxy/?url=https://localhost:42069"
            },
            {
                id: "entry6-database-url",
                createdOn: 1580608922005,
                text: settings.database_url
            },
            {
                id: "entry6",
                createdOn: 1580608922006,
                text: "\n"
            },
            {
                id: "entry7",
                createdOn: 1580608922007,
                text: "================================\n"
            }
        ]
        }}
    };
}

function Hello() {
    return function install(openmct) {
        openmct.objects.addRoot({
            namespace: "liquidrocketry.hello",
            key: "hello"
        });

        openmct.objects.addProvider("liquidrocketry.hello", {
            get: function(identifier) {
                if (identifier.key == "hello") {
                    return Promise.resolve({
                        identifier: identifier,
                        id: "hello",
                        location: "ROOT",
                        type: "notebook",
                        name: "2.Welcome",
                        classList: ["is-notebook-default"],
                        configuration: welcome_config()
                    }).then(value=>{
                        settings.enable_database_url_listener();
                        return value;
                    });
                }
            }
        });

        var db_url = window.location.protocol + "//" + window.location.host;
        if (window.location.port) {
            db_url = db_url.replace(window.location.port, "xxxx");
        } else {
            db_url = db_url + ":xxxx";
        }
        settings.database_url = db_url;


		//var domNode = document.createElement('div');
        //domNode.className = "c-indicator c-indicator--clickable";
		//domNode.innerText = "t=1";
		//setInterval(function () {
        //    var i = parseInt(domNode.innerText.substring(2));
        //    domNode.innerText = "t=" + (i+1).toString();
		//}, 1000);
		//openmct.indicators.add({
		//	element: domNode
		//});

        console.log("installed hello plugin");
    };
}
