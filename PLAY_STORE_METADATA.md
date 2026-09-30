# Google Play Store Metadata & Release Documentation

## 1. App Identity

- **App Name**: LTO Exam Coach – Philippines
- **Package Name / Application ID**: `com.ltoexamcoach.philippines`
- **Default Language**: English (United States / Philippines)
- **App Category**: Education / Reviewer & Test Preparation

---

## 2. Store Listing Copy

### Short Description (Max 80 Characters)
> Prepare for the LTO driver's license exam with offline practice & road signs.

*(Character count: 77 / 80)*

### Full Description (Up to 4000 Characters)
```text
Prepare with confidence for the Philippine Land Transportation Office (LTO) Non-Professional and Professional Driver’s License Written Examination.

LTO Exam Coach is a dedicated, offline-first study reviewer and practice companion designed to help aspiring Filipino drivers build comprehensive road knowledge, master traffic regulations, and recognize official road signs.

KEY FEATURES:

• 150 PRACTICE QUESTIONS
Comprehensive questions covering General Driving Knowledge, Traffic Rules & Regulations, Road Signs & Pavement Markings, Driving Safety & Defensive Driving, and Vehicle Emergencies & Maintenance. Filter practice by your vehicle type: Car (Light Vehicle), Motorcycle, or Both.

• TIMED MOCK EXAM MODE
Simulate real examination conditions with customizable 20, 30, or 40-question mock tests, an active 20-minute countdown timer, unanswered question warnings, and an educational 80% practice benchmark to evaluate your test readiness.

• VISUAL ROAD SIGNS CATALOG (45 SIGNS)
Explore 45 Philippine road signs rendered in high-resolution vector artwork based on official DPWH Highway Safety Standards:
- Regulatory Signs (Priority, Prohibitive, Restrictive, Mandatory)
- Warning Signs (Road Geometry, Hazards, Crossings)
- Informative & Guide Signs
- Road Work & Temporary Traffic Signs
Search, filter, and test your recognition with the interactive 10-question Road Sign Quiz.

• TARGETED MISTAKE BANK & BOOKMARKS
- Wrong Answers Bank: Automatically saves questions answered incorrectly in practice for focused remediation.
- Difficult Questions: Manually tag tricky concepts to revisit anytime.
- Favorites: Bookmark critical questions and road signs for quick review.

• PROGRESS & STUDY ANALYTICS
Track your learning trajectory with lifetime practice metrics, per-category accuracy breakdowns, recent 7-day study activity, and daily study streaks.

• OFFLINE STUDY EXPERIENCE
Study practice questions, mock exams, road signs, and progress without an internet connection or account registration. All your study data remains safely on your device.

---

IMPORTANT EDUCATIONAL DISCLAIMER:
LTO Exam Coach – Philippines is an independent educational reviewer and study aid created to assist test takers. This application is NOT affiliated with, associated with, endorsed by, or authorized in any way by the Land Transportation Office (LTO), the Department of Transportation (DOTr), or any government agency in the Philippines.

All questions and educational materials are designed for preparation and study purposes. Completing practice tests or achieving the educational benchmark in this app does not guarantee passing the official LTO examination.
```

---

## 3. Play Console Data Safety Declarations

Complete the Google Play Console Data Safety questionnaire using these exact technical facts:

### A. Data Stored Locally by the App
- **User Progress & Settings**: Practice counts, correct answers, streak dates, theme mode, and vehicle preferences are stored **strictly on the user's device** using local storage (`SharedPreferences`).
- **Personal Data**: The app collects **zero** personal information (no name, email, phone, location, contacts, or camera access).
- **Accounts**: No user accounts or social logins are used.

### B. Third-Party Advertising (Google Mobile Ads & UMP)
- **Data Shared with Google**: The Google Mobile Ads SDK may collect and process device identifiers, advertising IDs (such as Google Advertising ID), diagnostics, and ad interaction metrics to deliver non-intrusive advertisements and measure performance.
- **Data Encryption in Transit**: All ad communications sent by the Google Mobile Ads SDK use HTTPS / secure encryption in transit.
- **User Consent (UMP)**: In applicable jurisdictions, the Google User Messaging Platform (UMP) requests and manages user advertising preferences and consent.

### Summary Checklist for Data Safety Form
| Question | Response | Notes |
| :--- | :--- | :--- |
| Does your app collect or share any user data? | **Yes** | Required due to Google AdMob SDK integration |
| Is all of the user data collected encrypted in transit? | **Yes** | Google AdMob uses encrypted HTTPS requests |
| Do you provide a way for users to request data deletion? | **Yes** | Users can reset progress in Settings; app stores no cloud data |
| Device or other IDs | **Collected & Shared** | Google AdMob advertising identifier (Ad ID) |
| Purpose of Device ID collection | **Advertising & Analytics** | Ad serving, fraud prevention, and frequency capping |

