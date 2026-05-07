class Constants {
  Constants();

  // ── Notification backend (FastAPI local) ────────────────────────────────────
  // ⚠️  SWITCH THIS when changing between emulator and real device:
  //
  //   Android emulator  → 'http://10.0.2.2:8000'
  //   Real Android device on same WiFi → 'http://YOUR_PC_IP:8000'
  //     (find your PC IP by running `ipconfig` on Windows, look for IPv4)
  //     example: 'http://192.168.1.5:8000'
  static const String notificationBaseUrl = 'http://192.168.1.109:8000';

  // ── Existing AI/prediction APIs (unchanged) ─────────────────────────────────
  final String devBaseUrl              = 'https://web-production-0a787.up.railway.app';
  final String predictBaseUrl          = 'https://web-production-b4aa.up.railway.app';
  final String anemiaBaseUrl           = 'https://web-production-e378a.up.railway.app';
  final String anemiaSurveyBaseUrl     = 'https://web-production-554a4.up.railway.app';
  final String skincancerBaseUrl       = 'https://graduation-project-production-82a6.up.railway.app';
  final String skincancerSurveyBaseUrl = 'https://web-production-efbcf9.up.railway.app';
  final String textPredictBaseUrl      = 'https://web-production-ef341.up.railway.app';
}
