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
import com.ggj.quotidian.lerp.SaturationKeyframe;
import com.ggj.quotidian.Tooltip;
import flash.display.BitmapData;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import openfl.Assets;

/**
 * ...
 * @author David Maletz
 */
class Kitchen extends LerpSprite {
	private static inline var TAP_ON = 0; private static inline var TAP_OFF = 1; private static inline var POUR = 2; private static inline var DRINK = 3;
	private static var dialog = [
		"Today is monday. You didn't really want to get up in the morning, but you had no choice. Perhaps a cup of coffee to help ease your spirit?"
	];
	private var tooltip:Tooltip; private var text:DialogBox; private var count:Int; private var action(default,set):Int;
	private var bg:LerpBitmap; private var kitchen:BitmapData; private var faucet:FrameBitmap; private var water:FrameBitmap;
	private var cup_small:LerpBitmap; private var cup:LerpBitmap; private var cup_pour:LerpBitmap;
	public function new(count:Int) {
		super(); this.count = count; action = -1; kitchen = Assets.getBitmapData("data/kitchen"+((count==2)?"2":"")+".png");
		bg = new LerpBitmap(kitchen, 10); addChild(bg);
		faucet = new FrameBitmap(Assets.getBitmapData("data/faucet_off.png"), 10, 0);
		faucet.addFrame(Assets.getBitmapData("data/faucet_on.png")); faucet.x = 260; faucet.y = 320; bg.addChild(faucet);
		cup_small = new LerpBitmap(Assets.getBitmapData("data/cup_small.png"), 10);
		cup_small.x = 430; cup_small.y = 470; cup_small.alpha = 0; bg.addChild(cup_small);
		if(count != 1){
			var w = (count == 0)?"water":"spider";
			water = new FrameBitmap(Assets.getBitmapData("data/"+w+"1.png"), 10, 4);
			water.addFrame(Assets.getBitmapData("data/"+w+"2.png")); water.play();
			water.x = (count==0)?480:450; water.y = 380; water.visible = false; bg.addChild(water);
		} cup = new LerpBitmap(Assets.getBitmapData("data/cup"+(count+1)+".png"), 10);
		cup.x = 1320; cup.y = kitchen.height*10; cup.visible = false; bg.addChild(cup);
		cup_pour = new LerpBitmap(Assets.getBitmapData("data/cup_pour"+(count+1)+".png"), 10);
		cup_pour.x = 1540; cup_pour.y = 10; cup_pour.visible = false; bg.addChild(cup_pour);
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
			case TAP_ON: if(e.keyCode == Keyboard.T){
				tooltip.close(); if(text != null) text.close(); action = -1; faucet.setFrame(1); if(water != null) water.visible = true;
				lerp(new NullKeyframe(), 60, turnTapOff);
			}
			case TAP_OFF: if(e.keyCode == Keyboard.T){
				tooltip.close(); action = -1; faucet.setFrame(0); if(water != null) water.visible = false;
				lerp(new NullKeyframe(), 30, takeCup);
			}
			case POUR: if(e.keyCode == Keyboard.P){
				tooltip.close(); action = -1; cup_small.visible = false; cup_pour.visible = true;
				lerp(new NullKeyframe(), 60, hideCup);
			}
			case DRINK: if(e.keyCode == Keyboard.D){
				tooltip.close(); action = -1; cup.visible = true;
				cup.lerp(new PositionKeyframe(cup.x, 350), 60, wait);
			}
		}
	}
	private function wait():Void {lerp(new NullKeyframe(), 100, endScene);}
	private function endScene():Void {lerp(new DarkenKeyframe(0), 60, nextScene);}
	private function nextScene():Void {Main.setScreen(new Work(count));}
	private function hideCup():Void {
		cup_pour.lerp(new AlphaKeyframe(0), 5, drink);
	}
	private function takeCup():Void {
		cup_small.lerp(new AlphaKeyframe(0), 5, pan);
	}
	private function pan():Void {
		bg.lerp(new PositionKeyframe(-(kitchen.width-80)*10), 200, preparePour);
	}
	private function preparePour():Void {
		cup_small.x = 1530; cup_small.y = 10; cup_small.lerp(new AlphaKeyframe(), 5, pourCup);
	}
	private function pourCup():Void {
		action = POUR; tooltip = new Tooltip(0, 450, "Hit 'P' to Pour Water", 800, true); addChild(tooltip);
	}
	private function set_action(a:Int):Int {
		Main._root.stage.focus = null; action = a; if(a == -1){saturation = 1; clearLerp();} else lerp(new SaturationKeyframe(0), Main.SATURATION, Main.gray); return a;
	}
	private function sceneUp():Void {
		if(count < dialog.length){text = new DialogBox(100, 50, 600, 100, dialog[count], turnTapOn); addChild(text);} else turnTapOn();
		cup_small.lerp(new AlphaKeyframe(), 5);
	}
	private function turnTapOn():Void {
		action = TAP_ON; tooltip = new Tooltip(0, 450, "Hit 'T' to Turn Tap On", 800, true); addChild(tooltip);
	}
	private function turnTapOff():Void {
		action = TAP_OFF; tooltip = new Tooltip(0, 450, "Hit 'T' to Turn Tap Off", 800, true); addChild(tooltip);
	}
	private function drink():Void {
		action = DRINK; tooltip = new Tooltip(0, 450, "Hit 'D' to Drink", 800, true); addChild(tooltip);
	}
}