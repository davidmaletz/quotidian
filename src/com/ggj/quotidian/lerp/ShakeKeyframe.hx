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
package com.ggj.quotidian.lerp;
import com.ggj.quotidian.lerp.Keyframe.Interpolator;
import flash.display.Sprite;

/**
 * ...
 * @author David Maletz
 */
class ShakeKeyframe implements Keyframe {
	private var frame:Int; private var shake:Float;
	public inline function new(a:Float=1){shake = a;}
	public function set(from:Keyframe):Void {var k = cast(from, ShakeKeyframe); shake = k.shake;}
	public function setFromObject(d:Dynamic):Void {shake = 0;}
	public function getFrame():Int {return frame;}
	public function setFrame(f:Int):Void {frame = f;}
	public function shiftFrame(df:Int):Void {frame += df;}
	public function copy(frame:Int):Keyframe {var f = new ShakeKeyframe(shake); f.frame = frame; return f;}
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe {
		var k = cast(other, ShakeKeyframe); return new ShakeKeyframe(track.interp(shake, k.shake, f));
	}
	public function apply(d:Dynamic):Void {var a = cast(d, Sprite); a.x = Math.sin(shake*2)*10; a.y = Math.sin(shake)*10;}
	
	@:keep public function toString():String {return "SHAKE "+frame+" "+shake;}
}