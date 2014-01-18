// =================================================================
/*
 *  Copyright (c) 2009
 *  Lance Pollard
 *  http://www.viatropos.com
 *  lancejpollard at gmail dot com
 *  
 *  Permission is hereby granted, free of charge, to any person
 *  obtaining a copy of this software and associated documentation
 *  files (the "Software"), to deal in the Software without
 *  restriction, including without limitation the rights to use,
 *  copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following
 *  conditions:
 * 
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 *  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 *  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 *  OTHER DEALINGS IN THE SOFTWARE.
 */
// =================================================================

package bloom.core
{
	import mx.rpc.IResponder;
	
	[DefaultProperty("responders")]
	/**
	 *	ComplexResponder
	 */
	public class ComplexResponder implements IResponder
	{
		protected var resultHandler:Function;
		protected var faultHandler:Function;
		protected var params:Array;
		
		private var _responders:Array = [];
		[ArrayElementType("mx.rpc.IResponder")]
		/**
		 *  Responders so you can start nesting them
		 */
		public function get responders():Array
		{
			return _responders;
		}
		public function set responders(value:Array):void
		{
			_responders = value;
		}
		
		public var name:String;
	
		/**
		 *	ComplexResponder Constructor
		 */
		public function ComplexResponder(result:Function, fault:Function, ... params)
		{
			resultHandler = result;
			faultHandler = fault;
			this.params = params;
		}
		
		public function result(data:Object):void
		{
			resultHandler.apply(null, getArgs(data));
			
			if (_responders)
			{
				var i:int = 0;
				var n:int = _responders.length;
				for (i; i < n; i++)
				{
					_responders[i].result(data);
				}
			}
		}
		
		public function fault(data:Object):void
		{
			faultHandler.apply(null, getArgs(data));
			
			if (_responders)
			{
				var i:int = 0;
				var n:int = _responders.length;
				for (i; i < n; i++)
				{
					_responders[i].fault(data);
				}
			}
		}
		
		protected function getArgs(data:Object):Array
		{
			var args:Array = params ? params.concat() : [];
			args.splice(0, 0, data);
			return args;
		}
		
		public function pop():IResponder
		{
			if (_responders && _responders.length > 0)
				return _responders.pop();
			return null;
		}
		
		public function push(responder:IResponder):void
		{
			_responders.push(responder);
		}
	}
}