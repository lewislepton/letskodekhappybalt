package char;

import kha.Canvas;
import kha.input.KeyCode;

import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

class Player extends Sprite {
  public var animFlap:Animation;
  public var animIdle:Animation;
  public var flap:Bool;
  public var flapAmount = -2.6;

  public function new(x:Float, y:Float){
    super('bird', x, y, 8, 8);
    animFlap = Animation.createRange(0, 2, 4);
    animIdle = Animation.create(0);

    reset();
  }

  override public function update(){
    super.update();

    if (!flap){
      flap = true;
      if (flap){
        velocity.y = flapAmount;
      }
    }

    velocity.y += acceleration;
  }

  override public function render(canvas:Canvas){
    super.render(canvas);
  }

  public function onKeyDown(keyCode:KeyCode):Void {
    switch (keyCode){
      case F: flap = true;
    default: return;
    }
  }

  public function onKeyUp(keyCode:KeyCode):Void {
    switch (keyCode){
      case F: flap = false;
    default: return;
    }
  }

  public function reset(){
    velocity.x = 0.65;
    velocity.y = 0.0;
    acceleration = 0.23;
    speed = 2.2;
    flip.x = false;
    friction = 0.0;
    setAnimation(animIdle);
    position.x = Raccoon.BUFFERWIDTH / 2;
    position.y = Raccoon.BUFFERHEIGHT / 2;
  }
}