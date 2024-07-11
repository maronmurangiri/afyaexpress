class OtherConditionsStorageException implements Exception {
  const OtherConditionsStorageException();
}

class CouldNotCreateDiabetesVitalsException
    extends OtherConditionsStorageException {}

class CouldNotGetDiabetesVitalsException
    extends OtherConditionsStorageException {}

class CouldNotUpdateDiabetesVitalsException
    extends OtherConditionsStorageException {}

class CouldNotDeleteDiabetesVitalsException
    extends OtherConditionsStorageException {}
