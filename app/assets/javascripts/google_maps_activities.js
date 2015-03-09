function gmaps_draw_route(polyline) {
    handler = Gmaps.build('Google');
    handler.buildMap({ provider: {}, internal: { id: 'map' }}, function() {
        handler.addPolyline(polyline);
        handler.bounds.extend(polyline[0]);
        handler.bounds.extend(polyline[polyline.length -1]);
        markers = handler.addMarkers([
            {
                "lat": polyline[0].lat,
                "lng": polyline[0].lng,
                "infowindow": "<b>Start Point</b>",
            },
            {
                "lat": polyline[polyline.length - 1].lat,
                "lng": polyline[polyline.length - 1].lng,
                "infowindow": "<b>End Point</b>",
            },
        ]);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });
}
