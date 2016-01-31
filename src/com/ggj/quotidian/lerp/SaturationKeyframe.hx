package com.ggj.quotidian.lerp;
import com.ggj.quotidian.lerp.Keyframe.Interpolator;

/**
 * ...
 * @author David Maletz
 */
class SaturationKeyframe implements Keyframe {
	private var frame:Int; private var saturation:Float;
	public inline function new(a:Float=1){saturation = a;}
	public function set(from:Keyframe):Void {var k = cast(from, SaturationKeyframe); saturation = k.saturation;}
	public function setFromObject(d:Dynamic):Void {var a = cast(d, LerpSprite); saturation = a.saturation;}
	public function getFrame():Int {return frame;}
	public function setFrame(f:Int):Void {frame = f;}
	public function shiftFrame(df:Int):Void {frame += df;}
	public function copy(frame:Int):Keyframe {var f = new SaturationKeyframe(saturation); f.frame = frame; return f;}
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe {
		var k = cast(other, SaturationKeyframe); return new SaturationKeyframe(track.interp(saturation, k.saturation, f));
	}
	public function apply(d:Dynamic):Void {var a = cast(d, LerpSprite); a.saturation = saturation;}
	
	@:keep public function toString():String {return "SATURATION "+frame+" "+saturation;}
}