---

## 4. Ads & Content Declarations

- **Contains Ads**: **YES** (Google AdMob integrated on passive screens only; active quiz questions remain 100% ad-free).
- **App Category**: Education
- **Content Rating**: Complete the IARC questionnaire in Play Console.
  - Violence: None
  - Sexuality: None
  - Profanity: None
  - Controlled Substances: Brief references in traffic laws (e.g., RA 10586 Anti-Drunk and Drugged Driving Act regulations).
  - Expected outcome: Typically rated **PEGI 3 / Everyone** across all regions.
- **Target Audience**: 16 years and older (prospective student and driver license applicants).

---

## 5. Store Graphics & Assets Checklist

Before submitting the app on Google Play Console, ensure the following assets are ready:
1. **App Icon**: 512 x 512 px PNG (32-bit color, max 1MB).
2. **Feature Graphic**: 1024 x 500 px JPEG or 24-bit PNG (no alpha).
3. **Phone Screenshots**: At least 4 high-quality screenshots (16:9 or 18:9 aspect ratio, min 1080px):
   - Screen 1: Home Dashboard & Study Streak
   - Screen 2: Practice Mode with Instant Feedback & Explanations
   - Screen 3: Timed Mock Exam Mode with Category Breakdown
   - Screen 4: Road Signs Visual Catalog & Recognition Quiz
   - Screen 5: Progress Analytics & Mistake Bank
4. **Privacy Policy Web URL**: Must be hosted on a public HTTPS web page before publishing.

---

## 6. Production Privacy Policy Hosting & Play Console Submission

### A. Webpage Source Artifacts
The production-ready Privacy Policy is generated in the following locations in this project:
- **`docs/privacy_policy.html`**: Standalone, mobile-responsive HTML5 webpage.
- **`docs/index.html`**: Root-hosted version suitable for GitHub Pages or static web hosts.
- **`PRIVACY_POLICY.md`**: Markdown format for repository readers.

### B. Free HTTPS Hosting Options (Instant Deployment)
Choose one of the following methods to host the policy on HTTPS with zero cost:

1. **GitHub Pages (Recommended if using a GitHub repo):**
   - Push this repository to GitHub.
   - Go to **Repository Settings → Pages**.
   - Under **Build and deployment > Branch**, select your default branch (e.g., `main`) and the `/docs` folder.
   - Click **Save**.
   - Your public HTTPS URL will be: `https://<github-username>.github.io/<repo-name>/` (or `/privacy_policy.html`).

2. **Cloudflare Pages / Netlify / Vercel:**
   - Connect the repository or drag-and-drop the `docs/` folder.
   - Provides an immediate, globally distributed `https://*.pages.dev` or `https://*.netlify.app` URL with valid SSL.

3. **Custom Domain:**
   - Upload `docs/privacy_policy.html` to your server under `https://yourdomain.com/privacy-policy`.

### C. Where to Configure the URL in the App
Once you have the public HTTPS URL, update the central configuration value in Dart:
- **File:** `lib/config/ad_config.dart`
- **Variable:**
  ```dart
  static const String? privacyPolicyUrl = 'https://<your-verified-domain>/privacy_policy.html';
  ```
- When configured, tapping **Privacy Policy** in Settings or About screen opens this live URL in the user's browser.

### D. Google Play Console Form Field
In Google Play Console:
1. Navigate to: **Policy and programs → App content → Privacy policy**.
2. Paste the exact same HTTPS URL as configured in `AdConfig.privacyPolicyUrl`.
3. Click **Save**.

### E. Manual Release Requirements Prior to Store Submission
- [x] **Developer Support Contact Email**: Configured as `sagarssv112@gmail.com` in `docs/privacy_policy.html`, `docs/index.html`, and `PRIVACY_POLICY.md`.
- [ ] **Deploy Privacy Policy Webpage**: Host `docs/` on a public HTTPS server (e.g. GitHub Pages or Cloudflare Pages).
- [ ] **Set `privacyPolicyUrl` in `AdConfig`**: Set `AdConfig.privacyPolicyUrl` in `lib/config/ad_config.dart` to the live HTTPS URL.
- [ ] **Enter URL into Play Console**: Enter the identical URL into the Google Play Console Privacy Policy field.

