class DiabetesVitalsStorageException implements Exception {
  const DiabetesVitalsStorageException();
}

class CouldNotCreateDiabetesVitalsException
    extends DiabetesVitalsStorageException {}

class CouldNotGetDiabetesVitalsException
    extends DiabetesVitalsStorageException {}

class CouldNotUpdateDiabetesVitalsException
    extends DiabetesVitalsStorageException {}

class CouldNotDeleteDiabetesVitalsException
    extends DiabetesVitalsStorageException {}
