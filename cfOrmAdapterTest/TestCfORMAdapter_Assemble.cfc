component extends="modelglue.gesture.eventrequest.test.TestEventContext" {

	this.coldspringPath = "/ModelGlue/gesture/eventrequest/test/ColdSpring.xml";

	function setup() {
		request._modelglue.bootstrap.initializationRequest = false;
		createModelGlueIfNotDefined(this.coldspringPath);
		servicePath = "ModelGlue.gesture.modules.orm.cform.cfORMService";
		adapterPath = "ModelGlue.gesture.modules.orm.cform.cfORMAdapter";
		// ormService = createObject("component","ModelGlue.gesture.modules.orm.cform.cfORMService").init();
		ormService = mock(servicePath);
		//createModelGlueIfNotDefined(this.coldspringPath);
		//mg = mock("ModelGlue.gesture.ModelGlue");
		ormAdapter = createObject("component",adapterPath).init(mg,ormService);
		//debug(getMetaData(mg));
	}

	function lookAtMetadata() {
		
		theObject = EntityNew("MainObject");
		debug(getMetadata(theObject));
	}

	function assembleNoPropertiesArgumentPopulatesAllIndividualProperties() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("ormtype_string", "string");
		ec.setValue("ormtype_integer", 2);
		ormAdapter.assemble(ec,theObject);
		assertEquals("string",theObject.getormtype_string());
		assertEquals(2,theObject.getormtype_integer());
	}

	function assembleWithPropertiesArgumentPopulatesOnlySpecifiedProperties() {
		
		/* Holy complicated setup, batman!
			I had to manually put an argument into the event in setupEvent() below to make this work, 
			hence the "true" argument below
		*/
		ec = setupEvent(true);
		theObject = EntityNew("MainObject");
		ec.setValue("ormtype_string", "string");
		ec.setValue("ormtype_integer", 2);
		//ec.setArgument("properties", "ormtype_string");
		ormAdapter.assemble(ec,theObject);
		assertEquals("string",theObject.getormtype_string());
		assertTrue(IsNull(theObject.getormtype_integer()));
	}

	function assemblePopulatesInheritedProperties() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("aParentProperty", "Hello!");
		ormAdapter.assemble(ec,theObject);
		assertEquals("Hello!",theObject.getAParentProperty());
	}

	// private methods for injectMethod and extra setup
	
	private function setupEvent(boolean useProperties=false) {

		er = createEventContext();
		eh1 = createEventHandler();
		msg = createMessage();
		listeners = structNew();
		listener = createListener();
		
		eh1.name = "eh1";
	
		listener.target = this;
		listener.listenerFunction = "listener_testExecuteEventHandler_ListenerInvocation";
		msg.name = "message";


		// Bob's addition: This is to allow for arguments to be passed into the event
		if (arguments.useProperties) {
			mc = createObject("component", "ModelGlue.gesture.collections.MapCollection").init({properties="ormtype_string"});
			msg.arguments = mc;
		}


		listeners[msg.name] = arrayNew(1);
		arrayAppend(listeners[msg.name], listener);
		eh1.addMessage(msg);
	
		listener = createListener();
		listener.target = this;
		listener.listenerFunction = "listener_testExecuteEventHandler_ListenerInvocation_byFormat";
		msg = createMessage();
		msg.name = "explicitFormatMessage";
		listeners[msg.name] = arrayNew(1);
		arrayAppend(listeners[msg.name], listener);
		eh1.addMessage(msg, "explicitFormat");
		
		er = createEventContext();
		er.setListenerMap(listeners);
		
		variables.testExecuteEventHandler_ListenerInvocation_value = false;
		variables.testExecuteEventHandler_ListenerInvocation_value_byFormat = false;
		er.executeEventHandler(eh1);
		return er;
	}

	private function returnsNull() {
		return JavaCast("null", 0);
	}
	
	private function createProperties(aDate) {
		var props = {};
		props.ormtype_string = "string";
		props.ormtype_character = "c";
		props.ormtype_char = "c";
		props.ormtype_short = 2;
		props.ormtype_integer = 2;
		props.ormtype_int = 2;
		props.ormtype_long = 2;
		props.ormtype_big_decimal = 2;
		props.ormtype_float = 2;
		props.ormtype_double = 2;
		props.ormtype_Boolean = false;
		props.ormtype_yes_no = "no";
		props.ormtype_true_false = "false";
		props.ormtype_text = "text";
		props.ormtype_date = arguments.aDate;
		props.ormtype_timestamp = arguments.aDate;
		props.type_boolean = false;
		props.type_date = arguments.aDate;
		props.type_numeric = 2;
		props.type_string = "string";
		return props;
	}

}
