import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_add_view.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_alert_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_product_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';
import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:need_resume/need_resume.dart';
import 'package:notification_permissions/notification_permissions.dart';

class PriceAlertView extends StatefulWidget {
  @override
  _PriceAlertView createState() => _PriceAlertView();
}

class _PriceAlertView extends ResumableState<PriceAlertView> {
  bool loading = false;
  List<PriceAlert> priceAlerts;
  ScrollController _scrollController = new ScrollController();
  bool notificationToggleOn = false;
  bool showingDeviceNotificationSettings = false;

  @override
  void initState() {
    super.initState();

    updateNotificationToggle(false);
    loadAlerts();
  }

  @override
  void onResume() {
    if (showingDeviceNotificationSettings) {
      showingDeviceNotificationSettings = false;
      updateNotificationToggle(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          centerTitle: false,
          title: Text(
            'DealCircles',
            overflow: TextOverflow.visible,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
          leading: Image.asset("assets/logo.png"),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            IconButton(
              icon: Icon(
                notificationToggleOn
                    ? Icons.notifications_active_outlined
                    : Icons.notifications_none,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                NotificationPermissions.getNotificationPermissionStatus()
                    .then((permissionStatus) {
                  if (permissionStatus == PermissionStatus.granted) {
                    AppSettings.openNotificationSettings().then(
                        (value) => showingDeviceNotificationSettings = true);
                  } else if (permissionStatus == PermissionStatus.denied) {
                    NotificationPermissions.requestNotificationPermissions()
                        .then((value) =>
                            showingDeviceNotificationSettings = true);
                  } else {
                    NotificationPermissions.requestNotificationPermissions()
                        .then((value) => updateNotificationToggle(true));
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () => _addNewPriceAlert(context),
            ),
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Create a price alert to be notified\non deals for you.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            _generateListview(context),
          ],
        ));
  }

  Future _addNewPriceAlert(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => PriceAlertAddView()));

    if (result != null) {
      setState(() {
        priceAlerts.add(result);
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 80,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut);
      });
      ApiService.addPriceAlerts(result);
    }
  }

  Widget _generateListview(BuildContext context) {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      priceAlerts
          .sort((a, b) => b.alertType.toString().compareTo(a.alertType.toString()));
      return Expanded(
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: priceAlerts.length,
          itemBuilder: (BuildContext context, int index) => createCard(index),
        ),
      );
    }
  }

  Widget createCard(index) {
    return GestureDetector(
      onTap: () => showCardDetailDialog(index),
      child: Card(
        elevation: 4.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: _createRowTile(context, index),
        ),
      ),
    );
  }

  void showCardDetailDialog(index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (priceAlerts[index].alertType == PriceAlertType.URL) {
            return PriceAlertProductDialog(
                priceAlerts[index], false, priceAlerts[index].threshold);
          } else {
            return PriceAlertAlertDialog(priceAlerts[index]);
          }
        }).then((value) {
      if (value is bool) {
        if (value == true) {
          setState(() {
            priceAlerts.removeAt(index);
          });
        }
      } else if (value is String) {
        setState(() {
          priceAlerts[index].threshold = value;
        });
      } else {
        ApiService.openLink(priceAlerts[index].link);
      }
    });
  }

  Widget _createRowTile(BuildContext context, int index) {
    PriceAlert priceAlert = priceAlerts[index];
    List<Widget> priceItems = [];
    if (priceAlert.alertType == PriceAlertType.URL) {
      priceItems.add(Text(
        priceAlert.price,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ));
    }
    priceItems.add(Text(
      " | ${priceAlert.threshold}",
      overflow: TextOverflow.clip,
      style: TextStyle(color: Colors.black54, fontSize: 14),
    ));
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Row(
          children: <Widget>[
            if (priceAlert.alertType == PriceAlertType.KEYWORD)
              Container(
                width: 60,
                height: 60,
                child: Icon(
                  Icons.bookmark_outline,
                  color: Theme.of(context).primaryColor,
                  size: 40,
                ),
              ),
            if (priceAlert.alertType != PriceAlertType.KEYWORD)
              Image.network(
                priceAlert.img,
                fit: BoxFit.contain,
                height: 60,
                width: 60,
              ),
            SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(priceAlert.name,
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (priceAlerts[index].alertType == PriceAlertType.URL)
                    Row(
                      children: priceItems,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateNotificationToggle(bool possiblyUpdated) {
    NotificationPermissions.getNotificationPermissionStatus().then((status) {
      if (possiblyUpdated) {
        String snackbarText;
        if (status == PermissionStatus.granted && !notificationToggleOn) {
          snackbarText = 'Notification On';
        } else if (status != PermissionStatus.granted && notificationToggleOn) {
          snackbarText = 'Notification Off';
        }
        if (snackbarText != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(snackbarText),
              backgroundColor: Theme.of(context).primaryColor,
              action: SnackBarAction(
                label: 'Ok',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      }
      setState(() {
        notificationToggleOn = status == PermissionStatus.granted;
      });
    });
  }

  void loadAlerts() async {
    setState(() {
      loading = true;
    });

    List<PriceAlert> alerts = await ApiService.loadPriceAlerts();

    setState(() {
      priceAlerts = alerts;
      loading = false;
    });
  }
}
