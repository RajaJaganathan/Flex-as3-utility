package com.abc.utils
{
    import mx.collections.ArrayCollection;
    import mx.controls.ComboBox;
    import mx.controls.TextInput;
    import mx.utils.StringUtil;
    import mx.validators.StringValidator;
    import mx.validators.Validator;
    /**
     *
     * @author rajaj
     */
    public class CommonValidator
    {
        public static const var ERROR_COLOR:String = "#F8E0E0"; //"#FBEFEF";
        public static const var NORMAL_COLOR:String = "#FFFFFF";

        /**
         *
         * @param src
         * @return
         */
        public static function accValidator(src:*):Boolean
        {
            var accValidator:StringValidator = new StringValidator();
            accValidator.minLength = 2;
            accValidator.maxLength = 5;
            accValidator.property = "text";
            accValidator.source = src;
            accValidator.validate();
            return StringUtil.trim(src.errorString).length == 0;
        }

		/**
		 * 
		 * @param src
		 * @return 
		 * 
		 */		
        public static function comboValidator(src:*):Boolean
        {
            var cmb:ComboBox = src as ComboBox;

            if (cmb.selectedIndex == -1)
            {
                cmb.errorString = "Field required";
                src.setStyle("backgroundColor", ERROR_COLOR);
            }
            else
            {
                src.setStyle("backgroundColor", NORMAL_COLOR);
                cmb.errorString = null;
            }
            return StringUtil.trim(src.errorString).length == 0;
        }

        /**
         *
         * @param src
         * @return
         */
        public static function strValidator(src:*):Boolean
        {
            var strValidator:StringValidator = new StringValidator();
            strValidator.minLength = 4;
            strValidator.maxLength = 10;
            strValidator.required = true;
            strValidator.property = "text";
            strValidator.source = src;
            strValidator.validate();
            return StringUtil.trim(src.errorString).length == 0;
        }

		/**
		 * 
		 * @param items
		 * @return 
		 * 
		 */		
        public static function validateAll(... items):Boolean
        {
            switch (items.length)
            {
                case 1:
                    if (items[0] is ArrayCollection)
                        return validateAll_ArrCollection(items[0] as ArrayCollection);
                    break;
                case 2:
                    if (items[0] is Array && items[1] is Array)
                        return validateAll_Arr(items[0] as Array, items[1] as Array);
                    break;
            }
            return false;
        }

        /**
         *
         * @param validationArr
         * @param arrParam
         * @return
         */
        public static function validateAll_Arr(validationArr:Array, arrParam:Array):Boolean
        {
            var arrFailure:Array = [];
            var isValid:Boolean = false;

            for (var iIndex:int = 0; iIndex < validationArr.length; iIndex++)
            {
                isValid = CommonValidator[validationArr[iIndex]](arrParam[iIndex]);

                if (isValid == false)
                    arrFailure.push(isValid);
            }
            return arrFailure.length == 0;
        }

        /**
         *
         * @param validationArr
         * @return
         */
        public static function validateAll_ArrCollection(validationArr:ArrayCollection):Boolean
        {
            var arrFailure:Array = [];
            var isValid:Boolean = false;

            for (var iIndex:int = 0; iIndex < validationArr.length; iIndex++)
            {
                isValid = CommonValidator[validationArr.getItemAt(iIndex).methodName](validationArr.getItemAt(iIndex).srcObject);
                var src:* = validationArr.getItemAt(iIndex).srcObject as Object;

                if (isValid == false)
                    arrFailure.push(isValid);

                if (src is TextInput && StringUtil.trim(src.errorString).length > 0)
                    src.setStyle("backgroundColor", ERROR_COLOR);
                else if (src is TextInput)
                    src.setStyle("backgroundColor", NORMAL_COLOR);
            }
            return arrFailure.length == 0;
        }

        /**
         *
         */
        public function CommonValidator()
        {
        }
    }
}

/* ******************** USAGE ************************************** */ 
/* var validatorAC:ArrayCollection=new ArrayCollection();
validatorAC.addItem({methodName: "strValidator", srcObject: txtFirstName});
validatorAC.addItem({methodName: "accValidator", srcObject: shippingCity});
validatorAC.addItem({methodName: "comboValidator", srcObject: shippingState});
CommonValidator.validateAll(validatorAC);
 */


