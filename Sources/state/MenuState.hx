package state;

import kha.Canvas;
import kha.Color;
import kha.Assets;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.ui.Text;
import raccoon.ui.ButtonText;
import raccoon.ui.ToggleText;
import raccoon.Texture;
import raccoon.audio.Sfx;

import tween.Delta;
import tween.easing.Sine;
import tween.easing.Bounce;

class MenuState extends State {
	var _txtHeader:Text;
	var _txtWebsite:Text;
	var _btnPlay:ButtonText;
	public static var togSound:ToggleText;
	var _imgBackground:Texture;
	var _sndMusic:AudioChannel;

	public function new(){
		super();
		_sndMusic = Audio.play(Assets.sounds.khappybaltmusic, true);
		_sndMusic.volume = 0.3;

		_imgBackground = new Texture(Assets.images.background, 0, 0, Raccoon.BUFFERWIDTH, Raccoon.BUFFERHEIGHT);
		add(_imgBackground);

		_txtHeader = new Text('_8bit', 'KhappyBalt', 0, -42, 32);
		_txtHeader.position.x = Raccoon.BUFFERWIDTH / 2 - _txtHeader.width / 2;
		add(_txtHeader);

		_txtWebsite = new Text('_8bit', 'lewislepton.com', 0, Raccoon.BUFFERHEIGHT - 24, 16);
		_txtWebsite.position.x = Raccoon.BUFFERWIDTH / 2 - _txtWebsite.width / 2;
		add(_txtWebsite);

		_btnPlay = new ButtonText('_8bit', 'PLAY', 18, Raccoon.BUFFERHEIGHT + 8, 18);
		_btnPlay.colorOn = Color.fromFloats(0.8, 0.8, 0.8);
		_btnPlay.colorOff = Color.fromFloats(0.3, 0.3, 0.3);
		_btnPlay.onClick = setPlayState;
		add(_btnPlay);

		togSound = new ToggleText('_8bit', 'AUDIO', 0, Raccoon.BUFFERHEIGHT + 8, 18);
		togSound.position.x = _btnPlay.position.x + _btnPlay.width + 26;
		togSound.colorOff = Color.fromFloats(0.8, 0.8, 0.8);
		togSound.colorOn = Color.fromFloats(0.3, 0.3, 0.3);
		add(togSound);

		Delta.tween(_txtHeader.position).prop('y', 54, 1.0).ease(Bounce.easeOut).onActionComplete(tweenButton);
	}

	override public function update(){
		super.update();
		Delta.step(1 / 60);

		if (togSound.isOn){
			_sndMusic.play();
		} else {
			_sndMusic.pause();
		}
	}

	override public function render(canvas:Canvas){
		super.render(canvas);
	}

	override public function onMouseDown(button:Int, x:Int, y:Int):Void {
		if (button == 0){
			_btnPlay.onButtonDown(x, y);
			togSound.onToggleDown(x, y);
		}
	}

	function setPlayState(){
		if (togSound.isOn) Sfx.play('select', 0.4);
		State.set('play');
	}

	function tweenButton(){
		if (MenuState.togSound.isOn) Sfx.play('khappybalttitle', 0.6);
		Delta.tween(_btnPlay.position).prop('y', Raccoon.BUFFERHEIGHT - 64, 1.0).ease(Sine.easeOut);
		Delta.tween(togSound.position).prop('y', Raccoon.BUFFERHEIGHT - 64, 1.0).ease(Sine.easeOut);
	}

}