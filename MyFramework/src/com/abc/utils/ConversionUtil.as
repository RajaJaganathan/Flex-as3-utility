package com.abc.utils
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;

	import mx.collections.ArrayCollection;
	import mx.rpc.xml.SimpleXMLDecoder;
	import mx.rpc.xml.SimpleXMLEncoder;
	import mx.utils.ObjectUtil;

	public class ConversionUtil
	{
		public function ConversionUtil()
		{
		}

		private function xmlToArrayCollection(xml:XML):ArrayCollection
		{
			var xmlDoc:XMLDocument = new XMLDocument(xml.toString());
			var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
			var resultObj:Object = decoder.decodeXML(xmlDoc);
			var ac:ArrayCollection = new ArrayCollection(Array(resultObj.root.list.source.item));
			return ac;
		}

		private function objectToXML(obj:Object):XML
		{
			var qName:QName = new QName("root");
			var xmlDocument:XMLDocument = new XMLDocument();
			var simpleXMLEncoder:SimpleXMLEncoder = new SimpleXMLEncoder(xmlDocument);
			var xmlNode:XMLNode = simpleXMLEncoder.encodeValue(obj, qName, xmlDocument);
			var xml:XML = new XML(xmlDocument.toString());
			return xml;
		}

		private function objectToArrayCollection(obj:Object):ArrayCollection
		{
			var ac:ArrayCollection = new ArrayCollection(obj as Array);
			return ac;
		}

		private function arrayCollectionToXML(ac:ArrayCollection):XML
		{
			var xml:XML = objectToXML(ac);
			return xml;
		}

		private function init():void
		{
			var arr:Array = new Array();
			//arr.push({data:0,name:ï¿½devaï¿½});
			//arr.push({data:1,name:ï¿½rajï¿½});
			var ac:ArrayCollection = new ArrayCollection(arr);
			var xml:XML = arrayCollectionToXML(ac);
			var newAc:ArrayCollection = xmlToArrayCollection(xml);
			trace(newAc[0][0].name);
		}

		private function objToStr(value:Object, indent:int = 0,
			refs:Dictionary = null,
			namespaceURIs:Array = null,
			exclude:Array = null):String
		{
			var str:String;
			var refCount:int = 0;
			if (value is Date)
			{
				return value.toString();
			}
			else if (value is XMLNode)
			{
				return value.toString();
			}
			else if (value is Class)
			{
				return "(" + getQualifiedClassName(value) + ")";
			}
			else
			{
				var classInfo:Object = ObjectUtil.getClassInfo(value, exclude,
					{ includeReadOnly: true, uris: namespaceURIs });
				var properties:Array = classInfo.properties;
				str = "(" + classInfo.name + ")";
				if (refs == null)
					refs = new Dictionary(true);
				var id:Object = refs[value];
				if (id != null)
				{
					str += "#" + int(id);
					return str;
				}
				if (value != null)
				{
					str += "#" + refCount.toString();
					refs[value] = refCount;
					refCount++;
				}
				var isArray:Boolean = value is Array;
				var isDict:Boolean = value is Dictionary;
				var prop:*;
				indent += 2;
				for (var j:int = 0; j < properties.length; j++)
				{
					str = newline(str, indent);
					prop = properties[j];
					if (isArray)
						str += "[";
					else if (isDict)
						str += "{";
					if (isDict)
					{
						str += objToStr(prop, indent, refs,
							namespaceURIs, exclude);
					}
					else
					{
						str += prop.toString();
					}
					if (isArray)
						str += "] ";
					else if (isDict)
						str += "} = ";
					else
						str += " = ";
					try
					{
						str += objToStr(value[prop], indent, refs,
							namespaceURIs, exclude);
					}
					catch (e:Error)
					{
						str += "?";
					}
				}
				indent -= 2;
				return str;
			}
		}

		private static function newline(str:String, n:int = 0):String
		{
			var result:String = str;
			result += "\n";
			for (var i:int = 0; i < n; i++)
			{
				result += " ";
			}
			return result;
		}
	/* General function for Conversion (thanks, Krystian BieÅ„)
	public function xmlToArrayCollection(xml:XML):ArrayCollection{
	var temp:String = â€˜<items>â€™ + xml.toString() + â€˜</items>â€™;
	xml = XML(temp);
	var xmlDoc:XMLDocument = new XMLDocument(xml.toString());
	var decoder:SimpleXMLDecoder = new SimpleXMLDecoder(true);
	var resultObj:Object = decoder.decodeXML(xmlDoc);
	var ac:ArrayCollection;
	ac = new ArrayCollection();
	ac.addItem(resultObj.items);
	return ac;
	}*/
	}
}

