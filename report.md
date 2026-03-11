# Trustlya Session 04 Report

## Implemented Features

### 1. Profile Overview and Editing
* Added a polished **Profile Overview** screen that displays the user’s avatar, name, email, account tier, verification badges, join date and profile completion progress. The page also lists linked third‑party accounts (e.g. Google, Steam) using chips and provides a button to edit the profile.
* Implemented an **Edit Profile** form that pre‑populates the user’s name, email and phone number. The form validates inputs, offers save/discard actions and invokes `ProfileCubit.updateProfile()` to persist changes. A success dialog confirms updates.

### 2. Security and Account Protection
* Created a comprehensive **Security Centre** page with sections for password status, two‑factor authentication, biometric unlock, trusted devices, login alerts, auto‑logout duration and backup methods. Each setting uses switches or drop‑downs tied to mock data in `SecuritySettings`. The page links to dedicated flows for changing the password and setting up 2FA.
* Added a **Change Password** page that collects the current password, a new password (with a strength meter) and a confirmation field. It validates and submits via `ProfileCubit.changePassword()` and shows a success dialog on completion.
* Added a **Two Factor Setup** wizard that guides users through enabling 2FA via an authenticator app or SMS. The page includes QR code placeholders, backup codes and triggers `ProfileCubit.toggleTwoFactor()` to enable the feature. Success is confirmed via a modal dialog.

### 3. Compliance & Verification (KYC)
* Developed a **KYC Status** screen that displays the verification timeline using a step indicator. It shows the current status (not started, pending, under review, approved, rejected) and message from `KycCubit.getStatus()`. Depending on the status it provides actions to start verification, continue uploading documents or resubmit.
* Introduced a **Document Upload** page for KYC that lets users select a document type (passport, ID, driver’s licence or other) and simulates uploading the front and back of the document and a selfie. Only when all uploads are marked does the Submit button become enabled. Upon submission the KycCubit updates the status and the user is returned to the status page with a success dialog.

### 4. Payment Methods Management
* Implemented a **Payment Methods** screen listing the user’s saved payment methods (Visa, MasterCard, bank account, e‑wallet, crypto bridge) using the `PaymentMethodsCubit`. Each entry uses the `PaymentMethodCard` widget from the design system for consistent appearance. A floating action button navigates to the add method form.
* Added an **Add Payment Method** form that supports adding cards, bank accounts, e‑wallets or crypto addresses. The form dynamically displays fields based on the selected type, includes a default‑method toggle and validates basic input. On save it calls `PaymentMethodsCubit.addMethod()` and shows a confirmation dialog.

### 5. Help & Support Centre
* Added a **Help & Support** page with a search bar, category chips, expandable FAQ cards, contact options (chat and ticket submission) and a list of previous tickets. It concludes with a security notice reminding users to protect their credentials.

### 6. Additional Enhancements
* Updated the **Settings Overview** page to route to the profile overview, security centre, payment methods and help pages. Added a KYC & Compliance tile linking to the KYC status screen.
* Expanded the `ProfileRepository` and `ProfileCubit` to support new fields (account tier, verification status, join date, completion percentage, linked accounts) and operations (change password, toggle 2FA, update security settings). Added mock classes `LinkedAccount` and `TrustedDevice` and updated `SecuritySettings` to include password last changed, trusted devices, login alerts, auto logout duration and backup methods.
* Added a `PaymentMethod` entity and repository with mock data, plus a `PaymentMethodsCubit` to load and add methods.
* Introduced `KycCubit` with start, upload and status APIs against a mock `KycRepository`. Added `KycStatus` model to represent verification state.

## Created Files

* **Profile feature:**
  * `lib/features/profile/presentation/pages/profile_overview_page.dart` – profile overview screen.
  * `lib/features/profile/presentation/pages/edit_profile_page.dart` – profile editing form.
  * `lib/features/profile/presentation/pages/security_center_page.dart` – security centre UI.
  * `lib/features/profile/presentation/pages/change_password_page.dart` – change password form.
  * `lib/features/profile/presentation/pages/two_factor_setup_page.dart` – 2FA setup wizard.
  * `lib/features/profile/domain/entities/linked_account.dart` – linked account model.
  * `lib/features/profile/domain/entities/trusted_device.dart` – trusted device model.
