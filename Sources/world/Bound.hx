package world;

import kha.Canvas;
import kha.Assets;
import raccoon.Texture;

class Bound extends Texture {
  public function new(x:Float, y:Float){
    super(Assets.images.bound, x, y, 4, 208);
  }

  override public function update(){
    super.update();
  }

  override public function render(canvas:Canvas){
    super.render(canvas);
  }
}