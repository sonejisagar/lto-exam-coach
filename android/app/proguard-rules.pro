# Flutter ProGuard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Mobile Ads (AdMob) SDK
-keep class com.google.android.gms.ads.** { *; }
-keep public class com.google.android.gms.ads.** {
    public *;
}
-keep class com.google.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }

# AndroidX WorkManager (used internally by Google Mobile Ads)
-keep class androidx.work.** { *; }
-keep class * extends androidx.work.Worker { *; }
-keep class * extends androidx.work.ListenableWorker { *; }
-keep class * extends androidx.work.RxWorker { *; }
-keep class * extends androidx.work.CoroutineWorker { *; }
-keep class androidx.work.impl.** { *; }
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }

# AndroidX Room
-keep class androidx.room.** { *; }
-keep class * extends androidx.room.RoomDatabase { *; }
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
}
-keep class **_Impl { *; }

# AndroidX Startup
-keep class androidx.startup.** { *; }
-keep class * extends androidx.startup.Initializer { *; }

# Don't warn about missing references in third-party libraries
-dontwarn androidx.work.**
-dontwarn androidx.room.**
-dontwarn com.google.android.gms.internal.ads.**
