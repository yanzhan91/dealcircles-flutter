import 'package:dealcircles_flutter/models/screen_size.dart';
import 'package:dealcircles_flutter/services/screen_size_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterDrawer extends StatelessWidget {
  final List categories;
  final Function({String sort, String category, String search}) setFilters;

  final String sort;
  final String category;
  final String search;

  final TextEditingController _textEditingController = new TextEditingController();

  FilterDrawer({
    @required this.categories,
    @required this.setFilters,
    @required this.sort,
    @required this.category,
    @required this.search
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          (ScreenSizeService.compareSize(context, ScreenSize.SMALL) ? 0.6 : 0.25),
      child: Drawer(
        child: ListView(children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
            child: TextField(
              controller: _textEditingController,
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
                    _textEditingController.clear();
                    setFilters(sort: sort, category: category, search: null);
                  },
                )
                    : null,
              ),
              onEditingComplete: () {
                if (_textEditingController.text == null || _textEditingController.text == '') {
                  _textEditingController.clear();
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                } else {
                  setFilters(sort: sort, category: null, search: _textEditingController.text);
                  Navigator.pop(context);
                }
              },
            ),
          ),
          if ((sort != null && sort.isNotEmpty && sort != "newest") ||
          (category != null && category.isNotEmpty && category != "All") ||
          (search != null && search.isNotEmpty))
            ListTile(
            title: Text(
              "Clear",
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              setFilters(sort: 'newest', category: null, search: null);
              Navigator.pop(context);
            },
          ),
          addDrawerListTileHeader(context, "Sort"),
          addSortListTile(context, 'Newest', 'newest'),
          addSortListTile(context, 'Most Popular', 'popular'),
          addSortListTile(context, 'Discount', 'discount'),
          addSortListTile(context, 'Price Low to High', 'low_high'),
          addSortListTile(context, 'Price High to Low', 'high_low'),
          addDrawerListTileHeader(context, "Category"),
          addCategoryListTile(context, 'All', null),
          for (String category in categories)
            addSortListTile(context, category, category),
        ]),
      ),
    );
  }

  ListTile addDrawerListTileHeader(BuildContext context, String name) {
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

  ListTile addSortListTile(BuildContext context, String name, String value) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontSize: 16),
      ),
      selected: sort == value,
      onTap: () {
        setFilters(sort: value, category: category, search: search);
        Navigator.pop(context);
      },
    );
  }

  ListTile addCategoryListTile(BuildContext context, String name, String value) {
    if (value == 'All') {
      value = null;
    }
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontSize: 16),
      ),
      selected: category == value,
      onTap: () {
        setFilters(sort: sort, category: value, search: null);
        Navigator.pop(context);
      },
    );
  }
}