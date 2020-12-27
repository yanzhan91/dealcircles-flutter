import 'package:dealcircles_flutter/price_alerts_view/price_alert_type.dart';
import 'package:flutter/material.dart';

class PriceAlertAddView extends StatelessWidget {

  final TextEditingController textEditingController = new TextEditingController();
  final RegExp urlReg = new RegExp(r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$");

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
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_forward_rounded),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      if (urlReg.allMatches(textEditingController.text).isNotEmpty) {
                        addPriceAlert(context, PriceAlertType.URL, textEditingController.text);
                      } else {
                        addPriceAlert(context, PriceAlertType.KEYWORD, textEditingController.text);
                      }
                    },
                  )),
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
                FlatButton(
                  child: Image.network(
                      "https://www.lego.com/cdn/cs/set/assets/blt445eec351be85ac6/Lego-logo.jpg?format=jpg&quality=80&height=55&dpr=2"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Lego"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://assets.stickpng.com/thumbs/580b57fcd9996e24bc43c518.png"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Amazon"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://i.pinimg.com/originals/33/e6/3d/33e63d5adb0da6b303a83901c8e8463a.png"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Nike"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://logos-world.net/wp-content/uploads/2020/04/Apple-Logo.png"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Apple"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://www.freepnglogos.com/uploads/microsoft-logo-png-transparent-background-1.png"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Microsoft"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://assets.stickpng.com/images/580b57fcd9996e24bc43c51f.png"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Google"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://www.lego.com/cdn/cs/set/assets/blt445eec351be85ac6/Lego-logo.jpg?format=jpg&quality=80&height=55&dpr=2"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Lego"),
                ),
                FlatButton(
                  child: Image.network(
                      "https://www.lego.com/cdn/cs/set/assets/blt445eec351be85ac6/Lego-logo.jpg?format=jpg&quality=80&height=55&dpr=2"),
                  onPressed: () => addPriceAlert(context, PriceAlertType.BRAND_OR_STORE, "Lego"),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void addPriceAlert(context, PriceAlertType type, String text) {
    print(type);
    Navigator.pop(context, "test");
  }
}
