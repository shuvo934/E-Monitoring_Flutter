import 'package:geojson/geojson.dart';

class PolygonsCustom {
  String _id;
  GeoJsonPolygon _geoJsonPolygon;

  PolygonsCustom(this._id, this._geoJsonPolygon);

  GeoJsonPolygon get geoJsonPolygon => _geoJsonPolygon;

  set geoJsonPolygon(GeoJsonPolygon value) {
    _geoJsonPolygon = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
