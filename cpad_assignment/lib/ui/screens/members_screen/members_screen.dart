import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/provider/members_provider.dart';
import 'package:cpad_assignment/services/user_service.dart';
import 'package:cpad_assignment/ui/screens/members_screen/widgets/member_card.dart';
import 'package:cpad_assignment/ui/screens/members_screen/widgets/rounded_tab_bar.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/error_widget.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:get/get.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  _MembersScreenState createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  late Future _getAllUsers;

  Future<void> _getUsers() async {
    setState(() {
      _getAllUsers = UserService.getAllUsers();
      _getAllUsers.then((userList) => populateMemberProviderList(userList));
    });
  }

  void populateMemberProviderList(List<AppUser> userList) {
    userList.forEach((user) {
      if (user.isRejected ?? false)
        Provider.of<MembersProvider>(context, listen: false)
            .addRejectedMember(user);
      else {
        if (!(user.isVerified ?? false)) {
          Provider.of<MembersProvider>(context, listen: false)
              .addPendingMember(user);
        } else if (user.isVerified ?? false)
          Provider.of<MembersProvider>(context, listen: false)
              .addAcceptedMember(user);
      }
    });
  }

  List<AppUser> _getSelectedTabUsers() {
    if (!AppData.isAdmin())
      return Provider.of<MembersProvider>(context).acceptedMembers;
    switch (_selectedIndex) {
      case 0:
        return Provider.of<MembersProvider>(context).pendingMembers;
      case 1:
        return Provider.of<MembersProvider>(context).acceptedMembers;
      case 2:
        return Provider.of<MembersProvider>(context).rejectedMembers;
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(fontSize: kLargeText, fontWeight: kBold),
        title: Text(
            'Members${AppData.isAdmin() ? "" : " (${Provider.of<MembersProvider>(context).acceptedMembersCount})"}'),
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          SizedBox(height: SizeConfig.blockSizeHorizontal * 4),
          if (AppData.isAdmin())
            Padding(
              padding:
                  EdgeInsets.only(bottom: SizeConfig.blockSizeHorizontal * 4),
              child: RoundedTabBar(
                tabController: _tabController,
                onTap: (index) {
                  if (index == 0) {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  } else if (index == 1) {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  } else if (index == 2) {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  }
                },
              ),
            ),
          Flexible(
            child: FutureBuilder(
              future: _getAllUsers,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: List.generate(
                            10,
                            (index) => Shimmer.fromColors(
                              baseColor: Colors.white,
                              highlightColor: Colors.grey.shade200,
                              child: Column(
                                children: [1, 2, 3]
                                    .map(
                                      (user) => ListTile(
                                        leading: CircleAvatar(),
                                        title: Text("Name"),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    break;

                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Container(
                        height: SizeConfig.screenHeight / 2,
                        child: Center(
                          child: CustomErrorWidget(onRefresh: _getUsers),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: kHorizontalPadding),
                        itemCount: _getSelectedTabUsers().length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (_, index) {
                          final AppUser user = _getSelectedTabUsers()[index];
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: SizeConfig.blockSizeHorizontal * 1.5),
                            child: MemberCard(
                              isPending: (!(user.isVerified ?? false)),
                              isRejected: (user.isRejected ?? false),
                              user: user,
                              onAccept: () {
                                UserService.verifyUser(
                                        userId: user.id!, isVerified: true)
                                    .then((_) {
                                  Provider.of<MembersProvider>(context,
                                          listen: false)
                                      .addAcceptedMember(
                                    user.copyWith(
                                        isVerified: true, isRejected: false),
                                  );
                                  setState(() {});
                                  Get.back();
                                }).catchError((e) {
                                  Utility.showSnackBar(
                                      isError: true,
                                      message:
                                          'Something went wrong. Please try again.');
                                  print(e);
                                  Get.back();
                                });
                              },
                              onReject: () {
                                UserService.rejectUser(
                                        userId: user.id!, isRejected: true)
                                    .then((_) {
                                  Provider.of<MembersProvider>(context,
                                          listen: false)
                                      .addRejectedMember(
                                    user.copyWith(
                                        isRejected: true, isVerified: false),
                                  );
                                  Get.back();
                                }).catchError((e) {
                                  Utility.showSnackBar(
                                      isError: true,
                                      message:
                                          'Something went wrong. Please try again.');
                                  print(e);
                                  Get.back();
                                });
                              },
                            ),
                          );
                        },
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
