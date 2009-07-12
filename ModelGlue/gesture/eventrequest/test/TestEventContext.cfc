<cfcomponent extends="ModelGlue.gesture.collections.test.TestMapCollectionImplementation">

<cfset this.coldspringPath = "/ModelGlue/gesture/eventrequest/test/ColdSpring.xml">

<cffunction name="setUp" output="false" access="public" returntype="any" hint="">
	<cfset request._modelglue.bootstrap.initializationRequest = false />
	<cfset createModelGlueIfNotDefined(this.coldspringPath) />
</cffunction>

<cfset variables.mockHelpersScope = structNew() />
<cffunction name="mockHelperFunction">
	<cfreturn "I am a helper function." />
</cffunction>

<cfset variables.mockHelpersScope.helperFunction = this.mockHelperFunction />

<cffunction name="createMapCollectionNoInit" access="private" hint="Creates a basic MapCollection to test without running init().">
	<cfreturn createObject("component", "ModelGlue.gesture.eventrequest.EventContext") />
</cffunction>

<cffunction name="createMapCollection" access="private" hint="Creates a basic MapCollection to test.  Extend this test class and override this method to test other implementations.">
	<cfreturn createMapCollectionNoInit().init() />
</cffunction>

<cffunction name="createEventContext" access="private">
	<cfset var ec = "" />
	<cfset var vr = "" />
	
	<cfset vr = createObject("component", "ModelGlue.gesture.view.ViewRenderer").init() />
	<cfset vr.setModelGlue( mg ) />
	<cfset vr.addViewMapping("/ModelGlue/gesture/view/test/views") />	
		
		<!--- Simulating a bootstrapping request --->
	<cfset request._modelglue.bootstrap.initializationRequest = true />
	<cfset request._modelglue.bootstrap.framework = mg />
	
	<!--- Event context has many dependencies that are configured into the framework:  we list them explicitly here --->	
	<cfset ec = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init(
			viewRenderer=vr,
			helpers=variables.mockHelpersScope,
			modelglue=mg,
			statePersister=mg.getStatePersister()
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
	<cfset listeners[msg.name] = arrayNew(1) />
	<cfset arrayAppend(listeners[msg.name], listener) />
	<cfset eh1.addMessage(msg, "explicitFormat") />
	
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
	<cfset eh1.addMessage(msg1, "explicitFormat") />
	<!--- Explicit result --->
	<cfset result1.name = "result1" />
	<cfset result1.event = "eh2" />
	<cfset eh1.addResult(result1, "explicitFormat") />
	<!--- Implicit result --->
	<cfset result2.name = "" />
	<cfset result2.event = "eh3" />
	<cfset eh1.addResult(result2, "explicitFormat") />

	<cfset eh2.name = "eh2" />
	<cfset eh2.addMessage(msg2, "explicitFormat") />

	<cfset eh3.name = "eh3" />
	<cfset eh3.addMessage(msg3, "explicitFormat") />

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

	<cfset eh.name = "eh" />
	<cfset eh.addView(view) />
	<cfset eh.addView(formattedView, "explicitFormat") />

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
	<cfset var path = "http://localhost/ModelGlue/gesture/eventrequest/test/" />
	<cfset var urlpathdestination = "#path#/ForwardToUrlDestination.cfm?msg=#msg#" />
	<cfhttp url="#path#ForwardToUrlEndpoint.cfm?url=#urlEncodedFormat(urlpathdestination)#"  />
	<!--- todo: Find a better way to test this because this method is fragile and sucks --->
	<cfset assertTrue(cfhttp.fileContent eq msg, 'File content not message! Expected #msg#, got #cfhttp.filecontent#') />
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
	<cfset var thread = CreateObject("java", "java.lang.Thread")>

	<cfset assertTrue(arrayLen(trace) eq 1 and trace[1].time eq ec.getCreated(), "initial trace statement incorrect")>

	<cfset thread.sleep(100)>	

	<cfset ec.addTraceStatement("typeVal", "messageVal", "tagVal", "traceTypeVal") />
	
	<cfset trace = ec.getTrace() />
	
	<cfset assertTrue(arrayLen(trace) eq 2, "second trace statement not added") />
	<cfset assertTrue(trace[2].time gt trace[1].time, "time not greater!") />
	<cfset assertTrue(trace[2].type eq "typeVal", "typeVal incorrect") />
	<cfset assertTrue(trace[2].message eq "messageVal", "messageVal incorrect") />
	<cfset assertTrue(trace[2].tag eq "tagVal", "tagVal incorrect") />
	<cfset assertTrue(trace[2].traceType eq "traceTypeVal", "traceTypeVal incorrect") />
</cffunction>

<!--- BEAN POPULATION TEST --->
<cffunction name="testMakeEventBeanAllFields" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var bean = createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.test.Bean").init() />
	
	<cfset ec.setValue("implicitProp", "implicitPropValue") />
	<cfset ec.setValue("explicitProp", "explicitPropValue") />
	
	<cfset ec.makeEventBean(bean) />
	
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "implicitPropValue", "implicit prop not set") />
</cffunction>

<cffunction name="testMakeEventBeanWithExplicitlyListedFields" access="public" returntype="void">
	<cfset var ec = createEventContext() />
	<cfset var bean = createObject("component", "ModelGlue.gesture.externaladapters.beanpopulation.test.Bean").init() />
	
	<cfset ec.setValue("explicitProp", "explicitPropValue") />
	
	<cfset ec.makeEventBean(bean, "explicitProp") />
	
	<cfset assertTrue(bean.explicitProp eq "explicitPropValue", "explicit prop not set") />
	<cfset assertTrue(bean.getImplicitProp() eq "", "implicit prop set when not whitelisted!") />
</cffunction>

</cfcomponent>