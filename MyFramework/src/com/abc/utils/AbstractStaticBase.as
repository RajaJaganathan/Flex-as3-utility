/*
 Copyright (c) 2007 Eric J. Feminella  <eric@ericfeminella.com>
 All rights reserved.
  
 Permission is hereby granted, free of charge, to any person obtaining a copy 
 of this software and associated documentation files (the "Software"), to deal 
 in the Software without restriction, including without limitation the rights 
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished 
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all 
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @internal
 */

package com.ericfeminella.utils
{
    import mx.utils.StringUtil;
    
    /**
     * 
     * Abstract class which enforces a class of static type is never
     * instantiated. 
     * 
     * <p>
     * All static classes (classes which ONLY contain static members)
     * are to extend AbstractStaticBase. Implementors need not provide
     * any implementation. By extending AbstractStaticBase it will be
     * ensured that a class instance can not e instantiated.
     * </p>
     * 
     * <p>
     * Typically, Helper, Utility and Enumeration classes will extend
     * AbstractStaticBase to ensure clients do not misuse an API by
     * explicitly instantiating an instance of the static type
     * </p>
     * 
     * @example
     * <listing version="3.0">
     * 
     * package
     * {
     *     public final class CalculationUtils extends AbstractStaticBase
     *     { 
     *         public static function calculateX() : String {
     *             // implementation not relevant
     *         }
     * 
     *         public static function calculateY() : String {
     *             // implementation not relevant
     *         }
     * 
     *         public static function calculateZ() : String {
     *             // implementation not relevant
     *         }
     *     }
     * }
     * 
     * // an attempt to instantiate an instance of CalculationUtils...
     * 
     * var util:CalculationUtils = new CalculationUtils();
     * 
     * // results in the following exception being throw:
     * // Illegal instantiation attempted on class of static type: CalculationUtils
     * 
     * </listing>
     * 
     * 
     */    
    public class AbstractStaticBase
    {
        /**
         * Defines the message String which is used as the property of the Exception
         */
        private static const MESSAGE:String = "Illegal instantiation attempted on class of static type: {0}";
        
        /**
         *
         * Determines the sub class which was instantiated and throws 
         * an error of specifying the class which was instantiated
         *
         */        
        public function AbstractStaticBase()
        {
            var exception:Error = new Error();
            var stackFrame:String = exception.getStackTrace().split("at ")[2];
            var fullyQualifiedName:String  = stackFrame.split("()")[0];
            exception.message = StringUtil.substitute( MESSAGE, fullyQualifiedName ); 
            
            throw exception;
        }
    }
}
