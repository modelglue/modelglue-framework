/*
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
*/


component extends="modelgluetests.unittests.gesture.eventrequest.TestEventContext" {

	this.coldspringPath = "/modelgluetests/unittests/gesture/eventrequest/ColdSpring.xml";

	function setup() {
		request._modelglue.bootstrap.initializationRequest = false;
		createModelGlueIfNotDefined(this.coldspringPath);
		servicePath = "ModelGlue.gesture.modules.orm.cform.cfORMService";
		adapterPath = "ModelGlue.gesture.modules.orm.cform.cfORMAdapter";
		ormService = createObject("component","ModelGlue.gesture.modules.orm.cform.cfORMService").init();
		ormAdapter = createObject("component",adapterPath).init(mg,ormService);
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
		entityName = "MainObject";
		theObject = EntityNew(entityName);
		ec.setValue("aParentProperty", "Hello!");
		ormAdapter.assemble(ec,theObject);
		assertEquals("Hello!",theObject.getAParentProperty());
	}

	/**
	* @mxunit:expectedException "ModelGlue.gesture.orm.cform.cformService.entityNotFound"
	*/
	function assembleWithInvalidFKThrows() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("many2oneId", 99);
		ormAdapter.assemble(ec,theObject);
	}

	function assembleAddsManyToOne() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("many2oneId", 1);
		ormAdapter.assemble(ec,theObject);
		many2one = theObject.getMany2one();
		assertEquals("model.many2one",getMetaData(many2one).name);
		assertEquals(1,many2one.getmany2oneId());
	}

	function assembleAddsOneToOne() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("mainId", 1);
		ormAdapter.assemble(ec,theObject);
		one2one = theObject.getOne2one();
		assertEquals("model.one2one",getMetaData(one2one).name);
		assertEquals(1,one2one.getmainId());
	}

	function assembleAddsOneToMany() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("one2many_array|one2many_arrayId", "1,2");
		ormAdapter.assemble(ec,theObject);
		one2manys = theObject.getOne2Many_array();
		assertTrue(isArray(one2manys));
		assertEquals("model.one2many_array",getMetaData(one2manys[1]).name);
		assertEquals("model.one2many_array",getMetaData(one2manys[2]).name);
		assertEquals(1,one2manys[1].getone2many_arrayId());
		assertEquals(2,one2manys[2].getone2many_arrayId());
	}

	function assembleAddsManyToMany() {
		
		ec = setupEvent();
		theObject = EntityNew("MainObject");
		ec.setValue("many2many_array|many2many_arrayId", "1,2");
		ormAdapter.assemble(ec,theObject);
		many2manys = theObject.getMany2Many_array();
		assertTrue(isArray(many2manys));
		assertEquals("model.many2many_array",getMetaData(many2manys[1]).name);
		assertEquals("model.many2many_array",getMetaData(many2manys[2]).name);
		assertEquals(1,many2manys[1].getmany2many_arrayId());
		assertEquals(2,many2manys[2].getmany2many_arrayId());
	}

	function assembleRemovesManyToOne() {
		
		ec = setupEvent();
		theObject = EntityLoadByPK("MainObject",1);
		ormAdapter.assemble(ec,theObject);
		many2one = theObject.getMany2one();
		assertTrue(isNull(many2one));
	}

	function assembleRemovesOneToOne() {
		
		ec = setupEvent();
		theObject = EntityLoadByPK("MainObject",1);
		ormAdapter.assemble(ec,theObject);
		one2one = theObject.getOne2one();
		assertTrue(isNull(one2one));
	}

	function assembleRemovesOneToMany() {
		
		ec = setupEvent();
		theObject = EntityLoadByPK("MainObject",1);
		one2manys = theObject.getOne2Many_array();
		assertEquals(3,arrayLen(one2manys));
		ec.setValue("one2many_array|one2many_arrayId", "1");
		ormAdapter.assemble(ec,theObject);
		one2manys = theObject.getOne2Many_array();
		assertEquals(1,arrayLen(one2manys));
		assertEquals("model.one2many_array",getMetaData(one2manys[1]).name);
		assertEquals(1,one2manys[1].getone2many_arrayId());
	}

	function assembleRemovesManyToMany() {
		
		ec = setupEvent();
		theObject = EntityLoadByPK("MainObject",1);
		many2manys = theObject.getmany2Many_array();
		assertEquals(2,arrayLen(many2manys));
		ec.setValue("many2many_array|many2many_arrayId", "1");
		ormAdapter.assemble(ec,theObject);
		many2manys = theObject.getmany2Many_array();
		assertEquals(1,arrayLen(many2manys));
		assertEquals("model.many2many_array",getMetaData(many2manys[1]).name);
		assertEquals(1,many2manys[1].getmany2many_arrayId());
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
		args = {object="MainObject"};
		if (arguments.useProperties) {
			args.properties="ormtype_string";
		}
		mc = createObject("component", "ModelGlue.gesture.collections.MapCollection").init(args);
		msg.arguments = mc;


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
