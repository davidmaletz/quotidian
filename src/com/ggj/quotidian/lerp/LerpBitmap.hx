package com.ggj.quotidian.lerp;
import flash.display.BitmapData;
import flash.geom.Matrix;

/**
 * ...
 * @author David Maletz
 */
class LerpBitmap extends LerpSprite {
	public function new(b:BitmapData, scale:Float) {
		super(); draw(b, scale);
	}
	private function draw(b:BitmapData, scale:Float):Void {
		graphics.beginBitmapFill(b, new Matrix(scale, 0, 0, scale), false, false);
		graphics.drawRect(0, 0, b.width*scale, b.height*scale); graphics.endFill();
	}
}