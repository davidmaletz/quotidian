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
import com.ggj.quotidian.lerp.PositionKeyframe;
import com.ggj.quotidian.lerp.RandomFrameBitmap;
import com.ggj.quotidian.lerp.SaturationKeyframe;
import com.ggj.quotidian.lerp.ShakeKeyframe;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

/**
 * ...
 * @author David Maletz
 */
class Bedroom extends LerpSprite {
	private static inline var BRUSH_TEETH = 0; private static inline var CURTAIN = 1; private static inline var SLEEP = 2;
	private static var dialog = [
		"Time to sleep..."
	];
	private var tooltip:Tooltip; private var text:DialogBox; private var count:Int; private var action(default,set):Int;
	private var bg:LerpBitmap; private var bedroom:BitmapData; private var curtain:LerpBitmap; private var toothbrush:LerpBitmap;
	private var brush_ct:Int = 0; private var b:BitmapData; private var bed:LerpBitmap;
	public function new(count:Int) {
		super(); this.count = count; action = -1; bedroom = Assets.getBitmapData("data/bedroom"+((count==2)?"2":"")+".png");
		bg = new LerpBitmap(bedroom, 10); addChild(bg);
		if(count == 1){
			var g = new FrameBitmap(Assets.getBitmapData("data/ghost-1.png"), 10, 20);
			for(i in 2...6) g.addFrame(Assets.getBitmapData("data/ghost-"+i+".png"));
			for(i in 1...6) g.addFrame(Assets.getBitmapData("data/ghost-"+(6-i)+".png"));
			g.x = 1780; g.y = 200; g.play(); bg.addChild(g);
		} else if(count == 2){
			var g = new RandomFrameBitmap(Assets.getBitmapData("data/monster-1.png"), 10, 20);
			for(i in 2...4) g.addFrame(Assets.getBitmapData("data/monster-"+i+".png"));
			g.x = 1160; g.y = 60; g.play(); bg.addChild(g);
		} curtain = new LerpBitmap(Assets.getBitmapData("data/curtains"+((count==2)?"2":"")+".png"), 10);
		curtain.alpha = 0; if(count == 2){curtain.x = 1620; curtain.y = 150;}
		else {curtain.x = 149*10; curtain.y = 16*10;} bg.addChild(curtain);
		b = Assets.getBitmapData("data/"+((count==2)?"knife":"toothbrush")+".png"); toothbrush = new LerpBitmap(b, 10);
		toothbrush.y = bedroom.height*10; bg.addChild(toothbrush);
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
			case BRUSH_TEETH: if(text != null){text.close(); text = null;}
			if((brush_ct%2) == 0){
				if(e.keyCode == Keyboard.J){
					brush_ct++; toothbrush.x = 200; action = -1; action = BRUSH_TEETH; Main.playSFX("brush1");
					if(brush_ct == 31){
						action = -1; tooltip.close(); toothbrush.x = 0;
						toothbrush.lerp(new PositionKeyframe(toothbrush.x, bedroom.height*10), 30, pan);
					} else action = BRUSH_TEETH;
				}
			} else if(e.keyCode == Keyboard.F){brush_ct++; toothbrush.x = 0; action = -1; action = BRUSH_TEETH; Main.playSFX("brush2");}
			case CURTAIN: if(e.keyCode == Keyboard.C){
				curtain.lerp(new AlphaKeyframe(), 5, goToBed); tooltip.close(); action = -1;
			}
			case SLEEP: if(e.keyCode == Keyboard.Z){
				var d = DarkenKeyframe.addDarkness(this, 0.05); if(d == 0){
					action = -1; if(count < 2) lerp(new NullKeyframe(), 100, nextScene); else lerp(new NullKeyframe(), 500, title); return;
				} action = -1; action = SLEEP; lerp(new DarkenKeyframe(), Math.round((1-d*d)*200));
				if(!hasTrack(ShakeKeyframe)) lerp(new ShakeKeyframe(3*Math.PI), 5);
			}
		}
	}
	private function title():Void {Main.setScreen(new Title());}
	private function nextScene():Void {Main.setScreen(new Kitchen(count+1));}
	private function pan():Void {
		bg.lerp(new PositionKeyframe(-(bedroom.width-80)*10), 200, closeCurtains);
	}
	private function set_action(a:Int):Int {
		Main._root.stage.focus = null; action = a; if(a == -1){saturation = 1; clearLerp();} else lerp(new SaturationKeyframe(0), Main.SATURATION, Main.gray); return a;
	}
	private function sceneUp():Void {
		if(count < dialog.length){text = new DialogBox(100, 50, 600, 100, dialog[count], brushTeeth); addChild(text);} else brushTeeth();
	}
	private function brushTeeth():Void {
		action = BRUSH_TEETH; tooltip = new Tooltip(0, 450, "Alternate 'F' and 'J' to Brush Teeth", 800, true, false); addChild(tooltip);
		toothbrush.lerp(new PositionKeyframe(0, (bedroom.height-b.height)*10), 30);
	}
	private function closeCurtains():Void {
		action = CURTAIN; tooltip = new Tooltip(0, 450, "Hit 'C' to Close Curtains", 800, true, false); addChild(tooltip);
	}
	private function goToBed():Void {
		lerp(new NullKeyframe(), 60, fadeBed);
	}
	private function fadeBed():Void {
		bed = new LerpBitmap(Assets.getBitmapData("data/bed"+((count==2)?"2":"")+".png"), 10); bed.alpha = 0; addChild(bed);
		bed.lerp(new AlphaKeyframe(), 60, sleep);
	}
	private function sleep():Void {
		removeChild(bg); action = SLEEP; tooltip = new Tooltip(0, 450, "Mash 'Z' to Sleep", 800, true, false); addChild(tooltip);
	}
}