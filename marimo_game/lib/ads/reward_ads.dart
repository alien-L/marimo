import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marimo_game/components/alert/game_alert.dart';
import 'package:marimo_game/style/font.dart';
import '../marimo_game_world.dart';
import '../style/color.dart';
import 'ad_helper.dart';

class RewardAds extends StatefulWidget {
  RewardAds({Key? key, required this.game}) : super(key: key);
 final  MarimoWorldGame game;

  @override
  State<RewardAds> createState() => _RewardAdsState();
}

class _RewardAdsState extends State<RewardAds> {
  RewardedAd? _rewardedAd;

  // TODO: Implement _loadRewardedAd()
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadRewardedAd();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget  child ()=> GridView.count(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        primary: false,
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: CommonColor.green,
                    content: Text('광고를 보겠습니까?'),
                    actions: [
                      TextButton(
                        child: Text('cancel'.toUpperCase(),style:CommonFont.neoDunggeunmoPro(fontWeight: FontWeight.bold, fontSize: 13,color:Colors.white),),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: Text('ok'.toUpperCase(),style:CommonFont.neoDunggeunmoPro(fontWeight: FontWeight.bold, fontSize: 13,color:Colors.white),),
                        onPressed: () {
                          Navigator.pop(context);
                          _rewardedAd?.show(
                            onUserEarnedReward: (_, reward) {
                              widget.game.coinBloc.addCoin(50);
                              GameAlert().showInfoDialog(
                                  color: CommonColor.red,
                                  contents: "코인을 얻었어요",
                                  onTap: () {
                                  });
                              //   QuizManager.instance.useHint();
                            },
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black,),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color:  Colors.white.withOpacity(0.8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/images/one_marimo.png',height: 80,),
                  const Text("♥ 광고 보고 \n 50코인 얻기 ♥"),
                ],
              ),
            ),
          ),
          Container(),
        ]);

    return child();
  }
}


