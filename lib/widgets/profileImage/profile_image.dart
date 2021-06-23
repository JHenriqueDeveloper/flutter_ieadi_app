import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';

import '../../repositories/auth/auth_repository.dart';
import '../../style/style.dart';

class ProfileImage extends StatelessWidget {
  final double radius;
  final String profileImageUrl;
  final File profileImage;
  final Function onTap;

  const ProfileImage({
    Key key,
    @required this.radius,
    @required this.profileImageUrl,
    this.onTap,
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
          child: CircleAvatar(
            radius: radius,
            backgroundColor: LightStyle.paleta['Primaria'],
            backgroundImage: profileImage != null
                ? FileImage(profileImage)
                : profileImageUrl.isNotEmpty
                    ? CachedNetworkImageProvider(profileImageUrl)
                    : null,
            child: Container(
              height: 300,
              width: 240,
              alignment: Alignment.bottomRight,
              child: Stack(
                children: [
                  MaterialButton(
                    onPressed: !auth.isLoading ? onTap : () {}, //getImage,
                    color: LightStyle.paleta['Primaria'],
                    child: !auth.isLoading
                        ? Icon(
                            FeatherIcons.camera,
                            color: LightStyle.paleta['Branco'],
                          )
                        : CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
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
            ),
          ),
        );
      },
    );
  }
}
