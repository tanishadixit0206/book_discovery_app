class EnvConfig {
  static const String BASE_URL = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://gutendex.com/books/'
  );
}