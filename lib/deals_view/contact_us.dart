import 'package:flutter/material.dart';

class ContactUs extends StatelessWidget {
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
                decoration: InputDecoration(
                  labelText: 'Email (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 15,),
              TextFormField(
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