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
      PriceAlertBrand("Adidas", "assets/logos/adidas.png"),
      PriceAlertBrand("Asics", "assets/logos/asics.png"),
      PriceAlertBrand("Bose", "assets/logos/bose.png"),
      PriceAlertBrand("Calphalon", "assets/logos/calphalon.jpg"),
      PriceAlertBrand("Lego", "assets/logos/lego.png"),
      PriceAlertBrand("LG", "assets/logos/lg.png"),
      PriceAlertBrand("Nike", "assets/logos/nike.png"),
      PriceAlertBrand("PlayStation", "assets/logos/playstation.png"),
      PriceAlertBrand("Sketcher", "assets/logos/skechers.png"),
      PriceAlertBrand("Sony", "assets/logos/sony.png"),
      PriceAlertBrand("Under Armour", "assets/logos/under_armour.png"),
      PriceAlertBrand("Xbox", "assets/logos/xbox.png"),
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
                                        "Store not supported at the moment. We will notify when it becomes available. "
                                            "Please try other popular stores.",
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK",
                                            style: TextStyle(color: Theme.of(context).primaryColor),))
                                    ],
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
                      child: TextButton(
                        child: Image.asset(brand.img),
                        onPressed: () => addPriceAlert(
                            context,
                            PriceAlert(PriceAlertType.BRAND_OR_STORE,
                                brand.name, null, null, brand.img, null)),
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
