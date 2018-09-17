(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "inverted": true,
                    "polar": false
                },
                "title": {
                    "text": "Aged and Disabled Carers Employment Outlook"
                },
                "subtitle": {
                    "text": ""
                },
                "series": [{
                    "name": "workers",
                    "_colorIndex": 0,
                    "marker": {}
                }],
                "yAxis": [{
                    "title": {
                        "text": "Number of Workers"
                    },
                    "tickInterval": 25000,
                    "opposite": true,
                    "reversed": false,
                    "plotLines": [{}]
                }],
                "colors": ["#fdd835", "#434348", "#90ed7d", "#f7a35c", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "pane": {
                    "background": []
                },
                "responsive": {
                    "rules": []
                },
                "xAxis": [{
                    "tickInterval": 1,
                    "tickLength": 5
                }],
                "plotOptions": {
                    "series": {
                        "animation": false
                    }
                },
                "data": {
                    "csv": "\"year\";\"workers\"\n2007;82500\n2008;86000\n2009;108700\n2010;114400\n2011;112800\n2012;117300\n2013;128400\n2014;131200\n2015;145300\n2016;157200\n2017;163700\n2018;168852\n2019;176587\n2020;184303\n2021;192092",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                }
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-0b4ee0d2-4cda-4a17-96f1-0a15bbbb04b8", options);
        }
    }
})();

(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "polar": false
                },
                "plotOptions": {
                    "series": {
                        "dataLabels": {
                            "enabled": true
                        },
                        "animation": false
                    }
                },
                "title": {
                    "text": "Weekly earnings"
                },
                "subtitle": {
                    "text": ""
                },
                "exporting": {},
                "series": [{
                    "name": "Weekly Earnings",
                    "turboThreshold": 0,
                    "_colorIndex": 0,
                    "_symbolIndex": 0
                }],
                "data": {
                    "csv": "\"Earnings\";\"Weekly Earnings\"\n\"Aged and Disabled Carers\";900\n\"All Jobs Average\";1230",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                },
                "xAxis": [{
                    "title": {},
                    "labels": {}
                }],
                "yAxis": [{
                    "title": {},
                    "labels": {}
                }],
                "colors": ["#37474F", "#525E8C", "#90ed7d", "#C14953", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "legend": {
                    "enabled": false
                }
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-e1e525c2-a665-4e08-80a8-d2d522bce5c6", options);
        }
    }
})();

(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "polar": false
                },
                "plotOptions": {
                    "series": {
                        "stacking": "normal",
                        "animation": false
                    }
                },
                "title": {
                    "text": "Number of Staff by Method of Employment"
                },
                "subtitle": {
                    "text": ""
                },
                "exporting": {},
                "series": [{
                    "name": "Agency",
                    "turboThreshold": 0,
                    "_colorIndex": 0,
                    "_symbolIndex": 0
                }, {
                    "name": "Brokered",
                    "turboThreshold": 0,
                    "_colorIndex": 1,
                    "_symbolIndex": 1
                }, {
                    "name": "Self Employed",
                    "turboThreshold": 0,
                    "_colorIndex": 2
                }],
                "colors": ["#37474F", "#525E8C", "#90ed7d", "#C14953", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "legend": {
                    "enabled": true
                },
                "data": {
                    "csv": "\"Care Type\";\"Agency\";\"Brokered\";\"Self Employed\"\n\"Home Care\";1182;7676;3246\n\"Residential Care\";14371;794;810",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                }
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-3a6ccf16-bb89-4568-8ca3-e2a11ad3d13a", options);
        }
    }
})();

(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "polar": false
                },
                "plotOptions": {
                    "series": {
                        "dataLabels": {
                            "enabled": true
                        },
                        "animation": false
                    }
                },
                "title": {
                    "text": "Weekly earnings"
                },
                "subtitle": {
                    "text": ""
                },
                "exporting": {},
                "series": [{
                    "name": "Weekly Earnings",
                    "turboThreshold": 0,
                    "_colorIndex": 0,
                    "_symbolIndex": 0
                }],
                "data": {
                    "csv": "\"Earnings\";\"Weekly Earnings\"\n\"Aged and Disabled Carers\";900\n\"All Jobs Average\";1230",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                },
                "xAxis": [{
                    "title": {},
                    "labels": {}
                }],
                "yAxis": [{
                    "title": {},
                    "labels": {}
                }],
                "colors": ["#37474F", "#525E8C", "#90ed7d", "#C14953", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "legend": {
                    "enabled": false
                }
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-e1e525c2-a665-4e08-80a8-d2d522bce5c6", options);
        }
    }
})();

(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "polar": false
                },
                "title": {
                    "text": "Employment by State and Territory"
                },
                "subtitle": {
                    "text": ""
                },
                "exporting": {},
                "series": [{
                    "name": "Aged Carers",
                    "turboThreshold": 0,
                    "_colorIndex": 0,
                    "_symbolIndex": 0
                }, {
                    "name": "Target Proportion",
                    "turboThreshold": 0,
                    "_colorIndex": 1,
                    "_symbolIndex": 1
                }],
                "plotOptions": {
                    "series": {
                        "animation": false
                    }
                },
                "yAxis": [{
                    "title": {
                        "text": "Employment Percentage"
                    }
                }],
                "colors": ["#37474F", "#525E8C", "#90ed7d", "#C14953", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "legend": {
                    "enabled": true
                },
                "data": {
                    "csv": "\"State\";\"Aged Carers\";\"Target Proportion\"\n\"NSW\";26.4;31.6\n\"VIC\";25.1;26.2\n\"QLD\";20.3;19.7\n\"SA\";12.1;6.7\n\"WA\";10.8;10.8\n\"TAS\";3.5;2\n\"NT\";0.8;1.1\n\"ACT\";0.9;1.8",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                }
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-720ec5dd-fa44-48b5-9c99-967c929e8b6e", options);
        }
    }
})();

