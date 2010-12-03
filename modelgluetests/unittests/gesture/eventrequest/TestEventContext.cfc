<cfcomponent extends="modelgluetests.unittests.gesture.collections.TestMapCollectionImplementation">

<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/eventrequest/ColdSpring.xml">

<cffunction name="setUp" output="false" access="public" returntype="any" hint="">
	<cfset request._modelglue.bootstrap.initializationRequest = false />
    <cfset request._modelglue.bootstrap.initializationLockPrefix = "/modelgluetests/unittests/gesture/.modelglue" />
    <cfset request._modelglue.bootstrap.initializationLockTimeout = 10 />
	<cfset createModelGlueIfNotDefined(this.coldspringPath) />
</cffunction>

<cfset variables.mockHelpersScope = structNew() />
<cffunction name="mockHelperFunction">
	<cfreturn "I am a helper function." />
</cffunction>

<cfset variables.mockHelpersScope.helperFunction = this.mockHelperFunction />

<!--- <cffunction name="createMapCollectionNoInit" access="private" hint="Creates a basic MapCollection to test without running init().">
	<cfreturn createObject("component", "ModelGlue.gesture.eventrequest.EventContext") />
</cffunction>

<cffunction name="createMapCollection" access="private" hint="Creates a basic MapCollection to test.  Extend this test class and override this method to test other implementations.">
	<cfreturn createMapCollectionNoInit().init() />
</cffunction> --->

<cffunction name="createEventContext" access="private">
	<cfset var ec = "" />
	<cfset var vr = "" />
	
	<cfset vr = createObject("component", "ModelGlue.gesture.view.ViewRenderer").init() />
	<cfset vr.setModelGlue( mg ) />
	<cfset vr.addViewMapping("/modelgluetests/unittests/gesture/view/test/views") />	
		
		<!--- Simulating a bootstrapping request --->
	<cfset request._modelglue.bootstrap.initializationRequest = true />
	<cfset request._modelglue.bootstrap.framework = mg />
	
	<!--- Event context has many dependencies that are configured into the framework:  we list them explicitly here --->	
	<cfset ec =  mg.getEventContextFactory().new(
			helpers=variables.mockHelpersScope, 
			viewRenderer=vr
		) 
	/>
	<cfreturn ec />
</cffunction>

<cffunction name="createEventHandler" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.EventHandler") />
</cffunction>

<cffunction name="createMessage" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.Message") />
</cffunction>

<cffunction name="createListener" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.MessageListener") />
</cffunction>

<cffunction name="createResult" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.Result") />
</cffunction>

<cffunction name="createView" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.View") />
</cffunction>

<cffunction name="createValue" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.Value") />
</cffunction>

<!--- EVENT QUEUE TESTS --->
<cffunction name="testInitialEvent" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var eh1 = createEventHandler() />
	<cfset var eh2 = createEventHandler() />
	
	<cfset eh1.name = "eh1" />
	<cfset eh2.name = "eh2" />
	
	<cfset er.addEventHandler(eh1) />
	
	<cfset er.prepareForInvocation() />

	<cfset er.addEventHandler(eh2) />
	
	<cfset assertTrue(er.getInitialEventHandler().name eq "eh2", "Initial event shouldn't be set until _after_ prepareForInvocation() is invoked!") />
</cffunction>

<cffunction name="testValueRetrievalAFewWays" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var mockScope = structNew() />
	<cfset er.setValue("Pigs", "Fly") />
	<cfset er.setValue("Rugs", "Fly") />
	
	<cfset assertTrue( er.getValue("Pigs") IS "Fly", "Getting a simple value failed") />
	<cfset assertTrue( er.getValue("Dogs", "Rule") IS "Rule", "Getting a defaulted value failed.") />
	<cfset mockScope = er.copyToScope( mockScope, "Pigs,Rugs") /> 
	<cfset assertTrue("#mockScope.Pigs#,#mockScope.Rugs#" IS "Fly,Fly", "Copy To Scope failed. #structKeyList(mockScope)#") />
	<cfset structClear( mockScope ) />
	<cfset mockScope = er.copyToScope( mockScope, " Pigs , Rugs ") /> 
	<cfset assertTrue("#mockScope.Pigs#,#mockScope.Rugs#" IS "Fly,Fly", "Copy To Scope failed with whitespace in the list of values. #structKeyList(mockScope)#: #mockScope.Pigs#,#mockScope.Rugs#") />
	
