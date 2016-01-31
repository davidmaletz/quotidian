package com.ggj.quotidian.lerp;
import flash.display.BitmapData;

/**
 * ...
 * @author David Maletz
 */
class RandomFrameBitmap extends FrameBitmap {
	public function new(b:BitmapData, scale:Float, count:Int, x:Float=-1, y:Float=-1) {
		super(b, scale, count, x, y);
	}
	private override function nextFrame():Void {setFrame((Math.random() < 0.8)?0:1);}
}