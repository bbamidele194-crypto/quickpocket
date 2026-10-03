
import 'package:flutter/material.dart';

void main() => runApp(QuickPocketApp());

class QuickPocketApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickPocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _generatedAccount;
  String? _customerName;

  void _generateAccount() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter customer name and amount')),
      );
      return;
    }
    // Temporary OPay display - Squad QFL38ETP generates different GTB per customer after approval
    setState(() {
      _customerName = _nameController.text.toUpperCase();
      _generatedAccount = '80${DateTime.now().millisecondsSinceEpoch.toString().substring(6, 12)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QUICKPOCKET'),
        backgroundColor: Colors.green[800],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 50, color: Colors.green[800]),
                    SizedBox(height: 10),
                    Text('QUICKPOCKET', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800])),
                    Text('Settlement: OPay 8111275146', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Account: SAMUEL ADEMOLA (Hidden)', style: TextStyle(fontSize: 12)),
                    Divider(),
                    Text('Squad QFL38ETP: Different GTB per customer after approval', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Customer Full Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
            SizedBox(height: 15),
            TextField(controller: _amountController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: 'Amount (NGN)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.money))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAccount,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], padding: EdgeInsets.all(15)),
              child: Text('GENERATE GTB VIRTUAL ACCOUNT', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 20),
            if (_generatedAccount != null)
              Card(
                color: Colors.black,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text('VIRTUAL ACCOUNT GENERATED', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Text('GTB', style: TextStyle(color: Colors.white70)),
                      Text(_generatedAccount!, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      SizedBox(height: 10),
                      Text('Customer: $_customerName', style: TextStyle(color: Colors.white)),
                      Text('Amount: NGN ${_amountController.text}', style: TextStyle(color: Colors.white)),
                      Divider(color: Colors.white24),
                      Text('Temporary: All funds → OPay 8111275146', style: TextStyle(color: Colors.yellowAccent, fontSize: 11)),
                      Text('After Squad Approval: Settles to same OPay', style: TextStyle(color: Colors.yellowAccent, fontSize: 11)),
                      SizedBox(height: 15),
                      Text('Show this to customer to pay', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