</cffunction>

<cffunction name="testEventDequeueing" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var eh1 = createEventHandler() />
	<cfset var eh2 = createEventHandler() />
	
	<cfset eh1.name = "eh1" />
	<cfset eh2.name = "eh2" />
	
	<cfset assertFalse(er.hasNextEventHandler(), "queue should be empty before add!") />

	<cfset er.addEventHandler(eh1) />
	<cfset er.addEventHandler(eh2) />

	<cfset assertTrue(er.hasNextEventHandler(), "queue should have next after adding!") />
	
	<cfset eh1 = er.getNextEventHandler() />

	<cfset assertTrue(er.hasNextEventHandler(), "queue should have next after removing first!") />

	<cfset eh2 = er.getNextEventHandler() />
	
	<cfset assertFalse(er.hasNextEventHandler(), "queue should be empty after dequeueing!") />
</cffunction>

<cffunction name="testExecutionDequeueing" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var eh1 = createEventHandler() />
	<cfset var eh2 = createEventHandler() />
	
	<cfset eh1.name = "eh1" />
	<cfset eh2.name = "eh2" />
	
	<cfset assertFalse(er.hasNextEventHandler(), "queue should be empty before add!") />

	<cfset er.addEventHandler(eh1) />
	<cfset er.addEventHandler(eh2) />

	<cfset er.execute() />
	
	<cfset assertFalse(er.hasNextEventHandler(), "queue should be empty after dequeueing!") />
</cffunction>

<cffunction name="testExecuteEventHandler_ListenerInvocation" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var eh1 = createEventHandler() />
	<cfset var msg = createMessage() />
	<cfset var listeners = structNew() />
	<cfset var listener = createListener() />
	
	<cfset eh1.name = "eh1" />

	<cfset listener.target = this />
	<cfset listener.listenerFunction = "listener_testExecuteEventHandler_ListenerInvocation" />
	<cfset msg.name = "message" />
	<cfset listeners[msg.name] = arrayNew(1) />
	<cfset arrayAppend(listeners[msg.name], listener) />
	<cfset eh1.addMessage(msg) />

	<cfset listener = createListener() />
	<cfset listener.target = this />
	<cfset listener.listenerFunction = "listener_testExecuteEventHandler_ListenerInvocation_byFormat" />
	<cfset msg = createMessage() />
	<cfset msg.name = "explicitFormatMessage" />
	<cfset msg.format = "explicitFormat" />
	<cfset listeners[msg.name] = arrayNew(1) />
	<cfset arrayAppend(listeners[msg.name], listener) />
	<cfset eh1.addMessage(msg) />
	
	<cfset er = createEventContext() />
	<cfset er.setListenerMap(listeners) />
	
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value = false />
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value_byFormat = false />
	<cfset er.executeEventHandler(eh1) />
	<cfset assertTrue(variables.testExecuteEventHandler_ListenerInvocation_value, "listener function not invoked!") />
	<cfset assertFalse(variables.testExecuteEventHandler_ListenerInvocation_value_byFormat, "listener function invoked for explicit format during unformatted execution!") />

	<cfset er = createEventContext() />
	<cfset er.setListenerMap(listeners) />
	<cfset er.setValue("requestFormat", "explicitFormat") />
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value = false />
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value_byFormat = false />
	<cfset er.executeEventHandler(eh1) />
	<cfset assertTrue(variables.testExecuteEventHandler_ListenerInvocation_value, "listener function not invoked!") />
	<cfset assertTrue(variables.testExecuteEventHandler_ListenerInvocation_value_byFormat, "listener function not invoked for explicit format during formatted execution!") />

</cffunction>

<cffunction name="listener_testExecuteEventHandler_ListenerInvocation" access="public" returntype="void">
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value = true />
</cffunction>

