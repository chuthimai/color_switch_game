import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

class StarComponent extends SpriteComponent with CollisionCallbacks {
  StarComponent({
    required super.position,
  }) : super(
          size: Vector2.all(40),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await Sprite.load('star_icon.png');
    add(CircleHitbox(
      radius: size.y / 2,
      position: size / 2,
      anchor: Anchor.center,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  void showCollectEffect() {
    // Random dùng để tạo hướng, tốc độ và góc quay ngẫu nhiên
    final rnd = Random();

    // Hàm tạo Vector2 ngẫu nhiên theo cả 2 chiều (+/-),
    // nhân 100 để tăng biên độ chuyển động
    Vector2 randomVector2() =>
        (Vector2.random(rnd) - Vector2.random(rnd)) * 100;

    // Thêm ParticleSystemComponent vào parent (thường là game hoặc component cha)
    parent!.add(
      ParticleSystemComponent(
        // Vị trí xuất hiện hiệu ứng (thường là vị trí vật phẩm được nhặt)
        position: position,

        // Tạo một Particle generator
        particle: Particle.generate(
          // Thời gian sống của toàn bộ hệ particle (giây)
          lifespan: 4,

          // Hàm tạo từng particle con
          generator: (i) {
            return AcceleratedParticle(
              // Vận tốc ban đầu ngẫu nhiên
              speed: randomVector2(),

              // Gia tốc ngẫu nhiên (tạo cảm giác văng / bay / tản ra)
              acceleration: randomVector2(),

              // Particle con có hiệu ứng xoay
              child: RotatingParticle(
                // Góc xoay tối đa, chia ngẫu nhiên để mỗi hạt xoay khác nhau
                to: 2 * pi / (rnd.nextInt(8) + 1),

                // Particle con cuối cùng: tự vẽ bằng ComputedParticle
                child: ComputedParticle(
                  renderer: (canvas, particle) {
                    // Render sprite của vật phẩm
                    sprite!.render(
                      canvas,

                      // Kích thước giảm dần theo thời gian sống
                      size: (size / 2) * (1 - particle.progress),

                      // Căn giữa sprite
                      anchor: Anchor.center,

                      // Màu vàng mờ dần theo progress (hiệu ứng fade-out)
                      overridePaint: Paint()
                        ..color = Colors.yellow
                            .withOpacity(1 - particle.progress),
                    );
                  },
                ),
              ),
            );
          },

          // Số lượng particle được sinh ra
          count: 30,
        ),
      ),
    );

    // Đặt sau để xác định đc parent tồn tại
    removeFromParent();
  }
}
