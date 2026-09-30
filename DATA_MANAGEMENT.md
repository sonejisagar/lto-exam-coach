# LTO Exam Coach – Data Management & Privacy Audit

**Application:** LTO Exam Coach – Philippines  
**Package:** `com.ltoexamcoach.philippines`  
**Date of Audit:** September 2026  
**Auditor:** Mobile Architecture & Security Audit  
**Scope:** SharedPreferences Storage, Data Sanitization, Reset Mechanisms, Android Backup, AdMob Isolation, and Data Safety

---

## 1. Storage Architecture Overview

**LTO Exam Coach – Philippines** is architectured as a strict **offline-first educational reviewer application**.

* **Zero Cloud Transmissions:** The application does not maintain, connect to, or transmit user study records, quiz answers, test scores, or personal identifiers to any remote server or cloud database.
* **Local Device Persistence:** All user interactions, saved bookmarks, practice statistics, study streak metrics, and mock test scores are persisted strictly on the device using Android's sandboxed `SharedPreferences` API via the `shared_preferences` package.
* **No Account Required:** Users do not register, log in, or provide phone numbers, email addresses, or government identification to use the app.

---

## 2. Storage Keys Audit

The following table documents all persistent keys stored in `StorageService` (`lib/services/storage_service.dart`):

| Key Constant | Storage Key String | Data Type | Purpose & Scope | Cleared on "Reset Study Data"? |
| :--- | :--- | :--- | :--- | :---: |
| `keyLanguageCode` | `app_language_code` | `String` | Selected study language (`'en'` or `'fil'`) | **No (Preserved)** |
| `keyOnboardingCompleted` | `onboarding_completed` | `bool` | Flag whether user finished first-launch onboarding | **No (Preserved)** |
| `keyVehicleType` | `vehicle_type` | `String` | Filter preference (`'car'`, `'motorcycle'`, or `'both'`) | **No (Preserved)** |
| `keyThemeMode` | `theme_mode` | `String` | Display theme preference (`'light'`, `'dark'`, `'system'`) | **No (Preserved)** |
| `keyDailyGoal` | `daily_goal` | `int` | Target practice questions per day (10, 20, 30) | **No (Preserved)** |
| `keyDailyReminder` | `daily_reminder` | `bool` | Notification schedule toggle state | **No (Preserved)** |
| `keyPracticeProgress` | `lto_practice_progress` | `String (JSON)` | Question attempts, category accuracy, streak counters | **Yes (Wiped)** |
| `keyFavorites` | `favorite_questions` | `List<String>` | Saved / bookmarked question IDs | **Yes (Wiped)** |
| `keyDifficult` | `difficult_questions` | `List<String>` | Flagged high-difficulty study questions | **Yes (Wiped)** |
| `keyWrongAnswers` | `wrong_answers` | `List<String>` | Missed question bank for targeted remediation | **Yes (Wiped)** |
| `keyMockTestHistory` | `mock_test_history` | `List<String>` | Historical mock exam scores, timestamps, and pass/fail logs | **Yes (Wiped)** |
| `keyFavoriteSigns` | `lto_favorite_signs` | `List<String>` | Bookmarked road sign IDs (isolated from question bookmarks) | **Yes (Wiped)** |

---

## 3. Data Reset Mechanisms

### A. Reset Study Data (`resetAllStudyData()`)
* **Location in UI:** Settings Screen > DATA MANAGEMENT > "Reset Study Data"
* **User Confirmation Dialog:**
  > **Reset Study Data?**  
  > *This will permanently reset all your offline study progress on this device, including practice question attempts, study streak, bookmarks, wrong answer bank, and mock exam history.*  
  > *Your app preferences (language, theme mode, and vehicle preference) will be preserved.*  
  > *Note: This only affects local offline study data. It does not reset third-party ad personalization or consent settings, which can be managed separately under Ad Privacy Settings.*
* **Technical Action:**
  - Invokes `_storageService.resetAllStudyData()`.
  - Removes `keyPracticeProgress`, `keyWrongAnswers`, `keyFavorites`, `keyDifficult`, `keyFavoriteSigns`, and `keyMockTestHistory`.
  - Refreshes `ProgressProvider` to instantiate an empty progress model.
  - **Protects** `keyLanguageCode`, `keyThemeMode`, `keyVehicleType`, `keyDailyGoal`, `keyDailyReminder`, and `keyOnboardingCompleted`. Users are **not** forced to re-do onboarding or reset their preferred UI theme and language.

### B. Complete Local Data Wipe (`clearAll()`)
* **Technical Action:** Completely clears all keys in `SharedPreferences`. Used strictly during internal testing or factory data resets.

---

## 4. Boundary with Third-Party AdMob / UMP Data

* **Consent State Isolation:** User consent choices under the European Economic Area (EEA), UK, and California privacy regulations are managed through Google's User Messaging Platform (UMP) SDK.
* **Separation of Concerns:** The application's "Reset Study Data" feature strictly targets offline pedagogical reviewer progress and **does not make false claims** about deleting or altering Google AdMob advertising identifiers or UMP consent strings.
* **Privacy Choices UI:** A dedicated "Ad Privacy & Consent" entry exists in the Settings screen to reopen the official Google UMP consent form (`AdService.instance.showPrivacyOptionsForm()`), giving the user direct, transparent control over ad personalization without conflating study data with advertising consent.

---

## 5. Android Backup & Data Protection Audit

* **`AndroidManifest.xml` Configuration:**
  ```xml
  <application
      android:label="LTO Exam Coach"
      android:name="${applicationName}"
      android:icon="@mipmap/ic_launcher"
      android:allowBackup="false">
  ```
* **Security Rationale:**
  - Setting `android:allowBackup="false"` ensures that application data cannot be extracted via unencrypted Android Debug Bridge (`adb backup`) connections or uploaded to unencrypted third-party local backups.
  - This guarantees user study habits and device-local preferences remain strictly within the sandboxed application storage directory on the physical device.

---

## 6. Google Play Data Safety Declaration Mapping

For the Google Play Console Data Safety questionnaire, this audit confirms:

1. **Data Collected by First-Party App:** **None**. (No names, emails, user IDs, photos, contacts, financial info, or health data).
2. **Data Shared with Third Parties by First-Party App:** **None**.
3. **Third-Party SDK Collection:**
   - **Google Mobile Ads SDK (AdMob):** May collect device identifiers, crash/diagnostic logs, and coarse location (if network-derived) for ad fraud prevention, ad serving, and performance measurement.
   - Handled under Google Play's standard AdMob third-party declaration.
4. **Security Practices:**
   - Data encryption in transit: Applicable to AdMob network requests (HTTPS/TLS).
   - Data deletion mechanism: Built-in "Reset Study Data" allows users to wipe 100% of locally saved study history instantly.
