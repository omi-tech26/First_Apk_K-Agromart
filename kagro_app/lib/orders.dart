import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class UserOrdersPage extends StatefulWidget {
  @override
  _UserOrdersPageState createState() => _UserOrdersPageState();
}

class _UserOrdersPageState extends State<UserOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text(
            'Please log in to view your orders.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
        backgroundColor: Colors.green,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by Order ID or Address...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .orderBy('orderDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'You have no orders yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final orderId = orders[index].id;

              final orderDate = (order['orderDate'] as Timestamp).toDate();
              final formattedOrderDate = DateFormat('yyyy-MM-dd').format(
                  orderDate);
              final totalPrice = order['totalPrice'] ?? 0.0;
              final status = order['status'] ?? 'Pending';

              Color statusColor;
              switch (status.toLowerCase()) {
                case 'shipped':
                  statusColor = Colors.blue;
                  break;
                case 'delivered':
                  statusColor = Colors.green;
                  break;
                case 'cancelled':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.yellow;
              }

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${orderId}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Order Date: $formattedOrderDate',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Total Price: ₹$totalPrice',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1, color: Colors.grey[300]),
                      FutureBuilder<List<Widget>>(
                        future: _fetchOrderItems(order['orderItems'] as List),
                        builder: (context, itemSnapshot) {
                          if (itemSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (itemSnapshot.hasError) {
                            return Text(
                              'Error loading items.',
                              style: TextStyle(color: Colors.red),
                            );
                          }
                          return Column(children: itemSnapshot.data ?? []);
                        },
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (status.toLowerCase() == 'cancelled')
                            ElevatedButton.icon(
                              onPressed: () {
                                reorder(orderId, order);
                              },
                              icon: Icon(
                                  Icons.shopping_cart, color: Colors.white),
                              label: Text('Reorder'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          else
                            ElevatedButton.icon(
                              onPressed: () {
                                deleteOrder(orderId);
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                              label: Text('Cancel Order'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              generateInvoice(orderId, order);
                            },
                            child: Text('Generate Invoice'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Widget>> _fetchOrderItems(List<dynamic> orderItems) async {
    final List<Widget> itemWidgets = [];

    for (var item in orderItems) {
      final productName = item['productName'] ?? 'Unknown';
      final variant = item['variant'] ?? 'N/A';
      final quantity = item['quantity'] ?? 0;
      final price = item['price'] ?? 0.0;

      itemWidgets.add(
        ListTile(
          title: Text('$productName ($variant) - ₹$price x $quantity'),
          leading: Icon(Icons.shopping_cart, color: Colors.green),
        ),
      );
    }
    return itemWidgets;
  }

  Future<void> deleteOrder(String orderId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order has been deleted.')),
    );
  }

  Future<void> generateInvoice(String orderId,
      Map<String, dynamic> orderData) async {
    try {
      final pdf = pw.Document();

      final user = _auth.currentUser;
      final userDoc = await _firestore.collection('users').doc(user!.uid).get();
      final userData = userDoc.data() ?? {};
      final shippingAddress = userData['shippingAddress'] ?? {};
      final orderItems = orderData['orderItems'] ?? [];

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'K-Agro-Mart',
                  style: pw.TextStyle(fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Invoice/Bill of Supply/Cash Memo', style: pw.TextStyle(
                    fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text('Order Number: $orderId'),
                pw.Text('Invoice Number: INV-$orderId'),
                pw.Text('Order Date: ${DateFormat('yyyy-MM-dd').format(
                    (orderData['orderDate'] as Timestamp).toDate())}'),
                pw.Text('Invoice Date: ${DateFormat('yyyy-MM-dd').format(
                    DateTime.now())}'),
                pw.Text('Status: ${orderData['status'] ?? "Pending"}',
                    style: pw.TextStyle(color: PdfColors.orange)),
                pw.SizedBox(height: 20),
                pw.Text('Sold By:'),
                pw.Text('Seller Name'),
                pw.Text('Seller Address'),
                pw.Text('GSTIN: GST Number'),
                pw.SizedBox(height: 20),
                pw.Text('Shipping Address:'),
                pw.Text('${shippingAddress['buildingName'] ??
                    "No building name"}, ${shippingAddress['landmark'] ??
                    "No landmark"}'),
                pw.Text('${shippingAddress['city'] ??
                    "No city"}, ${shippingAddress['state'] ??
                    "No state"} - ${shippingAddress['pincode'] ??
                    "No pincode"}'),
                pw.SizedBox(height: 20),
                pw.Text('Order Items:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(children: [
                      pw.Text('Product Name',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Variant',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Quantity',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('Price',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ]),
                    ...orderItems.map((item) {
                      return pw.TableRow(children: [
                        pw.Text(item['productName'] ?? 'Unknown'),
                        pw.Text(item['variant'] ?? 'N/A'),
                        pw.Text(item['quantity'].toString()),
                        pw.Text('₹${item['price']}'),
                      ]);
                    }).toList(),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Total Amount: ₹${orderData['totalPrice'] ?? 0.0}',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Thank you for shopping with us!',
                    style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
              ],
            );
          },
        ),
      );

      final outputDir = await getTemporaryDirectory();
      final outputFile = File('${outputDir.path}/invoice_$orderId.pdf');
      await outputFile.writeAsBytes(await pdf.save());

      await OpenFile.open(outputFile.path);
    } catch (e) {
      print('Error generating or opening the invoice: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to generate invoice. Please try again.')),
      );
    }
  }

  Future<void> reorder(String orderId, Map<String, dynamic> order) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Get reference to the user's orders collection
      CollectionReference ordersRef = _firestore.collection('users').doc(
          user.uid).collection('orders');

      // Create a new order with updated timestamp
      Map<String, dynamic> newOrder = Map.from(order);
      newOrder['orderDate'] = Timestamp.now();
      newOrder['status'] = 'Pending';

      // Add new order to Firestore
      DocumentReference newOrderRef = await ordersRef.add(newOrder);

      print("Reorder placed successfully with Order ID: ${newOrderRef.id}");
    } catch (e) {
      print("Error placing reorder: $e");
    }
  }

}