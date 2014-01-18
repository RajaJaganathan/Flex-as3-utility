package bloom.constants
{
		
	/**
	 *	This is a list of all RESTful Resource Action you have in you application
	 */
	public class ResourceAction
	{	
		// =======================================================
		// CRUD (and related) Constants
		// =======================================================
		public static const LIST:String = "list";
		public static const INDEX:String = "index";
		public static const OPEN:String = "open";
		public static const SHOW:String = "show";
		public static const NEW:String = "new";
		public static const CREATE:String = "create";
		public static const SAVE:String = "save";
		public static const UPDATE:String = "update";
		public static const DESTROY:String = "destroy";
		public static const STORE:String = "store"; // use to save in favorites or add to cart
		public static const UPLOAD:String = "upload";
		public static const REFRESH:String = "refresh";
		public static const DOWNLOAD:String = "download";
		
		// =======================================================
		// Result Constants
		// =======================================================
		
		public static const SUCCESS:String = "success";
		public static const FAILURE:String = "failure";
		
		// =======================================================
		// Specific Combination Constants (optimization)
		// =======================================================
		
		// Login
		public static const SIGN_ON:String = "signOn";
		public static const SIGN_ON_SUCCESS:String = "signOnSuccess";
		public static const SIGN_ON_FAILURE:String = "signOnFailure";
		public static const CREATE_SESSION:String = "createSession";
		public static const CREATE_SESSION_SUCCESS:String = "createSessionSuccess";
		public static const CREATE_SESSION_FAILURE:String = "createSessionFailure";
		
		// Message
		public static const CREATE_MESSAGE:String = "createMessage";
		public static const CREATE_MESSAGE_SUCCESS:String = "createMessageSuccess";
		public static const CREATE_MESSAGE_FAILURE:String = "createMessageFailure";
		public static const SEND_MESSAGE:String = "sendMessage";
		public static const SEND_MESSAGE_SUCCESS:String = "sendMessageSuccess";
		public static const SEND_MESSAGE_FAILURE:String = "sendMessageFailure";
		
		// Account
		public static const SAVE_ACCOUNT:String = "saveAccount";
		public static const SAVE_ACCOUNT_SUCCESS:String = "saveAccountSuccess";
		public static const SAVE_ACCOUNT_FAILURE:String = "saveAccountFailure";
		
		// User
		public static const CREATE_USER:String = "createUser";
		public static const CREATE_USER_SUCCESS:String = "createUserSuccess";
		public static const CREATE_USER_FAILURE:String = "createUserFailure";
	}
}