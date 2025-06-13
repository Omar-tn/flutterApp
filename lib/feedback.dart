import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  String feedback = '';
  final String userId = 'firebaseUID-placeholder';

  Future<void> submitFeedback() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/api/feedback'),
      body: {
        'student_id': userId,
        'feedback_text': feedback,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Feedback submitted')));
      setState(() => feedback = '');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Submission failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Your Feedback'),
                onChanged: (val) => feedback = val,
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) submitFeedback();
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
