import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        child: Form(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Connect with us', style: TextStyle(fontSize: 26),),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
              ),
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    ApiService.contactUs(emailController.text, messageController.text);
                    Navigator.pop(context);
                  },
                  child: Text('Send', style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}