<cffunction name="listener_testExecuteEventHandler_ListenerInvocation_byFormat" access="public" returntype="void">
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value_byFormat = true />
</cffunction>

<cffunction name="testExecuteEventHandler_ResultQueueing" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var eh1 = createEventHandler() />
	<cfset var eh2 = createEventHandler() />
	<cfset var eh3 = createEventHandler() />
	<cfset var msg1 = createMessage() />
	<cfset var msg2 = createMessage() />
	<cfset var msg3 = createMessage() />
	<cfset var listeners = structNew() />
	<cfset var listener1 = createListener() />
	<cfset var listener2 = createListener() />
	<cfset var listener3 = createListener() />
	<cfset var eventHandlers = structNew() />
	<cfset var result1 = createResult() />
	<cfset var result2 = createResult() />

	<!--- Set up listeners --->	
	<cfset listener1.target = this />
	<cfset listener1.listenerFunction = "listener1_testExecuteEventHandler_ResultQueueing" />
	<cfset msg1.name = "message1" />
	<cfset makePublic(this,"listener1_testExecuteEventHandler_ResultQueueing") />

	<cfset listener2.target = this />
	<cfset listener2.listenerFunction = "listener2_testExecuteEventHandler_ResultQueueing" />
	<cfset msg2.name = "message2" />
	<cfset makePublic(this,"listener2_testExecuteEventHandler_ResultQueueing") />

	<cfset listener3.target = this />
	<cfset listener3.listenerFunction = "listener3_testExecuteEventHandler_ResultQueueing" />
	<cfset msg3.name = "message3" />
	<cfset makePublic(this,"listener3_testExecuteEventHandler_ResultQueueing") />
	
	<cfset listeners[msg1.name] = arrayNew(1) />
	<cfset listeners[msg2.name] = arrayNew(1) />
	<cfset listeners[msg3.name] = arrayNew(1) />
	<cfset arrayAppend(listeners[msg1.name], listener1) />
	<cfset arrayAppend(listeners[msg2.name], listener2) />
	<cfset arrayAppend(listeners[msg3.name], listener3) />
	<cfset er.setListenerMap(listeners) />

	<!--- Set up event handlers --->	
	<cfset eh1.name = "eh1" />
	<cfset eh1.addMessage(msg1) />
	<!--- Explicit result --->
	<cfset result1.name = "result1" />
	<cfset result1.event = "eh2" />
	<cfset eh1.addResult(result1) />
	<!--- Implicit result --->
	<cfset result2.name = "" />
	<cfset result2.event = "eh3" />
	<cfset eh1.addResult(result2) />

	<cfset eh2.name = "eh2" />
	<cfset eh2.addMessage(msg2) />

	<cfset eh3.name = "eh3" />
	<cfset eh3.addMessage(msg3) />

	<cfset eventHandlers[eh1.name] = eh1 />
	<cfset eventHandlers[eh2.name] = eh2 />
	<cfset eventHandlers[eh3.name] = eh3 />
	<cfset er.setEventHandlerMap(eventHandlers) />

	<!--- Execute --->	
	<cfset variables.listener1_testExecuteEventHandler_ResultQueueing_value = false />
	<cfset variables.listener2_testExecuteEventHandler_ResultQueueing_value = false />
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = "" />
	<cfset er.addEventHandler(eh1) />
	<cfset er.execute() />
		
	<!--- All listeners should have fired --->
	<cfset assertTrue(variables.listener1_testExecuteEventHandler_ResultQueueing_value, "First listener didn't execute!") />
	<cfset assertTrue(variables.listener2_testExecuteEventHandler_ResultQueueing_value, "Second listener didn't execute!") />
	
	<!--- Results should fire in explicit -> implicit order --->
	<cfset assertTrue(variables.testExecuteEventHandler_ResultQueueing_order eq "explicitimplicit", "Results not fired in correct order.") />
</cffunction>

