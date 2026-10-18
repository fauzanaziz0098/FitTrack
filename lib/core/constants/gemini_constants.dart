class GeminiConstants {
  // Google Gemini API Key for IronBite Smart Nutrition Vision
  static const String apiKey = 'AQ.Ab8RN6IEo3Qm7K3QJr8MOeOqivJgY8A5bOSUeJtjP695yHAe7w';

  // Fast, free-tier vision models optimized for multimodal food recognition
  static const String visionModel = 'gemini-3.5-flash';
  static const List<String> fallbackModels = [
    'gemini-3.5-flash',
    'gemini-3.8-flash',
    'gemini-2.5-flash-lite',
  ];
}
