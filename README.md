# Trustlya Flutter Project

## Overview

Trustlya is a comprehensive blockchain ecosystem application that unifies several discrete products under one umbrella: game item trading, crypto wallet management, casino gaming, and a carbon credit marketplace. This repository contains the Flutter implementation of the Trustlya client application. The code is organised using **Clean Architecture** to facilitate scalability, testability and separation of concerns. At its core, the project is designed to be easily replaced with a real backend in the future; for now, all services are implemented using mock data.

The high level folder structure is outlined below:

```
lib/
├── app/                – application entry point, routing and dependency injection
├── core/               – cross‑cutting concerns, constants and utilities
├── shared/             – reusable widgets and base classes
└── features/           – feature modules (auth, home, trading, wallet, casino, carbon, profile, kyc, notifications, settings)
```

### Clean Architecture Layers

Each feature adheres to a layered architecture:

1. **presentation** – UI widgets, pages and state management (Cubit/Bloc).
2. **domain** – business logic: entities, repository contracts and use cases.
3. **data** – concrete implementations of repositories using mock services.

The `presentation` layer depends only on the `domain` layer, while the `data` layer depends on both the `domain` layer and external services. This separation ensures that the UI never calls services directly, making it straightforward to swap mock data with real APIs later on.

### Dependency Injection

Dependency injection is configured in `lib/app/dependency_injection.dart` using the `GetIt` service locator. Repositories and cubits for each feature are registered here.

### Routing

All application routes are centralised in `lib/app/routes.dart`. Each screen in the project has a corresponding route name and is registered through the `onGenerateRoute` function. New pages should be added to the route map here.

### Theme and Design Tokens
Theme definitions and design tokens have been expanded significantly in the second session. The new design system lives under `lib/core/theme/` and includes:

* **Colour palette** – Dark‑first luxury fintech/gaming colours defined in `app_colors.dart`, including semantic colours for success, warning, danger and information as well as surface colours for backgrounds, cards and overlays.
* **Spacing scale** – Standardised spacing values in `app_spacing.dart` used for margins and padding across the app.
* **Corner radii** – Defined in `app_radii.dart` for consistent rounded corners.
* **Shadows/elevation** – Shadow presets in `app_shadows.dart` used by cards and panels.
* **Typography** – A rich type scale in `app_typography.dart` that defines headings, subtitles, body text, buttons and captions.
* **Gradients, icon sizes, motion durations and curves** – Centralised definitions for gradients (`app_gradients.dart`), icon sizing (`app_icon_sizes.dart`), animation durations (`app_durations.dart`) and curves (`app_curves.dart`).

These tokens are consumed by the `DesignSystemTheme` (see `lib/core/theme/design_system_theme.dart`), which provides `ThemeData` instances for both dark and light modes. The `TrustlyaTheme` now forwards to these design system themes.

### Shared Component Library

To support rapid development and ensure UI consistency, a comprehensive reusable component library has been added under `lib/shared/widgets/`. Highlights include:

* **Buttons** – Primary, secondary, ghost and destructive buttons with loading states (`buttons.dart`).
* **Inputs** – A suite of fields including standard text fields, search fields, amount inputs, OTP inputs and styled dropdowns (`inputs.dart`).
* **Chips and Filter Rows** – Tag and badge components along with a horizontally scrollable filter row (`chips.dart`, `filter_row.dart`).
* **Cards** – Base card, metric card, glass card and specialised rows/cards for transactions, assets, payment methods, wallet addresses, market items, casino games and carbon projects (`cards.dart`).
* **Dialogs** – Modal sheet, confirmation dialog, success dialog and snackbars (`dialogs.dart`).
* **Layout primitives** – Responsive page wrapper, adaptive grid, desktop side nav shell, mobile bottom nav shell, section spacing helper and sticky CTA footer (`layout.dart`, `cta_footer.dart`).
* **Animations** – Common animations such as number count‑up, balance blur/reveal, shimmer loading, card hover, stagger reveals and CTA entrance (`animations.dart`).

A design system showcase screen exists under `lib/features/design_system/presentation/pages/design_system_page.dart`. This page previews all components and should be used during development to verify visual consistency. The corresponding route is `/design_system` and can be accessed by adding it to the initial route for debugging.

### Mock Data

Mock models, repositories and services are located in each feature’s `data/` directory. They mimic network responses and persistent storage behaviour. All features support multiple states (loading, empty, error, success) to accommodate asynchronous operations.

### Contributing

When adding a new feature or screen, follow the existing folder conventions and update `routes.dart` accordingly. Create a cubit and state class for your new screen, register your repository and cubit in the dependency injection file, and provide mock implementations in the `data` layer.
