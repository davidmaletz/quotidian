package com.ggj.quotidian.lerp;
import flash.display.BitmapData;
import flash.events.Event;
import flash.geom.Point;

/**
 * ...
 * @author David Maletz
 */
class FrameBitmap extends LerpBitmap {
	private var frames:Array<BitmapData>; private var points:Array<Point>;
	private var scale:Float; private var count:Int; private var frame:Int = -1; private var ct:Int;
	public function new(b:BitmapData, scale:Float, count:Int, x:Float=-1, y:Float=-1) {
		super(b, scale); frames = [b]; this.scale = scale; this.count = count; ct = count;
		if(x == -1) points = null; else points = [new Point(x, y)];
	}
	public inline function addFrame(b:BitmapData, x:Float=-1, y:Float=-1):Void {
		frames.push(b); if(points != null) points.push(new Point(x, y));
	}
	public inline function setFrame(f:Int):Void {
		graphics.clear(); draw(frames[f], scale);
		if(points != null){var p = points[f]; x = p.x*scale; y = p.y*scale;}
	}
	public function play():Void {if(frame < 0) frame = -frame-1;}
	public function stop():Void {frame = -frame-1;}
	private function nextFrame():Void {frame++; if(frame >= frames.length) frame = 0; setFrame(frame);}
	private override function enter_frame(e:Event):Void {
		if(visible && frame >= 0){
			ct--; if(ct < 0){nextFrame(); ct = count;}
		}
		super.enter_frame(e);
	}
}