<cffunction name="testExecuteEventHandler_ResultQueueing_forFormat" access="public" returntype="void">
	<cfset var er = createEventContext() />
	<cfset var eh1 = createEventHandler() />
	<cfset var eh2 = createEventHandler() />
	<cfset var eh3 = createEventHandler() />
	<cfset var msg1 = createMessage() />
	<cfset var msg2 = createMessage() />
	<cfset var msg3 = createMessage() />
	<cfset var listeners = structNew() />
	<cfset var listener1 = createListener() />
	<cfset var listener2 = createListener() />
	<cfset var listener3 = createListener() />
	<cfset var eventHandlers = structNew() />
	<cfset var result1 = createResult() />
	<cfset var result2 = createResult() />

	<!--- Set up listeners --->	
	<cfset listener1.target = this />
	<cfset listener1.listenerFunction = "listener1_testExecuteEventHandler_ResultQueueing" />
	<cfset msg1.name = "message1" />
	<cfset msg1.format = "explicitFormat" />
	<cfset makePublic(this,"listener1_testExecuteEventHandler_ResultQueueing") />
	
	<cfset listener2.target = this />
	<cfset listener2.listenerFunction = "listener2_testExecuteEventHandler_ResultQueueing" />
	<cfset msg2.name = "message2" />
	<cfset msg2.format = "explicitFormat" />
	<cfset makePublic(this,"listener2_testExecuteEventHandler_ResultQueueing") />
	
	<cfset listener3.target = this />
	<cfset listener3.listenerFunction = "listener3_testExecuteEventHandler_ResultQueueing" />
	<cfset msg3.name = "message3" />
	<cfset msg3.format = "explicitFormat" />
	<cfset makePublic(this,"listener3_testExecuteEventHandler_ResultQueueing") />
	
	<cfset listeners[msg1.name] = arrayNew(1) />
	<cfset listeners[msg2.name] = arrayNew(1) />
	<cfset listeners[msg3.name] = arrayNew(1) />
	<cfset arrayAppend(listeners[msg1.name], listener1) />
	<cfset arrayAppend(listeners[msg2.name], listener2) />
	<cfset arrayAppend(listeners[msg3.name], listener3) />
	<cfset er.setListenerMap(listeners) />

	<!--- Set up event handlers --->	
	<cfset eh1.name = "eh1" />
	<cfset eh1.addMessage(msg1) />
	<!--- Explicit result --->
	<cfset result1.name = "result1" />
	<cfset result1.event = "eh2" />
	<cfset result1.format = "explicitFormat" />
	<cfset eh1.addResult(result1) />
	<!--- Implicit result --->
	<cfset result2.name = "" />
	<cfset result2.event = "eh3" />
	<cfset result2.format = "explicitFormat" />
	<cfset eh1.addResult(result2) />

	<cfset eh2.name = "eh2" />
	<cfset eh2.addMessage(msg2) />

	<cfset eh3.name = "eh3" />
	<cfset eh3.addMessage(msg3) />

	<cfset eventHandlers[eh1.name] = eh1 />
	<cfset eventHandlers[eh2.name] = eh2 />
	<cfset eventHandlers[eh3.name] = eh3 />

	<!--- Execute --->	
	<cfset er = createEventContext() />
	<cfset er.setListenerMap(listeners) />
	<cfset er.setEventHandlerMap(eventHandlers) />
	<cfset variables.listener1_testExecuteEventHandler_ResultQueueing_value = false />
	<cfset variables.listener2_testExecuteEventHandler_ResultQueueing_value = false />
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = "" />
	<cfset er.addEventHandler(eh1) />
	<cfset er.execute() />
		
	<!--- No listeners should have fired --->
	<cfset assertFalse(variables.listener1_testExecuteEventHandler_ResultQueueing_value, "First listener executed despite format!") />
	<cfset assertFalse(variables.listener2_testExecuteEventHandler_ResultQueueing_value, "Second listener executed despite format!") />

	<!--- Execute --->	
	<cfset er = createEventContext() />
	<cfset er.setValue("requestFormat", "explicitFormat") />
	<cfset er.setEventHandlerMap(eventHandlers) />
	<cfset er.setListenerMap(listeners) />
	<cfset variables.listener1_testExecuteEventHandler_ResultQueueing_value = false />
	<cfset variables.listener2_testExecuteEventHandler_ResultQueueing_value = false />
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = "" />
	<cfset er.addEventHandler(eh1) />
	<cfset er.execute() />
		
	<!--- All listeners should have fired --->
	<cfset assertTrue(variables.listener1_testExecuteEventHandler_ResultQueueing_value, "First listener didn't execute!") />
	<cfset assertTrue(variables.listener2_testExecuteEventHandler_ResultQueueing_value, "Second listener didn't execute!") />
	
	<!--- Results should fire in explicit -> implicit order --->
	<cfset assertTrue(variables.testExecuteEventHandler_ResultQueueing_order eq "explicitimplicit", "Results not fired in correct order.") />
