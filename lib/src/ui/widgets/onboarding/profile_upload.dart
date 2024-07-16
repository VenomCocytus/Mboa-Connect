import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mboa_connect/src/states_management/onboarding/profile_picture_cubit.dart';
import 'package:mboa_connect/styles/colors.dart';
import 'package:mboa_connect/styles/themes.dart';

class ProfileUplaod extends StatelessWidget {
   const ProfileUplaod();

   @override
   Widget build(BuildContext buildContext) {
     return Container(
       height: 126.0,
       width: 126.0,
       child: Material(
         color: isLightTheme(buildContext) ? Color(0xFFF2F2F2) : Color(0xFF211E1E),
         borderRadius: BorderRadius.circular(126.0),
         child: InkWell(
           borderRadius: BorderRadius.circular(126.0),
           onTap: () async {
             await buildContext.read<ProfilePictureCubit>().getImage();
           },
           child: Stack(
             fit: StackFit.expand,
             children: [
               CircleAvatar(
                 backgroundColor: Colors.transparent,
                 child: BlocBuilder<ProfilePictureCubit, File?>(
                   builder: (context, state) {
                     return state == null
                         ? Icon(Icons.person_outline_rounded,
                         size: 126.0,
                         color: isLightTheme(context)
                             ? kIconLight
                             : Colors.black)
                         : ClipRRect(
                       borderRadius: BorderRadius.circular(126.0),
                       child: Image.file(state,
                           width: 126, height: 126, fit: BoxFit.fill),
                     );
                   },
                 ),
               ),
               Align(
                 alignment: Alignment.bottomRight,
                 child: Icon(
                   Icons.add_circle_rounded,
                   color: kPrimary,
                   size: 38.0,
                 ),
               )
             ],
           ),
         ),
       ),
     );
   }
}