(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "polar": false
                },
                "plotOptions": {
                    "series": {
                        "stacking": "normal",
                        "animation": false
                    }
                },
                "title": {
                    "text": "Weekly earnings"
                },
                "subtitle": {
                    "text": ""
                },
                "exporting": {},
                "series": [{
                    "name": "Weekly Earnings",
                    "turboThreshold": 0,
                    "_colorIndex": 0,
                    "_symbolIndex": 0
                }],
                "colors": ["#37474F", "#525E8C", "#90ed7d", "#C14953", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "legend": {
                    "enabled": false
                },
                "data": {
                    "csv": "\"Earnings\";\"Weekly Earnings\"\n\"Aged and Disabled Carers\";900\n\"All Jobs Average\";1230",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                }
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-819641f2-29aa-4426-8159-17297864e8ad", options);
        }
    }
})();

(function () {
    var files = ["https://code.highcharts.com/stock/highstock.js", "https://code.highcharts.com/highcharts-more.js", "https://code.highcharts.com/highcharts-3d.js", "https://code.highcharts.com/modules/data.js", "https://code.highcharts.com/modules/exporting.js", "https://code.highcharts.com/modules/funnel.js", "https://code.highcharts.com/modules/annotations.js", "https://code.highcharts.com/modules/solid-gauge.js"],
        loaded = 0;
    if (typeof window["HighchartsEditor"] === "undefined") {
        window.HighchartsEditor = {
            ondone: [cl],
            hasWrapped: false,
            hasLoaded: false
        };
        include(files[0]);
    } else {
        if (window.HighchartsEditor.hasLoaded) {
            cl();
        } else {
            window.HighchartsEditor.ondone.push(cl);
        }
    }

    function isScriptAlreadyIncluded(src) {
        var scripts = document.getElementsByTagName("script");
        for (var i = 0; i < scripts.length; i++) {
            if (scripts[i].hasAttribute("src")) {
                if ((scripts[i].getAttribute("src") || "").indexOf(src) >= 0 || (scripts[i].getAttribute("src") === "http://code.highcharts.com/highcharts.js" && src === "https://code.highcharts.com/stock/highstock.js")) {
                    return true;
                }
            }
        }
        return false;
    }

    function check() {
        if (loaded === files.length) {
            for (var i = 0; i < window.HighchartsEditor.ondone.length; i++) {
                try {
                    window.HighchartsEditor.ondone[i]();
                } catch (e) {
                    console.error(e);
                }
            }
            window.HighchartsEditor.hasLoaded = true;
        }
    }

    function include(script) {
        function next() {
            ++loaded;
            if (loaded < files.length) {
                include(files[loaded]);
            }
            check();
        }
        if (isScriptAlreadyIncluded(script)) {
            return next();
        }
        var sc = document.createElement("script");
        sc.src = script;
        sc.type = "text/javascript";
        sc.onload = function () {
            next();
        };
        document.head.appendChild(sc);
    }

    function each(a, fn) {
        if (typeof a.forEach !== "undefined") {
            a.forEach(fn);
        } else {
            for (var i = 0; i < a.length; i++) {
                if (fn) {
                    fn(a[i]);
                }
            }
        }
    }
    var inc = {},
        incl = [];
    each(document.querySelectorAll("script"), function (t) {
        inc[t.src.substr(0, t.src.indexOf("?"))] = 1;
    });

    function cl() {
        if (typeof window["Highcharts"] !== "undefined") {
            var options = {
                "chart": {
                    "type": "column",
                    "polar": false,
                    "inverted": false
                },
                "title": {
                    "text": "Aged and Disabled Carers Employment Outlook"
                },
                "subtitle": {
                    "text": ""
                },
                "series": [{
                    "name": "workers"
                }],
                "colors": ["#37474F", "#525E8C", "#90ed7d", "#C14953", "#8085e9", "#f15c80", "#e4d354", "#2b908f", "#f45b5b", "#91e8e1"],
                "pane": {
                    "background": []
                },
                "responsive": {
                    "rules": []
                },
                "data": {
                    "csv": "\"year\";\"workers\"\n2007;82500\n2008;86000\n2009;108700\n2010;114400\n2011;112800\n2012;117300\n2013;128400\n2014;131200\n2015;145300\n2016;157200\n2017;163700\n2018;168852\n2019;176587\n2020;184303\n2021;192092",
                    "googleSpreadsheetKey": false,
                    "googleSpreadsheetWorksheet": false
                },
                "xAxis": [{
                    "minorTickLength": 2,
                    "tickInterval": 1
                }],
                "yAxis": [{
                    "title": {
                        "text": "Number of Workers"
                    }
                }]
            };
            /*
            // Sample of extending options:
            Highcharts.merge(true, options, {
                chart: {
                    backgroundColor: "#bada55"
                },
                plotOptions: {
                    series: {
                        cursor: "pointer",
                        events: {
                            click: function(event) {
                                alert(this.name + " clicked\n" +
                                      "Alt: " + event.altKey + "\n" +
                                      "Control: " + event.ctrlKey + "\n" +
                                      "Shift: " + event.shiftKey + "\n");
                            }
                        }
                    }
                }
            });
            */
            new Highcharts.Chart("highcharts-0cc26b75-81f1-4b11-bceb-cb5f2021afe4", options);
        }
    }
})();
