import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final List categories;
  final Function({String sort, String category, String search}) setFilters;

  final String sort;
  final String category;
  final String search;

  final TextEditingController _textEditingController =
      new TextEditingController();

  CustomSliverAppBar({
    @required this.setFilters,
    @required this.categories,
    @required this.sort,
    @required this.category,
    @required this.search,
  }) {
    _textEditingController.text = this.search;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
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
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Sort:',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 18,
                ),
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  _createSortButton(context, 'Newest', 'newest'),
                  _createSortButton(context, 'Most Popular', 'popular'),
                  _createSortButton(context, 'Discount', 'discount'),
                  _createSortButton(context, 'Price Low to High', 'low_high'),
                  _createSortButton(context, 'Price High to Low', 'high_low'),
                ],
              ),
            ],
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Category:',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Wrap(
                    children: [
                      _createCategoryButton(context, 'All', null),
                      for (String category in categories)
                        _createCategoryButton(context, category, category),
                    ],
                  )
                )
              ],
            ),
        ],
      ),
    );
  }

  Widget _createSortButton(BuildContext context, String sortName, String sortValue) {
    return FlatButton(
      child: Text(
        sortName,
        style: TextStyle(
            fontSize: 16,
            color: sort == sortValue
                ? Theme.of(context).primaryColor : Colors.black54
        ),
      ),
      onPressed: () {
        setFilters(sort: sortValue, category: category, search: search);
      },
    );
  }

  Widget _createCategoryButton(BuildContext context, String categoryName, String categoryValue) {
    if (categoryValue == 'All') {
      categoryValue = null;
    }
    return FlatButton(
      child: Text(
        categoryName,
        style: TextStyle(
            fontSize: 16,
            color: category == categoryValue
                ? Theme.of(context).primaryColor : Colors.black54
        ),
      ),
      onPressed: () {
        setFilters(sort: sort, category: categoryValue, search: null);
      },
    );
  }
}
