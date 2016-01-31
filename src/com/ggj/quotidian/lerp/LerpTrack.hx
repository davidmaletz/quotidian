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
import flash.events.Event;

/**
 * ...
 * @author David Maletz
 */
class LerpTrack {
	private var keyframe_class:Class<Keyframe>; private var frame:Int; private var from:Keyframe; private var to:Keyframe;
	private var onComplete:Void->Void;
	public inline function new(cls:Class<Keyframe>) {keyframe_class = cls; frame = 0;}
	public inline function getKeyframeClass():Class<Keyframe> {return keyframe_class;}
	private inline function newKeyframe():Keyframe {return Type.createEmptyInstance(keyframe_class);}
	public inline function setLerp(a:Dynamic, to:Keyframe, frames:Int, onComplete:Void->Void=null):Void {
		from = newKeyframe(); from.set(to); from.setFromObject(a); from.setFrame(0); frame = 0; this.to = to; to.setFrame(frames);
		/*fireComplete();*/ this.onComplete = onComplete;
	}
	private function doComplete():Void {var f = onComplete; onComplete = null; if(f != null) f();}
	private inline function fireComplete():Void {
		var f = onComplete; onComplete = null; if(f != null){
			var complete:Event->Void = null; function func(e:Event):Void {
				Main._root.removeEventListener(Event.ENTER_FRAME, complete); f();
			} complete = func; Main._root.addEventListener(Event.ENTER_FRAME, complete);
		}
	}
	public inline function clear():Void {from = null; to = null; frame = 0; fireComplete();}
	private inline function hasKeyframes():Bool {return from != null && to != null;}
	public function getKeyframe(f:Int):Keyframe {
		var pf = from.getFrame(), nf = to.getFrame(); if(f <= pf) return from; else if(f >= nf) return to;
		else return from.interp(this, to, (f-pf)/(nf-pf));
	}
	public function interp(a:Float, b:Float, f:Float):Float {return a*(1-f)+b*f;}
	public inline function nextFrame(a:Dynamic):Bool {
		if(hasKeyframes()){
			var k = getKeyframe(frame++); k.apply(a); if(k == to){clear(); return false;} else return true;
		} else return false;
	}
}