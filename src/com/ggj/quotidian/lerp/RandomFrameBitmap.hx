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
import flash.display.BitmapData;

/**
 * ...
 * @author David Maletz
 */
class RandomFrameBitmap extends FrameBitmap {
	public function new(b:BitmapData, scale:Float, count:Int, x:Float=-1, y:Float=-1) {
		super(b, scale, count, x, y);
	}
	private override function nextFrame(off:Int=0):Void {if(Math.random() < 0.8) super.nextFrame(1); else setFrame(frames.length-1);}
}