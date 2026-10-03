
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(QuickPocketApp());

class QuickPocketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickPocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: FundWalletScreen(),
    );
  }
}

const String MY_OPAY = "8111275146";
const String MY_OPAY_NAME = "SAMUEL ADEMOLA";
const String BUSINESS_NAME = "QUICKPOCKET";
const String SQUAD_SECRET_KEY = "YOUR_SQUAD_SECRET_KEY_HERE";
const String SQUAD_BASE_URL = "https://api-d.squadco.com";

class FundWalletScreen extends StatefulWidget {
  @override
  _FundWalletScreenState createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  String? customerVirtualAccount;
  String? customerBankName;
  bool loading = false;
  String userPhone = "08012345678";

  Future<void> generateAccountForCustomer() async {
    setState(() => loading = true);
    if (SQUAD_SECRET_KEY == "YOUR_SQUAD_SECRET_KEY_HERE") {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        customerVirtualAccount = MY_OPAY;
        customerBankName = "OPay (Temporary) - " + BUSINESS_NAME;
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Squad KYC pending. Using OPay 8111275146 temporary. After approval, each customer gets different GTB account showing QUICKPOCKET")),
      );
      return;
    }
    try {
      final response = await http.post(
        Uri.parse("$SQUAD_BASE_URL/virtual-account"),
        headers: {
          "Authorization": "Bearer $SQUAD_SECRET_KEY",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "customer_identifier": userPhone,
          "business_name": BUSINESS_NAME,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          customerVirtualAccount = data['data']['virtual_account_number'];
          customerBankName = "${data['data']['bank_name']} - $BUSINESS_NAME";
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    generateAccountForCustomer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("QuickPocket - $BUSINESS_NAME"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, Ademola! 👋", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("Squad Dashboard: QFL38ETP - quickpocket", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Card(
              color: Colors.green.shade50,
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.green),
                        SizedBox(width: 8),
                        Text("YOUR PERSONAL FUNDING ACCOUNT", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Divider(height: 20),
                    if (loading) Center(child: CircularProgressIndicator())
                    else if (customerVirtualAccount != null) ...[
                      Row(children: [Text("Bank: ", style: TextStyle(fontWeight: FontWeight.bold)), Text(customerBankName ?? 'GTBank')]),
                      SizedBox(height: 8),
                      Row(children: [Text("Account: ", style: TextStyle(fontWeight: FontWeight.bold)), SelectableText(customerVirtualAccount!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1))]),
                      SizedBox(height: 8),
                      Row(children: [Text("Name: ", style: TextStyle(fontWeight: FontWeight.bold)), Text(BUSINESS_NAME, style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold))]),
                      SizedBox(height: 12),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                        child: Text("✓ Different acc for each customer\n✓ Shows $BUSINESS_NAME not $MY_OPAY_NAME\n✓ Money auto goes to OPay $MY_OPAY", style: TextStyle(fontSize: 12, color: Colors.black87)),
                      ),
                    ],
                    SizedBox(height: 16),
                    SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: generateAccountForCustomer, icon: Icon(Icons.refresh), label: Text("Refresh My Account"))),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("How it works (After Squad Approval):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),
            Text("1. Customer John → GTB 3001234501 - QUICKPOCKET (his own)"),
            Text("2. Customer Amaka → GTB 3001234502 - QUICKPOCKET (her own)"),
            Text("3. All settle to your OPay $MY_OPAY - $MY_OPAY_NAME"),
            Text("4. You confirm in Admin → Wallet credited"),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdminScreen())), style: ElevatedButton.styleFrom(padding: EdgeInsets.all(16)), child: Text("Go to Admin - Confirm Payments →"))),
            SizedBox(height: 12),
            Card(color: Colors.orange.shade50, child: Padding(padding: EdgeInsets.all(12), child: Row(children: [Icon(Icons.pending, color: Colors.orange), SizedBox(width: 8), Expanded(child: Text("Squad KYC Status: PENDING APPROVAL - Using OPay $MY_OPAY temporary until approved today"))]))),
          ],
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin - Confirm Payments")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(color: Colors.blue.shade50, child: Padding(padding: EdgeInsets.all(12), child: Text("All Squad different accounts settle to: OPay $MY_OPAY - $MY_OPAY_NAME", style: TextStyle(fontWeight: FontWeight.bold)))),
          SizedBox(height: 10),
          Card(child: ListTile(leading: CircleAvatar(child: Text("J")), title: Text("John paid ₦5,000"), subtitle: Text("To GTB 3001234501 - QUICKPOCKET → Settled to OPay $MY_OPAY"), trailing: ElevatedButton(onPressed: () {}, child: Text("Confirm")))),
          Card(child: ListTile(leading: CircleAvatar(child: Text("A")), title: Text("Amaka paid ₦2,000"), subtitle: Text("To GTB 3001234502 - QUICKPOCKET → Settled to OPay $MY_OPAY"), trailing: ElevatedButton(onPressed: () {}, child: Text("Confirm")))),
          SizedBox(height: 20),
          Text("Settlement Account:", style: TextStyle(fontWeight: FontWeight.bold)),
          ListTile(leading: Icon(Icons.account_balance), title: Text("OPay"), subtitle: Text("$MY_OPAY - $MY_OPAY_NAME"), trailing: Icon(Icons.check_circle, color: Colors.green)),
        ],
      ),
    );
  }
}
