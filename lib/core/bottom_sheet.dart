import 'package:flutter/material.dart';

void showCameraOrGallerySheet(
  BuildContext context, {
  required VoidCallback onCameraSelected,
  required VoidCallback onGallerySelected,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('التقاط صورة بالكاميرا'),
              onTap: () {
                Navigator.of(context).pop(); // إغلاق الـ Bottom Sheet
                onCameraSelected();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('اختيار صورة من المعرض'),
              onTap: () {
                Navigator.of(context).pop(); // إغلاق الـ Bottom Sheet
                onGallerySelected();
              },
            ),
          ],
        ),
      );
    },
  );
}
