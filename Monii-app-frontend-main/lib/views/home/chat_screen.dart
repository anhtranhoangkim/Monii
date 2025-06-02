import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monii/config/session_manager.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  void _sendMessage(String message) {
    setState(() {
      messages.add({'sender': 'user', 'message': message});
    });
    _getFinancialAdvice(message);
    _controller.clear();
  }

  Future<void> _getFinancialAdvice(String message) async {
    final url = 'http://10.0.2.2:8080/api/openai/get-financial-advice';

    final token = await SessionManager.getToken();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'message': message}),
      );

      if (response.statusCode == 200) {
        final String advice = response.body; 
        setState(() {
          messages.add({'sender': 'bot', 'message': advice});
        });
      } else {
        setState(() {
          messages.add({
            'sender': 'bot',
            'message': 'Error: Unable to get advice. Status ${response.statusCode}'
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'sender': 'bot', 'message': 'Error: Something went wrong.'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Financial Advisor'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (ctx, index) {
                final msg = messages[index];
                return ListTile(
                  title: Align(
                    alignment: msg['sender'] == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: msg['sender'] == 'user' ? Colors.blue : Colors.grey[600],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        msg['message']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
