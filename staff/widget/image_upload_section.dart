import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/images.dart';
import 'package:flutter/material.dart';

class ImageUploadSection extends StatefulWidget {
  const ImageUploadSection({super.key});

  @override
  State<ImageUploadSection> createState() => _ImageUploadSectionState();
}

class _ImageUploadSectionState extends State<ImageUploadSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(Dimensions.space5),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: 75,
        width: 75,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.space5),
        decoration: const BoxDecoration(shape: BoxShape.circle),
        child: Stack(
          children: [
            Container(
              height: 55,
              width: 55,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(MyImages.profile),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 2,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 18,
                  width: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).cardColor,
                    size: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
