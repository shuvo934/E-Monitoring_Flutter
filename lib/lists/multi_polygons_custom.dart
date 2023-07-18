import 'package:geojson/geojson.dart';

class MultiPolygonsCustom {
  String _id;
  GeoJsonMultiPolygon _geoJsonMultiPolygon;

  MultiPolygonsCustom(this._id, this._geoJsonMultiPolygon);

  GeoJsonMultiPolygon get geoJsonMultiPolygon => _geoJsonMultiPolygon;

  set geoJsonMultiPolygon(GeoJsonMultiPolygon value) {
    _geoJsonMultiPolygon = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
