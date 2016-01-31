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
import com.ggj.quotidian.lerp.AlphaKeyframe;
import com.ggj.quotidian.lerp.LerpSprite;

/**
 * ...
 * @author David Maletz
 */
class Tooltip extends LerpSprite {
	private var doFlash:Bool;
	public function new(x:Float, y:Float, msg:String, w:Int=1000, center:Bool=false, flash:Bool=true) {
		super(); this.x = x; this.y = y; var t = Main.createText(msg, 16, 0xffffff, w, 1000, center); addChild(t); doFlash = flash;
		graphics.beginFill(0); graphics.drawRect((center?(w-t.textWidth)*0.5:0)+t.x-5, t.y-5, t.textWidth+10, t.textHeight+10); graphics.endFill();
	}
	public function close():Void {
		lerp(new AlphaKeyframe(0), 60, remove);
	}
	private function remove():Void {parent.removeChild(this);}
	public override function init(e){
		super.init(e); alpha = 0; flash();
	}
	public function flash():Void {lerp(new AlphaKeyframe((Main.paused)?0:1), 60, flashOff);}
	public function flashOff():Void {if(doFlash || alpha == 0) lerp(new AlphaKeyframe(0), 60, flash);}
}