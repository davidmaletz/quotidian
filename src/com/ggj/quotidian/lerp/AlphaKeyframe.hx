package com.ggj.quotidian.lerp;
import com.ggj.quotidian.lerp.Keyframe.Interpolator;
import flash.display.Sprite;

/**
 * ...
 * @author David Maletz
 */
class AlphaKeyframe implements Keyframe {
	private var frame:Int; private var alpha:Float;
	public inline function new(a:Float=1){alpha = a;}
	public function set(from:Keyframe):Void {var k = cast(from, AlphaKeyframe); alpha = k.alpha;}
	public function setFromObject(d:Dynamic):Void {var a = cast(d, Sprite); alpha = a.alpha;}
	public function getFrame():Int {return frame;}
	public function setFrame(f:Int):Void {frame = f;}
	public function shiftFrame(df:Int):Void {frame += df;}
	public function copy(frame:Int):Keyframe {var f = new AlphaKeyframe(alpha); f.frame = frame; return f;}
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe {
		var k = cast(other, AlphaKeyframe); return new AlphaKeyframe(track.interp(alpha, k.alpha, f));
	}
	public function apply(d:Dynamic):Void {var a = cast(d, Sprite); a.alpha = alpha;}
	
	@:keep public function toString():String {return "ALPHA "+frame+" "+alpha;}
}