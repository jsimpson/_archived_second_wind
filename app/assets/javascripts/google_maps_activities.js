function gmaps_show(geo_points) {
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        handler.addPolyline(geo_points);
        handler.bounds.extend(geo_points[0]);
        handler.bounds.extend(geo_points[geo_points.length -1]);
        markers = handler.addMarkers([
            {
                "lat": geo_points[0].lat,
                "lng": geo_points[0].lng,
                "infowindow": "<b>Start Point</b>",
            },
            {
                "lat": geo_points[geo_points.length - 1].lat,
                "lng": geo_points[geo_points.length - 1].lng,
                "infowindow": "<b>Start Point</b>",
            },
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });
}
