package com.ggj.quotidian.lerp;

typedef Interpolator = {public function interp(a:Float, b:Float, f:Float):Float ;};

/**
 * ...
 * @author David Maletz
 */
interface Keyframe {
	public function set(k:Keyframe):Void;
	public function setFromObject(a:Dynamic):Void;
	public function getFrame():Int;
	public function setFrame(f:Int):Void;
	public function shiftFrame(df:Int):Void;
	public function copy(f:Int):Keyframe;
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe;
	public function apply(a:Dynamic):Void;
}