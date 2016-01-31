package com.ggj.quotidian;
import com.ggj.quotidian.lerp.AlphaKeyframe;
import com.ggj.quotidian.lerp.LerpSprite;
import com.ggj.quotidian.lerp.PositionKeyframe;
import com.ggj.quotidian.lerp.ScaleKeyframe;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import openfl.text.TextFieldType;

/**
 * ...
 * @author David Maletz
 */
class DialogBox extends LerpSprite {
	private static inline var BORDER = 5; private static inline var PADDING = 5; private static inline var WRITE_FRAMES = 2;
	private var bottom:LerpSprite; private var sides:LerpSprite; private var tf:TextField; private var tfl:LerpSprite;
	private var text:String; private var index:Int; private var h:Int; private var onComplete:Void->Void;
	public function new(x:Float, y:Float, w:Int, h:Int, txt:String, complete:Void->Void=null) {
		super(); this.x = x; this.y = y; onComplete = complete;
		graphics.beginFill(0xffffff); graphics.drawRect(BORDER, 0, w-BORDER*2, BORDER); graphics.endFill();
		sides = new LerpSprite(); var g = sides.graphics; addChild(sides); sides.y = BORDER;
		g.beginFill(0xffffff); g.drawRect(0, 0, BORDER, h-BORDER*2); g.endFill();
		g.beginFill(0xffffff); g.drawRect(w-BORDER, 0, BORDER, h-BORDER*2); g.endFill();
		g.beginFill(0); g.drawRect(BORDER, 0, w-BORDER*2, h-BORDER*2); g.endFill();
		bottom = new LerpSprite(); var g = bottom.graphics; addChild(bottom);
		g.beginFill(0xffffff); g.drawRect(BORDER, h-BORDER, w-BORDER*2, BORDER); g.endFill();
		var t = Main.createText(txt, 16, 0xffffff, w-BORDER*2-PADDING*2, 1000, true); tf = t; this.h = h;
		t.x = BORDER+PADDING; t.y = (h-t.textHeight)*0.5-8; t.text = ""; text = txt; index = 0;
		tfl = new LerpSprite(); tfl.addChild(tf); sides.addChild(tfl);
	}
	public function makeEditable():Void {
		tf.multiline = false; tf.y = PADDING*3+BORDER; tf.selectable = true; tf.type = TextFieldType.INPUT; Main._root.stage.focus = tf;
	}
	public override function init(e:Event):Void {
		super.init(e); alpha = 0; bottom.y = -h; sides.scaleY = 0; lerp(new AlphaKeyframe(), 5, open); Main._root.stage.addEventListener(MouseEvent.MOUSE_DOWN, focus);
	}
	public override function destroy(e:Event):Void {
		super.destroy(e); removeEventListener(Event.ENTER_FRAME, writeChars); Main._root.stage.removeEventListener(MouseEvent.MOUSE_DOWN, focus);
	}
	private function focus(e:MouseEvent):Void {
		if(!Main.paused && tf.selectable) Main._root.stage.focus = tf;
	}
	private function open():Void {
		bottom.lerp(new PositionKeyframe(), 20); sides.lerp(new ScaleKeyframe(), 20, (text.length > 0)?writeText:onComplete);
	}
	private function writeText():Void {addEventListener(Event.ENTER_FRAME, writeChars);}
	private var ct:Int = WRITE_FRAMES;
	private function writeChars(e:Event):Void {
		if(Main.paused && onComplete != Main.giveUpShown) return;
		ct--; if(ct <= 0){
			ct = WRITE_FRAMES; index++; if(index >= text.length){
				tf.text = text; removeEventListener(Event.ENTER_FRAME, writeChars);
				if(onComplete != null) onComplete();
			} else tf.text = text.substring(0, index);
		}
	}
	public function close():Void {
		tfl.lerp(new AlphaKeyframe(0), 5); bottom.lerp(new PositionKeyframe(0,-h+BORDER), 20); sides.lerp(new ScaleKeyframe(1,0), 20, hide);
	}
	private function hide():Void {lerp(new AlphaKeyframe(0), 5, remove);}
	private function remove():Void {parent.removeChild(this);}
}