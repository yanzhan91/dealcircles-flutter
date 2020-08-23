import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_us.dart';

class WebFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("assets/logo.png"),
            SizedBox(width: 10,),
            Text(
              'DealCircles',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(width: 20,),
            FlatButton(
              child: Text('Terms of Use', style: TextStyle(color: Colors.white),),
              onPressed: () => openLink('https://docs.google.com/document/d/1TIXQihwa3HRwyu_scdOw25TGgev6syjp_HKAFS6muIA/edit?usp=sharing'),
            ),
            FlatButton(
              child: Text('Privacy Policy', style: TextStyle(color: Colors.white),),
              onPressed: () => openLink('https://docs.google.com/document/d/1gQur8ij_9SJy_Kc2YVMXku2Xn6CaTNZlgx27gwisKP8/edit?usp=sharing'),
            ),
            FlatButton(
              child: Text('Contact Us', style: TextStyle(color: Colors.white),),
              onPressed: () {
                showDialog(context: context, builder: (context) {
                  return AlertDialog(
                    content: ContactUs(),
                  );
                });
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Copyright 2020 DealCircles. All Rights Reserved.',
                  style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openLink(String link) async {
    if (await canLaunch(link)) {
      await launch(link, forceSafariVC: false);
    }
  }
}