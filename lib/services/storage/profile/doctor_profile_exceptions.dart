class CloudStorageException implements Exception {
  const CloudStorageException();
}

// C in CRUD
class CouldNotCreateProfileException extends CloudStorageException {}

// R in CRUD
class CouldNotGetProfileException extends CloudStorageException {}

// U in CRUD
class CouldNotUpdateProfileException extends CloudStorageException {}

// D in CRUD
class CouldNotDeleteProfileException extends CloudStorageException {}
