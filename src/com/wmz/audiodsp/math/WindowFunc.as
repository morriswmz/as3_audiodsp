package com.wmz.audiodsp.math 
{
	/**
	 * ...
	 * @author morriswmz
	 */
	public final class WindowFunc 
	{
		private var windowSeq:Vector.<Number>;
		private var windowType:String;
		private var buffer:Vector.<Number>;
		
		public function WindowFunc(p_type:String, p_n:int, inverse:Boolean = false) 
		{
			windowType = p_type;
			windowSeq = generate(p_type, p_n, inverse);
			buffer = new Vector.<Number>();
		}
		
		public function apply(p_seq:Vector.<Number>, clone:Boolean = false):Vector.<Number> {
			if (windowSeq.length != p_seq.length) throw new Error('Window length mismatch!' )
			var n:int = Math.min(p_seq.length, windowSeq.length);
			var i:int;
			if (clone) {
				for (i = 0; i < n; i++) {
					buffer[i] = windowSeq[i] * p_seq[i];
				}
				return buffer;
			} else {
				for (i = 0; i < n; i++) {
					p_seq[i] *= windowSeq[i];
				}
				return null;
			}
		}
		
		public static const W_TRIANGLE:String = "triangle";
		public static const W_HANNING:String = "hanning";
		public static const W_HAMMING:String = "hamming";
		public static const W_GAUSSIAN:String = "gaussian";
		public static const W_BLACKMAN:String = "blackman";
		
		private static function _triangleWindow(x:Number):Number {
			return ((x > 0.5) ? 2.0 * (1.0 - x) : x);
		}
		
		private static function _hammingWindow(x:Number):Number {
			return (0.54 + 0.46 * Math.cos(2 * Math.PI * (x - 0.5)));
		}
		
		private static function _hanningWindow(x:Number):Number {
			return 0.5 * (1 + Math.cos(2 * Math.PI * (x - 0.5)));
		}
		
		private static function _gussianWindow(x:Number, sigma:Number = 0.15):Number {
			return Math.exp( -0.5 * (x - 0.5) * (x - 0.5) / sigma / sigma);
		}
		
		private static function _blackmanWindow(x:Number):Number {
			return 0.42659 + 0.49656 * Math.cos(2 * Math.PI * (x - 0.5)) + 0.076849 * Math.cos(4 * Math.PI * (x - 0.5));
		}
		
		private static function _rectWindow(x:Number):Number {
			return 1.0;
		}
		
		private static function generate(type:String, n:int, inverse:Boolean = false):Vector.<Number> {
			var i:int;
			var ret:Vector.<Number> = new Vector.<Number>(n);
			var n_1:int = n + 1;
			var generator:Function;
			switch (type) {
				case W_TRIANGLE: generator = _triangleWindow; break;
				case W_HAMMING: generator = _hammingWindow; break;
				case W_HANNING: generator = _hanningWindow; break;
				case W_GAUSSIAN: generator = _gussianWindow; break;
				case W_BLACKMAN: generator = _blackmanWindow; break;
				default: generator = _rectWindow;
			}
			if (inverse) {
				for (i = 0; i < n; i++) ret[i] = 1.0 / generator((i + 1) / n_1);
			} else {
				for (i = 0; i < n; i++) ret[i] = generator((i + 1) / n_1);
			}
			return ret;
		}
		
	}

}