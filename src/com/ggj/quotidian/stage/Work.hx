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
import com.ggj.quotidian.lerp.AlphaKeyframe;
import com.ggj.quotidian.lerp.DarkenKeyframe;
import com.ggj.quotidian.lerp.FrameBitmap;
import com.ggj.quotidian.lerp.LerpBitmap;
import com.ggj.quotidian.lerp.LerpSprite;
import com.ggj.quotidian.lerp.NodKeyframe;
import com.ggj.quotidian.lerp.PositionKeyframe;
import com.ggj.quotidian.lerp.SaturationKeyframe;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.ui.Keyboard;
import openfl.Assets;
import openfl.text.TextFieldType;

/**
 * ...
 * @author David Maletz
 */
class Work extends LerpSprite {
	private static inline var OPEN_WINDOW = 0; private static inline var WORK = 1; private static inline var BOSS = 2;
	private static inline var TURN_ON = 3;
	private static var dialog = [
		"Working..."
	];
	private static var work = [
		"This is your work. You have to type every character one at a time. Doesn't that suck?",
		"This is your work. You have to type every character one at a time. Doesn't that suck?",
		"This is your work. You have to type every character one at a time. Doesn't that suck?"
	];
	private static var boss_text = [
		"Yeaaaah, if you could come in to work on Labor Day, that'd be great. We're a bit understaffed.",
		"Yeaaaah, we've got some new faces joining, soo we're gonna have to let you go. You need to pack up your things.",
		"..."
	];
	private var tooltip:Tooltip; private var text:DialogBox; private var count:Int; private var action(default,set):Int;
	private var bg:LerpBitmap; private var window:LerpBitmap; private var black:LerpSprite;
	private var work_text:TextField; private var work_index:Int = 0;
	public function new(count:Int) {
		super(); this.count = count; action = -1; var col:Int;
		if(count == 2){
			var b = Assets.getBitmapData("data/work2.png"); var f = new FrameBitmap(b, 10, 6); col = 0x990000;
			bg = f; bg.y = -(b.height-60)*10; f.addFrame(Assets.getBitmapData("data/work3.png")); f.play(); addChild(bg);
		} else {
			var b = Assets.getBitmapData("data/work.png"); bg = new LerpBitmap(b, 10); col = 0;
			bg.y = -(b.height-60)*10; addChild(bg);
		} var window_b = Assets.getBitmapData("data/window.png"); window = new LerpBitmap(window_b, 10);
		window.visible = false; window.x = 25*10; window.y = 71*10; bg.addChild(window);
		work_text = Main.createText("", 16, col, window_b.width*10-10-50, window_b.height*10-10-60, false);
		work_text.x = window.x+5+40; work_text.y = window.y+5+50; bg.addChild(work_text);
		if(count == 2) window = null; else {
			black = new LerpSprite(); var g = black.graphics; g.beginFill(0); g.drawRect(180, 690, 480, 360); g.endFill();
			bg.addChild(black);
		}
	}
	public override function init(e){
		Main._root.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new DarkenKeyframe(), 60, sceneUp);
	}
	public override function destroy(e){
		super.destroy(e); Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	private function doTurnOn():Void {if(black != null) black.visible = false; openWindow();}
	private function keyUp(e:KeyboardEvent):Void {
		if(Main.paused) return;
		switch(action){
			case TURN_ON: if(e.keyCode == Keyboard.F10){
				action = -1; if(text != null) text.close(); tooltip.close(); lerp(new NullKeyframe(), 120, doTurnOn);
			}
			case OPEN_WINDOW: if(e.keyCode == Keyboard.O){
				if(window != null) window.visible = true; tooltip.close(); action = -1;
				lerp(new NullKeyframe(), 30, doWork);
			}
			case WORK: work_index++; if(work_index == work[count].length){
				tooltip.close(); work_text.text = work[count]; action = -1; bg.lerp(new PositionKeyframe(), 200, boss);
			} else {work_text.text = work[count].substring(0, work_index); action = -1; action = WORK;}
			case BOSS: if(e.keyCode == Keyboard.Y){
				tooltip.close(); bg.lerp(new NodKeyframe(2*Math.PI), 30, wait); action = -1;
			}
		}
	}
	private function sceneUp():Void {
		if(count < dialog.length){text = new DialogBox(100, 50, 600, 100, dialog[count], turnOn); addChild(text);} else turnOn();
	}
	private function set_action(a:Int):Int {
		Main._root.stage.focus = null; action = a; if(a == -1){saturation = 1; clearLerp();} else lerp(new SaturationKeyframe(0), Main.SATURATION, Main.gray); return a;
	}
	private function turnOn():Void {
		action = TURN_ON; tooltip = new Tooltip(0, 450, "Hit 'F10' to Turn On Computer", 800, true, false); addChild(tooltip);
	}
	private function openWindow():Void {
		action = OPEN_WINDOW; tooltip = new Tooltip(0, 450, "Hit 'O' to Open Outlook", 800, true, false); addChild(tooltip);
	}
	private function doWork():Void {
		action = WORK; tooltip = new Tooltip(0, 450, "Mash Keys to Work", 800, true, false); addChild(tooltip);
	}
	private function boss():Void {
		text = new DialogBox(100, 450, 600, 100, boss_text[count], bossDone); addChild(text);
	}
	private function bossDone():Void {action = BOSS; tooltip = new Tooltip(0, 560, "Hit 'Y' to Nod", 800, true, false); addChild(tooltip);}
	private function wait():Void {lerp(new NullKeyframe(), 60, endScene);}
	private function endScene():Void {lerp(new DarkenKeyframe(0), 60, nextScene);}
	private function nextScene():Void {Main.setScreen(new Mailbox(count));}
}