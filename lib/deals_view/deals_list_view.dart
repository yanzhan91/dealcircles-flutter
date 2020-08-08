import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/constants.dart';
import 'deal_card.dart';

class DealsListView extends StatelessWidget {
  final ScrollController _scrollController;
  final List deals;
  final bool ableToLoadMore;
  final VoidCallback loadDeals;
  final VoidCallback loadDealsFuture;

  DealsListView(this._scrollController, this.deals, this.ableToLoadMore,
      this.loadDeals, this.loadDealsFuture);

  @override
  Widget build(BuildContext context) {
    return kIsWeb && MediaQuery.of(context).size.width > Constants.screenMedium
        ? _webView(context) : _appView(context);
  }

  Widget _appView(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: deals.length + (ableToLoadMore ? 1 : 0),
        itemBuilder: (BuildContext context, int index) {
          if (index < deals.length) {
            return DealsCard(deals[index]);
          } else {
            return Card(
              elevation: 4.0,
              margin:
              new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              color: Theme.of(context).primaryColor,
              child: FlatButton(
                child: Text(
                  "Load More",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onPressed: () => loadDeals(),
              ),
            );
          }
        },
      ),
      onRefresh: loadDealsFuture,
    );
  }

  Widget _webView(BuildContext context) {
    int crossCount = 1;
    double ratio = 0.7;
    if (MediaQuery.of(context).size.width >= Constants.screenFull) {
      crossCount = 8;
      ratio = 0.66 + (MediaQuery.of(context).size.width - Constants.screenFull) / Constants.screenFull;
    }  else if (MediaQuery.of(context).size.width >= Constants.screenHigh) {
      crossCount = 6;
      ratio = 0.6 + (MediaQuery.of(context).size.width - Constants.screenHigh) / Constants.screenHigh;
    } else if (MediaQuery.of(context).size.width >= Constants.screenMedium) {
      crossCount = 4;
      ratio = 0.6 + (MediaQuery.of(context).size.width - Constants.screenMedium) / Constants.screenMedium;
    }

    // width / count / 200 = 0.6

    ratio = MediaQuery.of(context).size.width / crossCount / 230;
    print(MediaQuery.of(context).size.width);
    print(ratio);

    return Container(
      child: CustomScrollView(
        slivers: [
          SliverGrid.count(
            crossAxisCount: crossCount,
            mainAxisSpacing: 2.0,
            childAspectRatio: ratio,
            children: deals.map((deal) => DealsCard(deal)).toList(),
          ),
        ],
      ),
    );
  }
}