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
package com.ggj.quotidian;
import com.ggj.quotidian.lerp.DarkenKeyframe;
import com.ggj.quotidian.lerp.LerpSprite;
import com.ggj.quotidian.lerp.SaturationKeyframe;
import com.ggj.quotidian.stage.Title;
import flash.display.InteractiveObject;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.media.SoundTransform;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.ui.Keyboard;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.media.SoundChannel;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author David Maletz
 */
class Main extends Sprite 
{
	//Vultre: 137 30;  130, 35
	public static inline var SATURATION = 600;
	public static var TITLE = Assets.getFont("data/Xeliard.ttf");
	public static var FONT = Assets.getFont("data/Thintel.ttf");
	public static var _root:LerpSprite; private static var instance:Main; private var top:Sprite;
	public static var _scaled:LerpSprite;
	public function new() {
		instance = this; stage.scaleMode = StageScaleMode.NO_SCALE; super();
		_root = new LerpSprite(); addChild(_root); _scaled = new LerpSprite(); addChild(_scaled); 
		top = new Sprite(); addChild(top); resize(null);
		setScreen(new Title()); stage.addEventListener(Event.RESIZE, resize);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	private function resize(e:Event):Void {
		var s = Math.min(stage.stageWidth/800.0, stage.stageHeight/600.0);
		_root.scaleX = _root.scaleY = s;
		_root.x = (stage.stageWidth-800*s)*0.5; var ix = Math.round(_root.x);
		_root.y = (stage.stageHeight-600*s)*0.5; var iy = Math.round(_root.y);
		_scaled.scaleX = _scaled.scaleY = s; _scaled.x = _root.x; _scaled.y = _root.y;
		var g = top.graphics; g.clear(); if(Math.abs(_root.x) > Math.abs(_root.y)){
			g.beginFill(0); g.drawRect(0, 0, ix, stage.stageHeight); g.endFill();
			g.beginFill(0); g.drawRect(stage.stageWidth-ix, 0, ix, stage.stageHeight); g.endFill();
		} else {
			g.beginFill(0); g.drawRect(0, 0, stage.stageWidth, iy); g.endFill();
			g.beginFill(0); g.drawRect(0, stage.stageHeight-iy, stage.stageWidth, iy); g.endFill();
		}
	}
	private static var prevScreen:LerpSprite = null;
	public static function setScreen(s:LerpSprite):Void {
		if (prevScreen != null) _root.removeChild(prevScreen);
		prevScreen = s; if(s != null) _root.addChildAt(s, 0);
	}
	public static function createText(txt:String, sz:Int, col:Int=0xffffff, w:Int=1000, h:Int=1000, center:Bool=false, font:String="Thintel Regular"):TextField {
		if(font == "Thintel Regular") sz *= 2;
		var t = new TextField(); t.defaultTextFormat = new TextFormat(font, sz, col, null, null,null, null, null, (center)?TextFormatAlign.CENTER:null);
		t.selectable = false; t.embedFonts = true; t.text = txt; t.width=w; t.height=h; t.multiline = true; t.wordWrap = true; return t;
	}
	public static function playSFX(id:String, startTime:Float=0, loops:Int=0, sndTransform:SoundTransform=null):SoundChannel {
		#if flash
		var ext = ".mp3";
		#else
		var ext = ".ogg";
		#end
		return Assets.getSound("data/sound/"+id+ext).play(startTime, loops, sndTransform);
	}
	private static var giveUp:Bool = false;
	private function keyUp(e:KeyboardEvent):Void {
		if(e.keyCode == Keyboard.ESCAPE && prevScreen != null && !Std.is(prevScreen, Title)){
			if(!paused) prevScreen.lerp(new SaturationKeyframe(0), 15, doPause); else unpause();
		} else if(paused && giveUp){
			if(e.keyCode == Keyboard.Y){
				if(box != null){box.close(); box = null;} _root.lerp(new DarkenKeyframe(0), 15, toTitle);
			} else if(e.keyCode == Keyboard.N) unpause();
		}
	}
	private static function toTitle():Void {
		paused = false; focus = null; DarkenKeyframe.setDarkness(_root, 1); setScreen(new Title());
	}
	public static var paused:Bool = false; private static var focus:InteractiveObject;
	public static function gray():Void {}
	public static function doPause():Void {
		if(prevScreen != null){
			giveUp = false; paused = true; _root.lerp(new DarkenKeyframe(0.25), 15, showGiveUp); focus = _root.stage.focus;
			_root.stage.focus = null; prevScreen.mouseChildren = false;
		}
	}
	private static var box:DialogBox = null;
	private static function showGiveUp():Void {
		if(box != null) box.close();
		box = new DialogBox(100, 250, 600, 100, "Do you wish to give up your ritual?\nHit [Y]/[N]", giveUpShown); _scaled.addChild(box);
	}
	public static function giveUpShown():Void {giveUp = true;}
	private static function unpause():Void {
		if(box != null){box.close(); box = null;}
		if(prevScreen != null){
			_root.lerp(new DarkenKeyframe(1), 15, _unpause); prevScreen.lerp(new SaturationKeyframe(1), 15);
		}
	}
	private static function _unpause():Void {
		if(prevScreen != null){
			paused = false; _root.stage.focus = focus; focus = null; prevScreen.mouseChildren = true; var p:Dynamic = prevScreen;
			if(p.action != -1){prevScreen.lerp(new SaturationKeyframe(0), Main.SATURATION, Main.gray);}
		}
	}
}
