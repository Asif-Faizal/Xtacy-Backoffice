# Xtacy Backoffice

Production-ready Flutter inventory and sales management app for a single retail clothing outlet. Multiple authenticated staff users share one common inventory.

**Backend split (Spark-friendly):**
- **Firebase (Spark / free)** — Google Sign-In, Firestore database
- **Supabase (free tier)** — Product image storage (no Blaze plan, no prepayment)

## Features

- Google Sign-In authentication
- Product inventory management (add, edit, delete, mark sold)
- Auto-generated product codes (`XT000001`, `XT000002`, …)
- Image upload to **Supabase Storage** with compression
- Dashboard analytics with charts and category summaries
- Inventory tabs: All, Unsold, Sold, Upper Wear, Lower Wear, Accessories
- Search and filters (category, sold status, date range, price range, sort)
- Offline Firestore persistence and Hive local cache
- Pull to refresh, shimmer loading, empty states
- Material 3 UI with IBM Carbon-inspired theme (zero border radius)
- Dark mode support

## Tech Stack

- Flutter (latest stable)
- Firebase Auth + Cloud Firestore (Spark plan)
- Supabase Storage (free tier — 1 GB)
- Bloc (`flutter_bloc`) + Clean Architecture + Repository Pattern
- GoRouter, Hive, Cached Network Image, Image Picker, fl_chart, Intl, UUID

## Prerequisites

- Flutter SDK 3.12+ ([install guide](https://docs.flutter.dev/get-started/install))
- Firebase project: `xtacy-backoffice` (Spark plan is enough)
- Supabase account ([supabase.com](https://supabase.com) — free, no card required)
- Google Sign-In enabled in Firebase Authentication
- Android Studio / Xcode for device builds

## Setup

### 1. Install dependencies

```bash
cd xtacy_backoffice
flutter pub get
```

### 2. Firebase (Auth + Firestore)

Firebase is already configured via `flutterfire configure`. If you need to reconfigure:

```bash
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire configure
```

**Enable Google Sign-In:**

1. [Firebase Console](https://console.firebase.google.com/) → **xtacy-backoffice**
2. **Authentication** → **Sign-in method** → enable **Google**
3. iOS: download updated `GoogleService-Info.plist` (must include `CLIENT_ID`)
4. Android: add SHA-1 fingerprint in Firebase project settings

**Deploy Firestore rules only** (no Firebase Storage / Blaze needed):

```bash
firebase deploy --only firestore:rules --project xtacy-backoffice
```

### 3. Supabase (product images — free)

1. Create a project at [supabase.com](https://supabase.com) (free tier, no payment required)
2. Open **Project Settings** → **API** and copy:
   - **Project URL**
   - **anon public** key
3. Paste them in `lib/core/constants/supabase_constants.dart`:

```dart
static const String url = 'https://YOUR_PROJECT.supabase.co';
static const String anonKey = 'YOUR_ANON_KEY';
```

4. Open **SQL Editor** in Supabase and run the contents of `supabase/storage_setup.sql`
   - Or manually: **Storage** → **New bucket** → name `products` → enable **Public bucket**
5. Free tier includes **1 GB** storage — enough for hundreds of compressed product photos

### 4. Run the app

```bash
flutter run
```

## Why Supabase instead of Firebase Storage?

Firebase Storage now requires the **Blaze (pay-as-you-go)** plan with a billing account. Supabase free tier provides **1 GB storage** with **no card or prepayment** — ideal for a small store on Firebase Spark.

| Service | Plan | Cost for this app |
|---------|------|-------------------|
| Firebase Auth + Firestore | Spark | $0 |
| Supabase Storage | Free | $0 (within 1 GB) |
| Firebase Storage | Blaze required | Needs billing account |

## Project Structure

```
lib/
├── core/
│   ├── constants/     # App, category, Supabase config
│   ├── errors/        # Failure classes
│   ├── routes/        # GoRouter configuration
│   ├── theme/         # IBM Carbon theme
│   ├── utils/         # Date, currency, image helpers
│   └── validators/    # Form validators
├── data/
│   ├── models/        # Product, User, Dashboard models
│   ├── repositories/  # Auth, Product, Dashboard, Storage
│   └── services/      # Firebase, Supabase, Hive services
├── presentation/
│   ├── blocs/         # Auth, Product, Dashboard, Form, Filter
│   ├── screens/       # All app screens
│   └── widgets/       # Reusable UI components
├── app.dart
└── main.dart
supabase/
└── storage_setup.sql  # Bucket + policies for product images
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

## Image Storage (Supabase)

```
Bucket: products (public read)
Path:   {productId}.jpg
```

Public URL is stored in Firestore as `imageUrl`.

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
