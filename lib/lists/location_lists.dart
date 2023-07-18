class LocationLists {
  var _latitude;
  var _longitude;
  var _segment;

  LocationLists(this._latitude, this._longitude, this._segment);

  get segment => _segment;

  set segment(value) {
    _segment = value;
  }

  get longitude => _longitude;

  set longitude(value) {
    _longitude = value;
  }

  get latitude => _latitude;

  set latitude(value) {
    _latitude = value;
  }
}
