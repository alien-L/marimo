import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:marimo_game/app_manage/language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ads/ad_helper.dart';
import '../bloc/component_bloc/background_bloc.dart';
import '../bloc/component_bloc/coin_bloc.dart';
import '../bloc/component_bloc/language_manage_bloc.dart';
import '../bloc/component_bloc/sound_bloc.dart';
import '../bloc/marimo_bloc/marimo_bloc.dart';
import '../bloc/marimo_bloc/marimo_exp_bloc.dart';
import '../bloc/marimo_bloc/marimo_level_bloc.dart';
import '../bloc/shop_bloc.dart';
import '../model/game_data_info.dart';
import '../model/marimo_shop.dart';

///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

// 앱 상태 체크 옵저버 클래스
class AppStatusObserver extends StatefulWidget {
  final Widget child;

  final MarimoBloc marimoBloc;
  final MarimoLevelBloc marimoLevelBloc;
  final MarimoExpBloc marimoExpBloc;

  final LanguageManageBloc languageManageBloc;
  final BackgroundBloc backgroundBloc;

  final SoundBloc soundBloc;
  final CoinBloc coinBloc;
  final ShopBloc shopBloc;

  const AppStatusObserver({
    required this.child,
    Key? key,
    required this.marimoBloc,
    required this.marimoLevelBloc,
    required this.marimoExpBloc,
    required this.languageManageBloc,
    required this.backgroundBloc,
    required this.soundBloc,
    required this.coinBloc,
    required this.shopBloc,
  }) : super(key: key);

  @override
  State<AppStatusObserver> createState() => _AppStatusObserverState();
}

class _AppStatusObserverState extends State<AppStatusObserver>
    with WidgetsBindingObserver {
 // InterstitialAd? _interstitialAd;
  int maxFailedLoadAttempts = 3;

  // void _loadInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: AdHelper.interstitialAdUnitId,
  //     request: AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         ad.fullScreenContentCallback = FullScreenContentCallback(
  //           onAdDismissedFullScreenContent: (ad) {},
  //         );
  //
  //         setState(() {
  //           _interstitialAd = ad;
  //         });
  //       },
  //       onAdFailedToLoad: (err) {},
  //     ),
  //   );
  // }
  //
  // void _showInterstitialAd() {
  //   if (_interstitialAd == null) {
  //     _loadInterstitialAd();
  //     return;
  //   }
  //   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdDismissedFullScreenContent: (InterstitialAd ad) {
  //       ad.dispose();
  //     },
  //   );
  //   _interstitialAd!.show();
  //   _interstitialAd = null;
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  if(Platform.isIOS) {
    //_loadInterstitialAd();
  }
  }

  GameDataInfo gameDataInfo = GameDataInfo();
  List<Shop> shopDataList = <Shop>[];

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        saveGameDataInfo();
     //   if(!widget.soundBloc.state){widget.soundBloc.offBgmSound();}
        print("백");
        break;
      case AppLifecycleState.resumed:
       // if(widget.soundBloc.state){widget.soundBloc.onBgmSound();}
        print("포");
      // if(Platform.isIOS) { _showInterstitialAd();}
        saveGameDataInfo();
        break;
      case AppLifecycleState.detached:
        saveGameDataInfo();
        break;
      case AppLifecycleState.inactive:
        saveGameDataInfo();
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  //  if(Platform.isIOS) {  _interstitialAd?.dispose();}
    super.dispose();
  }

  saveGameDataInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("gameDataInfo", json.encode(gameDataInfo));
  }

  @override
  Widget build(BuildContext context) {
    Widget result() => MultiBlocListener(
          listeners: [
            BlocListener<MarimoBloc, MarimoState>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.marimoAppearanceState =
                      state.marimoAppearanceState.name;
                });
              },
            ),
            BlocListener<MarimoLevelBloc, int>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.marimoLevel = state;
                });
              },
            ),
            BlocListener<MarimoExpBloc, int>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.marimoExp = state;
                });
              },
            ),
            BlocListener<LanguageManageBloc, Language>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.language = state.name;
                });
              },
            ),
            BlocListener<BackgroundBloc, BackgroundState>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.background = state.name;
                });
              },
            ),
            BlocListener<CoinBloc, int>(
              listener: (context, state) {
                setState(() {
                  gameDataInfo.coin = state;
                });
              },
            ),
          ],
          child: widget.child,
        );

    return result();
  }
}
