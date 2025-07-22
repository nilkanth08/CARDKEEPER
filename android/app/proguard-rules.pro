# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Keep Flutter classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep SQLite classes
-keep class org.sqlite.** { *; }
-keep class org.sqlite.database.** { *; }

# Keep notification classes
-keep class com.dexterous.** { *; }

# Keep secure storage classes
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# Keep biometric classes
-keep class androidx.biometric.** { *; }

# Keep image picker classes
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep network classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }