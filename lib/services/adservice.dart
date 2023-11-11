import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._privateConstructor();

  static final AdService instance = AdService._privateConstructor();

  static bool isTestAd = false;
  final String testBanner = 'ca-app-pub-3940256099942544/6300978111';
  final String normalBanner = 'ca-app-pub-3003834599002372/1517787760';

  final String testInterstitial = 'ca-app-pub-3940256099942544/8691691433';
  final String normalInterstitial = 'ca-app-pub-3003834599002372/3952379412';

  InterstitialAd? interstitialAd = null;
  static int count = 0;

  Future<Widget> getAd(Size appSize) async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            appSize.width.truncate());

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return Center();
    }
    final BannerAd myBanner = BannerAd(
      adUnitId: isTestAd ? testBanner : normalBanner,
      size: size,
      request: AdRequest(),
      listener: BannerAdListener(),
    );

    await myBanner.load();
    return Container(
        color: Colors.white,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
        child: AdWidget(ad: myBanner));
  }

  Future<void> initializeInterstitialAd(BuildContext context) async {
    count++;
    if (interstitialAd == null) {
      await InterstitialAd.load(
        adUnitId: isTestAd ? testInterstitial : normalInterstitial,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this.interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ),
      );
    } else if (count == 3) {
      await interstitialAd!.show();
      Navigator.of(context).pop();
      interstitialAd = null;
      count = 0;
    }
  }
}
