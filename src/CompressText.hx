import haxe.io.Path;
import haxe.Json;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import sys.FileSystem;
import sys.io.File;
import Sys.println;

using StringTools;

class CompressText {
	static var targetPath:String = null;

	static function main() {
		var decode = CompressTextMacro.getDefine('decode') != null;

		var str = CompressTextMacro.getDefine('str') ?? null;
		var file = CompressTextMacro.getDefine('file') ?? null;

		targetPath = CompressTextMacro.getDefine('targ') ?? null;

		if (targetPath == null) {
			println('No Target Path provided');
			return;
		}

		if (file == null && str == null && !decode) {
			println('No File or String provided');
			return;
		}

		function proceed(str:String) {
			if (decode)
				uncompress(str);
			else
				compress(str);
		}

		if (file != null && str == null) {
			println('File provided : $file');

			if (!FileSystem.exists(file)) {
				println('File not found : $file');
				return;
			}

			proceed(File.getContent(file));
			return;
		}

		if (file == null && str != null) {
			println('String provided : $str');
			proceed(str);
			return;
		}
	}

	static function uncompress(str:String) {
		var data = Json.parse(str);

		if (data.compression == null) {
			println('.JSON "compression" field missing!');
			return;
		}

		if (data.base64 == null) {
			println('.JSON "base64" field missing!');
			return;
		}

		save('txt', [
			for (number in Base64.decode(data.base64).toString().split(' '))
				data.compression.charAt(Std.parseInt(number))
		].join(''));
	}

	static function compress(str:String) {
		var cmpr = '';
		var values:Array<Int> = [];

		for (i in 0...str.length) {
			var index = cmpr.indexOf(str.charAt(i));

			if (index < 0) {
				// println('"$letter" has no index in compression');

				cmpr += str.charAt(i);
				index = cmpr.length - 1;
			}

			values.push(index);
		}

		save('json', Json.stringify({
			compression: cmpr,
			base64: Base64.encode(Bytes.ofString(values.join(' '))),
		}, null, '\t'));
	}

	static function save(ext:String, data:String) {
		var targ = new Path(Path.addTrailingSlash('$targetPath'.replace('\\', '/')));

		if (!FileSystem.exists(targ.dir))
			FileSystem.createDirectory(targ.dir);

		var path = '${targ.dir}/${Date.now().getTime() / 1000}.$ext';
		println('Result saved : $path');
		File.saveContent(path, data);
	}
}

class CompressTextMacro {
	public static macro function getDefine(define:String)
		return macro $v{haxe.macro.Context.definedValue(define)};
}
