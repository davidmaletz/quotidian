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