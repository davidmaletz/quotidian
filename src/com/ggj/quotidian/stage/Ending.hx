package com.ggj.quotidian.stage;
import com.ggj.quotidian.lerp.AlphaKeyframe;
import com.ggj.quotidian.lerp.DarkenKeyframe;
import com.ggj.quotidian.lerp.LerpSprite;

/**
 * ...
 * @author David Maletz
 */
class Ending extends LerpSprite {
	private var text:LerpSprite;
	public function new() {
		super(); var t = Main.createText("And so the daily ritual continues, never changing...", 24, 0xffffff, 800, 1000, true);
		t.y = 200; addChild(t);
		var t = Main.createText("The End?", 60, 0xffffff, 800, 1000, true, "Alagard");
		t.y = 300; text = new LerpSprite(); text.addChild(t); text.alpha = 0; addChild(text);
	}
	public override function init(e){
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new DarkenKeyframe(), 60, sceneUp);
	}
	private function sceneUp():Void {
		lerp(new NullKeyframe(), 200, endScene); text.lerp(new AlphaKeyframe(), 60);
	}
	private function endScene():Void {lerp(new DarkenKeyframe(0), 60, nextScene);}
	private function nextScene():Void {Main.setScreen(new Title());}
}