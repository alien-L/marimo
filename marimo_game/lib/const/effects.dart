import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';

class CommonEffects {
  static sizeEffect() => SizeEffect.by(
        Vector2(-24, -24),
        EffectController(
          duration: .75,
          reverseDuration: .5,
          infinite: true,
          curve: Curves.easeOut,
        ),
      );

  static rotateEffect() => RotateEffect.by(
        90,
        EffectController(
          duration: 40,
          infinite: true,
          curve: Curves.easeOutQuad,
        ),
      );

  static moveEffect() => MoveEffect.by(
        Vector2(30, 100),
        EffectController(
          duration: 5,
          infinite: true,
          curve: Curves.easeOutQuad,
        ),
      );

  static moveToEffect() => MoveToEffect(
        Vector2(100, 100),
        EffectController(
          duration: 5,
          infinite: true,
          curve: Curves.easeOutQuad,
        ),
      );

  static sequenceEffect(List<Effect> effects) => SequenceEffect(effects);
}
