import 'package:cpad_assignment/models/mom.dart';
import 'package:cpad_assignment/provider/mom_provider.dart';
import 'package:cpad_assignment/services/mom_service.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/custom_dialog.dart';
import 'package:cpad_assignment/ui/widgets/custom_expansion_tile.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class MOMExpansionTile extends StatefulWidget {
  final MOM mom;

  const MOMExpansionTile({required this.mom});

  @override
  _MOMExpansionTileState createState() => _MOMExpansionTileState();
}

class _MOMExpansionTileState extends State<MOMExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      titlePadding: EdgeInsets.symmetric(vertical: 10),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.title, size: 18, color: kPrimaryColor),
              SizedBox(width: SizeConfig.blockSizeHorizontal),
              Text(
                widget.mom.title ?? '-',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal),
          Row(
            children: [
              Icon(Icons.date_range, size: 18, color: kPrimaryColor),
              SizedBox(width: SizeConfig.blockSizeHorizontal),
              Text(
                Utility.getTimeStamp(
                    unformattedDate: widget.mom.date!, showTime: false),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.mom.content ?? '-',
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
        if (AppData.isAdmin())
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap: () {
                showCustomDialog(
                  context: context,
                  title: 'MOM',
                  description: 'Are you sure you want to delete?',
                  rightButtonText: 'Delete',
                  onRightButton: () {
                    Provider.of<MOMProvider>(context, listen: false)
                        .deleteMOM(widget.mom);
                    Get.back();
                    MOMService.deleteMOMById(id: widget.mom.id!).then((_) {
                      Utility.showToast('MOM deleted');
                    }).catchError((e) {
                      Get.back();
                      print(e);
                      Provider.of<MOMProvider>(context, listen: false)
                          .addMOM(widget.mom);
                      Utility.showSnackBar(
                          isError: true,
                          message:
                              'Something went wrong while deleting. Please try again.');
                    });
                  },
                );
              },
              child: Icon(Icons.delete_outline, color: Colors.red),
            ),
          ),
        SizedBox(height: 14)
      ],
    );
  }
}
