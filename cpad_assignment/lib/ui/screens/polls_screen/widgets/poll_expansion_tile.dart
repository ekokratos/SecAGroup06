import 'package:cpad_assignment/models/poll.dart';
import 'package:cpad_assignment/provider/poll_provider.dart';
import 'package:cpad_assignment/services/poll_service.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/custom_dialog.dart';
import 'package:cpad_assignment/ui/widgets/custom_expansion_tile.dart';
import 'package:cpad_assignment/ui/widgets/custom_outlined_button.dart';
import 'package:cpad_assignment/ui/widgets/solid_rounded_button.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:polls/polls.dart' as polls;
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;

class PollExpansionTile extends StatefulWidget {
  final Poll poll;

  const PollExpansionTile({required this.poll});

  @override
  _PollExpansionTileState createState() => _PollExpansionTileState();
}

class _PollExpansionTileState extends State<PollExpansionTile> {
  double option1 = 0;
  double option2 = 0;
  double option3 = 0;
  double option4 = 0;

  List _optionList = [];

  Map<String, int> usersWhoVoted = {};
  late String _currentUser;
  String _creator = "6vKBlV5aTQaLpNOYfNZwM8facLq1";
  bool _isVoted = false;

  void _populateUserVotes() {
    setState(() {
      widget.poll.options!.forEach((option) {
        if (option.votedUserIds != null)
          option.votedUserIds!.forEach((uid) {
            usersWhoVoted[uid] = option.id!;
            if (_currentUser == uid)
              setState(() {
                _isVoted = true;
              });
          });

        if (option.id == 1)
          option1 = option.votedUserIds?.length.toDouble() ?? 0.0;
        else if (option.id == 2)
          option2 = option.votedUserIds?.length.toDouble() ?? 0.0;
        else if (option.id == 3)
          option3 = option.votedUserIds?.length.toDouble() ?? 0.0;
        else if (option.id == 4)
          option4 = option.votedUserIds?.length.toDouble() ?? 0.0;
      });
    });
  }

  double _getOptionValue(Option option) {
    switch (option.id) {
      case 1:
        return option1;
      case 2:
        return option2;
      case 3:
        return option3;
      case 4:
        return option4;
      default:
        return 0;
    }
  }

  void _populateOptionList({double? choice}) {
    List<Option> _options = List.from(widget.poll.options as List<Option>);
    _options.sort((a, b) => a.id.toString().compareTo(b.id.toString()));

    _optionList.clear();
    setState(() {
      _options.forEach((option) {
        _optionList.add(polls.Polls.options(
            title:
                '${option.name} ${AppData.isAdmin() ? "(${_getOptionValue(option).toInt()})" : ""}',
            value: (choice != null && choice == option.id!.toDouble())
                ? _getOptionValue(option) + 1 //when user votes
                : _getOptionValue(option)));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentUser = firebaseAuth.FirebaseAuth.instance.currentUser!.uid;
    });
    _populateUserVotes();
    _populateOptionList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomExpansionTile(
      title: Row(
        children: [
          Icon(Icons.date_range, size: 18, color: kPrimaryColor),
          SizedBox(width: SizeConfig.blockSizeHorizontal),
          Text(
            Utility.getTimeStamp(unformattedDate: widget.poll.timestamp!),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
              fontSize: 14,
            ),
          ),
        ],
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2),
          child: polls.Polls(
            children: _optionList,
            question: Text(
              widget.poll.question ?? '-',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 0.2,
                fontSize: 14,
              ),
            ),
            currentUser: _currentUser,
            creatorID: _creator,
            voteData: usersWhoVoted,
            userChoice: usersWhoVoted[_currentUser],
            onVoteBackgroundColor: Color(0xFFA7CD7A),
            leadingBackgroundColor: Color(0xFFA7CD7A),
            backgroundColor: Colors.white,
            onVote: (choice) {
              PollService.updatePollOption(
                  choice: choice, poll: widget.poll, userId: _currentUser);
              _populateOptionList(choice: choice.toDouble());

              if (choice == 1) {
                setState(() {
                  option1 += 1.0;
                });
              }
              if (choice == 2) {
                setState(() {
                  option2 += 1.0;
                });
              }
              if (choice == 3) {
                setState(() {
                  option3 += 1.0;
                });
              }
              if (choice == 4) {
                setState(() {
                  option4 += 1.0;
                });
              }
              setState(() {
                usersWhoVoted[_currentUser] = choice;
                _isVoted = true;
              });
            },
          ),
        ),
        if (AppData.isAdmin())
          SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
        if (AppData.isAdmin())
          Align(
              alignment: Alignment.centerRight,
              child: SolidRoundedButton(
                  buttonColor: Colors.redAccent,
                  onPressed: () {
                    showCustomDialog(
                      context: context,
                      rightButtonText: 'Delete',
                      title: 'Poll',
                      description: 'Are you sure you want to delete?',
                      onRightButton: () {
                        Provider.of<PollProvider>(context, listen: false)
                            .deletePoll(widget.poll);
                        Get.back();
                        PollService.deletePoll(poll: widget.poll).then((_) {
                          Utility.showToast('Poll deleted.');
                        }).catchError((e) {
                          Get.back();
                          Provider.of<PollProvider>(context, listen: false)
                              .addPoll(widget.poll);
                          Utility.showSnackBar(
                              isError: true,
                              message:
                                  'Something went wrong while deleting. Please try again.');
                        });
                      },
                    );
                  },
                  text: 'Delete')),
        SizedBox(height: 14),
      ],
    );
  }
}
