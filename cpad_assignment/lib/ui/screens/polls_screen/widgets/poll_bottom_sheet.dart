import 'package:cpad_assignment/models/poll.dart';
import 'package:cpad_assignment/provider/poll_provider.dart';
import 'package:cpad_assignment/services/poll_service.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/rounded_text_field.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:cpad_assignment/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

showPollBottomSheet() {
  Get.bottomSheet(PollBottomSheet(),
      isScrollControlled: true, enableDrag: false);
}

class PollBottomSheet extends StatefulWidget {
  @override
  _PollBottomSheetState createState() => _PollBottomSheetState();
}

class _PollBottomSheetState extends State<PollBottomSheet> {
  bool _isLoading = false;
  bool _disableOption3 = true;
  bool _disableOption4 = true;

  final GlobalKey<FormState> _pollFormKey = GlobalKey<FormState>();

  TextEditingController _questionController = TextEditingController();
  TextEditingController _option1Controller = TextEditingController();
  TextEditingController _option2Controller = TextEditingController();
  TextEditingController _option3Controller = TextEditingController(text: '');
  TextEditingController _option4Controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2.6),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
                vertical: SizeConfig.blockSizeHorizontal * 7),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Form(
              key: _pollFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundedTextField(
                    hintText: 'Question',
                    controller: _questionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  RoundedTextField(
                    controller: _option1Controller,
                    hintText: 'Option 1',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  RoundedTextField(
                    controller: _option2Controller,
                    hintText: 'Option 2',
                    onChanged: (value) {
                      if (_option2Controller.text.isEmpty)
                        setState(() {
                          _disableOption3 = true;
                          _disableOption4 = true;
                        });
                      else
                        setState(() {
                          _disableOption3 = false;
                          _disableOption4 = false;
                        });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  RoundedTextField(
                    onChanged: (value) {
                      if (_option2Controller.text.isEmpty ||
                          _option3Controller.text.isEmpty)
                        setState(() {
                          _disableOption4 = true;
                        });
                      else
                        setState(() {
                          _disableOption4 = false;
                        });
                    },
                    isReadOnly: _disableOption3,
                    controller: _option3Controller,
                    hintText: 'Option 3',
                    validator: (value) {
                      if ((value == null || value.isEmpty) &&
                          _option4Controller.text.isNotEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                  RoundedTextField(
                    isReadOnly: _disableOption4,
                    controller: _option4Controller,
                    hintText: 'Option 4',
                  ),
                  SizedBox(height: SizeConfig.blockSizeHorizontal * 5),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith((states) =>
                            EdgeInsets.symmetric(vertical: 8, horizontal: 14)),
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => kButtonColor),
                      ),
                      onPressed: () {
                        if (_pollFormKey.currentState!.validate()) {
                          _startLoading();
                          List<Option> _optionList = [
                            Option(id: 1, name: _option1Controller.text),
                            Option(id: 2, name: _option2Controller.text)
                          ];
                          if (_option3Controller.text.isNotEmpty)
                            _optionList.add(
                                Option(id: 3, name: _option3Controller.text));
                          if (_option4Controller.text.isNotEmpty)
                            _optionList.add(
                                Option(id: 4, name: _option4Controller.text));
                          Poll _newPoll = Poll(
                              question: _questionController.text,
                              timestamp: DateTime.now().toIso8601String(),
                              options: _optionList);
                          PollService.savePoll(poll: _newPoll).then((poll) {
                            Provider.of<PollProvider>(context, listen: false)
                                .addPoll(poll);
                            _stopLoading();
                            Get.back();
                          }).catchError((e) {
                            print(e);
                            Utility.showSnackBar(
                                isError: true,
                                message:
                                    'Something went wrong while creating the Poll. Please try again.');

                            _stopLoading();
                            Get.back();
                          });
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 26,
                      ),
                      label: Text(
                        'Add',
                        style: TextStyle(
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            alignment: Alignment.center,
            color: Colors.black.withOpacity(0.5),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          )
      ],
    );
  }

  void _startLoading() {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    } else {
      _isLoading = true;
    }
  }

  void _stopLoading() {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    } else {
      _isLoading = false;
    }
  }
}
