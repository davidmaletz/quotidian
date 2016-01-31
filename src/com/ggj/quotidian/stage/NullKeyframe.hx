package com.ggj.quotidian.stage;
import com.ggj.quotidian.lerp.Keyframe;

/**
 * ...
 * @author David Maletz
 */
class NullKeyframe implements Keyframe {
	private var frame:Int;
	public inline function new(){}
	public function set(from:Keyframe):Void {}
	public function setFromObject(d:Dynamic):Void {}
	public function getFrame():Int {return frame;}
	public function setFrame(f:Int):Void {frame = f;}
	public function shiftFrame(df:Int):Void {frame += df;}
	public function copy(frame:Int):Keyframe {var f = new NullKeyframe(); f.frame = frame; return f;}
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe {return new NullKeyframe();}
	public function apply(d:Dynamic):Void {}
	
	@:keep public function toString():String {return "NULL "+frame;}
}