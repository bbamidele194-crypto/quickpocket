import 'package:flutter/material.dart';

void main() => runApp(const QuickPocketApp());

class QuickPocketApp extends StatelessWidget {
  const QuickPocketApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickPocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final nameCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  String? genAccount;
  String? custName;

  void generate() {
    if (nameCtrl.text.isEmpty || amountCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter customer name and amount')));
      return;
    }
    setState(() {
      custName = nameCtrl.text.toUpperCase();
      genAccount = '80${DateTime.now().millisecondsSinceEpoch.toString().substring(6, 14)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QUICKPOCKET'), backgroundColor: Colors.green[800], centerTitle: true, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 50, color: Colors.green[800]),
                    const SizedBox(height: 10),
                    Text('QUICKPOCKET', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800])),
                    const Text('Settlement: OPay 8111275146', style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text('Account: SAMUEL ADEMOLA (Hidden)', style: TextStyle(fontSize: 12)),
                    const Divider(),
                    Text('Squad QFL38ETP: Different GTB per customer after approval', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey[700])),
                    const SizedBox(height: 5),
                    const Text('PENDING MODE: Give customers OPay 8111275146 for now', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Customer Full Name', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 15),
            TextField(controller: amountCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Amount (NGN)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.money))),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: generate,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], padding: const EdgeInsets.all(15)),
              child: const Text('GENERATE VIRTUAL ACCOUNT', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (genAccount != null)
              Card(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text('VIRTUAL ACCOUNT GENERATED', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      const Text('GTB', style: TextStyle(color: Colors.white70)),
                      Text(genAccount!, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      const SizedBox(height: 10),
                      Text('Customer: $custName', style: const TextStyle(color: Colors.white)),
                      Text('Amount: NGN ${amountCtrl.text}', style: const TextStyle(color: Colors.white)),
                      const Divider(color: Colors.white24),
                      const Text('Now: Collect via OPay 8111275146 with name as reference', style: TextStyle(color: Colors.yellowAccent, fontSize: 11), textAlign: TextAlign.center),
                      const Text('After Squad Approval: GTB numbers become live', style: TextStyle(color: Colors.yellowAccent, fontSize: 11), textAlign: TextAlign.center),
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
