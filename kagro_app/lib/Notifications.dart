import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late FirebaseFirestore _firestore;
  late Stream<QuerySnapshot> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _notificationsStream = _firestore
        .collection('notifications') // Ensure this matches your Firestore collection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _deleteNotification(String docId) async {
    try {
      await _firestore.collection('notifications').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete notification: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications yet."));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var doc = notifications[index];
              var data = doc.data() as Map<String, dynamic>;
              var title = data['title'] ?? 'No title';
              var description = data['description'] ?? 'No description';

              // Handle timestamp conversion
              var timestamp;
              if (data['timestamp'] is String) {
                timestamp = DateTime.tryParse(data['timestamp']) ?? DateTime.now();
              } else if (data['timestamp'] is Timestamp) {
                timestamp = (data['timestamp'] as Timestamp).toDate();
              } else {
                timestamp = DateTime.now();
              }

              var formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(timestamp);

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.notifications, color: Colors.green, size: 30),
                  title: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(description, style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      Text(
                        formattedDate,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNotification(doc.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}