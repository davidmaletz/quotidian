package com.ggj.quotidian.lerp;
import com.ggj.quotidian.lerp.Keyframe.Interpolator;
import flash.display.Sprite;

/**
 * ...
 * @author David Maletz
 */
class PositionKeyframe implements Keyframe {
	private var frame:Int; private var x:Float; private var y:Float;
	public inline function new(_x:Float=0, _y:Float=0){x = _x; y = _y;}
	public function set(from:Keyframe):Void {var k = cast(from, PositionKeyframe); x = k.x; y = k.y;}
	public function setFromObject(d:Dynamic):Void {var a = cast(d, Sprite); x = a.x; y = a.y;}
	public function getFrame():Int {return frame;}
	public function setFrame(f:Int):Void {frame = f;}
	public function shiftFrame(df:Int):Void {frame += df;}
	public function copy(frame:Int):Keyframe {var f = new PositionKeyframe(x, y); f.frame = frame; return f;}
	public function interp(track:Interpolator, other:Keyframe, f:Float):Keyframe {
		var k = cast(other, PositionKeyframe); return new PositionKeyframe(track.interp(x, k.x, f), track.interp(y, k.y, f));
	}
	public function apply(d:Dynamic):Void {var a = cast(d, Sprite); a.x = x; a.y = y;}
	
	@:keep public function toString():String {return "POS "+frame+" ["+x+","+y+"]";}
}