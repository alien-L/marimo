
///
/// Created by ahhyun [ah2yun@gmail.com] on 2023. 03. 30
///

enum Villain {cat,shrimp,snail,fish,dog,shark,marooMarimo}

enum FishBowlState {good , bad}

enum MarimoLevel{baby,child,child2,teenager,adult,oldMan}

enum MarimoState{dangerous,good,bad,normal,die}

abstract class Constant {
  String hello = '';
  List<String> assetsList = [
    'background.jpg',
    'coin.png',
    'e_marimo.png',
    'marimo.png',
    'marimo_adult.png',
    'marimo_baby.png',
    'marimo_child.png',
    'marimo_child0.png',
    'marimo_child2.png',
    'marimo_oldMan.png',
    'marimo_teenager.png',
    'mymarimo_btn.png',
    'one_marimo.png',
    'player.png',
    // '',
    // '',
    // '',
    // '',
    // '',
  ];
}

class KoreanConstant extends Constant{

  @override
  String hello = '안녕하세요';

  @override
  // TODO: implement assetsList
  List<String> get assetsList => super.assetsList;
}

class EnglishConstant extends Constant{
  @override
  String hello = 'hello';

  @override
  // TODO: implement assetsList
  List<String> get assetsList => super.assetsList;

}

class JapanConstant extends Constant{}