</cffunction>

<cffunction name="listener1_testExecuteEventHandler_ResultQueueing" access="private" returntype="void">
	<cfargument name="event" />
	<cfset variables.listener1_testExecuteEventHandler_ResultQueueing_value = true />

	<cfset event.addResult("result1") />
</cffunction>

<cffunction name="listener2_testExecuteEventHandler_ResultQueueing" access="private" returntype="void">
	<cfset variables.listener2_testExecuteEventHandler_ResultQueueing_value = true />
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = variables.testExecuteEventHandler_ResultQueueing_order & "explicit" />
</cffunction>

<cffunction name="listener3_testExecuteEventHandler_ResultQueueing" access="private" returntype="void">
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = variables.testExecuteEventHandler_ResultQueueing_order & "implicit" />
</cffunction>

<cffunction name="testExecuteEventHandler_ViewRendering" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var eh = createEventHandler() />
	<cfset var view = createView() />
	<cfset var formattedView = createView() />
			
	<cfset view.name = "testRenderView" />
	<cfset view.template = "testView.cfm" />

	<cfset formattedView.name = "testFormattedRenderView" />
	<cfset formattedView.template = "testFormatView.cfm" />
	<cfset formattedView.format = "explicitFormat" />

	<cfset eh.name = "eh" />
	<cfset eh.addView(view) />
	<cfset eh.addView(formattedView) />

	<cfset ec = createEventContext() />
	<cfset ec.setValue("viewContents", "testEventHandler_ViewRendering") />
	<cfset ec.setValue("formatViewContents", "testEventHandler_formatViewRendering") />
	<cfset ec.addEventHandler(eh) />
	<cfset ec.execute() />
	
	<cfset assertTrue(ec.getViewCollection().getFinalView() eq "testEventHandler_ViewRendering", "view not rendered to last position.") />

	<cfset ec = createEventContext() />
	<cfset ec.setValue("requestFormat", "explicitFormat") />
	<cfset ec.setValue("viewContents", "testEventHandler_ViewRendering") />
	<cfset ec.setValue("formatViewContents", "testEventHandler_formatViewRendering") />
	<cfset ec.addEventHandler(eh) />
	<cfset ec.execute() />
	
	<cfset assertTrue(ec.getViewCollection().getFinalView() eq "testEventHandler_formatViewRendering", "formatted view not rendered to last position.") />
</cffunction>

<!--- VIEW TESTS --->
<cffunction name="testGetViewCollection" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	
	<cfset var viewCollection = ec.getViewCollection() />
	
	<cfset assertTrue(getMetadata(viewCollection).name eq "ModelGlue.gesture.collections.ViewCollection") />
</cffunction>

<cffunction name="testAddView" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var col= ec.getViewCollection() />

	<cfset ec.addView("content", "renderedContent") />
	
	<cfset assertTrue(col.getView("content") eq "renderedContent", "renderedContent not returned from col") />
	<cfset assertTrue(ec.getView("content") eq "renderedContent", "renderedContent not returned from event context (returned: ""#ec.getView("content")#"")") />
	
	<cfset ec.addView("content", "appendedContent", true) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContentappendedContent", "renderedContentappendedContent not returned from col") />
	<cfset assertTrue(ec.getView("content") eq "renderedContentappendedContent", "renderedContentappendedContent not returned from event context") />
