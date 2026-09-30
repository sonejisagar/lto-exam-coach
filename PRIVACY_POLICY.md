# Privacy Policy — LTO Exam Coach Philippines

**Effective Date:** September 29, 2026  
**Application Name:** LTO Exam Coach Philippines  
**Package Name:** `com.ltoexamcoach.philippines`  

---

> ### LEGAL & AFFILIATION DISCLAIMER
> **LTO Exam Coach Philippines is an independent educational practice application and is NOT affiliated with, endorsed by, or authorized by the Land Transportation Office (LTO), the Department of Transportation (DOTr), or any Philippine government agency.** This application is designed solely as an offline study aid and practice reviewer. For official licensing rules, regulations, and official examination procedures, please refer directly to the Land Transportation Office portal ([lto.gov.ph](https://lto.gov.ph)).

---

## 1. Introduction
This Privacy Policy describes how **LTO Exam Coach Philippines** ("the Application," "we," "us," or "our") handles information when you use our mobile application on the Android platform.

We believe in privacy by design. LTO Exam Coach Philippines is built as an **offline-first educational preparation tool**. We do not require you to create an account, register your email address, or provide any personal identification to review questions and prepare for your examination.

---

## 2. Information Stored on Your Device (Local Storage)
The Application does not maintain user accounts, databases, or cloud servers. All study progress and preferences are saved exclusively on your local device storage using Android's private `SharedPreferences` sandbox.

The following information is stored strictly on your device:
- **Study Progress & Statistics:** Total questions reviewed, correct answer count, lifetime practice totals, study streak count, and the timestamp of your last study session.
- **Practice History & Mistake Bank:** Identifiers of questions answered incorrectly during practice (Wrong Answers Bank) to facilitate targeted review.
- **User Bookmarks:** Questions tagged as "Difficult" and questions or road signs marked as "Favorites."
- **Mock Exam Records:** Historical results from timed mock exams (test date, score, passing status, and per-category breakdown), capped at the latest 50 attempts.
- **Application Preferences:** Your preferred reviewer language (English or Filipino), theme mode (Light, Dark, or System), vehicle category preference (Car, Motorcycle, or Both), daily practice goal (10, 20, or 30 questions), and daily study reminder preference.
- **Onboarding State:** A boolean flag recording that you completed the initial welcome introduction.

**No Cloud Synchronization:** This information is stored exclusively on your physical hardware. We do not transmit, back up, or sync this data to any external developer server.

---

## 3. How We Use Local Information
Information stored locally on your device is used solely to provide and improve your learning experience within the Application:
- To display your personal study streak, completion metrics, and readiness benchmarks.
- To populate the Wrong Answers Bank and Difficult Questions review sections so you can master challenging topics.
- To remember your language, theme, and vehicle category preferences across app sessions.
- To trigger local reminders if you have enabled the optional daily study reminder.

We do not sell, rent, monetize, or use your local study data for commercial profiling or behavioral tracking.

---

## 4. Advertising and Google Mobile Ads
The Application is supported by non-intrusive advertisements served through the **Google Mobile Ads SDK (Google AdMob)**, provided by Google LLC.

To deliver advertisements, measure ad effectiveness, and prevent fraudulent activity, Google AdMob and its advertising technology partners may automatically process certain technical device information when an active internet connection is present:
- **Device Identifiers:** Advertising identifiers such as the Google Advertising ID (GAID) or Android ID.
- **Network Information:** Coarse IP address (used for approximate geographic location and network quality detection).
- **Interaction & Diagnostic Data:** Ad views, clicks, launch metrics, and performance diagnostics.

Google uses this information in accordance with its own privacy practices. To learn more about how Google processes information and how to manage your Google advertising settings, please visit:
- [Google Privacy Policy](https://policies.google.com/privacy)
- [How Google uses information from sites or apps that use our services](https://policies.google.com/technologies/partner-sites)
- [Google Advertising Technologies & Choices](https://policies.google.com/technologies/ads)

---

## 5. Consent and Privacy Choices (Google UMP)
The Application integrates **Google's User Messaging Platform (UMP) SDK** to manage user privacy choices and comply with applicable data protection frameworks, including the European Economic Area (EEA) General Data Protection Regulation (GDPR) and UK GDPR.
- **Consent Prompts:** Depending on your location and regulatory requirements, you may be presented with a consent form upon first launch to customize your advertising and data processing preferences.
- **Managing Your Choices:** You can review or adjust your advertising consent preferences at any time by opening the Application and navigating to: **Settings → Ad Privacy & Consent**.
- **Respecting Preferences:** The Application respects your selected consent preferences for subsequent ad requests made through the Google Mobile Ads SDK.

---

## 6. Notifications
The Application offers an optional **Daily Study Reminder** to assist you in building a consistent study habit.
- **Opt-in Feature:** The daily study reminder is disabled by default. You must explicitly activate it in **Settings → Daily Study Reminder**.
- **Android Notification Permission:** On devices running Android 13 (API level 33) or higher, the Application requests the standard `POST_NOTIFICATIONS` runtime permission before scheduling reminders.
- **Local Execution:** Reminders are generated entirely on your device using Android's local notification manager with battery-friendly inexact scheduling. No remote push notification service (such as FCM) is used.
- **No Marketing:** Notifications are exclusively study reminders. They are never used to deliver advertisements, promotional content, or third-party marketing.
- **Disabling:** You can turn off the reminder at any time within the Settings screen, which immediately cancels all scheduled alarms.

---

## 7. Data Deletion / Reset Study Data
The Application gives you full control over your locally stored information through the built-in **Reset Study Data** feature located in **Settings → Reset Study Data**.

| Data Category | Action on "Reset Study Data" | Details |
| :--- | :--- | :--- |
| **Practice Progress & Streak** | **Permanently Deleted** | Lifetime practice counts, streak days, and timestamps are purged. |
| **Wrong Answers Bank** | **Permanently Deleted** | All saved wrong answer references are cleared. |
| **Favorites & Difficult Questions** | **Permanently Deleted** | All bookmarked questions and road signs are cleared. |
| **Mock Exam History** | **Permanently Deleted** | All previous mock examination records are deleted. |
| **App Preferences** | *Preserved* | Language, theme, vehicle type, and reminder toggles are kept for convenience. |
| **Third-Party Ad / UMP Records** | *Not Managed by App* | The app cannot delete third-party data stored by Google. |

**Distinction Between Local Data and Third-Party Data:** Tapping "Reset Study Data" removes application study data from your local device storage. It does not erase third-party advertising identifiers or consent records maintained by Google. To reset your Google Advertising ID on Android, navigate to: **Device Settings → Google → All services → Ads → Reset advertising ID**.

---

## 8. Data Sharing and Third-Party Services
**We do not sell, rent, or trade your personal information.** Because the developer operates no backend servers or analytics platforms, the developer has no access to your study records.

The only third-party service integrated into this Application is:
- **Google LLC (Google Mobile Ads & Google UMP):** Provides advertisement serving and consent management functionality.

The Application contains **no** third-party analytics SDKs (such as Firebase Analytics, Mixpanel, or Amplitude), **no** third-party crash reporting SDKs (such as Sentry, Crashlytics, or Bugsnag), and **no** social media tracking pixels.

---

## 9. Data Security & Android Backup Configuration
We employ standard security practices to protect your data:
- **Sandbox Isolation:** All study records are stored in the Android private application directory, isolated from other applications by Android OS security sandboxing.
- **Backup Configuration:** The Application explicitly sets `android:allowBackup="false"` in its Android Manifest. This prevents study data from being extracted via unencrypted Android Debug Bridge (ADB) backups or automatically uploaded to cloud backup storage.
- **Uninstallation:** When you uninstall the Application from your Android device, the operating system removes the private application directory and all associated local preferences.
- **Limitations:** While we implement reasonable safeguards and leverage Android's native application sandbox, please be aware that no method of electronic storage or wireless transmission is 100% secure.

---

## 10. Children's Privacy
LTO Exam Coach Philippines is designed for individuals preparing for Land Transportation Office (LTO) driver licensing examinations. In the Philippines, the minimum legal age to apply for a Student Driver's Permit is 16 years of age.

The Application is not directed at children under the age of 13. We do not knowingly solicit or collect personal information from children under 13 years of age. If you believe that a child has provided information through third-party advertising SDKs integrated into our app, please contact us so that we can take appropriate steps.

---

## 11. Changes to This Privacy Policy
We may update this Privacy Policy from time to time to reflect modifications in our application features, operational practices, or applicable legal and regulatory requirements.

When updates are made, we will revise the "Effective Date" at the top of this document. Any changes become effective immediately upon posting. We encourage you to review this Privacy Policy periodically to stay informed about how we protect your privacy.

---

## 12. Contact Us
If you have any questions, comments, or concerns regarding this Privacy Policy or our data practices, please contact us at:
- **Application:** LTO Exam Coach Philippines
- **Package Name:** `com.ltoexamcoach.philippines`
- **Developer / Support Contact:** [sagarssv112@gmail.com](mailto:sagarssv112@gmail.com)
