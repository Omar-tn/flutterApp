import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local/root.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  String feedback = '';
  final String userId = root.userId;

  Future<void> submitFeedback() async {
    final response = await http.post(
      Uri.parse(root.domain() + ('feedback')),
      body: {
        'student_id': userId,
        'feedback_text': feedback,
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted')));
      setState(() {
        feedback = '';
        _formKey.currentState!.reset();
      });

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed' + response.body)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Report or Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: kIsWeb ? MediaQuery
                  .of(context)
                  .size
                  .width * 0.4 : MediaQuery
                  .of(context)
                  .size
                  .width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: 'Your Report or Feedback'),
                    onChanged: (val) => feedback = val,
                    validator: (val) =>
                    val == null || val.isEmpty
                        ? 'Required'
                        : null,
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
        ),
      ),
    );
  }
}
