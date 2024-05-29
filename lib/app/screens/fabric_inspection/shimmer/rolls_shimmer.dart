import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../app_assets/styles/my_colors.dart';

class ShimmerForRollList extends StatelessWidget {
  const ShimmerForRollList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 800.0;
    double height = 12.0;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      shrinkWrap: true,
      padding: const EdgeInsets.only(
        top: 16,
      ),
      itemBuilder: (BuildContext context, int index) => Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Shimmer.fromColors(
          baseColor: MyColors.shimmerBaseColor,
          highlightColor: MyColors.shimmerHighlightColor,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.all(
                  10.0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 12,
                      ),
                      child: MyShimmer(
                        width: width + 30,
                        height: height,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 12,
                      ),
                      child: MyShimmer(
                        width: width + 30,
                        height: height,
                      ),
                    ),
                  ],
                ),
                trailing: MyShimmer(
                  width: 15.0,
                  height: height + 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      width: 40.0,
      height: 32.0,
    );
  }
}

class MyShimmer extends StatelessWidget {
  final double? width;
  final double? height;

  const MyShimmer({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        10.0,
      ),
      width: width,
      height: height,
      color: Colors.white,
    );
  }
}
