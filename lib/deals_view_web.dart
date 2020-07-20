import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Deal.dart';
import 'api_service.dart';
import 'deal_details.dart';
import 'theme_colors.dart';

class DealsViewWeb extends StatefulWidget {
  @override
  _DealsviewWebState createState() => _DealsviewWebState();
}

class _DealsviewWebState extends State<DealsViewWeb> {
  List deals;
  List categories;
  bool loading = false;
  bool ableToLoadMore = true;
  String sort = "newest";
  String category;
  String search;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController _scrollController = new ScrollController();
  TextEditingController _textEditingController = new TextEditingController();

  @override
  void initState() {
    deals = [];
    categories = [];
    loadDeals();
    loadCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.1,
        title: GestureDetector(
          onTap: () => _scrollController.animateTo(0,
              duration: Duration(seconds: 1), curve: Curves.ease),
          child: Text(
            'DealCircles',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
          ),
        ),
        leading: Image.asset("assets/logo.png"),
        backgroundColor: Theme.of(context).primaryColor,
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(
//              Icons.tune,
//              color: Colors.white,
//              size: 28,
//            ),
//            onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
//          )
//        ],
      ),
//      endDrawer: SizedBox(
//        width: MediaQuery.of(context).size.width * 0.2,
//        child: Drawer(
//          child: generateFilterListView(context),
//        ),
//      ),
      body: generateListview(context),
    );
  }

  void setFilters({String sort, String category, String search}) {
    this.sort = sort;
    this.category = category;
    this.search = search;

    if (search == null) {
      _textEditingController.clear();
    }
  }

  ListTile addDrawerListTileHeader(String name) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
          fontSize: 18,
        ),
      ),
      enabled: false,
    );
  }

  ListTile addDrawerListTile(String name, bool selected, Function setValue) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontSize: 16),
      ),
      selected: selected,
      onTap: () {
        deals.clear();
        setValue();
        loadDeals();
        Navigator.pop(context);
      },
    );
  }

  Widget generateFilterListView(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(
      Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: TextField(
          controller: _textEditingController,
          onChanged: (text) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: "Search",
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
            suffixIcon: _textEditingController.text.length > 0
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _textEditingController.clear();
                        search = null;
                      });
                    },
                  )
                : null,
          ),
          onEditingComplete: () {
            search = _textEditingController.text;
            if (search == null || search == '') {
              search = null;
              _textEditingController.clear();
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            } else {
              category = null;
              deals.clear();
              loadDeals();
              Navigator.pop(context);
            }
          },
        ),
      ),
    );

    if ((sort != null && sort.isNotEmpty && sort != "newest") ||
        (category != null && category.isNotEmpty && category != "All") ||
        (search != null && search.isNotEmpty)) {
      widgets.add(
        ListTile(
          title: Text(
            "Clear",
            style: TextStyle(fontSize: 16),
          ),
          onTap: () {
            deals.clear();
            setFilters(sort: "newest", category: null, search: null);
            loadDeals();
            Navigator.pop(context);
          },
        ),
      );
    }

    widgets.add(addDrawerListTileHeader("Sort"));
    widgets.add(addDrawerListTile("Newest", sort == "newest",
        () => setFilters(sort: "newest", category: category, search: search)));
    widgets.add(addDrawerListTile("Most Popular", sort == "popular",
        () => setFilters(sort: "popular", category: category, search: search)));
    widgets.add(addDrawerListTile(
        "Discount",
        sort == "discount",
        () =>
            setFilters(sort: "discount", category: category, search: search)));
    widgets.add(addDrawerListTile(
        "Price Low to High",
        sort == "low_high",
        () =>
            setFilters(sort: "low_high", category: category, search: search)));
    widgets.add(addDrawerListTile(
        "Price High to Low",
        sort == "high_low",
        () =>
            setFilters(sort: "high_low", category: category, search: search)));

    widgets.add(addDrawerListTileHeader("Categories"));
    widgets.add(addDrawerListTile("All", category == null,
        () => setFilters(category: null, search: null, sort: sort)));

    for (String c in categories) {
      widgets.add(addDrawerListTile(c, category == c,
          () => setFilters(category: c, search: null, sort: sort)));
    }

    return new ListView(children: widgets);
  }

  Widget generateListview(BuildContext context) {
    if (deals.length > 0) {
      return Container(
        child: CustomScrollView(
          slivers: [
            SliverGrid.count(
              crossAxisCount: MediaQuery.of(context).size.width >= 800 ? 8 : 1,
              mainAxisSpacing: 2.0,
              childAspectRatio: .7,
              children: deals.map((deal) => makeCard(deal)).toList(),
            ),
          ],
        ),
      );
    } else if (loading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Icon(
                Icons.remove_circle_outline,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                "No Results Found",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 20),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).primaryColor,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Check out latest deals"),
                ),
                textColor: Colors.white,
                onPressed: () {
                  setFilters(sort: "newest");
                  loadDeals();
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget makeCard(Deal deal) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 4.0,
          child: InkWell(
            onTap: () {
              ApiService.addClicks(deal);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DealDetails(deal)));
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: makeListTile(deal),
            ),
          ),
        ),
        addNewFlag(deal)
      ],
    );
  }

  Widget addNewFlag(Deal deal) {
    DateTime now = DateTime.now().toUtc();
    if (now.year == deal.createDate.year &&
        now.month == deal.createDate.month &&
        now.day == deal.createDate.day) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Icon(
            Icons.fiber_new,
            color: ThemeColors.primary_color,
          ),
        ),
      );
    } else {
      return new Container();
    }
  }

  Widget makeListTile(Deal deal) {
    List<Widget> priceItems = [];
    priceItems.add(Text(
      deal.salePrice,
      style: TextStyle(
        color: deal.valid ? ThemeColors.primary_color : Colors.black54,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ));
    priceItems.add(Text(
      " | ${deal.discount}% Off" + (deal.valid ? "" : " | "),
      style: TextStyle(color: Colors.black54, fontSize: 16),
    ));
    if (!deal.valid) {
      priceItems.add(Text(
        "Expired",
        style: TextStyle(color: Colors.red, fontSize: 16),
      ));
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Column(
        children: <Widget>[
          Image.network(
            deal.img,
            fit: BoxFit.contain,
            height: 100,
            width: 100,
          ),
          SizedBox(height: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      deal.brand,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      deal.name,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      maxLines: 4,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: priceItems,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void loadDeals() async {
    setState(() {
      loading = true;
    });

    List newDeals =
        await ApiService.loadDeals(sort, category, search, deals.length);

//    List newDeals = [
//      Deal(
//          '1',
//          'test, test, test, test, test, test, test, test, test, test',
//          'Brand',
//          '12.99',
//          '5.99',
//          30,
//          'https://s.yimg.com/uu/api/res/1.2/DdytqdFTgtQuxVrHLDdmjQ--~B/aD03MTY7dz0xMDgwO3NtPTE7YXBwaWQ9eXRhY2h5b24-/https://media-mbst-pub-ue1.s3.amazonaws.com/creatr-uploaded-images/2019-11/7b5b5330-112b-11ea-a77f-7c019be7ecae',
//          'Store',
//          'Link',
//          DateTime.now(),
//          true)
//    ];

    if (newDeals.length == 0) {
      setState(() {
        ableToLoadMore = false;
        loading = false;
      });
    } else {
      setState(() {
        ableToLoadMore = newDeals.length == 30;
        deals.addAll(newDeals);
        loading = false;
      });
    }
  }

  Future<void> loadDealsFuture() async {
    deals.clear();
    loadDeals();
  }

  void loadCategories() async {
    List temp = await ApiService.loadCategories();
    setState(() {
      categories = temp;
    });
  }
}
