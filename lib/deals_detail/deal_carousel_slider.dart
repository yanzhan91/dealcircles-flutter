import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealcircles_flutter/models/screen_size.dart';
import 'package:dealcircles_flutter/services/screen_size_service.dart';
import 'package:flutter/material.dart';

class DealCarouselSlider extends StatefulWidget {
  final List images;
  final String img;

  const DealCarouselSlider(this.images, this.img);

  @override
  _DealCarouselSliderState createState() => _DealCarouselSliderState();
}

class _DealCarouselSliderState extends State<DealCarouselSlider> {

  int _current = 0;

  CarouselController _buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScreenSizeService.compareSize(context, ScreenSize.SMALL)
            ? _createAppCarouselSlider(context) : _createWebCarouselSlider(context),
        _createPaginationIcons()
      ],
    );
  }

  Widget _createAppCarouselSlider(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: max(widget.images.length, 1),
      itemBuilder: (BuildContext context, int itemIndex) => Container(
        child: Image.network(
          widget.images.length > 0 ? widget.images[itemIndex] : widget.img,
          fit: BoxFit.contain,
        ),
      ),
      carouselController: _buttonCarouselController,
      options: CarouselOptions(
        height: MediaQuery.of(context).size.width,
        autoPlay: false,
        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        scrollDirection: Axis.horizontal,
        onPageChanged: (index, reason) {
          setState(() {
            _current = index;
          });
        },
      ),
    );
  }

  Widget _createWebCarouselSlider(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IgnorePointer(
          ignoring: true,
          child: CarouselSlider.builder(
            itemCount: max(widget.images.length, 1),
            itemBuilder: (BuildContext context, int itemIndex) => Container(
              child: Image.network(
                widget.images.length > 0 ? widget.images[itemIndex] : widget.img,
                fit: BoxFit.contain,
              ),
            ),
            carouselController: _buttonCarouselController,
            options: CarouselOptions(
              autoPlay: false,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: () => _buttonCarouselController.previousPage(),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: () => _buttonCarouselController.nextPage(),
          ),
        )
      ],
    );
  }

  Widget _createPaginationIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.images.map((url) {
        int index = widget.images.indexOf(url);
        return Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _current == index
                ? Theme.of(context).primaryColor
                : Color.fromRGBO(0, 0, 0, 0.25),
          ),
        );
      }).toList(),
    );
  }
}