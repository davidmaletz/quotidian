package com.ggj.quotidian.lerp;

/**
 * ...
 * @author David Maletz
 */
class LerpTracks extends Tracks<LerpTrack> {
	public inline function new() {super();}
	
	private override function createTrack(cls:Class<Keyframe>):LerpTrack {return new LerpTrack(cls);}
	public function nextFrame(a:Dynamic):Bool {
		var ret = false; for(track in tracks) if(track.nextFrame(a)) ret = true; return ret;
	}
}