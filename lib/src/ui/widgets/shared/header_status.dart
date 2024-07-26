import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mboa_connect/src/ui/widgets/common/profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String photoUrl;
  final bool online;
  final String description;
  final String typingNotification;

  const HeaderStatus(
      this.username,
      this.photoUrl,
      this.online,
      {
        this.description = "",
        this.typingNotification = "",
      }
  );


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfilePicture(
            photoUrl: photoUrl,
            online: online,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Text(
                  username.trim(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: typingNotification == null
                    ? Text(
                  online ? 'online' : description,
                  style: Theme.of(context).textTheme.bodySmall,
                )
                    : Text(
                  typingNotification,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

}