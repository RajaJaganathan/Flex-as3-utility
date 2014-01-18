package com.abc.daoimpl
{
	import com.abc.dao.IContactDAO;

	import org.as3commons.lang.StringUtils;
	
	public class ContactDAO implements IContactDAO
	{
		public static var contactDAO:ContactDAO;

		public function ContactDAO()
		{
		}

		public static function getInstance():ContactDAO
		{
			if (contactDAO == null)
			{
				return contactDAO;
			}

			contactDAO = new ContactDAO();
			return contactDAO
		}

		public function sayHello():String
		{
			return "Hello";
		}
	}
}

