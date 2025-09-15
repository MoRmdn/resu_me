import 'dart:html' as html;

class SplashScreenService {
  static const String _splashScreenId = 'splash-screen';
  static const String _flutterReadyClass = 'flutter-ready';

  /// Hides the splash screen with animation
  static void hideSplashScreen() {
    try {
      // Check if we're running on web
      if (html.window.navigator.userAgent.contains('Web')) {
        final splashElement = html.document.getElementById(_splashScreenId);
        final body = html.document.body;

        if (splashElement != null && body != null) {
          // Add fade-out class for animation
          splashElement.classes.add('fade-out');

          // Remove splash screen after animation completes
          Future.delayed(const Duration(milliseconds: 500), () {
            splashElement.style.display = 'none';
            body.classes.add(_flutterReadyClass);
          });
        }
      }
    } catch (e) {
      // Silently handle any errors (e.g., when not running on web)
      print('Splash screen service error: $e');
    }
  }

  /// Shows the splash screen (useful for testing)
  static void showSplashScreen() {
    try {
      if (html.window.navigator.userAgent.contains('Web')) {
        final splashElement = html.document.getElementById(_splashScreenId);
        final body = html.document.body;

        if (splashElement != null && body != null) {
          splashElement.style.display = 'flex';
          splashElement.classes.remove('fade-out');
          body.classes.remove(_flutterReadyClass);
        }
      }
    } catch (e) {
      print('Splash screen service error: $e');
    }
  }

  /// Checks if splash screen is currently visible
  static bool isSplashScreenVisible() {
    try {
      if (html.window.navigator.userAgent.contains('Web')) {
        final splashElement = html.document.getElementById(_splashScreenId);
        return splashElement?.style.display != 'none';
      }
    } catch (e) {
      print('Splash screen service error: $e');
    }
    return false;
  }

  /// Adds a custom loading message to the splash screen
  static void updateLoadingMessage(String message) {
    try {
      if (html.window.navigator.userAgent.contains('Web')) {
        final loadingTextElement = html.document.querySelector('.loading-text');
        if (loadingTextElement != null) {
          loadingTextElement.text = message;
        }
      }
    } catch (e) {
      print('Splash screen service error: $e');
    }
  }

  /// Triggers a custom event for JavaScript to listen to
  static void triggerFlutterReadyEvent() {
    try {
      if (html.window.navigator.userAgent.contains('Web')) {
        // Dispatch a custom event that JavaScript can listen to
        html.window.dispatchEvent(html.CustomEvent('flutter-ready'));
      }
    } catch (e) {
      print('Splash screen service error: $e');
    }
  }
}
