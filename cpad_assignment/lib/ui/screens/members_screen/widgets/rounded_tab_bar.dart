import 'package:cpad_assignment/provider/members_provider.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundedTabBar extends StatelessWidget {
  final TabController tabController;
  final ValueChanged<int>? onTap;

  const RoundedTabBar({required this.tabController, required this.onTap});

  @override
  Widget build(BuildContext context) {
    MembersProvider membersProvider = Provider.of<MembersProvider>(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Card(
        color: kButtonColor,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: TabBar(
            unselectedLabelColor: Colors.white,
            onTap: onTap,
            controller: tabController,
            indicator: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(30),
            ),
            labelColor: kPrimaryColor,
            tabs: [
              Tab(
                child: Text(
                  "Pending(${membersProvider.pendingMembersCount})",
                  overflow: TextOverflow.ellipsis,
                  // style: TextStyle(color: kPrimaryColor),
                ),
              ),
              Tab(
                child: Text(
                  "Accepted(${membersProvider.acceptedMembersCount})",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // color: kPrimaryColor,
                      ),
                ),
              ),
              Tab(
                child: Text(
                  "Rejected(${membersProvider.rejectedMembersCount})",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      // color: kPrimaryColor,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
