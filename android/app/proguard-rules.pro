# ─────────────────────────────────────────────────────────────────
# Flutter Engine, Embedding & Plugin Registration (R8 Full Mode)
# ─────────────────────────────────────────────────────────────────
-keep class io.flutter.app.FlutterApplication { *; }
-keep class io.flutter.embedding.android.FlutterActivity { *; }
-keep class io.flutter.embedding.android.FlutterFragmentActivity { *; }
-keep class io.flutter.embedding.engine.FlutterEngine { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }
-keep class com.getkeepsafe.relinker.** { *; }
-dontwarn io.flutter.**
-dontwarn com.getkeepsafe.relinker.**

# ─────────────────────────────────────────────────────────────────
# AndroidX Startup, WorkManager & Room (required by Google Mobile Ads)
# ─────────────────────────────────────────────────────────────────
-keep class androidx.startup.** { *; }
-keep class androidx.work.WorkManagerInitializer { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class **_Impl { *; }
-keep class * extends androidx.work.Worker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-keep class * extends androidx.work.ListenableWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
}
-dontwarn androidx.work.**
-dontwarn androidx.room.**

# ─────────────────────────────────────────────────────────────────
# Flutter Plugins (Platform Channel reflection & registration)
# ─────────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class dev.britannio.in_app_review.** { *; }
-keep class de.ffuf.in_app_update.** { *; }

# ─────────────────────────────────────────────────────────────────
# Google Mobile Ads (AdMob) SDK
# ─────────────────────────────────────────────────────────────────
-keep public class com.google.android.gms.ads.** { public *; }
-keep public class com.google.ads.** { public *; }
-dontwarn com.google.android.gms.ads.**
-dontwarn com.google.ads.**

# ─────────────────────────────────────────────────────────────────
# Google Play Core (In-App Review & In-App Update)
# ─────────────────────────────────────────────────────────────────
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# ─────────────────────────────────────────────────────────────────
# Suppress common harmless third-party warnings
# ─────────────────────────────────────────────────────────────────
-dontwarn sun.misc.Unsafe
-dontwarn javax.annotation.**
-dontwarn org.conscrypt.**
-dontwarn org.bouncycastle.**
-dontwarn org.openjsse.**

# ─────────────────────────────────────────────────────────────────
# Preserve annotations, generic signatures (Gson / Notifications) & line numbers
# ─────────────────────────────────────────────────────────────────
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod,SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
