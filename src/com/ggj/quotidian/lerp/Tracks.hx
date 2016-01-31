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