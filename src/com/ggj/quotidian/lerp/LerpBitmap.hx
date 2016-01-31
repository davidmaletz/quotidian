/******************************************************************************* 
 * Copyright (C) 2013  David Maletz
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
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