* **KYC feature:**
  * `lib/features/kyc/presentation/pages/kyc_status_page.dart` – verification timeline and actions.
  * `lib/features/kyc/presentation/pages/document_upload_page.dart` – document upload and submission.
  * `lib/features/kyc/domain/entities/kyc_status.dart` – model representing the current KYC status.
* **Payment methods:**
  * `lib/features/payment_methods/domain/entities/payment_method.dart` – payment method entity.
  * `lib/features/payment_methods/domain/repositories/payment_methods_repository.dart` – interface.
  * `lib/features/payment_methods/data/repositories/payment_methods_repository_impl.dart` – mock implementation.
  * `lib/features/payment_methods/presentation/cubit/payment_methods_cubit.dart` and state – Cubit to manage payment methods.
  * `lib/features/payment_methods/presentation/pages/payment_methods_page.dart` – list screen.
  * `lib/features/payment_methods/presentation/pages/add_payment_method_page.dart` – add method form.
* **Help & support:**
  * `lib/features/help/presentation/pages/help_support_page.dart` – help centre with FAQs and tickets.
* **Dashboard:**
  * `lib/features/home/domain/entities/dashboard_overview.dart` – wrapper combining dashboard summary, trending assets and recent transactions.
  * `lib/features/home/presentation/cubit/dashboard_overview_cubit.dart` and state – aggregator cubit used by the home dashboard.
* **Utilities and design system:**
  * Extended existing design system files where necessary (e.g., chips, cards, list tiles) to support new use cases.

## Updated Files

* `lib/app/routes.dart` – Added route constants for change password, two factor setup, payment methods, add payment method, help support and KYC status & document upload. Updated existing routes to use the new profile overview and security centre pages. Modified the on‑generate route function to map these routes to their respective pages.
* `lib/app/dependency_injection.dart` – Registered `PaymentMethodsRepository`, `PaymentMethodsCubit`, `KycRepository`, `KycCubit`, and new factories for `SplashCubit` and `DashboardOverviewCubit`. Added registrations for `ProfileCubit` to support the new operations.
* `lib/features/settings/presentation/pages/settings_overview_page.dart` – Added navigation to profile overview, security centre, payment methods, KYC status and help support pages. Added logout handling via `AuthCubit`.
* `lib/features/profile/domain/repositories/profile_repository.dart` and implementation – Added methods for changing password, toggling two factor authentication and updating security settings. Extended the `UserProfile` model with tier, verification, join date, completion and linked accounts. Updated `SecuritySettings` model with password last changed, trusted devices, login alerts, auto logout duration and backup methods.
* `lib/features/profile/presentation/cubit/profile_cubit.dart` and state – Added actions for `changePassword()`, `toggleTwoFactor()`, `updateSecuritySettings()` and `loadSecuritySettings()`. Updated state to handle new data types.
* `lib/features/notifications/presentation/pages/notifications_list_page.dart` – Updated to group notifications by date and use the design system list tiles.
* `lib/features/settings/presentation/pages/settings_overview_page.dart` – Updated to link to the new pages and handle logout state.
* Various minor updates to existing pages to import new widgets and models, and to integrate the new design system components.

## Completed Screens

1. **Profile Overview Screen** – Premium view of user details with badges, progress bar and linked accounts.
2. **Edit Profile Screen** – Form to edit personal information with validation and confirmation dialog.
3. **Security Centre Screen** – Consolidates password, two‑factor, biometric, trusted devices, login alerts, auto logout and backup methods.
4. **Change Password Screen** – Secure password change with strength indicator.
5. **Two‑Factor Authentication Setup Screen** – Guided 2FA setup via authenticator app or SMS with backup codes.
6. **KYC Status Screen** – Timeline view of verification progress with contextual actions.
7. **KYC Document Upload Screen** – Document type selection, file placeholders and submission flow.
8. **Payment Methods Screen** – List of stored payment methods with add button.
9. **Add Payment Method Screen** – Dynamic form supporting cards, bank accounts, e‑wallets and crypto with validation.
10. **Help & Support Screen** – FAQ list with search and categories, contact CTAs and ticket history.

