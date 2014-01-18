package dash.utils
{
	import dash.__deprecated__.Assert;

    public final class DateUtil {
		
		public static const MONTHS_PER_YEAR:int		= 12;
		public static const DAYS_PER_WEEK:int 		= 7;
		public static const HOURS_PER_DAY:int		= 24;
		public static const MINUTES_PER_HOUR:int	= 60;
		public static const SECONDS_PER_MINUTE:int 	= 60;
		
		public static const MILLIS_PER_SECOND:int	= 1000;
		public static const MILLIS_PER_MINUTE:int	= SECONDS_PER_MINUTE * MILLIS_PER_SECOND;
		public static const MILLIS_PER_HOUR:int		= MINUTES_PER_HOUR * MILLIS_PER_MINUTE;
		public static const MILLIS_PER_DAY:int		= HOURS_PER_DAY * MILLIS_PER_HOUR;
		
		private static const NOT_NULL_ASSERTION_MESSAGE:String = "The dates must not be null.";
		private static const GMT_TIMEZONE_STRING:String = "GMT";
	
		public static function getDaysInMonth(year:int, month:int):int
		{
			var checkMonth:Date = new Date(year, month+1, 0);
			return checkMonth.date;
		}
		
		public static function convertFromMySQLDate( s:String, convertFromUTC:Boolean=false ):Date 
		{
			var a:Array = s.split(' ')[0].split( '-' );
			var date:Date = new Date( a[0], a[1] - 1, a[2] );
			var utcMS:Number = Date.parse(date);
			if(convertFromUTC) {
				utcMS -= getTimezone();
				date.setTime(utcMS);
			}
			return date; 
		}
		
		public static function convertToMySQLDate( date:Date ):String 
		{
			var s:String = date.fullYear + '-';
			
			// add the month
			if( date.month < 10 ) {
				s += '0' + ( date.month + 1 ) + '-';
			} else {
				s += ( date.month + 1 ) + '-';
			}
			
			// add the day
			if( date.date < 10 ) {
				s += '0' + date.date;
			} else {
				s += date.date;
			}
			
			return s;
		}
		
		public static function convertFromMySQLTimeStamp (time:String,  isUTC:Boolean=false):Date
		{
			var pattern:RegExp = /[: -]/g;
			time = time.replace( pattern, ',' );
			var timeArray:Array = time.split( ',' );
			var date:Date = new Date( 	timeArray[0], timeArray[1]-1, timeArray[2],
				timeArray[3], timeArray[4], timeArray[5] );
			if(isUTC) {
				date.setUTCFullYear(timeArray[0]);
				date.setUTCMonth(timeArray[1]-1);
				date.setUTCDate(timeArray[2]);
				date.setUTCHours(timeArray[3]);
				date.setUTCMinutes(timeArray[4]);
				date.setUTCSeconds(timeArray[5]);
			}
			return date;
		}
		
		public static function convertToMySQLTimeStamp( d:Date, convertToUTC:Boolean=false ):String 
		{
			var s:String = '';
			if(convertToUTC) {
				s = d.fullYearUTC + '-';
				s += prependZero( d.monthUTC + 1 ) + '-';
				s += prependZero( d.dateUTC ) + ' ';
				
				s += prependZero( d.hoursUTC ) + ':';
				s += prependZero( d.minutesUTC ) + ':';
				s += prependZero( d.secondsUTC );
			} else {
				s = d.fullYear + '-';
				s += prependZero( d.month + 1 ) + '-';
				s += prependZero( d.date ) + ' ';
				
				s += prependZero( d.hours ) + ':';
				s += prependZero( d.minutes ) + ':';
				s += prependZero( d.seconds );			
			}
			
			return s;
		}
		
		private static function prependZero( n:Number ):String 
		{
			var s:String = ( n < 10 ) ? '0' + n : n.toString();
			return s;
		}
		
		public static function getTimezone():Number
		{
			// Create two dates: one summer and one winter
			var d1:Date = new Date( 0, 0, 1 )
			var d2:Date = new Date( 0, 6, 1 )
			
			// largest value has no DST modifier
			var tzd:Number = Math.max( d1.timezoneOffset, d2.timezoneOffset )
			
			// convert to milliseconds
			return tzd * 60000
		}
		
		public static function getDST( d:Date ):Number
		{
			var tzd:Number = getTimezone()
			var dst:Number = (d.timezoneOffset * 60000) - tzd
			return dst
		}
		
		/*
		*  Comparison Functions
		*/
		public static function isSameDay(date1:Date, date2:Date):Boolean 
		{
			Assert.notNull(date1, NOT_NULL_ASSERTION_MESSAGE);
			Assert.notNull(date2, NOT_NULL_ASSERTION_MESSAGE);
			
			var result:Boolean=false;
			if (date1.getFullYear() == date2.getFullYear() && date1.getMonth() == date2.getMonth() && date1.getDate() == date2.getDate())
				result=true;
			
			return result;
		}
		
		public static function isSameInstant(date1:Date, date2:Date):Boolean 
		{
			Assert.notNull(date1, NOT_NULL_ASSERTION_MESSAGE);
			Assert.notNull(date2, NOT_NULL_ASSERTION_MESSAGE);
			
			var result:Boolean=false;
			if (date1.getTime() == date2.getTime())
				result=true;
			
			return result;
		}
		
		
		/*
		*  Add Functions
		*/
		public static function addYears(date:Date, years:Number):Date 
		{
			return addMonths(date, years * MONTHS_PER_YEAR);
		}
		
		public static function addMonths(date:Date, months:Number):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			
			var result:Date=new Date(date.getTime());
			result.setMonth(date.month + months);
			result=handleShorterMonth(date, result);
			return result;
		}
		
		public static function addWeeks(date:Date, weeks:int):Date 
		{
			return addDays(date, weeks * DAYS_PER_WEEK);
		}
		
		public static function addDays(date:Date, days:int):Date 
		{
			var result:Date=add(date, MILLIS_PER_DAY, days);
			return handleDaylightSavingsTime(date, result);
		}
		
		public static function addHours(date:Date, hours:int):Date 
		{
			return add(date, MILLIS_PER_HOUR, hours);
		}
		
		public static function addMinutes(date:Date, minutes:int):Date 
		{
			return add(date, MILLIS_PER_MINUTE, minutes);
		}
		
		public static function addSeconds(date:Date, seconds:int):Date 
		{
			return add(date, MILLIS_PER_SECOND, seconds);
		}
		
		public static function addMilliseconds(date:Date, milliseconds:int):Date 
		{
			return add(date, 1, milliseconds);
		}
		
		private static function add(date:Date, multiplier:int, num:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			var resultTime:Number=date.getTime() + multiplier * num;
			return new Date(resultTime);
		}
		
		/*
		* Set Functions
		*/
		public static function setYear(date:Date, year:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			var result:Date=new Date(year, date.month, date.date, date.hours, date.minutes, date.seconds, date.milliseconds);
			return handleShorterMonth(date, result);
		}
		
		public static function setMonth(date:Date, month:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			var result:Date=new Date(date.fullYear, month, date.date, date.hours, date.minutes, date.seconds, date.milliseconds);
			return handleShorterMonth(date, result);
		}
		
		public static function setDay(date:Date, day:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, day, date.hours, date.minutes, date.seconds, date.milliseconds);
		}
		
		public static function setHours(date:Date, hour:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, date.date, hour, date.minutes, date.seconds, date.milliseconds);
		}
		
		public static function setMinutes(date:Date, minute:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, date.date, date.hours, minute, date.seconds, date.milliseconds);
		}
		
		public static function setSeconds(date:Date, second:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, date.date, date.hours, date.minutes, second, date.milliseconds);
		}
		
		public static function setMilliseconds(date:Date, millisecond:int):Date 
		{
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, date.date, date.hours, date.minutes, date.seconds, millisecond);
		}
		
		
		/*
		* Conversion Functions
		*/
		public static function getUTCDate(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return getDateForOffset(date, date.getTimezoneOffset());
		}
		
		public static function getDateForOffset(date:Date, offsetMinutes:int):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			var offsetMilliseconds:Number=offsetMinutes * MILLIS_PER_MINUTE;
			return new Date(date.getTime() + offsetMilliseconds);
		}
		
		
		/*
		* Period Functions
		*/
		public static function getStartOfYear(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return getStartOfDay(new Date(date.fullYear, 0, 1));
		}
		
		public static function getStartOfMonth(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return getStartOfDay(new Date(date.fullYear, date.month, 1));
		}
		
		public static function getStartOfWeek(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return getStartOfDay(new Date(date.fullYear, date.month, date.date - date.day));
		}
		
		public static function getStartOfDay(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, date.date, 0, 0, 0, 0);
		}
		
		public static function getUTCStartOfDay(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(Date.UTC(date.fullYearUTC, date.monthUTC, date.dateUTC, 0, 0, 0, 0));
		}
		
		
		public static function getEndOfYear(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return getEndOfDay(new Date(date.fullYear, 11, 31));
		}
		
		public static function getEndOfMonth(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			var lastDateOfMonth:Date=getStartOfMonth(date);
			lastDateOfMonth=addMonths(lastDateOfMonth, 1);
			lastDateOfMonth=addDays(lastDateOfMonth, -1);
			return getEndOfDay(new Date(lastDateOfMonth.fullYear, lastDateOfMonth.month, lastDateOfMonth.date));
		}
		
		public static function getEndOfWeek(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return getEndOfDay(new Date(date.fullYear, date.month, date.date - date.day + 6));
		}
		
		public static function getEndOfDay(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(date.fullYear, date.month, date.date, 23, 59, 59, 999);
		}
		
		public static function getUTCEndOfDay(date:Date):Date {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return new Date(Date.UTC(date.fullYearUTC, date.monthUTC, date.dateUTC, 23, 59, 59, 999));
		}
		
		/*
		* Diff functions
		*/
		public static function getDaysDiff(startDate:Date, endDate:Date):int {
			Assert.notNull(startDate, NOT_NULL_ASSERTION_MESSAGE);
			Assert.notNull(endDate, NOT_NULL_ASSERTION_MESSAGE);
			return Math.ceil((endDate.getTime() - startDate.getTime()) / MILLIS_PER_DAY);
		}
		
		public static function getHoursDiff(startDate:Date, endDate:Date):int {
			Assert.notNull(startDate, NOT_NULL_ASSERTION_MESSAGE);
			Assert.notNull(endDate, NOT_NULL_ASSERTION_MESSAGE);
			return Math.ceil((endDate.getTime() - startDate.getTime()) / MILLIS_PER_HOUR);
		}
		
		public static function getMinutesDiff(startDate:Date, endDate:Date):int {
			Assert.notNull(startDate, NOT_NULL_ASSERTION_MESSAGE);
			Assert.notNull(endDate, NOT_NULL_ASSERTION_MESSAGE);
			return Math.ceil((endDate.getTime() - startDate.getTime()) / MILLIS_PER_MINUTE);
		}
		
		
		/*
		* Misc Functions
		*/
		
		public static function getLocalTimeZoneCode():String {
			var dateString:String=new Date().toString();
			var startIndex:int=dateString.indexOf(GMT_TIMEZONE_STRING);
			var endIndex:int=dateString.indexOf(" ", startIndex);
			
			return dateString.substring(startIndex, endIndex);
		}
		
		public static function isLeapYear(date:Date):Boolean {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			return (date.fullYear % 400 == 0) || ((date.fullYear % 4 == 0) && (date.fullYear % 100 != 0));
		}
		
		public static function isWeekDay(date:Date):Boolean {
			return !(isWeekEnd(date));
		}
		
		public static function isWeekEnd(date:Date):Boolean {
			Assert.notNull(date, NOT_NULL_ASSERTION_MESSAGE);
			var dayOfWeek:uint=date.day;
			return dayOfWeek == 0 || dayOfWeek == 6;
		}
		
		public static function getYesterday():Date {
			var result:Date=new Date();
			result.setDate(result.getDate() - 1);
			return result;
		}
		
		public static function getTomorrow():Date {
			var result:Date=new Date();
			result.setDate(result.getDate() + 1);
			return result;
		}
		
		
		/*
		* Helper methods
		*/
		private static function handleShorterMonth(originalDate:Date, newDate:Date):Date {
			var result:Date=newDate;
			var originalDayOfMonth:Number=originalDate.getDate();
			if (originalDayOfMonth > result.date) {
				result=addDays(newDate, -(newDate.date));
			}
			return result;
		}
		
		private static function handleDaylightSavingsTime(originalDate:Date, newDate:Date):Date {
			var result:Date=newDate;
			var originalHours:int=originalDate.hours;
			if (originalHours != result.hours)
				result=addHours(result, -(result.hours - originalHours));
			var originalMinutes:int=originalDate.minutes;
			if (originalMinutes != result.minutes)
				result=addMinutes(result, -(result.minutes - originalMinutes));
			
			return result;
			
		}
		
		public static function notNull(object:Object, message:String = ""):void {
			if (object == null) {
				if (message == null || message.length == 0) {
					message = "[Assertion failed] - this argument is required; it must not null";
				}
				throw new Error(message);
			}
		}
	}
}