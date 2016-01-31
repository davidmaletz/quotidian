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
package com.ggj.quotidian;
#if flash
typedef Assets = openfl.Assets;
#else
import flash.display.BitmapData;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.text.Font;
import flash.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author ...
 */
class Assets{
	public static inline function exists(id:String):Bool {return FileSystem.exists(id);}
	public static inline function getBytes(id:String):ByteArray {return ByteArray.fromBytes(File.getBytes(id));}
	public static inline function getText(id:String):String {
		var b = getBytes(id); if(b == null) return null; else return b.readUTFBytes(b.length);
	}
	private static var bitmaps = new Map<String, BitmapData>();
	public static inline function getBitmapData(id:String):BitmapData {
		var b = bitmaps.get(id); if(b == null){
			b = BitmapData.fromFile(id); bitmaps.set(id, b);
		} return b;
	}
	public static inline function getFont(id:String):Font {return new Font(id);}
	private static var sounds = new Map<String, Sound>();
	public static inline function getSound(id:String):Sound {
		var s = sounds.get(id); if(s == null){
			s = new Sound(new URLRequest(id)); sounds.set(id, s);
		} return s;
	}
}
#end