import mx.utils.ObjectProxy;

// To avoid itemRenderer warning message like
// Warning Unable to bind to Property "somevar" on object 'Object' class is not an IEventDispatcher

[Bindable]
private var _data:ObjectProxy;

override public function set data(value:Object):void
{
	super.data = value;
	_data = new ObjectProxy(value);
}

[Binding]
override public function get data():Object
{
	return _data;
}

