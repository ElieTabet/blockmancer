import 'package:shared_domain/shared_domain.dart';

/// The run as the brief tunes it, until Remote Config supplies the numbers.
const defaultConfig = RunConfig(
  offerCount: 3,
  partnerBias: 0.75,
  revivePieces: 3,
  reviveRows: 2,
  revivesPerRun: 1,
  rounds: [
    RoundSpec(isBoss: false, pieces: 14, stones: 0, target: 250),
    RoundSpec(isBoss: false, pieces: 16, stones: 0, target: 500),
    RoundSpec(isBoss: false, pieces: 18, stones: 0, target: 900),
    RoundSpec(isBoss: false, pieces: 20, stones: 0, target: 1400),
    RoundSpec(isBoss: true, pieces: 22, stones: 6, target: 2000),
  ],
  traySize: 3,
);