</cffunction>

<cffunction name="testRenderView" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var view = createView() />
	
	<cfset view.name = "testRenderView" />
	<cfset view.template = "testView.cfm" />
	
	
	<cfset ec.setValue("viewContents", "testRenderViewContent") />
	
	<cfset ec.renderView(view) />
	
	<cfset assertTrue(ec.getView("testRenderView") eq "testRenderViewContent", "view not rendered!") />
</cffunction>

<cffunction name="testRenderStackedView" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var innerView = createView() />
	<cfset var outerView = createView() />
	
	<cfset innerView.name = "innerView" />
	<cfset innerView.template = "testView.cfm" />
	
	<cfset outerView.name = "outerView" />
	<cfset outerView.template = "testOuterView.cfm" />
	
	<cfset ec.setValue("viewContents", "testRenderStackedViewContent") />
	
	<cfset ec.renderView(innerView) />
	<cfset ec.renderView(outerView) />
	
	<cfset assertTrue(ec.getView("outerView") eq "testRenderStackedViewContent", "view not rendered!") />
</cffunction>

<!--- LOCATION TESTS --->
<cffunction name="testForwardToUrl" access="public" returntype="void">
	<cfset var cfhttp = "" />
	<cfset var msg = createUUID() />
	<cfset var path = "http://#cgi.server_name#:#cgi.server_port#/modelgluetests/unittests/gesture/eventrequest/" />
	<cfset var urlpathdestination = "#path#/ForwardToUrlDestination.cfm?msg=#msg#" />
	
	<cfhttp url="#path#ForwardToUrlEndpoint.cfm?url=#urlEncodedFormat(urlpathdestination)#"  />
	<!--- todo: Find a better way to test this because this method is fragile and sucks --->
	<cfset assertTrue(find(msg, cfhttp.fileContent) GT 0, 'File content not message! Expected #msg# got #cfhttp.filecontent#') />
</cffunction>

<cffunction name="testSaveState" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	
	<cfset assertFalse(ec.getValue("someKey") eq "bar") />
	
	<cfset ec.setValue("someKey", "bar") />
	
	<cfset ec.saveState() />
	
	<cfset assertTrue(structKeyExists(session, "_modelgluePreservedState"), "_modelgluePreservedState not in session") />
	<cfset assertTrue(structKeyExists(session._modelgluePreservedState, "someKey"), "someKey not in preservedState") />
	<cfset assertTrue(session._modelgluePreservedState.someKey eq "bar", "someKey's value is not 'bar'") />
</cffunction>

<cffunction name="testLoadState" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	
	<cfset assertFalse(ec.getValue("someKey") eq "bar") />
	
	<cfset ec.setValue("someKey", "bar") />
	
	<cfset ec.saveState() />

	<cfset ec = createEventContext() />
	
	<cfset ec.loadState() />
	
	<cfset assertTrue(ec.getValue("someKey") eq "bar", "state not loaded: somekey != bar") />
</cffunction>

<!--- TRACE TESTS --->
<cffunction name="testTrace" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	
	<cfset var trace = ec.getTrace() />
	<cfset var thread = "" />
	<cfset assertTrue(arrayLen(trace) eq 1 and trace[1].type eq "Creation", "initial trace statement incorrect: #trace[1].type# eq Creation")>
	<cfset thread = CreateObject("java", "java.lang.Thread")>

	<cfset thread.sleep(100)>	

	<cfset ec.addTraceStatement("typeVal", "messageVal", "tagVal", "traceTypeVal") />
	
	<cfset trace = ec.getTrace() />
	
	<cfset assertTrue(arrayLen(trace) eq 2, "second trace statement not added") />
	<cfset assertTrue(trace[2].time gt trace[1].time, "time not greater!") />
	<cfset assertTrue(trace[2].type eq "typeVal", "typeVal incorrect") />
	<cfset assertTrue(trace[2].message eq "messageVal", "messageVal incorrect") />
	<cfset assertTrue(trace[2].tag eq "tagVal", "tagVal incorrect") />
	<cfset assertTrue(trace[2].traceType eq "traceTypeVal", "traceTypeVal incorrect") />
	<cfset ec.addTraceStatement("Unicorn", structNew(), "UnicornTagVal", "UnicornTypeVal") />
	<cfset trace = ec.getTrace() />
	<cfset assertTrue( trace[3].message CONTAINS "cfdump", "Complex value didn't get dumped")>
