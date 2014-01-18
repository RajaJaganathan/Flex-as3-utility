package com.abc.utils
{
	public class NumberUtil
	{
//Usage: trace(NumberUtil.converToWords(numbers.text));
		private static const THOUSANDS:Array = ['','Thousand','Million','Billion','Trillion'];
		private static const DECADES:Array = ['Twenty','Thirty','Forty','Fifty','Sixty','Seventy','Eighty','Ninety'];
		private static const TENS:Array = ['Ten','Eleven','Twelve','Thirteen','Fourteen','Fifteen','Sixteen','Seventeen','Eighteen','Nineteen'];
		private static const DIGITS:Array = ['Zero','One','Two','Three','Four','Five','Six','Seven','Eight','Nine'];
		private static const HUNDRED:String = 'Hundred ';
		private static const POINT:String ='point ';
		private static const BIG:String ='Too big'

		public static function converToWords(s:String):String{
			s = s.replace(/[\, ]/g,'');
			var x:int = s.indexOf('.');
			if (x == -1) x = s.length;
			if (x > 15) return BIG;

			var number:Array = s.split('');
			var Words:String = '';
			var cnt:int = 0;

			for (var i:int=0; i < x; i++) {
				if ((x-i)%3==2) {
					if (number[i] == '1') {
						Words += TENS[Number(number[i+1])] + ' ';
						i++;
						cnt=1;
					}
					else if (number[i]!=0){
						Words += DECADES[number[i]-2] + ' ';
						cnt=1;
					}
				}else if (number[i]!=0) {
					Words += DIGITS[number[i]] +' ';
					if ((x-i)%3==0) Words += HUNDRED;
					cnt=1;
				}
				if ((x-i)%3==1) {
					if (cnt) Words += THOUSANDS[(x-i-1)/3] + ' ';
					cnt=0;
				}
			}
			if (x != s.length) {
				var y:int = s.length;
				Words += POINT;
				for (var j:int=x+1; j<y; j++) Words += DIGITS[number[j]] +' ';
			}
			return Words.replace(/\s+/g,' ');
		}
	}
}

