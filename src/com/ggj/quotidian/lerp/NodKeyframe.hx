package com.ggj.quotidian.lerp;
import com.ggj.quotidian.lerp.Keyframe.Interpolator;
import flash.display.Sprite;

/**
 * ...
 * @author David Maletz
 */
class NodKeyframe implements Keyframe {
	private var frame:Int; private var shake:Float;
	public inline function new(a:Float=1){shake = a;}
	public function set(from:Keyframe):Void {var k = cast(from, NodKeyframe); shake = k.shake;}
	public function setFromObject(d:Dynamic):Void {shake = 0;}
	public function getFrame():Int {return frame;}
	public function setFrame(f:Int):Void {frame = f;}
	public function shiftFrame(df:Int):Void {frame += df;}
	public function copy(frame:Int):Keyframe {var f = new NodKeyframe(shake); f.frame = frame; return f;}
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe {
		var k = cast(other, NodKeyframe); return new NodKeyframe(track.interp(shake, k.shake, f));
	}
	public function apply(d:Dynamic):Void {var a = cast(d, Sprite); a.y = Math.sin(shake)*50;}
	
	@:keep public function toString():String {return "NOD "+frame+" "+shake;}
}