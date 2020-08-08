import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
    return kIsWeb ? _webView(context) : _appView(context);
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
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverGrid.count(
            crossAxisCount: MediaQuery.of(context).size.width >= 800 ? 7 : 1,
            mainAxisSpacing: 2.0,
            childAspectRatio: .7,
            children: deals.map((deal) => DealsCard(deal)).toList(),
          ),
        ],
      ),
    );
  }
}