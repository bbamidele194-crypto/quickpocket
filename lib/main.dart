import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// CONFIG - OPay ONLY - No Moniepoint
const String OPAY_SETTLEMENT_ACCOUNT = "8111275146"; // SAMUEL ADEMOLA
const String OPAY_SETTLEMENT_NAME = "SAMUEL ADEMOLA"; // Hidden in UI
const String BUSINESS_DISPLAY_NAME = "QUICKPOCKET"; // Show this to customers
const String SQUAD_SANDBOX_SECRET = "YOUR_SQUAD_SECRET_KEY_HERE"; // Replace after Squad QFL38ETP approval
const bool USE_SQUAD_DIFFERENT_ACC = false; // Set true after Squad approved

void main() {
  runApp(const QuickPocketApp());
}

class QuickPocketApp extends StatelessWidget {
  const QuickPocketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickPocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const WalletScreen(),
    );
  }
}

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String displayAccountNumber = OPAY_SETTLEMENT_ACCOUNT;
  String displayBankName = "OPay (Temporary)";
  String displayAccountName = BUSINESS_DISPLAY_NAME; // QUICKPOCKET - Hides SAMUEL ADEMOLA
  bool isLoading = false;
  String statusMessage = "Temporary Mode: All customers fund to OPay 8111275146 - Shows QUICKPOCKET in app";

  // Generate Different GTB Account Per Customer via Squad QFL38ETP
  Future<void> generateSquadVirtualAccount(String customerPhone, String customerBVN) async {
    setState(() {
      isLoading = true;
      statusMessage = "Generating your QUICKPOCKET GTB account...";
    });

    try {
      // Squad API - Create Virtual Account - Different per customer
      final response = await http.post(
        Uri.parse("https://api.squadco.com/virtual-account"),
        headers: {
          "Authorization": "Bearer $SQUAD_SANDBOX_SECRET",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "customer_identifier": customerPhone,
          "bvn": customerBVN,
          "business_name": BUSINESS_DISPLAY_NAME, // QUICKPOCKET - Hides SAMUEL ADEMOLA
          "bank_code": "058", // GTB - Will show QUICKPOCKET
          "account_name": BUSINESS_DISPLAY_NAME, // QUICKPOCKET
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          displayAccountNumber = data['data']['virtual_account_number'] ?? "GTB 30xxxxxx";
          displayBankName = "GTB - ${BUSINESS_DISPLAY_NAME}";
          displayAccountName = BUSINESS_DISPLAY_NAME; // QUICKPOCKET
          statusMessage = "Success! Your personal ${BUSINESS_DISPLAY_NAME} GTB account - Funds settle to OPay 8111275146";
          isLoading = false;
        });
      } else {
        // Fallback to OPay if Squad not approved yet
        setState(() {
          displayAccountNumber = OPAY_SETTLEMENT_ACCOUNT;
          displayBankName = "OPay (Temporary) - ${BUSINESS_DISPLAY_NAME}";
          displayAccountName = BUSINESS_DISPLAY_NAME;
          statusMessage = "Squad pending (QFL38ETP). Using OPay 8111275146 temporary. App shows QUICKPOCKET, bank may show SAMUEL ADEMOLA.";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        displayAccountNumber = OPAY_SETTLEMENT_ACCOUNT;
        displayBankName = "OPay (Temporary)";
        displayAccountName = BUSINESS_DISPLAY_NAME;
        statusMessage = "Offline mode: OPay 8111275146 - ${BUSINESS_DISPLAY_NAME} hides SAMUEL ADEMOLA";
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto show OPay 8111275146 as QUICKPOCKET on start
    // After Squad approval, call generateSquadVirtualAccount(userPhone, userBVN)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QuickPocket - QUICKPOCKET"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card showing QUICKPOCKET - Hides SAMUEL ADEMOLA
            Card(
              elevation: 5,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Your Wallet Account", style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Text(displayAccountNumber, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.account_balance, size: 16),
                        const SizedBox(width: 5),
                        Text(displayBankName, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 5),
                        Text(displayAccountName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("NO Moniepoint - OPay 8111275146 only", style: TextStyle(fontSize: 10, color: Colors.red)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (isLoading) const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(8)),
              child: Text(statusMessage, style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 20),
            const Text("How it works:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("1. NOW: All customers → OPay $OPAY_SETTLEMENT_ACCOUNT (Shows $BUSINESS_DISPLAY_NAME in app)"),
            Text("2. Bank transfer may show ${OPAY_SETTLEMENT_NAME} - Tell customers it's $BUSINESS_DISPLAY_NAME official"),
            const Text("3. AFTER Squad QFL38ETP approved: Each customer → Different GTB - QUICKPOCKET"),
            const Text("4. All money settles to OPay 8111275146 SAMUEL ADEMOLA - NO Moniepoint"),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate new customer - will generate different GTB after Squad approval
                  generateSquadVirtualAccount("080${DateTime.now().millisecond}1234567", "12345678901");
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.all(15)),
                child: const Text("Generate My QUICKPOCKET Account (Different per customer)", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