</cffunction>

<!--- BEAN POPULATION TEST --->
<cffunction name="testMakeEventBeanAllFields" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var bean = createObject("component", "modelgluetests.unittests.gesture.externaladapters.beanpopulation.Bean").init() />
	
	<cfset ec.setValue("implicitProp", "implicitPropValue") />
	<cfset ec.setValue("explicitProp", "explicitPropValue") />
	
	<cfset ec.makeEventBean(bean) />
	
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "implicitPropValue", "implicit prop not set") />
</cffunction>

<cffunction name="testMakeEventBeanWithExplicitlyListedFields" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var bean = createObject("component", "modelgluetests.unittests.gesture.externaladapters.beanpopulation.Bean").init() />
	
	<cfset ec.setValue("explicitProp", "explicitPropValue") />
	
	<cfset ec.makeEventBean(bean, "explicitProp") />
	
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "", "implicit prop set when not whitelisted!") />
</cffunction>

<!--- EVENT HANDLER NAME TESTS --->
<cffunction name="testGetInitialEventHandlerNameForDefaultEvent" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/eventHandlerName.xml")>
	
	<cfset structClear(url) />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "home", ec.getInitialEventHandlerName(), "The requested event should be ""home"" " ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testGetInitialEventHandlerNameForExplicitEvent" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/eventHandlerName.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "test" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "test", ec.getInitialEventHandlerName(), "The requested event should be ""test"" " ) />
	
	<cfset structClear(url) />
</cffunction>

<!--- INTERNAL EVENT EXECUTION TESTS --->
<cffunction name="testInternalEventExecution" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/internalEvents.xml")>
	
	<cfset structClear(url) />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertTrue( ec.exists("onRequestStart"), "The internal onRequestStart function was not invoked" ) />
	<cfset assertTrue( ec.exists("onQueueComplete"), "The internal onQueueComplete function was not invoked" ) />
	<cfset assertTrue( ec.exists("onRequestEnd"), "The internal onRequestEnd function was not invoked" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testInternalEventsExecuteOnce" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/internalEvents.xml")>
	
	<cfset structClear(url) />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( 1, ec.getValue("onRequestStartCount"), "The internal onRequestStart function was invoked #ec.getValue('onRequestStartCount')# times" ) />
	<cfset assertEquals( 1, ec.getValue("onQueueCompleteCount"), "The internal onQueueComplete function was invoked #ec.getValue('onQueueCompleteCount')# times" ) />
	<cfset assertEquals( 1, ec.getValue("onRequestEndCount"), "The internal onRequestEnd function was invoked #ec.getValue('onRequestEndCount')# times" ) />
	
	<cfset structClear(url) />
</cffunction>

<!--- EVENT HANDLER EXTENSIBILITY TEST --->
<cffunction name="testEventHandlerExtensibility" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/eventHandlerExtensibility.xml")>
	
	<cfset structClear(url) />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertTrue( ec.exists("onRequestStart"), "The internal onRequestStart function was not invoked" ) />
	<cfset assertTrue( ec.exists("customOnRequestStart"), "The custom onRequestStart function was not invoked" ) />
	
	<cfset structClear(url) />
</cffunction>

<!--- EVENT TYPE BROADCAST TEST --->
<cffunction name="testEventTypeBroadCast" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/eventHandlerName.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "typeTest" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertTrue( ec.exists("testMessage"), "The testMessage function was not invoked" ) />
	
	<cfset structClear(url) />
</cffunction>

