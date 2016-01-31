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
import flash.display.Sprite;
import flash.events.Event;
import flash.filters.ColorMatrixFilter;

/**
 * ...
 * @author David Maletz
 */
class LerpSprite extends Sprite {
	private var tracks:LerpTracks; public var saturation(default,set):Float = 1;
	public inline function new() { super(); addEventListener(Event.ADDED_TO_STAGE, init); addEventListener(Event.REMOVED_FROM_STAGE, destroy); }
	private function init(e:Event):Void {
		addEventListener(Event.ENTER_FRAME, enter_frame);
	}
	private function destroy(e:Event):Void {
		removeEventListener(Event.ENTER_FRAME, enter_frame);
	}
	public inline function hasTrack(cls:Class<Keyframe>):Bool {return tracks != null && tracks.hasTrack(cls);}
	public inline function hasLerp():Bool {return tracks != null;}
	public inline function clearLerp():Void {tracks = null;}
	public function lerp(k:Keyframe, frames:Int, onComplete:Void->Void=null):Void {
		if(tracks == null) tracks = new LerpTracks();
		tracks.getTrack(Type.getClass(k)).setLerp(this, k, frames, onComplete);
	}
	private function enter_frame(e:Event):Void {
		if(tracks != null && !tracks.nextFrame(this)) tracks = null;
	}
	private function set_saturation(f:Float):Float {
		saturation = f;
		#if flash
		if(f == 1) filters = []; else {
			var r = 0.2989, g = 0.5870, b = 0.1141, fi=1-f;
			filters = [new ColorMatrixFilter([1.0-(1.0-r)*fi, g*fi, b*fi, 0, 0, r*fi, 1.0-(1.0-g)*fi, b*fi, 0, 0, r*fi, g*fi, 1.0-(1.0-b)*fi, 0, 0, 0, 0, 0, 1, 0])];
		}
		#end
		return f;
	}
}