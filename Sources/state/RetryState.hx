package state;

import kha.Canvas;
import kha.Color;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.Texture;
import raccoon.ui.ButtonText;
import raccoon.ui.Text;
import raccoon.audio.Sfx;

class RetryState extends State {
	var _imgBackground:Texture;
	var _btnRetry:ButtonText;
	var _btnQuit:ButtonText;
	var _txtGameover:Text;

	public function new(){
		super();

		_imgBackground = new Texture(Assets.images.background, 0, 0, Raccoon.BUFFERWIDTH, Raccoon.BUFFERHEIGHT);
		add(_imgBackground);

		_btnRetry = new ButtonText('_8bit', 'RETRY', 18, Raccoon.BUFFERHEIGHT - 64, 18);
		_btnRetry.colorOff = Color.fromFloats(0.3, 0.3, 0.3);
		_btnRetry.colorOn = Color.fromFloats(0.8, 0.8, 0.8);
		_btnRetry.onClick = setPlayState;
		add(_btnRetry);

		_btnQuit = new ButtonText('_8bit', 'QUIT', 0, Raccoon.BUFFERHEIGHT - 64, 18);
		_btnQuit.position.x = Raccoon.BUFFERWIDTH - _btnQuit.width - 24;
		_btnQuit.colorOff = Color.fromFloats(0.3, 0.3, 0.3);
		_btnQuit.colorOn = Color.fromFloats(0.8, 0.8, 0.8);
		_btnQuit.onClick = setMenuState;
		add(_btnQuit);

		_txtGameover = new Text('_8bit', 'GAME OVER', 0, 24, 32);
		_txtGameover.position.x = Raccoon.BUFFERWIDTH / 2 - _txtGameover.width / 2;
		add(_txtGameover);
	}

	override public function update(){
		super.update();
	}

	override public function render(canvas:Canvas){
		super.render(canvas);
		PlayState.score.render(canvas);
	}

	override public function onMouseDown(button:Int, x:Int, y:Int):Void {
		if (button == 0){
			_btnRetry.onButtonDown(x, y);
			_btnQuit.onButtonDown(x, y);
		}
	}

	function setPlayState() {
		if (MenuState.togSound.isOn) Sfx.play('select', 0.4);
		PlayState.score.reset();
		PlayState.reset();
		State.set('play');
	}

	function setMenuState() {
		if (MenuState.togSound.isOn) Sfx.play('select', 0.4);
		PlayState.score.reset();
		PlayState.reset();
		State.set('menu');
	}
}