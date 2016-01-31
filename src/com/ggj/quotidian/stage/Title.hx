package com.ggj.quotidian.stage;
import com.ggj.quotidian.DialogBox;
import com.ggj.quotidian.lerp.AlphaKeyframe;
import com.ggj.quotidian.lerp.DarkenKeyframe;
import com.ggj.quotidian.lerp.LerpSprite;
import com.ggj.quotidian.Tooltip;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

/**
 * ...
 * @author David Maletz
 */
class Title extends LerpSprite {
	private var tooltip:Tooltip;
	public function new(){
		super(); var t = Main.createText("Quotidian", 100, 0xffffff, 800, 1000, true, "Xeliard"); t.y = 50; addChild(t);
	}
	public override function init(e){
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new DarkenKeyframe(), 100, titleUp);
	}
	public override function destroy(e){
		super.destroy(e); Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	private function keyUp(e:KeyboardEvent):Void {
		if(Main.paused) return;
		if(e.keyCode == Keyboard.ENTER){
			Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp); tooltip.close(); lerp(new DarkenKeyframe(0), 60, startGame);
		}
	}
	private function startGame():Void {Main.setScreen(new Mailbox(1));}
	private function titleUp():Void {
		Main._root.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		tooltip = new Tooltip(0, 250, "Hit 'Enter' to Start", 800, true); addChild(tooltip);
		var t = Main.createText("David Maletz - Natalie Maletz - Matthew Bumb", 16, 0xffffff, 800, 1000, true);
		t.y = 450; var l = new LerpSprite(); l.addChild(t); l.alpha = 0; addChild(l); l.lerp(new AlphaKeyframe(), 60);
	}
}