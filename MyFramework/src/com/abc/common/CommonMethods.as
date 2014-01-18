package com.clipboard.common.classes
{
	import com.clipboard.common.model.ModelLocator;
	import com.clipboard.common.vo.MemberAuditVO;
	import com.clipboard.insurance.events.DeleteUploadedDataEvent;
	import com.clipboard.insurance.events.UpdateInsuranceEvent;
	import com.clipboard.insurance.vo.InsuranceDetailsVO;
	import com.clipboard.medical.model.MedicalLocator;
	import com.clipboard.medical.vo.AllergyVO;
	import com.clipboard.medical.vo.ChildDiseaseVO;
	import com.clipboard.medical.vo.GeneralMedicationVO;
	import com.clipboard.medical.vo.HistoryVO;
	import com.clipboard.medical.vo.ImmunizationVO;
	import com.clipboard.medical.vo.RiskFactorVO;
	import com.clipboard.member.events.UpdatePersonalInfoEvent;
	import com.clipboard.personalinformation.events.UpdateMemberInfoEvent;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	
	public class CommonMethods
	{
		public function CommonMethods()
		{
		}
		//public static function emergencyContactEntry(id:String, name:String):void
		public static function emergencyContactEntry(data:Object):void
		{
			var commonLocator:ModelLocator= ModelLocator.getInstance();
			//data can be two different objects, handle both
			var id : int = data.memberID;
			var name : String = data.firstName + " " + data.lastName;
			if (isNaN(id) || id <=0)
			{
				id = data.member_id;
				name = data.member_first_name + " " + data.member_last_name;
			}
			
			//Modification. akorkki 8/31/2010 add the first option right away if this list is empty
			if (commonLocator.emergencyContacts.length == 0) {
				commonLocator.emergencyContacts.addItem({
					name: "New",
					id: 0
				});
			}
			
			var i:int=0;
			for(i=0;i<commonLocator.emergencyContacts.length;i++)
			{
				if(commonLocator.emergencyContacts[i].id==id)
				{
					commonLocator.emergencyContacts[i].name=name;
					break;
				}
			}
			if(i >= commonLocator.emergencyContacts.length)
			{
				var obj:Object= new Object();
				obj.id=id;
				obj.name=name;
				commonLocator.emergencyContacts.addItem(obj);
				
			}
		}
		public static function convertToArrayCollection(objIn:Object, includeSelect:Boolean = false):ArrayCollection
		{
			var acTmpArray:ArrayCollection = new ArrayCollection;
			var i : Number = 0;
			if (includeSelect==true)
				i = -1;
				
	        for (i; i < objIn.initialData.length;i++) 
	        { 
	            var clTempClass:Object = new Object(); 
	            for (var j:Number = 0;j < objIn.columnNames.length;j++) 
	            { 
	            	if (i<0 && includeSelect==true) 
					{
						if (objIn.initialData.length < 1)
							clTempClass[objIn.columnNames[j]] = "------------------";
						else
							clTempClass[objIn.columnNames[j]] = "SELECT ONE";
						if (j==(objIn.columnNames.length-1))
							includeSelect=false;
					}
					else
	                 	clTempClass[objIn.columnNames[j]] = objIn.initialData[i][j]; 
	            } 
	            acTmpArray.addItem(clTempClass); 
	        } 
	        return acTmpArray; 
		}
		 public static function saveData(page:int):void
		{
			var evt:UpdatePersonalInfoEvent= new UpdatePersonalInfoEvent(page);
				evt.dispatch();
		} 
		public static function saveInsuranceData(vo : InsuranceDetailsVO):void
		{
			var saveInsuranceDataEvent:UpdateInsuranceEvent= new UpdateInsuranceEvent(vo);
				saveInsuranceDataEvent.dispatch();
		}
		
			
		public static function deleteHandler(event:CloseEvent):void
		{	
			 var model:ModelLocator= ModelLocator.getInstance();
			if(event.detail == mx.controls.Alert.YES)
			{
				var deleteUplodedData:DeleteUploadedDataEvent=new DeleteUploadedDataEvent(model.loginMemberId,model.type)
				deleteUplodedData.dispatch();
			}	
		}
		public static function saveMemberInfo():void
		{
			var updateEvent:UpdateMemberInfoEvent=new UpdateMemberInfoEvent();
				updateEvent.dispatch();
		}
		 public static function addRiskFactor(qId:int,answerId:int,bitSum:int,enteredData:String):void
		{
			var riskFactorVo:RiskFactorVO=new RiskFactorVO();
			riskFactorVo.memberId=ModelLocator.getInstance().selectedFamilyMemberID;
			riskFactorVo.answerId=answerId;
			riskFactorVo.questionId=qId;
			riskFactorVo.bitSum=bitSum;
			riskFactorVo.userEnteredValue=enteredData;
			var flag:Boolean;
			var medicalLocator:MedicalLocator=MedicalLocator.getInstance();
			for(var i:int;i< medicalLocator.riskFactor.length;i++)
			{
				if(medicalLocator.riskFactor[i].questionId==qId )
				{	
					medicalLocator.riskFactor.setItemAt(riskFactorVo,i);
					flag=true;
					break;
				}
			} 
			if(!flag)
				medicalLocator.riskFactor.addItem(riskFactorVo);
		}
		public static function addAllergy(qId:int,answerId:int,bitSum:int,enteredData:String):void
		{
			var allergyVo:AllergyVO=new AllergyVO();
			allergyVo.memberID=ModelLocator.getInstance().selectedFamilyMemberID;
			allergyVo.answerID=answerId;
			allergyVo.questionID=qId;
			allergyVo.bitSum=bitSum;
			allergyVo.userEnteredValue=enteredData;
			var flag:Boolean;
			var medicalLocator:MedicalLocator=MedicalLocator.getInstance();
			for(var i:int;i< medicalLocator.allergy.length;i++)
			{
				if(medicalLocator.allergy[i].questionID==qId )
				{	
					medicalLocator.allergy.setItemAt(allergyVo,i);
					flag=true;
					break;
				}
			} 
			if(!flag)
				medicalLocator.allergy.addItem(allergyVo);
		}
		public static function InsertHistory(qId:int,answerId:int,bitSum:int,enteredData:String):void
		{
			var historyVo:HistoryVO=new HistoryVO();
			historyVo.memberID=ModelLocator.getInstance().selectedFamilyMemberID;
			historyVo.answerID=answerId;
			historyVo.questionID=qId;
			historyVo.bitSum=bitSum;
			historyVo.userEnteredValue=enteredData;
			var flag:Boolean;
			var medicalLocator:MedicalLocator=MedicalLocator.getInstance();
			for(var i:int;i< medicalLocator.history.length;i++)
			{
				if(medicalLocator.history[i].questionID==qId )
				{	
					medicalLocator.history.setItemAt(historyVo,i);
					flag=true;
					break;
				}
			} 
			if(!flag)
				medicalLocator.history.addItem(historyVo);
		}
		
		public static function InsertImmunization(qId:int,answerId:int,doseCount:int,year:int):void
		{
			var immuVo:ImmunizationVO=new ImmunizationVO();
			immuVo.memberID=ModelLocator.getInstance().selectedFamilyMemberID;
			immuVo.answerID=answerId;
			immuVo.questionID=qId;
			immuVo.doseCount=doseCount;
			immuVo.iYear= year;
			var flag:Boolean;
			var medicalLocator:MedicalLocator=MedicalLocator.getInstance();
			for(var i:int;i< medicalLocator.immunization.length;i++)
			{
				if(medicalLocator.immunization[i].questionID==qId )
				{	
					medicalLocator.immunization.setItemAt(immuVo,i);
					flag=true;
					break;
				}
			} 
			if(!flag)
				medicalLocator.immunization.addItem(immuVo);
		}
		
		public static function addChildDisease(qId:int,answerId:int,bitSum:int,enteredData:String):void
		{
			var childDisease:ChildDiseaseVO=new ChildDiseaseVO();
			childDisease.memberID=ModelLocator.getInstance().selectedFamilyMemberID;
			childDisease.answerID=answerId;
			childDisease.questionID=qId;
			childDisease.bitSum=bitSum;
			childDisease.userEnteredValue=enteredData;
			var flag:Boolean;
			var medicalLocator:MedicalLocator=MedicalLocator.getInstance();
			for(var i:int;i< medicalLocator.disease.length;i++)
			{
				if(medicalLocator.disease[i].questionID==qId )
				{	
					medicalLocator.disease.setItemAt(childDisease,i);
					flag=true;
					break;
				}
			} 
			if(!flag)
				medicalLocator.disease.addItem(childDisease);
				
		}
		public static function addGeneralMedication(qId:int,answerId:int,bitSum:int,enteredData:String):void
		{
			var generalMedication:GeneralMedicationVO=new GeneralMedicationVO();
			generalMedication.memberID=ModelLocator.getInstance().selectedFamilyMemberID;
			generalMedication.answerID=answerId;
			generalMedication.questionID=qId;
			generalMedication.bitSum=bitSum;
			generalMedication.userEnteredValue=enteredData;
			var flag:Boolean;
			var medicalLocator:MedicalLocator=MedicalLocator.getInstance();
			for(var i:int;i< medicalLocator.medication.length;i++)
			{
				if(medicalLocator.medication[i].questionID==qId )
				{	
					medicalLocator.medication.setItemAt(generalMedication,i);
					flag=true;
					break;
				}
			} 
			if(!flag)
				medicalLocator.medication.addItem(generalMedication);
				
		}
		public static function setSelectToAnserArray(arr:ArrayCollection):ArrayCollection
		{
			var obj:Object=arr[0];
			if(obj.AnswerOption !="Select")
			 {
			 	var obj1:Object= new Object();
			 	obj1.AnswerOption="Select";
			 	obj1.BitValue=0;
			 	arr.addItemAt(obj1,0);
			 }
			return arr;
			
		}  
		public static function setSelectToYNArray(arr:ArrayCollection):ArrayCollection
		{
			var obj:Object=arr[0];
			if(obj.AnswerOption !="Select")
			 {
			 	var obj1:Object= new Object();
			 	obj1.name="Select";
			 	obj1.id=0;
			 	arr.addItemAt(obj1,0);
			 }
			return arr;
			
		} 
		
		public static function addMemberAudit(columnName:String,oldValue:String,newValue:String,memberId:int):void
		{
			var obj:MemberAuditVO=new MemberAuditVO();
			obj.columnName=columnName;
			obj.newValue=newValue;
			obj.oldValue=oldValue;
			obj.createdBy=ModelLocator.getInstance().loginMemberId;
			obj.memberId=memberId;
			ModelLocator.getInstance().memberAudit.addItem(obj);
		}
		
		public static function addInsuranceAudit(columnName:String,oldValue:String,newValue:String,memberId:int,insuranceId:int):void
		{
			var obj:MemberAuditVO=new MemberAuditVO();
			obj.columnName=columnName;
			obj.newValue=newValue;
			obj.oldValue=oldValue;
			obj.createdBy=ModelLocator.getInstance().loginMemberId;
			obj.memberId=memberId;
			obj.insuranceId=insuranceId;
			ModelLocator.getInstance().insuranceAudit.addItem(obj);
			
		}
		
		//Addition.  bsmith.  Assign name to top menu
		public static function getTopMenuName():String
		{
			var locator:ModelLocator= ModelLocator.getInstance();
			var rtnStr:String;
			if (locator.isDoctor==true)
			{
				if (locator.medicalGroupVO.medicalGroupID>0)
					rtnStr=locator.medicalGroupVO.name;
				else
				{
					rtnStr=locator.currentDoctor.FirstName +' '+ locator.currentDoctor.lastName;
					if (locator.currentDoctor.ProfTitle!=null && locator.currentDoctor.ProfTitle!='')
					{
						rtnStr+=", " + locator.currentDoctor.ProfTitle;
					}
					//if (locator.loginType=="Staff")
					//	rtnStr+=" | " + locator.fullMemberName;
				}
				if (locator.staffName && locator.staffName.length > 0) {
		  			rtnStr = locator.staffName + " (" + rtnStr + ")";
	  			}
			}
			return rtnStr;
		}
		
	// function to check session to server is timed out or not
	  public static function checkSession(dt:ArrayCollection):Boolean
	  {	
			var locator:ModelLocator= ModelLocator.getInstance();
			if(dt.length>0)
			{
				if(dt[0]["SessionFailure"] !=null && locator.isLoggedOut != true)
				{
					locator.isLoggedOut=true;
					Alert.show("Your Session Timed out. Please Login"," Session Time Out");
					if (locator.menuObj!=null)
						locator.menuObj.onLogout();

					return false;
				}
				else
					return true;  
			}
			else
				return true;
		}
	  
	  public static function onConfigLoad(event:ResultEvent):void
	  {
		  var tempPath:Object=event.result.CONFIG;
	  }
	  
	}
}