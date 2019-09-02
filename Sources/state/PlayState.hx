package state;

import kha.Canvas;
import kha.input.KeyCode;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.tmx.TiledMap;
import raccoon.tmx.TiledObjectGroup;
import raccoon.audio.Sfx;
import raccoon.particle.Emitter;
import raccoon.ui.Text;
import raccoon.tool.Util;
import raccoon.Entity;

import tween.Delta;
import tween.easing.Sine;

import asset.ScoreManager;
import char.Player;
import world.Bound;
import world.Spike;

enum GameState {
	run;
	pause;
}

class PlayState extends State {
	static var _gameState:GameState;
	var _tiledMap:TiledMap;
	public static var player:Player;
	var _playerObject:TiledObjectGroup;
	var _spikes:Entity;
	var _spikesObject:TiledObjectGroup;
	var _boundLeft:Bound;
	var _boundRight:Bound;
	static var _spikeLeft:Spike;
	static var _spikeRight:Spike;
	public static var score:ScoreManager;
	var _emitter:Emitter;
	var _txtFlap:Text;
	public function new(){
		super();

		setPauseState();

		_tiledMap = TiledMap.fromAssets(Assets.blobs.level_tmx.toString());

		_playerObject = _tiledMap.getObjectGroupByName('player');
		for (play in _playerObject){
			player = new Player(play.position.x, play.position.y);
		}

		_emitter = new Emitter();
		add(_emitter);

		_spikesObject = _tiledMap.getObjectGroupByName('spikes');
		for (spike in _spikesObject){
			_spikes = new Entity(spike.position.x, spike.position.y, spike.width, spike.height);
			add(_spikes);
		}

		_boundLeft = new Bound(0, 16);
		add(_boundLeft);
		_boundRight = new Bound(Raccoon.BUFFERWIDTH - 4, 16);
		add(_boundRight);

		_spikeLeft = new Spike(4, Raccoon.BUFFERHEIGHT);
		add(_spikeLeft);
		_spikeRight = new Spike(0, Raccoon.BUFFERHEIGHT);
		_spikeRight.position.x = _boundRight.position.x - _spikeRight.width;
		_spikeRight.flip.x = true;
		add(_spikeRight);

		score = new ScoreManager(0, 64, 32);
		score.position.x = Raccoon.BUFFERWIDTH / 2 - score.width / 2;
		add(score);

		_txtFlap = new Text('_8bit', 'F - to flap', 0, 0, 24);
		_txtFlap.position.x = Raccoon.BUFFERWIDTH / 2 - _txtFlap.width / 2;
		_txtFlap.position.y = Raccoon.BUFFERHEIGHT / 2 + 24;
	}

	override public function update(){
		super.update();
		switch (_gameState){
			case pause:
			case run: player.update();
		default: return;
		}

		updateBound();
		updateCollision();
		score.update();

		Delta.step(1 / 60);
	}

	override public function render(canvas:Canvas){
		_tiledMap.render(canvas);
		super.render(canvas);

		switch (_gameState){
			case pause: _txtFlap.render(canvas);
			case run:
		default: return;
		}

		player.render(canvas);
	}

	override public function onKeyDown(keyCode:KeyCode):Void {
		player.onKeyDown(keyCode);
		switch (keyCode){
			case F: setRunState();
		default: return;
		}
	}

	override public function onKeyUp(keyCode:KeyCode):Void {
		player.onKeyUp(keyCode);
	}
	
	static function setPauseState() {
		_gameState = GameState.pause;
	}

	function setRunState() {
		_gameState = GameState.run;
		player.setAnimation(player.animFlap);
	}

	function setRetryState() {
		State.set('retry');
		_emitter.empty();
		Delta.reset();
		if (MenuState.togSound.isOn) Sfx.play('khappybaltgameover', 0.6);
	}
	
	public static function reset(){
		setPauseState();
		player.reset();
		_spikeLeft.position.y = Raccoon.BUFFERHEIGHT;
		_spikeRight.position.y = Raccoon.BUFFERHEIGHT;
	}

	function updateBound() {
		var paddleValue = Util.randomRangeFloat(16, 132);
		if (player.overlap(_boundLeft)){
			score.up();
			player.flip.x = false;
			player.velocity.x = -player.velocity.x;
			Delta.tween(_spikeRight.position).prop('y', paddleValue, 0.3).ease(Sine.easeInOut);
			_emitter.spawn(player.position.x, player.position.y);
			if (MenuState.togSound.isOn){
				Sfx.random('spike', 3, 0.3);
				Sfx.random('bounce', 3, 0.6);
			}
		}
		if (player.overlap(_boundRight)){
			score.up();
			player.flip.x = true;
			player.velocity.x = -player.velocity.x;
			Delta.tween(_spikeLeft.position).prop('y', paddleValue, 0.3).ease(Sine.easeInOut);
			_emitter.spawn(player.position.x, player.position.y);
			if (MenuState.togSound.isOn){
				Sfx.random('spike', 3, 0.3);
				Sfx.random('bounce', 3, 0.6);
			}
		}
	}

	function updateCollision() {
		for (spike in _spikesObject){
			if (player.overlap(spike)){
				if (MenuState.togSound.isOn) Sfx.random('death', 3, 0.4);
				reset();
				setRetryState();
			}
		}
		if (player.overlap(_spikeLeft) || player.overlap(_spikeRight)){
			if (MenuState.togSound.isOn) Sfx.random('death', 3, 0.4);
			setRetryState();
		}
	}
}