<!--- CASE SENSITIVITY TESTS --->
<cffunction name="testMessageListenerCaseSensitivity" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/caseSensitivity.xml")>
	
	<cfset structClear(url) />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertTrue( ec.exists("caseTest"), "The caseTest function was not invoked" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testEventHandlerCaseSensitivity" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	<cfset var handlerName = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/caseSensitivity.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "HOME" />
	
	<cftry>
		<cfset ec = mg.handleRequest() />
		<cfset handlerName = ec.getInitialEventHandlerName() />
		
		<!--- Empty catch to prevent exception if event handler is not found --->
		<cfcatch></cfcatch>
	</cftry>
	
	<cfset assertEquals( "home", handlerName, "The ""home"" event handler was not found" ) />
	
	<cfset structClear(url) />
</cffunction>

<!--- FORMAT EXECUTION ORDER TESTS --->
<cffunction name="testExecutionOrderOfMessageBroadcastWithFormat" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "broadcastEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "format,none", ec.getValue("messageFormats"), "The message with the format of ""format"" should be broadcast first" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfMessageBroadcastWithFormatFromEventType" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "typedBroadcastEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />

	<cfset assertEquals( "format,none", ec.getValue("messageFormats"), "The message with the format of ""format"" should be broadcast first" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfImplicitResultQueuedWithFormat" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "resultEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "format,none", ec.getValue("messageFormats"), "The message with the format of ""format"" should be broadcast first" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfImplicitResultQueuedWithFormatFromEventType" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "typedResultEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "format,none", ec.getValue("messageFormats"), "The message with the format of ""format"" should be broadcast first" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfNamedResultQueuedWithFormat" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "namedResultEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "format,none", ec.getValue("messageFormats"), "The message with the format of ""format"" should be broadcast first" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfNamedResultQueuedWithFormatFromEventType" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "typedNamedResultEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "format,none", ec.getValue("messageFormats"), "The message with the format of ""format"" should be broadcast first" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfViewQueuedWithFormat" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "viewEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "none", ec.getViewCollection().getFinalView(), "The view with the content of ""none"" should be the final view" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testExecutionOrderOfViewQueuedWithFormatFromEventType" returntype="void" access="public">
	<cfset var mg = createModelGlue(this.coldspringPath) />
	<cfset var ec = "" />
	
	<cfset mg.setConfigSetting("primaryModule", "/modelgluetests/unittests/gesture/eventrequest/format/formatOrder.xml")>
	
	<cfset structClear(url) />
	
	<cfset url.event = "typedViewEvent" />
	<cfset url.requestFormat = "format" />
	
	<cfset ec = mg.handleRequest() />
	
	<cfset assertEquals( "none", ec.getViewCollection().getFinalView(), "The view with the content of ""none"" should be the final view" ) />
	
	<cfset structClear(url) />
</cffunction>

<cffunction name="testQueuedEventLimit" returntype="void" access="public">
	<cfset var maxQueuedEventsPerRequest = mg.getConfigSetting("maxQueuedEventsPerRequest") />
	<cfset var i = 0 />
	<cfset var er = "" />
	<cfset var eh = "" />

	<!--- Test that does not exceed the queue limit --->
	<cfset er = createEventContext() />
	<cfloop index="i" from="1" to="#maxQueuedEventsPerRequest#">
		<cfset eh = createEventHandler() />
		<cfset eh.name = "eh#i#" />		
		<cfset er.addEventHandler(eh) />
	</cfloop>
	<cftry>
		<cfset er.execute() />
		<cfcatch type="ModelGlue.QueuedEventLimitExceeded">
			<cfset fail("Event queue limit exception thrown prematurely!") />
		</cfcatch>
	</cftry>
	
	<!--- Test that exceeds the queue limit --->
	<cfset er = createEventContext() />	
	<cfloop index="i" from="1" to="#(maxQueuedEventsPerRequest+1)#">
		<cfset eh = createEventHandler() />
		<cfset eh.name = "eh#i#" />		
		<cfset er.addEventHandler(eh) />
	</cfloop>
	<cftry>
		<cfset er.execute() />
		<cfset fail("Event queue limit exception not thrown!") />
		<cfcatch type="ModelGlue.QueuedEventLimitExceeded" />
	</cftry>	
</cffunction>

</cfcomponent>