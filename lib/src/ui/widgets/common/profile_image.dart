import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mboa_connect/src/ui/widgets/common/online_indicator.dart';
import 'package:mboa_connect/styles/colors.dart';

class ProfilePicture extends StatelessWidget {
  final String photoUrl;
  final bool online;

  const ProfilePicture({required this.photoUrl, this.online = false});

  Widget build(BuildContext buildContext) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(126.0),
            child: photoUrl != null
                ? Image.network(
              photoUrl,
              width: 126,
              height: 126,
              fit: BoxFit.fill,
            )
                : Icon(
              Icons.group_rounded,
              size: 35,
              color: kPrimary,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: online ? OnlineIndicator() : Container(),
          )
        ],
      ),
    );
  }
}