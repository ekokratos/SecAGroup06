import 'package:cpad_assignment/models/user.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/custom_dialog.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MemberCard extends StatelessWidget {
  final AppUser user;
  final GestureTapCallback? onAccept;
  final GestureTapCallback? onReject;
  final bool isPending;
  final bool isRejected;

  const MemberCard(
      {required this.user,
      this.onAccept,
      this.onReject,
      this.isPending = false,
      this.isRejected = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isRejected ? Colors.grey.shade300 : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.person,
                size: 40,
              ),
              title: Text(
                user.name ?? '-',
              ),
              subtitle: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.email ?? '-',
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      user.flatNumber ?? '-',
                      style: TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              trailing: (isPending && !isRejected)
                  ? Container(
                      width: SizeConfig.screenWidth * 0.3,
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _UserActionButton(
                                  isAccept: true,
                                  constraints: constraints,
                                  onTap: () => showCustomDialog(
                                      context: context,
                                      title: 'Accept',
                                      rightButtonText: 'Accept',
                                      description:
                                          'Are you sure you want to accept?',
                                      onRightButton: onAccept,
                                      leftButtonColor: Colors.red,
                                      rightButtonColor: Colors.green),
                                ),
                                // if (isPending && !isRejected)
                                _UserActionButton(
                                  constraints: constraints,
                                  onTap: () => showCustomDialog(
                                    context: context,
                                    title: 'Reject',
                                    description:
                                        'Are you sure you want to reject?',
                                    rightButtonText: 'Reject',
                                    onRightButton: onReject,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _UserActionButton extends StatelessWidget {
  final bool isAccept;
  final BoxConstraints constraints;
  final GestureTapCallback? onTap;

  const _UserActionButton(
      {this.isAccept = false, required this.constraints, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Column(
          children: [
            Icon(
              isAccept ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: isAccept ? Colors.green : Colors.red,
              size: constraints.maxWidth * 0.25,
            ),
            Text(
              isAccept ? "Accept" : "Reject",
              style: TextStyle(
                color: Colors.grey,
                fontSize: constraints.maxWidth * 0.08,
              ),
            )
          ],
        ),
      ),
    );
  }
}
