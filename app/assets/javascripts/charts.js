var CHART_INDEX_LIFETIME_ACTIVITY = 0;
var chartsLoaded = [false];
var chartIds = ["chart-1"];
var apiEndpoints = ["/lifetime_monthly_mileage"];

$(document).ready(function() {
    Highcharts.setOptions({
        global: {
            useUTC: false
        },
        chart: {
            zoomType: "x"
        },
        credits: {
            enabled: false
        },
        title: {
            style: {
                "fontName": "Helvetica",
                "fontSize": "16px"
            }
        },
        xAxis: {
            type: "datetime",
            dateTimeLabelFormats: {
                hour: "%I %p",
                minute: "%I:%M %p"
            }
        },
        yAxis: {
            min: 0
        },
        colors: ["#777"],
        plotOptions: {
            series: {
                lineWidth: 1,
                marker: {
                    enabled: true,
                    symbol: "circle",
                    radius: 4
                }
            },
        },
        yAxis: {
            title: {
                style: {
                    "fontName": "Helvetica",
                    "fontSize": "16px"
                }
            }
        }
    });

    // redraw the graphs whenever the chart tabs are clicked
    $(document).on("click", "#charts-nav-tab", function() {
        drawChart(CHART_INDEX_LIFETIME_ACTIVITY, "Mileage", "Lifetime Monthly Mileage", "Mileage"); });
});

function drawChart(index, legendLabel, titleText, yAxisTitle) {
    var id = chartIds[index];

    if (!chartsLoaded[index]) {
        chartsLoaded[index] = true;

        var url = location.protocol + "//" + location.host + location.pathname + apiEndpoints[index];
        var opts = {
            library: {
                legend: {
                    enabled: true,
                    labelFormat: legendLabel
                },
                title: {
                    text: titleText
                },
                yAxis: {
                    title: {
                        text: yAxisTitle
                    }
                },
                tooltip: {
                    useHTML: true,
                    formatter: function() {
                        return Highcharts.dateFormat("%B %Y", this.x) + "<br />Mileage: <b>" + Highcharts.numberFormat(this.y, ".2f") + "</b>";
                    }
                }
            }
        }

        new Chartkick.LineChart(id, url, opts);
    } else {
        var height = $("#" + id).height();
        var width = $("#" + id).width();
        $("#" + id).highcharts().setSize(width, height, doAnimation = true);
    }
}
