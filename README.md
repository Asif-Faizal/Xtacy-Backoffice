# Xtacy Backoffice

Production-ready Flutter inventory and sales management app for a single retail clothing outlet. Multiple authenticated staff users share one common inventory backed by Firebase.

## Features

- Google Sign-In authentication
- Product inventory management (add, edit, delete, mark sold)
- Auto-generated product codes (`XT000001`, `XT000002`, …)
- Image upload to Firebase Storage with compression
- Dashboard analytics with charts and category summaries
- Inventory tabs: All, Unsold, Sold, Upper Wear, Lower Wear, Accessories
- Search and filters (category, sold status, date range, price range, sort)
- Offline Firestore persistence and Hive local cache
- Pull to refresh, shimmer loading, empty states
- Material 3 UI with IBM Carbon-inspired theme (zero border radius)
- Dark mode support

## Tech Stack

- Flutter (latest stable)
- Firebase Auth, Cloud Firestore, Firebase Storage
- Bloc (`flutter_bloc`) + Clean Architecture + Repository Pattern
- GoRouter, Hive, Cached Network Image, Image Picker, fl_chart, Intl, UUID

## Prerequisites

- Flutter SDK 3.12+ ([install guide](https://docs.flutter.dev/get-started/install))
- Firebase project: `xtacy-backoffice`
- Google Sign-In enabled in Firebase Authentication
- Android Studio / Xcode for device builds

## Setup

### 1. Clone and install dependencies

```bash
cd xtacy_backoffice
flutter pub get
```

### 2. Firebase configuration

Firebase is already configured via `flutterfire configure`. If you need to reconfigure:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire configure
```

### 3. Enable Google Sign-In

1. Open [Firebase Console](https://console.firebase.google.com/) → **xtacy-backoffice**
2. Go to **Authentication** → **Sign-in method** → enable **Google**
3. For iOS: download an updated `GoogleService-Info.plist` (must include `CLIENT_ID`)
4. For Android: ensure SHA-1 fingerprint is added in Firebase project settings

### 4. Deploy security rules

```bash
firebase deploy --only firestore:rules,storage:rules
```

Or copy `firestore.rules` and `storage.rules` into the Firebase Console.

### 5. Run the app

```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App and category constants
│   ├── errors/        # Failure classes
│   ├── routes/        # GoRouter configuration
│   ├── theme/         # IBM Carbon theme
│   ├── utils/         # Date, currency, image helpers
│   └── validators/    # Form validators
├── data/
│   ├── models/        # Product, User, Dashboard models
│   ├── repositories/  # Auth, Product, Dashboard, Storage
│   └── services/      # Firebase, Hive, Storage services
├── presentation/
│   ├── blocs/         # Auth, Product, Dashboard, Form, Filter
│   ├── screens/       # All app screens
│   └── widgets/       # Reusable UI components
├── app.dart
└── main.dart
```

## Firestore Structure

```
users/{uid}
  - uid, name, email, photoUrl

products/{productId}
  - id, productCode, productName, category, gender, ...
  - purchasePrice, sellingPrice, soldPrice, isSold, soldDate
  - customerName, customerPhone, imageUrl, sleeveType, colour, size, quantity, notes
  - createdAt, updatedAt, createdBy, updatedBy

metadata/product_counter
  - count (for sequential product codes)
```

## Storage Structure

```
/products/{productId}.jpg
```

## Screens

| Screen | Route | Description |
|--------|-------|-------------|
| Splash | `/` | Auth check and redirect |
| Login | `/login` | Google Sign-In |
| Dashboard | `/home` (tab 0) | Analytics and charts |
| Inventory | `/home` (tab 1) | Product listing with filters |
| Profile | `/home` (tab 2) | User info and sign out |
| Add Product | `/products/add` | Create new product |
| Product Details | `/products/:id` | View, sell, delete |
| Edit Product | `/products/:id/edit` | Update product |

## Dashboard Calculations

| Metric | Formula |
|--------|---------|
| Total Investment | SUM(purchasePrice) of unsold items |
| Inventory Value | SUM(sellingPrice ?? purchasePrice) of unsold |
| Total Sales | SUM(soldPrice) |
| Total Profit | SUM(soldPrice - purchasePrice) of sold items |

## Categories

**Upper Wear:** Oversized Tee, Regular Tee, Shirt, Hoodie, Sweatshirt, Tank Top  
**Lower Wear:** Jeans, Cargo, Jogger, Shorts, Trouser  
**Accessories:** Cap, Belt, Bag, Socks, Other

Sleeve type is shown only for upper wear categories.

## License

Private — Xtacy Backoffice
