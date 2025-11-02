import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/dimensions.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutex_admin/core/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required this.searchController,
    required this.title,
    required this.onTap,
  });
  final TextEditingController searchController;
  final String title;
  final VoidCallback onTap;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(Dimensions.space15),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.defaultRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: regularSmall.copyWith(
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.color!.withValues(alpha: 0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: Dimensions.space5),
                    SizedBox(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        cursorColor: Theme.of(context).secondaryHeaderColor,
                        style: regularSmall.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        keyboardType: TextInputType.text,
                        controller: widget.searchController,
                        decoration: InputDecoration(
                          hintText: LocalStrings.enterName.tr,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 15,
                          ),
                          hintStyle: regularSmall.copyWith(
                            color: ColorResources.hintTextColor,
                          ),
                          filled: true,
                          fillColor: ColorResources.transparentColor,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorResources.colorGrey,
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: ColorResources.colorGrey,
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!
                                  .withValues(alpha: 0.5),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimensions.space10),
              InkWell(
                onTap: widget.onTap,
                child: Container(
                  height: 45,
                  width: 45,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  child: const Icon(
                    Icons.search_outlined,
                    color: ColorResources.colorWhite,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
