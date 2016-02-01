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
import flash.media.SoundChannel;
import flash.ui.Keyboard;

/**
 * ...
 * @author David Maletz
 */
class Kitchen extends LerpSprite {
	private static inline var TAP_ON = 0; private static inline var TAP_OFF = 1; private static inline var POUR = 2; private static inline var DRINK = 3;
	private static var dialog = [
		"Your daily ritual begins with a nice cup of coffee."
	];
	private var tooltip:Tooltip; private var text:Tooltip; private var count:Int; private var action(default,set):Int;
	private var bg:LerpBitmap; private var kitchen:BitmapData; private var faucet:FrameBitmap; private var water:FrameBitmap;
	private var cup_small:LerpBitmap; private var cup:LerpBitmap; private var cup_pour:LerpBitmap; private var grinds:FrameBitmap;
	private var puddle:FrameBitmap;
	public function new(count:Int) {
		super(); this.count = count; action = -1; kitchen = Assets.getBitmapData("data/kitchen"+((count==2)?"2":"")+".png");
		bg = new LerpBitmap(kitchen, 10); addChild(bg); if(count == 2){
			bg.saturation = 0.75; DarkenKeyframe.setDarkness(bg, 0.75);
		} faucet = new FrameBitmap(Assets.getBitmapData("data/faucet_off.png"), 10, 0);
		faucet.addFrame(Assets.getBitmapData("data/faucet_on.png")); faucet.x = 260; faucet.y = 320; bg.addChild(faucet);
		cup_small = new LerpBitmap(Assets.getBitmapData("data/cup_small.png"), 10);
		cup_small.x = 430; cup_small.y = 470; cup_small.alpha = 0; bg.addChild(cup_small);
		if(count != 1){
			var w = (count == 0)?"water":"spider";
			water = new FrameBitmap(Assets.getBitmapData("data/"+w+"1.png"), 10, 4);
			water.addFrame(Assets.getBitmapData("data/"+w+"2.png")); water.play();
			water.x = (count==0)?480:450; water.y = 380; water.visible = false; bg.addChild(water);
		} if(count != 2){
			var g = (count == 1)?"grinds":"coffee-made";
			grinds = new FrameBitmap(Assets.getBitmapData("data/"+g+"-1.png"), 10, 6);
			grinds.addFrame(Assets.getBitmapData("data/"+g+"-2.png"));
			grinds.x = 1510; grinds.y = 330; grinds.play(); grinds.visible = false; bg.addChild(grinds);
		} if(count == 2){
			puddle = new FrameBitmap(Assets.getBitmapData("data/spider-puddle1.png"), 10, 6);
			puddle.addFrame(Assets.getBitmapData("data/spider-puddle2.png")); puddle.play();
			puddle.x = 1370; puddle.y = 440; puddle.visible = false; bg.addChild(puddle);
		} cup = new LerpBitmap(Assets.getBitmapData("data/cup"+(count+1)+".png"), 10);
		cup.x = 1320; cup.y = kitchen.height*10; cup.visible = false; bg.addChild(cup);
		cup_pour = new LerpBitmap(Assets.getBitmapData("data/cup_pour"+(count+1)+".png"), 10);
		cup_pour.x = (count==2)?1370:1540; cup_pour.y = 10; cup_pour.visible = false; bg.addChild(cup_pour);
	}
	public override function init(e){
		Main._root.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp); Main.playSFX("alarmclick");
		if(count == 2) channel = Main.playSFX("cityfire", 0, 10000);
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new NullKeyframe(), 240, _start);
	}
	private var bed:LerpBitmap;
	private function _start():Void {
		bed = new LerpBitmap(Assets.getBitmapData("data/bed"+((count==2)?"2":"")+".png"), 10); addChild(bed);
		lerp(new DarkenKeyframe(0.5), 60, hold);
	}
	private function hold():Void {
		lerp(new NullKeyframe(), 60, _start2);
	}
	private function _start2():Void {
		lerp(new DarkenKeyframe(0), 60, _start3);
	}
	private function _start3():Void {
		if(channel != null){channel.stop(); channel = null;} bed.parent.removeChild(bed); lerp(new NullKeyframe(), 60, _start4);
	}
	private function _start4():Void {lerp(new DarkenKeyframe(), 60, sceneUp);}
	public override function destroy(e){
		if(channel != null){channel.stop(); channel = null;}
		super.destroy(e); Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	private var channel:SoundChannel;
	private function keyUp(e:KeyboardEvent):Void {
		if(Main.paused) return;
		switch(action){
			case TAP_ON: if(e.keyCode == Keyboard.T){
				tooltip.close(); if(text != null) text.close(); action = -1; faucet.setFrame(1); if(water != null) water.visible = true;
				Main.playSFX("sinksqueak"); if(count == 0) channel = Main.playSFX("tapwater", 0, 10000);
				else if(count == 2) channel = Main.playSFX("spiders", 0, 10000); lerp(new NullKeyframe(), 60, turnTapOff);
			}
			case TAP_OFF: if(e.keyCode == Keyboard.T){
				if(channel != null){channel.stop(); channel = null;}
				tooltip.close(); action = -1; faucet.setFrame(0); if(water != null) water.visible = false;
				Main.playSFX("sinksqueak"); lerp(new NullKeyframe(), 30, takeCup);
			}
			case POUR: if(e.keyCode == Keyboard.P){
				tooltip.close(); action = -1; cup_small.visible = false; cup_pour.visible = true;
				if(count == 0) Main.playSFX("cuppour"); else if(count == 2){
					channel = Main.playSFX("spiders", 0, 10000);
				} lerp(new NullKeyframe(), 60, hideCup);
			}
			case DRINK: if(e.keyCode == Keyboard.D){
				tooltip.close(); action = -1; cup.visible = true;
				cup.lerp(new PositionKeyframe(cup.x, 350), 60, wait);
			}
		}
	}
	private function wait():Void {
		if(count == 1) Main.playSFX("crunch-beans");
		else Main.playSFX("coffeeslurp");
		lerp(new NullKeyframe(), 120, endScene);
	}
	private function endScene():Void {lerp(new DarkenKeyframe(0), 60, nextScene);}
	private function nextScene():Void {Main.setScreen(new Work(count));}
	private function hideCup():Void {
		cup_pour.lerp(new AlphaKeyframe(0), 5, (grinds != null)?null:drink);
		if(grinds != null){
			if(count == 1) Main.playSFX("beandrop"); grinds.visible = true; grinds.alpha = 0; grinds.lerp(new AlphaKeyframe(), 5, waitDrink);
		} if(puddle != null) puddle.visible = true;
	}
	private function waitDrink():Void {
		lerp(new NullKeyframe(), 60, hideGrinds);
	}
	private function hideGrinds():Void {
		grinds.lerp(new AlphaKeyframe(0), 5, drink);
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
		if(count < dialog.length){text = new Tooltip(100, 50, dialog[count], 600, true, false); lerp(new NullKeyframe(), 30, turnTapOn); addChild(text);} else turnTapOn();
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