class Photos {
  final _photoName;
  final _uploadDate;
  final _stage;

  Photos(this._photoName, this._uploadDate, this._stage);

  get stage => _stage;

  get uploadDate => _uploadDate;

  get photoName => _photoName;
}
