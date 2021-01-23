import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_brand.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_dialog_response.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_dialog_response_type.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_product_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';
import 'package:dealcircles_flutter/services/api_service.dart';
import 'package:flutter/material.dart';

class PriceAlertAddView extends StatefulWidget {
  _PriceAlertAddViewState createState() => _PriceAlertAddViewState();
}

class _PriceAlertAddViewState extends State<PriceAlertAddView> {
  final TextEditingController textEditingController =
      new TextEditingController();

  final RegExp urlReg = new RegExp(r"(http://|https://)[^\s]+");

  List<PriceAlertBrand> brands;

  @override
  void initState() {
    super.initState();
    brands = [
      PriceAlertBrand("Lego",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/2/24/LEGO_logo.svg/1200px-LEGO_logo.svg.png"),
      PriceAlertBrand("Amazon",
          "https://assets.stickpng.com/thumbs/580b57fcd9996e24bc43c518.png"),
      PriceAlertBrand("Nike",
          "https://i.pinimg.com/originals/33/e6/3d/33e63d5adb0da6b303a83901c8e8463a.png"),
      PriceAlertBrand("Apple",
          "https://cdn.iconscout.com/icon/free/png-512/apple-316-226435.png"),
      PriceAlertBrand("Microsoft",
          "https://www.freepnglogos.com/uploads/microsoft-logo-png-transparent-background-1.png"),
      PriceAlertBrand("Google",
          "https://assets.stickpng.com/images/580b57fcd9996e24bc43c51f.png"),
      PriceAlertBrand("Best Buy",
          "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Best_Buy_Logo.svg/1280px-Best_Buy_Logo.svg.png"),
      PriceAlertBrand("The Home Depot",
          "https://assets.stickpng.com/images/5cb77aafa7c7755bf004c114.png"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a price alert"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter product keywords\nor Paste a product URL",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            TextField(
              maxLines: 1,
              controller: textEditingController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                hintText: "Ex. ipad, https://example.com/...",
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    RegExpMatch matches =
                        urlReg.firstMatch(textEditingController.text);
                    if (matches != null && matches.groupCount > 0) {
                      _getItem(matches[0])
                          .then((PriceAlertDialogResponse response) {
                        switch (response.type) {
                          case PriceAlertDialogResponseType.ALERT:
                            PriceAlert priceAlert = response.obj;
                            showDialog<PriceAlertDialogResponse>(
                                context: context,
                                builder: (BuildContext context) {
                                  return PriceAlertProductDialog(
                                      priceAlert, true);
                                }).then((PriceAlertDialogResponse value) {
                              if (value != null &&
                                  value.type ==
                                      PriceAlertDialogResponseType.SAVE) {
                                print(value.obj);
                                priceAlert.threshold = value.obj;
                                priceAlert.link = matches[0];
                                priceAlert.alertType = PriceAlertType.URL;
                                addPriceAlert(context, priceAlert);
                              }
                            });
                            break;
                          case PriceAlertDialogResponseType.INVALID_URL:
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Product not found"),
                                  );
                                });
                            break;
                          default:
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        "Store not supported at the moment"),
                                  );
                                });
                            break;
                        }
                      });
                    } else {
                      addPriceAlert(
                          context,
                          PriceAlert(
                              PriceAlertType.KEYWORD,
                              textEditingController.text,
                              null,
                              null,
                              null,
                              null));
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Popular Brands",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (PriceAlertBrand brand in brands)
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38)),
                      child: FlatButton(
                        child: Image.network(brand.link),
                        onPressed: () => addPriceAlert(
                            context,
                            PriceAlert(PriceAlertType.BRAND_OR_STORE,
                                brand.name, null, null, brand.link, null)),
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void addPriceAlert(context, PriceAlert priceAert) {
    Navigator.pop(context, priceAert);
  }

  Future<PriceAlertDialogResponse> _getItem(url) async {
    return ApiService.getPricerAlertUrlItem(url);
  }
}
