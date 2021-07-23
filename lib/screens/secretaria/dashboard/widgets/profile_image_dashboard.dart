import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../repositories/repositories.dart';
import '../../../../style/style.dart';

class ProfileImageDashboard extends StatelessWidget {
  final Function onTap;

  const ProfileImageDashboard({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(
      builder: (_, auth, __) {
        return Container(
          margin: EdgeInsets.only(right: 8.sp),
          padding: const EdgeInsets.all(1.0),
          decoration: new BoxDecoration(
            color: LightStyle.paleta['Branco'],
            shape: BoxShape.circle,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              backgroundColor: LightStyle.paleta['Primaria'],
              backgroundImage: auth.user.profileImageUrl.isNotEmpty
                  ? CachedNetworkImageProvider(auth.user?.profileImageUrl)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
