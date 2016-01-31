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

/**
 * ...
 * @author David Maletz
 */
class Tracks<E> {
	private var tracks:Map<String, E>;
	public inline function new() {tracks = new Map<String, E>();}
	
	public inline function hasTrack(cls:Class<Keyframe>):Bool {return tracks.exists(Type.getClassName(cls));}
	public inline function getTrack(cls:Class<Keyframe>):E {
		var n = Type.getClassName(cls), t = tracks.get(n); if(t == null){t = createTrack(cls); tracks.set(n, t);} return t;
	}
	public inline function removeTrack(cls:Class<Keyframe>):Void {tracks.remove(Type.getClassName(cls));}
	public function getTracks():Array<Class<Keyframe> > {
		var ret = new Array<Class<Keyframe> >(); for(k in tracks.keys()) ret.push(cast(Type.resolveClass(k))); return ret;
	}
	private function createTrack(cls:Class<Keyframe>):E {return null;}
}