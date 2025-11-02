import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutex_admin/common/components/snack_bar/show_custom_snackbar.dart';
import 'package:flutex_admin/core/utils/color_resources.dart';
import 'package:flutex_admin/core/utils/local_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutex_admin/core/utils/style.dart';

class DownloadingDialog extends StatefulWidget {
  final String url;
  final String fileName;
  final bool isPdf;
  final bool isImage;
  const DownloadingDialog(
      {super.key,
      required this.isImage,
      required this.url,
      this.isPdf = true,
      required this.fileName});

  @override
  DownloadingDialogState createState() => DownloadingDialogState();
}

class DownloadingDialogState extends State<DownloadingDialog> {
  int _total = 0, _received = 0;
  late http.StreamedResponse _response;
  //File? _image;
  final List<int> _bytes = [];

  Future<void> _downloadFile() async {
    _response =
        await http.Client().send(http.Request('GET', Uri.parse(widget.url)));
    _total = _response.contentLength ?? 0;

    _response.stream.listen((value) {
      setState(() {
        _bytes.addAll(value);
        _received += value.length;
      });
    }).onDone(() async {
      final file = File(
          '${(await getApplicationDocumentsDirectory()).path}/fiiiiile.png');
      File savedFile = await file.writeAsBytes(_bytes);
      Get.back();
      CustomSnackBar.success(successList: [
        '${LocalStrings.fileDownloadedSuccess.tr}: ${savedFile.path.toString()}'
      ]);
      //setState(() {
      //  _image = file;
      //});
    });
  }

  _saveImage() async {
    var response = await Dio()
        .get(widget.url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: widget.fileName);

    try {
      dynamic value = result['isSuccess'];
      if (value.toString() == 'true') {
        Get.back();
        CustomSnackBar.success(
            successList: [(LocalStrings.fileDownloadedSuccess.tr)]);
      } else {
        Get.back();
        dynamic errorMessage = result['errorMessage'];
        CustomSnackBar.error(errorList: [errorMessage]);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      Get.back();
      CustomSnackBar.error(errorList: [LocalStrings.requestFail.tr]);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.isImage) {
      _saveImage();
    } else {
      _downloadFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorResources.getCardBgColor(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: SpinKitThreeBounce(
                    color: ColorResources.primaryColor,
                    size: 20.0,
                  ))),
          Visibility(
              visible: !widget.isImage,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                      '${LocalStrings.downloading.tr} ${_received ~/ 1024}/${_total ~/ 1024} ${'KB'.tr}',
                      style: regularDefault),
                ],
              ))
        ],
      ),
    );
  }
}
