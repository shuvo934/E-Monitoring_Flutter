class FinancialYears {
  final int _fyId;
  final String _financialYearName;
  final String _fyFromYear;
  final String _fyToYear;
  var _fyDetails;
  final int _activeFlag;

  FinancialYears(this._fyId, this._financialYearName, this._fyFromYear,
      this._fyToYear, this._fyDetails, this._activeFlag);

  int get fyId => _fyId;

  String get financialYearName => _financialYearName;

  int get activeFlag => _activeFlag;

  String get fyDetails => _fyDetails;

  String get fyToYear => _fyToYear;

  String get fyFromYear => _fyFromYear;
}
