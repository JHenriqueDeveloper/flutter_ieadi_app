import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../../style/style.dart';

class UploadImage extends StatelessWidget {
  final double radius;
  final String imageUrl;
  final File image;
  final Function onTap;
  final bool isLoading;

  UploadImage({
    this.radius,
    this.imageUrl,
    this.image,
    this.onTap,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: GestureDetector(
        onTap: isLoading ? () {} : onTap,
        child: CircleAvatar(
          radius: radius,
          backgroundColor: LightStyle.paleta['Primaria'],
          backgroundImage: image != null
              ? FileImage(image)
              : imageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(imageUrl)
                  : null,
          child: !isLoading
              ? Icon(
                  FeatherIcons.camera,
                  color: LightStyle.paleta['Branco'],
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
        ),
      ),
    );
  }
}

/*
class ProfileImage extends StatelessWidget {
  final double radius;
  final String profileImageUrl;
  final File profileImage;
  final Function onTap;
  final Function onPressed;

  const ProfileImage({
    Key key,
    @required this.radius,
    @required this.profileImageUrl,
    this.onTap,
    this.onPressed,
    this.profileImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 300,
          margin: const EdgeInsets.symmetric(vertical: 32),
          child: GestureDetector(
            onTap: onPressed ?? null,
                      child: CircleAvatar(
              radius: radius,
              backgroundColor: LightStyle.paleta['Primaria'],
              backgroundImage: profileImage != null
                  ? FileImage(profileImage)
                  : profileImageUrl.isNotEmpty
                      ? CachedNetworkImageProvider(profileImageUrl)
                      : null,
              child: this.onTap != null
                  ? Container(
                      height: 300,
                      width: 240,
                      alignment: Alignment.bottomRight,
                      child: Stack(
                        children: [
                          MaterialButton(
                            onPressed:
                                !auth.isLoading ? onTap : () {}, //getImage,
                            color: LightStyle.paleta['Primaria'],
                            child: !auth.isLoading
                                ? Icon(
                                    FeatherIcons.camera,
                                    color: LightStyle.paleta['Branco'],
                                  )
                                : CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                            padding: EdgeInsets.all(16),
                            shape: CircleBorder(),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 58, top: 44),
                            child: Badge(
                              showBadge: profileImageUrl != null
                                  ? profileImageUrl != ''
                                      ? false
                                      : true
                                  : true,
                              elevation: 2,
                              //padding: const EdgeInsets.all(3),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ),
          ),
        );
      },
    );
  }
}
*/
