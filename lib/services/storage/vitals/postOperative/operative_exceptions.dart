class PostOperativeVitalsStorageException implements Exception {
  const PostOperativeVitalsStorageException();
}

class CouldNotCreateDiabetesVitalsException
    extends PostOperativeVitalsStorageException {}

class CouldNotGetDiabetesVitalsException
    extends PostOperativeVitalsStorageException {}

class CouldNotUpdateDiabetesVitalsException
    extends PostOperativeVitalsStorageException {}

class CouldNotDeleteDiabetesVitalsException
    extends PostOperativeVitalsStorageException {}
