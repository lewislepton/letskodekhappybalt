package asset;

import kha.Canvas;

import raccoon.Entity;
import raccoon.ui.Text;

class ScoreManager extends Entity {
  public var text:Text;
  public var score = 0;

  public function new(x:Float, y:Float, size:Int){
    text = new Text('_8bit', '' + score, x, y, size);

    super(x, y, text.font.width(size, text.string), text.font.height(size));
  }

  override public function update(){
    super.update();
    text.position.x = position.x;
    text.position.y = position.y;

    text.string = '' + score;
  }

  override public function render(canvas:Canvas){
    super.render(canvas);
    text.render(canvas);
  }

  public function up(){
    score += 1;
  }

  public function reset(){
    score = 0;
  }
}