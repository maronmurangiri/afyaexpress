class BloodPressureVitalsStorageException implements Exception {
  const BloodPressureVitalsStorageException();
}

class CouldNotCreateDiabetesVitalsException
    extends BloodPressureVitalsStorageException {}

class CouldNotGetDiabetesVitalsException
    extends BloodPressureVitalsStorageException {}

class CouldNotUpdateDiabetesVitalsException
    extends BloodPressureVitalsStorageException {}

class CouldNotDeleteDiabetesVitalsException
    extends BloodPressureVitalsStorageException {}
