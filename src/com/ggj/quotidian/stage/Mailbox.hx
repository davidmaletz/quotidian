/******************************************************************************* 
 * Copyright (C) 2013  David Maletz
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package com.ggj.quotidian.stage;
import com.ggj.quotidian.DialogBox;
import com.ggj.quotidian.lerp.AlphaKeyframe;
import com.ggj.quotidian.lerp.DarkenKeyframe;
import com.ggj.quotidian.lerp.FrameBitmap;
import com.ggj.quotidian.lerp.LerpBitmap;
import com.ggj.quotidian.lerp.LerpSprite;
import com.ggj.quotidian.lerp.PositionKeyframe;
import com.ggj.quotidian.lerp.RandomFrameBitmap;
import com.ggj.quotidian.lerp.SaturationKeyframe;
import com.ggj.quotidian.Tooltip;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

/**
 * ...
 * @author David Maletz
 */
class Mailbox extends LerpSprite {
	private static inline var SAY_HI = 0; private static inline var CHECK_MAIL = 1;
	private static var dialog = [
		"A long day of work done, you return home, checking the mail and saying hi to your neighbor Jim as usual."
	];
	private static var hi = [
		"Hi, Jim.",
		"Nice bird, Jim.",
		"Lookin' trim, Jim. Did you lose weight?"
	];
	private var tooltip:Tooltip; private var text:DialogBox; private var count:Int; private var action(default,set):Int;
	private var bg:LerpBitmap; private var input:DialogBox; private var mail:LerpBitmap;  private var read:LerpBitmap; private var b:BitmapData;
	public function new(count:Int) {
		super(); this.count = count; action = -1;
		b = Assets.getBitmapData("data/neighborhood"+(count+1)+".png"); bg = new LerpBitmap(b, 10); addChild(bg);
		if(count == 0){
			mail = new LerpBitmap(Assets.getBitmapData("data/letters.png"), 10);
			mail.x = 24*10; mail.y = 22*10; bg.addChild(mail);
			read = new LerpBitmap(Assets.getBitmapData("data/waternotice.png"), 10);
			read.alpha = 0; read.x = 8*10; read.y = 5*10; bg.addChild(read);
		} else if(count == 1){
			var vulture = new RandomFrameBitmap(Assets.getBitmapData("data/vulture1.png"), 10, 6, 137, 30);
			vulture.addFrame(Assets.getBitmapData("data/vulture2.png"), 130, 35);
			vulture.play(); bg.addChild(vulture);
		}
	}
	public override function init(e){
		Main._root.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new DarkenKeyframe(), 60, sceneUp);
	}
	public override function destroy(e){
		super.destroy(e); Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	private function keyUp(e:KeyboardEvent):Void {
		if(Main.paused) return;
		switch(action){
			case SAY_HI: if(e.keyCode == Keyboard.ENTER){
				Main._root.stage.focus = null; input.close(); tooltip.close();
				tooltip = new Tooltip(0, 50, "Jim will remember this.", 800, true, false); addChild(tooltip);
				action = -1; lerp(new NullKeyframe(), 150, endScene);
			}
			case CHECK_MAIL: if(e.keyCode == Keyboard.M){
				tooltip.close(); action = -1; if(text != null) text.close();
				if(mail != null) mail.lerp(new AlphaKeyframe(0), 30);
				if(read != null) read.lerp(new AlphaKeyframe(1), 30);
				else {
					tooltip = new Tooltip(0, 50, (count == 1)?"No mail today.":"I guess they don't deliver on sundays.", 800, true, false); addChild(tooltip);
				} lerp(new NullKeyframe(), 180, pan);
			}
		}
	}
	private function endScene():Void {lerp(new DarkenKeyframe(0), 60, nextScene);}
	private function nextScene():Void {Main.setScreen(new Bedroom(count));}
	private function pan():Void {
		tooltip.close(); bg.lerp(new PositionKeyframe(-(b.width-80)*10), 200, sayHi);
	}
	private function sceneUp():Void {
		if(count < dialog.length){text = new DialogBox(100, 50, 600, 100, dialog[count], checkMail); addChild(text);} else checkMail();
	}
	private function set_action(a:Int):Int {
		Main._root.stage.focus = null; action = a; if(a == -1){saturation = 1; clearLerp();}
		else lerp(new SaturationKeyframe(0), Main.SATURATION, Main.gray); return a;
	}
	private function edit():Void {input.makeEditable();}
	private function sayHi():Void {
		var y = (text == null)?50:450; input = new DialogBox(100, y, 600, 100, "", edit); addChild(input);
		action = SAY_HI; tooltip = new Tooltip(0, y-10, "Type '"+hi[count]+"'", 800, true, false); addChild(tooltip);
	}
	private function checkMail():Void {
		action = CHECK_MAIL; tooltip = new Tooltip(0, 450, "Hit 'M' to Check Mail", 800, true, false); addChild(tooltip);
	}
}