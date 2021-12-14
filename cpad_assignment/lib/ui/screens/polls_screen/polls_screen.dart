import 'package:cpad_assignment/provider/poll_provider.dart';
import 'package:cpad_assignment/services/poll_service.dart';
import 'package:cpad_assignment/ui/screens/polls_screen/widgets/poll_bottom_sheet.dart';
import 'package:cpad_assignment/ui/screens/polls_screen/widgets/poll_expansion_tile.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/error_widget.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PollsScreen extends StatefulWidget {
  @override
  _PollsScreenState createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  late Future _fetchPolls;

  Future<void> _fetchPollData() async {
    setState(() {
      _fetchPolls = PollService.fetchPolls();
      _fetchPolls.then((polls) {
        Provider.of<PollProvider>(context, listen: false)
            .updatePollList(polls.pollList ?? []);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPollData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: AppData.isAdmin()
            ? FloatingActionButton(
                heroTag: 'pollFAB',
                onPressed: () => showPollBottomSheet(),
                backgroundColor: kButtonColor,
                child: Icon(Icons.add, size: 32),
              )
            : null,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          titleTextStyle: TextStyle(fontSize: kLargeText, fontWeight: kBold),
          title: Text("Polls"),
        ),
        body: FutureBuilder(
          future: _fetchPolls,
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
                          baseColor: kButtonColor,
                          highlightColor: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: Container(
                                width: double.infinity,
                                height: SizeConfig.screenHeight * 0.12,
                              ),
                            ),
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
                    height: SizeConfig.screenHeight * 0.8,
                    child: Center(
                      child: CustomErrorWidget(onRefresh: _fetchPollData),
                    ),
                  );
                } else {
                  if (Provider.of<PollProvider>(context).pollCount > 0)
                    return RefreshIndicator(
                      onRefresh: _fetchPollData,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: kHorizontalPadding,
                              right: kHorizontalPadding,
                              bottom: SizeConfig.blockSizeHorizontal * 18,
                              left: kHorizontalPadding),
                          child: Column(
                            children:
                                Provider.of<PollProvider>(context).pollList.map(
                              (poll) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: PollExpansionTile(poll: poll),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ),
                    );
                  else
                    return RefreshIndicator(
                      onRefresh: _fetchPollData,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: SizeConfig.screenHeight * 0.8,
                          child: Center(
                            child: Text(
                              'No Polls available',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    );
                }
            }
          },
        ));
  }
}
