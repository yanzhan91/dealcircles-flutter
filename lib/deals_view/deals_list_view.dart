import 'package:dealcircles_flutter/models/screen_size.dart';
import 'package:dealcircles_flutter/services/screen_size_service.dart';
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
    return ScreenSizeService.compareSize(context, ScreenSize.SMALL)
        ? _appView(context) : _webView(context);
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
            return _loadMoreCard(context);
          }
        },
      ),
      onRefresh: loadDealsFuture,
    );
  }

  Widget _webView(BuildContext context) {
    int crossCount = 1;
    if (ScreenSizeService.compareSize(context, ScreenSize.FULL)) {
      crossCount = 7;
    }  else if (ScreenSizeService.compareSize(context, ScreenSize.HIGH)) {
      crossCount = 4;
    } else if (ScreenSizeService.compareSize(context, ScreenSize.MEDIUM)) {
      crossCount = 4;
    }

    double ratio = MediaQuery.of(context).size.width / crossCount / 380;

    List<Widget> widgets = List();
    widgets.addAll(deals.map((deal) => DealsCard(deal)).toList());
    widgets.add(_loadMoreCard(context));
    EdgeInsets edgeInsets;
    if (ScreenSizeService.compareSize(context, ScreenSize.MEDIUM)) {
      edgeInsets = EdgeInsets.only(left: 0, right: 0);
    } else {
      edgeInsets = EdgeInsets.only(left: 100, right: 100);
    }
    return Container(
      child: Padding(
        padding: edgeInsets,
        child: CustomScrollView(
          slivers: [
            SliverGrid.count(
              crossAxisCount: crossCount,
              mainAxisSpacing: 2.0,
              childAspectRatio: ratio,
              children: widgets,
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadMoreCard(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
}