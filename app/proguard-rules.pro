# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Preserve Flutter engine
-dontwarn io.flutter.embedding.**
-keep class io.flutter.embedding.** { *; }

# Preserve annotations
-keepattributes *Annotation*

# Preserve generic signatures
-keepattributes Signature

# Preserve exception information
-keepattributes Exceptions

# Preserve inner classes
-keepattributes InnerClasses

# Preserve enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Preserve Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Preserve Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Preserve native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Preserve classes used by reflection
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Preserve Google services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Preserve camera and image picker
-keep class * extends android.app.Activity
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider

# Preserve SQLite
-keep class androidx.sqlite.** { *; }
-keep class org.sqlite.** { *; }

# Preserve biometric authentication
-keep class androidx.biometric.** { *; }

# Preserve local notifications
-keep class com.dexterous.** { *; }

# Preserve shared preferences
-keep class androidx.preference.** { *; }

# Preserve connectivity
-keep class androidx.core.net.** { *; }

# Preserve HTTP client (Dio)
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Preserve Charts library
-keep class com.github.mikephil.charting.** { *; }

# Preserve image loading
-keep class com.bumptech.glide.** { *; }

# Remove logging in release builds
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}