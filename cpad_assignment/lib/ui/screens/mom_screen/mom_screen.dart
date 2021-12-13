import 'package:cpad_assignment/provider/mom_provider.dart';
import 'package:cpad_assignment/services/mom_service.dart';
import 'package:cpad_assignment/ui/screens/mom_screen/widgets/mom_bottom_sheet.dart';
import 'package:cpad_assignment/ui/screens/mom_screen/widgets/mom_expansion_tile.dart';
import 'package:cpad_assignment/ui/styles.dart';
import 'package:cpad_assignment/ui/widgets/error_widget.dart';
import 'package:cpad_assignment/utility/app_data.dart';
import 'package:cpad_assignment/utility/size_config.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MOMScreen extends StatefulWidget {
  @override
  _MOMScreenState createState() => _MOMScreenState();
}

class _MOMScreenState extends State<MOMScreen> {
  late Future fetchMOMs;

  Future<void> _fetchMOMData() async {
    setState(() {
      fetchMOMs = MOMService.fetchMOMs();
      fetchMOMs.then((moms) {
        Provider.of<MOMProvider>(context, listen: false)
            .updateMOMList(moms?.momList ?? []);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMOMData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppData.isAdmin()
          ? FloatingActionButton(
              heroTag: 'momFAB',
              onPressed: () => showMOMBottomSheet(),
              backgroundColor: kButtonColor,
              child: Icon(Icons.add, size: 32),
            )
          : null,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        titleTextStyle: TextStyle(fontSize: kLargeText, fontWeight: kBold),
        title: Text("Minutes of meeting"),
      ),
      body: FutureBuilder(
        future: fetchMOMs,
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
                return Container(
                  height: SizeConfig.screenHeight * 0.8,
                  child: Center(
                      child: CustomErrorWidget(onRefresh: _fetchMOMData)),
                );
              } else {
                if (Provider.of<MOMProvider>(context).momsCount > 0)
                  return RefreshIndicator(
                    onRefresh: _fetchMOMData,
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
                              Provider.of<MOMProvider>(context).momList.map(
                            (mom) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: MOMExpansionTile(mom: mom),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                else
                  return RefreshIndicator(
                    onRefresh: _fetchMOMData,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: SizeConfig.screenHeight * 0.8,
                        child: Center(
                          child: Text(
                            'No MOMs available',
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
      ),
    );
  }
}
