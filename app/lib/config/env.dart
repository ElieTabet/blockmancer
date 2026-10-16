enum Env {
  dev,
  prod;

  static Env fromValue(String value) => switch (value) {
    'dev' => Env.dev,
    'prod' => Env.prod,
    _ => throw ArgumentError.value(value, 'value', 'Unrecognized env'),
  };
}
