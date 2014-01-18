package com.abc.constants
{
	public class ActionConstants
	{
		public static const CREATE:String = 'Create';
		public static const UPDATE:String = 'Update';
		public static const READ:String = 'Read';
		public static const FIND_ID:String = 'FindId';
		public static const FINDBY_NAME:String = 'FindByName';
		public static const FINDBY_ID:String = 'FindById';
		public static const FINDPUSH_ID:String = 'FindPushId';
		public static const DELETE:String = 'Delete';
		public static const GET_COUNT:String = 'Count';
		public static const GET_LIST:String = 'FindAll';
		public static const SQL_FINDALL:String = 'SQLFindAll';
		public static const BULK_UPDATE:String = 'BulkUpdate';
		public static const DELETE_ALL:String = 'DeleteAll';
		public static const PUSH_MSG:String = 'PushMsg';
		public static const RECEIVE_MSG:String = 'receiveMsg';

		public static const GETQUERYRESULT:String = 'getQueryResult';
		public static const PAGINATIONLISTVIEW:String = 'paginationListView';
		public static const QUERYLISTVIEW:String = 'queryListView';
		public static const PAGINATIONLISTVIEWID:String = 'paginationListViewId';
		public static const QUERYPAGINATION:String = 'queryPagination';
		public static const REFRESHTWEETS:String = 'refreshTweets';
		public static const UPDATETWEET:String = 'updateTweet';
		public static const SENDMAIL:String = 'sendMail';
		public static const CREATEPERSON:String = 'createPerson';
		public static const PAGINGACTIONS:Array = [GETQUERYRESULT,PAGINATIONLISTVIEW,QUERYLISTVIEW,PAGINATIONLISTVIEWID,QUERYPAGINATION,REFRESHTWEETS,UPDATETWEET,SENDMAIL,CREATEPERSON];

		public function ActionConstants()
		{
		}
	}
}

