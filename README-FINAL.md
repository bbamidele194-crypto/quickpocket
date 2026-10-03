# QuickPocket Wallet - Complete Build Ready

QuickPocket Wallet - Fintech wallet that generates different account number per customer showing business name QUICKPOCKET (hiding personal name).

### 💳 Settlement Account (Only One)
- Bank: OPay
- Account Number: 8111275146
- Account Name: SAMUEL ADEMOLA (Hidden in app as QUICKPOCKET)
- App Display: QUICKPOCKET - No personal name shown to customers

### 🚀 Temporary Mode (NOW - Before Squad Approval)
- All customers fund to SAME account: OPay 8111275146
- App shows: OPay (Temporary) - QUICKPOCKET
- Bank transfer screen may show SAMUEL ADEMOLA (OPay limitation)
- App UI hides it and shows QUICKPOCKET only

### ✅ Permanent Mode (After Squad QFL38ETP Approval)
- Squad Dashboard: QFL38ETP - quickpocket
- Each customer gets DIFFERENT GTB virtual account:
  - John → GTB 3001234501 - QUICKPOCKET
  - Amaka → GTB 3001234502 - QUICKPOCKET
  - Emeka → GTB 3001234503 - QUICKPOCKET
- All funds auto-settle to: OPay 8111275146 SAMUEL ADEMOLA
- Customer bank app shows: QUICKPOCKET (SAMUEL ADEMOLA hidden 100%)

### 📱 Features
- Registration: Name, Phone Number, NIN (11 digits) - No BVN
- Wallet Funding: OPay 8111275146 temporary
- Different account per customer (Squad GTB) after approval
- Business name QUICKPOCKET hides SAMUEL ADEMOLA
- Admin dashboard to verify payments
- No Moniepoint - OPay only

### 🛠 Build APK
```bash
flutter pub get
flutter build apk --release
```
APK location: `build/app/outputs/flutter-apk/app-release.apk`

### 🔑 After Squad Approval
- Get Squad Secret Key from Dashboard
- Replace in `lib/main.dart`:
  `const String SQUAD_SECRET_KEY = "YOUR_KEY"`
- Rebuild APK - Now generates different QUICKPOCKET accounts!

**GitHub:** bbamidele194-crypto/quickpocket
**Status:** OPay 8111275146 Temporary → Squad QFL38ETP Different Acc (QUICKPOCKET)
