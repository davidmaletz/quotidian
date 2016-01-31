package com.ggj.quotidian.stage;
import com.ggj.quotidian.lerp.DarkenKeyframe;
import com.ggj.quotidian.lerp.LerpSprite;

/**
 * ...
 * @author David Maletz
 */
class Definition extends LerpSprite {

	public function new() {
		super(); var t = Main.createText("quo-tid-i-an", 32, 0xffffff, 800, 1000, true);
		t.y = 200; addChild(t);
		var t = Main.createText("/kwo tidean/\n\nOf or occurring every day; daily.\nAs in: a daily ritual.", 24, 0xffffff, 800, 1000, true);
		t.y = 250; addChild(t);
	}
	public override function init(e){
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new DarkenKeyframe(), 60, sceneUp);
	}
	private function sceneUp():Void {
		lerp(new NullKeyframe(), 400, endScene);
	}
	private function endScene():Void {lerp(new DarkenKeyframe(0), 60, nextScene);}
	private function nextScene():Void {Main.setScreen(new Kitchen(0));}
}