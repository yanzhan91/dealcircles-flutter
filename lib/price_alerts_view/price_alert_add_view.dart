import 'package:dealcircles_flutter/price_alerts_view/price_alert.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_brand.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_product_dialog.dart';
import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';
import 'package:flutter/material.dart';

class PriceAlertAddView extends StatefulWidget {
  _PriceAlertAddViewState createState() => _PriceAlertAddViewState();
}

class _PriceAlertAddViewState extends State<PriceAlertAddView> {
  final TextEditingController textEditingController =
      new TextEditingController();
  final RegExp urlReg = new RegExp(
      r"^(http://www\.|https://www\.|http://|https://)[a-z0-9]+([\-.][a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?$");

  List<PriceAlertBrand> brands;

  @override
  void initState() {
    super.initState();
    brands = [
      PriceAlertBrand("Lego",
          "https://logos-world.net/wp-content/uploads/2020/09/LEGO-Logo.png"),
      PriceAlertBrand("Amazon",
          "https://assets.stickpng.com/thumbs/580b57fcd9996e24bc43c518.png"),
      PriceAlertBrand("Nike",
          "https://i.pinimg.com/originals/33/e6/3d/33e63d5adb0da6b303a83901c8e8463a.png"),
      PriceAlertBrand("Apple",
          "https://logos-world.net/wp-content/uploads/2020/04/Apple-Logo.png"),
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
                suffixIcon: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (urlReg
                        .allMatches(textEditingController.text)
                        .isNotEmpty) {
                      _getItem(textEditingController.text).then((PriceAlert priceAlert) =>
                          {
                            showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PriceAlertProductDialog(
                                          priceAlert, true
                                      );
                                    })
                                .then((value) {
                                  priceAlert.threshold = value;
                                  addPriceAlert(context, priceAlert);
                                })
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
              "Popular Brands and Stores",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  for (PriceAlertBrand brand in brands)
                    FlatButton(
                      child: Image.network(brand.link),
                      onPressed: () => addPriceAlert(
                          context,
                          PriceAlert(PriceAlertType.BRAND_OR_STORE, brand.name,
                              null, null, brand.link, null)),
                    ),
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

  Future<PriceAlert> _getItem(url) async {
    // TODO get item from api
    return PriceAlert(
        PriceAlertType.URL,
        'Another Test',
        '\$15.67',
        null,
        'https://images-na.ssl-images-amazon.com/images/I/91w5gn1TEHL._SL1500_.jpg',
        'link');
  }
}