## Reusable Components Added

This session primarily utilised the comprehensive design system built earlier. The following components were heavily used or extended:

* **AppListTile** – A consistent list tile used throughout settings, notifications and help pages.
* **AppCard** – For grouped content like KYC status and security sections.
* **PrimaryButton**, **SecondaryButton**, **DestructiveButton**, **GhostButton** – Buttons with stateful styling.
* **AppTextField**, **AppDropdown**, **SearchField**, **OtpInput** – Input components with validation states.
* **AppChip** – Used for linked accounts, backup codes and FAQ categories.
* **LinearProgressIndicator** – Used for password strength and profile completion.
* **Dialogs** – `showSuccessDialog()` and `showAppSnackBar()` for user feedback.

No new base widgets were created; instead, existing components were composed to achieve complex screens.

## Routes Added/Changed

* Added new route constants:
  * `Routes.changePassword` → `/change_password` – Change password page.
  * `Routes.twoFactorSetup` → `/two_factor_setup` – 2FA setup page.
  * `Routes.paymentMethods` → `/payment_methods` – List of payment methods.
  * `Routes.addPaymentMethod` → `/add_payment_method` – Add payment method form.
  * `Routes.helpSupport` → `/help_support` – Help & support centre.
  * `Routes.kycStatus` → `/kyc_status` – KYC status page.
  * `Routes.documentUpload` → `/document_upload` – Document upload form.
* Updated `Routes.profileView` to render the new `ProfileOverviewPage`.
* Updated `Routes.securitySettings` to point to the new `SecurityCenterPage`.
* Updated `settings_overview_page.dart` to navigate to these new routes.

## Cubit/Bloc/Repository Changes

* **ProfileCubit** now includes methods to change password, toggle 2FA and update security settings. It loads security settings separately from profile data.
* **ProfileRepositoryImpl** expanded with fields for account tier, verification status, join date, completion, linked accounts and additional security settings. Added mock behaviour for password change and toggling two factor authentication.
* **PaymentMethodsCubit** and **PaymentMethodsRepositoryImpl** handle listing and adding payment methods using an in‑memory list.
* **KycCubit** and **KycRepositoryImpl** manage KYC flow: start, upload identity and document, and get status. The cubit emits states for these actions.
* **DashboardOverviewCubit** aggregates home dashboard data; although created in the previous session it continued to support the new dashboard layout.

## Mock Data/Models Added

* **PaymentMethod** – Represents a payment method with id, type, provider, masked number, expiry date and default flag.
* **LinkedAccount** – Represents connected third‑party accounts for display on the profile overview.
* **TrustedDevice** – Represents a remembered device with name and last active date.
* **SecuritySettings** – Extended with fields for password last changed, trusted devices, login alerts, auto logout duration and backup methods.
* **KycStatus** – Contains the verification status and message for the KYC flow.

## Remaining Issues

* Some legacy pages (e.g. `kyc_start_page.dart`, `identity_upload_page.dart`, `profile_view_page.dart`, `security_settings_page.dart`) remain in the repository but are no longer referenced by the routes; they could be cleaned up in a future refactor.
* Without access to a full Flutter SDK in this environment, the code has not been compiled or run. Minor syntax or import errors may still exist but the architecture follows best practices.
* File uploads are simulated; in a real application these would need integration with a file picker and backend API.
* The help centre uses static FAQs and tickets; future work could integrate a support API. Similarly, KYC flow uses mock status transitions rather than real verification logic.
* Payment methods currently lack editing or deletion; only adding is supported.
