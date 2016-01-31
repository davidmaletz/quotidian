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
import flash.events.Event;
import flash.geom.Point;

/**
 * ...
 * @author David Maletz
 */
class FrameBitmap extends LerpBitmap {
	private var frames:Array<BitmapData>; private var points:Array<Point>;
	private var scale:Float; private var count:Int; private var frame:Int = -1; private var ct:Int;
	public function new(b:BitmapData, scale:Float, count:Int, x:Float=-1, y:Float=-1) {
		super(b, scale); frames = [b]; this.scale = scale; this.count = count; ct = count;
		if(x == -1) points = null; else points = [new Point(x, y)];
	}
	public inline function addFrame(b:BitmapData, x:Float=-1, y:Float=-1):Void {
		frames.push(b); if(points != null) points.push(new Point(x, y));
	}
	public inline function setFrame(f:Int):Void {
		graphics.clear(); draw(frames[f], scale);
		if(points != null){var p = points[f]; x = p.x*scale; y = p.y*scale;}
	}
	public function play():Void {if(frame < 0) frame = -frame-1;}
	public function stop():Void {frame = -frame-1;}
	private function nextFrame(off:Int=0):Void {frame++; if(frame >= frames.length-off) frame = 0; setFrame(frame);}
	private override function enter_frame(e:Event):Void {
		if(visible && frame >= 0){
			ct--; if(ct < 0){nextFrame(); ct = count;}
		}
		super.enter_frame(e);
	}
}