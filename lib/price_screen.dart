import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

String selectedCurrency = 'UGX';
String selectedCrypto = 'BTC';
int selectedIndex = 0;
String rate = '?';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation colorAnime;
  Animation sizeAnime;

  void updateUI(selectedCurrecy, selectedCrypto) async {
    try {
      var coins = await CoinData()
          .getCoinRate(crpto: selectedCrypto, currency: selectedCurrecy);
      setState(() {
        rate = coins['last'].toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }

  void updateCryptoUI(String crypto) {
    selectedCrypto = crypto;
  }

  void getAnimation() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    controller.forward();
    colorAnime =
        ColorTween(begin: Colors.blueGrey[100], end: Colors.orange[200])
            .animate(controller);
    sizeAnime =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutBack);
    controller.addListener(() {
      setState(() {});
    });
  }

  List<FlatButton> cryptoButton() {
    List<FlatButton> cryptoItems = [];
    List<IconData> cryptoNames = [
      FontAwesomeIcons.bitcoin,
      FontAwesomeIcons.ethereum,
      MdiIcons.litecoin
    ];

    for (int i = 0; i < cryptoList.length; i++) {
      var c = FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          setState(() {
            updateUI(selectedCurrency, cryptoList[i]);
            updateCryptoUI(cryptoList[i]);
            getAnimation();
          });
        },
        child: Column(
          children: <Widget>[
            Icon(
              cryptoNames[i],
              size: selectedCrypto == cryptoList[i]
                  ? sizeAnime.value * 30 + 50
                  : 50,
            ),
            SizedBox(
                height: selectedCrypto == cryptoList[i]
                    ? sizeAnime.value * 7.5 + 12.5
                    : 12.5),
            Text(
              cryptoList[i],
              style: TextStyle(
                  fontSize: selectedCrypto == cryptoList[i]
                      ? sizeAnime.value * 7.5 + 12.5
                      : 12.5),
            ),
          ],
        ),
        color: selectedCrypto == cryptoList[i]
            ? colorAnime.value
            : Colors.blueGrey[100],
      );
      cryptoItems.add(c);
    }

    return cryptoItems;
  }

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      items: dropdownItems,
      value: selectedCurrency,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getAnimation();
          updateUI(selectedCurrency, selectedCrypto);
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItemsList = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItemsList.add(newItem);
    }
    return CupertinoPicker(
      backgroundColor: Colors.blueGrey,
      itemExtent: 32,
      onSelectedItemChanged: (index) {
        selectedIndex = index;
        getAnimation();
        updateUI(selectedCurrency, selectedCrypto);
      },
      children: pickerItemsList,
    );
  }

  @override
  void initState() {
    super.initState();
    getAnimation();
    updateUI(selectedCurrency, selectedCrypto);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💰 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: cryptoButton(),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.green[400],
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $selectedCrypto = ${(int.parse(rate) * sizeAnime.value).toInt()} $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.blueGrey[700],
            child: Platform.isIOS ? iOSPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

// --------------  OLD CODE --------------- //

//  List<DropdownMenuItem> getDropdownItems() {
//    List<DropdownMenuItem<String>> dropdownItems = [];
//    for (String currency in currenciesList) {
//      var newItem = DropdownMenuItem(
//        child: Text(currency),
//        value: currency,
//      );
//      dropdownItems.add(newItem);
//    }
//    return dropdownItems;
//  }

//  List<Text> getDropdownItemsIOS() {
//    List<Text> pickerItemsList = [];
//    for (String currency in currenciesList) {
//      var newItem = Text(currency);
//      pickerItemsList.add(newItem);
//    }
//    return pickerItemsList;
//  }

//Widget getDropdownPicker() {
//  if (Platform.isIOS) {
//    return iOSPicker();
//  } else if (Platform.isAndroid) {
//    return androidDropdownButton();
//  }
//}
