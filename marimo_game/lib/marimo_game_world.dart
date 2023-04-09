import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart' as ex;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:marimo_game/app_manage/environment/environment.dart';
import 'package:marimo_game/components/coin.dart';
import 'package:marimo_game/components/player.dart';
import 'bloc/game_stats/bloc/game_stats_bloc.dart';
import 'components/hud.dart';
import 'components/marimo.dart';
import 'components/world.dart';
import 'components/world_collidable.dart';
import 'helpers/direction.dart';
import 'helpers/tap_event_controller.dart';
class GameStatsController extends Component with HasGameRef<MarimoWorldGame> {
  @override
  Future<void>? onLoad() async {
    add(
      FlameBlocListener<GameStatsBloc, GameStatsState>(
        listenWhen: (previousState, newState) {
          return true;
            // previousState.status != newState.status &&
            //   newState.status == GameStatus.initial;
        },
        onNewState: (state) {
          print("game state ==>> $state");
        //  gameRef.removeWhere((element) => element is EnemyComponent);
        },
      ),
    );
  }
}
class MarimoWorldGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, ex.TapCallbacks {
  MarimoWorldGame(this.context, this.statsBloc);
  final GameStatsBloc statsBloc;
  late Marimo marimo;
  late PlayerComponent player;
  final World _world = World();
  final constant = Environment().config.constant;
  int coinsCollected = 0;
  final List<Coin> _coinList = List<Coin>.empty(growable: true);
  final BuildContext context;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await images.loadAll(constant.assetsList); // 필요에 따라 여러 번 액세스할 수 있는 Flame의 내장 캐싱 시스템
     add(
      FlameMultiBlocProvider(
        providers: [
          FlameBlocProvider<GameStatsBloc, GameStatsState>.value(
            value: statsBloc,
          ),
          // FlameBlocProvider<PlayerStatsBloc, PlayerStatsState>(
          //   create: () => PlayerStatsBloc(),
          // ),
        ],
        children: [
          marimo = Marimo(),
          player = PlayerComponent(),
          PlayerController(),
          PlayerController2(),
          GameStatsController(),
          // ...
        ],
      ),
    );
    await add(_world);
    //add(marimo);
    await add(Hud());
    //addWorldCollision();

    //marimo.position = _world.size / 2;

    for(var i=0; i<100; i++){

      final tempCoin = Coin(size);
      _coinList.add(tempCoin);

      add(tempCoin);

    }

    camera.followComponent(marimo,
        worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y));

  //  camera.viewport = FixedResolutionViewport(Vector2(393, 852));

    final x = MediaQuery.of(context).size.width;
    final y =  MediaQuery.of(context).size.height;
    print("x ==> $x , y ===> $y");


  }

  // void addWorldCollision() async =>
  //     (await MapLoader.readRayWorldCollisionMap()).forEach((rect) {
  //       add(WorldCollidable()
  //         ..position = Vector2(rect.left, rect.top)
  //         ..width = rect.width
  //         ..height = rect.height);
  //     });

  void onJoypadDirectionChanged(Direction direction) {
    //if(_marimo.position.x > 200){
    print("🦄🦄 ${marimo.position}");
   // }else{
      marimo.direction = direction;
   // }

  }

  WorldCollidable createWorldCollidable(Rect rect) {
    final collidable = WorldCollidable();
    collidable.position = Vector2(rect.left, rect.top);
    collidable.width = rect.width;
    collidable.height = rect.height;

    return collidable;
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection = null;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      keyDirection = Direction.down;
    }

    if (isKeyDown && keyDirection != null) {
      marimo.direction = keyDirection;
    } else if (marimo.direction == keyDirection) {
      marimo.direction = Direction.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  final Map<int, ExpandingCircle> _circles = {};

  //@override
  // void onTapDown(ex.TapDownEvent event) {
  //   final circle = ExpandingCircle(event.localPosition);
  //   _circles[event.pointerId] = circle;
  //   add(circle);
  // }
  //
  // @override
  // void onLongTapDown(ex.TapDownEvent event) {
  //   _circles[event.pointerId]!.accent();
  // }
  //
  // @override
  // void onTapUp(ex.TapUpEvent event) {
  //   _circles.remove(event.pointerId)!.release();
  // }
  //
  // @override
  // void onTapCancel(ex.TapCancelEvent event) {
  //   _circles.remove(event.pointerId)!.cancel();
  // }
}

class ExpandingCircle extends Component {
  ExpandingCircle(this._center)
      : _baseColor =
  HSLColor.fromAHSL(1, random.nextDouble() * 360, 1, 0.8).toColor();

  final Color _baseColor;
  final Vector2 _center;
  double _outerRadius = 0;
  double _innerRadius = 0;
  bool _released = false;
  bool _cancelled = false;
  late final _paint = Paint()
    ..style = PaintingStyle.stroke
    ..color = _baseColor;

  /// "Accent" is thin white circle generated by `onLongTapDown`. We use
  /// negative radius to indicate that the circle should not be drawn yet.
  double _accentRadius = -1e10;
  late final _accentPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0
    ..color = const Color(0xFFFFFFFF);

  /// At this radius the circle will disappear.
  static const maxRadius = 175;
  static final random = Random();

  double get radius => (_innerRadius + _outerRadius) / 2;

  void release() => _released = true;
  void cancel() => _cancelled = true;
  void accent() => _accentRadius = 0;

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(_center.toOffset(), radius, _paint);
    if (_accentRadius >= 0) {
      canvas.drawCircle(_center.toOffset(), _accentRadius, _accentPaint);
    }
  }

  @override
  void update(double dt) {
    if (_cancelled) {
      _innerRadius += dt * 100; // implosion
    } else {
      _outerRadius += dt * 20;
      _innerRadius += dt * (_released ? 20 : 6);
      _accentRadius += dt * 20;
    }
    if (radius >= maxRadius || _innerRadius > _outerRadius) {
      removeFromParent();
    } else {
      final opacity = 1 - radius / maxRadius;
      _paint.color = _baseColor.withOpacity(opacity);
      _paint.strokeWidth = _outerRadius - _innerRadius;
    }
  }
}