import 'dart:io';
import 'dart:typed_data';

import 'package:ethosv2/common/extension/custom_theme_extension.dart';
import 'package:ethosv2/common/helper/show_alert_dialog.dart';
import 'package:ethosv2/common/utils/coloors.dart';
import 'package:ethosv2/common/widgets/custom_elevated_button.dart';
import 'package:ethosv2/common/widgets/custom_icon_button.dart';
import 'package:ethosv2/common/widgets/short_h_bar.dart';
import 'package:ethosv2/feature/auth/pages/img_picker_page.dart';
import 'package:ethosv2/feature/auth/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({super.key});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();

}
class _UserInfoPageState extends State<UserInfoPage> {
  File? imageCamera;
  Uint8List? imageGallery;

  imagePickerTypeBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ShortHBar(),
              Row(
                children: [
                  const SizedBox(width: 20),
                  const Text('profile photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  CustomIconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.close,
                  ),
                  const SizedBox(width: 15),
                ],
              ),
              Divider(color: context.theme.greyColor!.withOpacity(0.3),),
              const SizedBox(height: 5,),
              Row(
                children: [
                  const SizedBox(width: 20,),

                  imagePickerIcon(
                    onTap: pickImageFromCamera,
                    icon: Icons.camera_alt_rounded,
                    text: 'Camera',
                  ),
                  const SizedBox(width: 15,),
                  imagePickerIcon(
                    onTap: () async{
                      Navigator.pop(context);
                      final image = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ImagePickerPage()
                      ),
                      );
                      if (image == null) return;
                      setState(() {
                        imageGallery = image;
                        imageCamera = null;
                      });

                    },
                    icon: Icons.photo_camera_back_rounded,
                    text: 'Gallery',
                  ),
                ],
              ),
              const SizedBox(height: 15,),

            ],
          );
        }
    );
  }

pickImageFromCamera()async{
    Navigator.of(context).pop();
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      setState(() {
        imageCamera = File(image!.path);
        imageGallery = null;
      });
    } catch (e){
      showAlertDialog(context: context, message: e.toString());
    }
}

imagePickerIcon({
    required VoidCallback onTap,
    required IconData icon,
    required String text,
}){
    return Column(
      children: [
        CustomIconButton(
            onPressed: onTap,
            icon: icon,
            iconColor: Coloors.greenDark,
            minWidth: 50,
            border: Border.all(
              color: context.theme.greyColor!.withOpacity(.2),
              width: 1,
            ),
        ),
        const SizedBox(height: 5,),
        Text(text, style: TextStyle(color: context.theme.greyColor),),
      ],
    );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
          title: Text(
            "Profile info",
            style: TextStyle(
            color: context.theme.authAppbarTextColor,
          ),
          ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Text('Please provide your name and an optional profile photo',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.theme.greyColor,
            ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.theme.photoIconBgColor,
                border: Border.all(
                  color: imageCamera == null && imageGallery == null
                      ? Colors.transparent
                      : context.theme.greyColor!.withOpacity(0.4),
                ),
                image: imageCamera != null || imageGallery != null
                    ?DecorationImage(
                          fit: BoxFit.cover,
                            image: imageGallery != null
                                ? MemoryImage(imageGallery!) as ImageProvider
                                : FileImage(imageCamera!),
                  )
                  : null,
              ),

              child: Padding(
                padding: const EdgeInsets.only(bottom: 3, right: 3),
                child: Icon(
                  Icons.add_a_photo_rounded,
                  size: 48,
                  color:imageCamera == null && imageGallery == null
                      ? context.theme.photoIconColor
                      : Colors.transparent,

                ),
                ),
              ),

            const SizedBox(height: 40),
            Row(
              children: [
                const SizedBox(width: 20,),
                const Expanded(
                  child:  CustomTextField(
                  hintText: 'Type your name here',
                  textAlign: TextAlign.left,
                  autoFocus: true,
                ),
                ),
                const SizedBox(width: 10,),
                Icon(
                  Icons.emoji_emotions_outlined,
                  color: context.theme.photoIconColor,
                ),
                const SizedBox(width: 20,),
              ],
            )
          ]
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CustomElevatedButton(
          onPressed: (){},
          text: 'NEXT',
          buttonWidth: 90,
      ),

    );
  }
}

