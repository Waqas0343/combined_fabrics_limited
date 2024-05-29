import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Banners extends StatelessWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RxInt current = RxInt(0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final carouselHeight = constraints.maxWidth * (8 / 16);
        bool isDesktop = constraints.maxWidth > 600;
        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                onPageChanged: (index, reason) {
                  current(index);
                },
                aspectRatio: isDesktop ? 16 / 3.5 : 16 / 8, // Adjust aspect ratio for desktop
                autoPlayInterval: const Duration(seconds: 16),
                autoPlayAnimationDuration: const Duration(seconds: 3),
                viewportFraction: 1.0,
              ),
              items: images
                  .map(
                    (imagePath) => GestureDetector(
                  child: Image.asset(
                    imagePath,
                    width: Get.width,
                    height: isDesktop ? carouselHeight / 2 : carouselHeight,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  List<String> get images => [
    'assets/images/banners/super-app.png',
    'assets/images/banners/banner4.png',
    'assets/images/banners/banner3.png',
  ];
}
