// import 'package:flutter/cupertino.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import 'ad_helper.dart';
//
// class BannerAds extends StatefulWidget {
//   const BannerAds({Key? key}) : super(key: key);
//
//   @override
//   State<BannerAds> createState() => _BannerAdsState();
// }
//
// class _BannerAdsState extends State<BannerAds> {
//
//   BannerAd? _bannerAd;
//
//   @override
//   void initState() {
//     super.initState();
//
//     BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       request: const AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _bannerAd = ad as BannerAd;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           ad.dispose();
//         },
//       ),
//     ).load();
//
//   }
//
//   @override
//   void dispose() {
//     // TODO: Dispose a BannerAd object
//     _bannerAd?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return   _bannerAd != null?
//     Align(
//       alignment: Alignment.topCenter,
//       child: Container(
//         width: _bannerAd!.size.width.toDouble(),
//         height: _bannerAd!.size.height.toDouble(),
//         child: AdWidget(ad: _bannerAd!),
//       ),
//     ):Container();
//   }
// }
//
//
