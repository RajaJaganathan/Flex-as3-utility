package com.xinote.utils
{
	public class CommonUtil
	{
		public function CommonUtil()
		{
		}
		
		protected function findAndReplace ( search:String, replace:String, source:String ):String
		{
			return source.split(search).join(replace);
		}
	}
}