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
import com.ggj.quotidian.lerp.LerpBitmap;
import com.ggj.quotidian.lerp.LerpSprite;
import com.ggj.quotidian.Tooltip;
import flash.events.KeyboardEvent;
import flash.media.SoundChannel;
import flash.ui.Keyboard;

/**
 * ...
 * @author David Maletz
 */
class Title extends LerpSprite {
	private var tooltip:Tooltip;
	public function new(){
		super(); var t = Main.createText("Quotidian", 100, 0xffffff, 800, 1000, true, "Xeliard"); t.y = 50; addChild(t);
		var i = Assets.getBitmapData("data/title.png"), b = new LerpBitmap(i, 10); b.x = 800-i.width*10; b.y = 150; addChild(b);
	}
	private var bgm:SoundChannel;
	public override function init(e){
		bgm = Main.playSFX("title", 0, 10000);
		super.init(e); DarkenKeyframe.setDarkness(this, 0); lerp(new DarkenKeyframe(), 100, titleUp);
	}
	public override function destroy(e){
		bgm.stop();
		super.destroy(e); Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
	private function keyUp(e:KeyboardEvent):Void {
		if(Main.paused) return;
		if(e.keyCode == Keyboard.ENTER){
			Main._root.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp); tooltip.close(); lerp(new DarkenKeyframe(0), 60, startGame);
		}
	}
	private function startGame():Void {Main.setScreen(new Definition());}
	private function titleUp():Void {
		Main._root.stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
		tooltip = new Tooltip(0, 420, "Hit 'Enter' to Start", 800, true, true, 24); addChild(tooltip);
		var t = Main.createText("David Maletz - Natalie Maletz - Matthew Bumb", 16, 0x666666, 800, 1000, true);
		t.y = 480; var l = new LerpSprite(); l.addChild(t); l.alpha = 0; addChild(l); l.lerp(new AlphaKeyframe(), 60);
	}
}