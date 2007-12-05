<cfcomponent extends="ModelGlue.gesture.collections.test.TestMapCollectionImplementation">

<cffunction name="createMapCollectionNoInit" access="private" hint="Creates a basic MapCollection to test without running init().">
	<cfreturn createObject("component", "ModelGlue.gesture.eventrequest.EventContext") />
</cffunction>

<cffunction name="createMapCollection" access="private" hint="Creates a basic MapCollection to test.  Extend this test class and override this method to test other implementations.">
	<cfreturn createMapCollectionNoInit().init() />
</cffunction>

<cffunction name="createEventContext" access="private">
	<cfset ec = createObject("component", "ModelGlue.gesture.eventrequest.EventContext").init() />
	<cfset ec.setViewRenderer(createObject("component", "ModelGlue.gesture.view.ViewRenderer").init()) />
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
	
	<cfset er.onReadyForExecution() />

	<cfset er.addEventHandler(eh2) />
	
	<cfset assertTrue(er.getInitialEventHandler().name eq "eh2", "Initial event shouldn't be set until _after_ onReadyForExecution() is invoked!") />
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
	
	<cfset listener.target = this />
	<cfset listener.listenerFunction = "listener_testExecuteEventHandler_ListenerInvocation" />
	<cfset msg.name = "message" />
	
	<cfset listeners[msg.name] = arrayNew(1) />
	<cfset arrayAppend(listeners[msg.name], listener) />
	<cfset er.setListenerMap(listeners) />
	
	<cfset msg.name = "message" />
	
	<cfset eh1.name = "eh1" />
	<cfset eh1.addMessage(msg) />
	
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value = false />
	<cfset er.executeEventHandler(eh1) />
	<cfset assertTrue(variables.testExecuteEventHandler_ListenerInvocation_value, "listener function not invoked!") />
</cffunction>

<cffunction name="listener_testExecuteEventHandler_ListenerInvocation" access="public" returntype="void">
	<cfset variables.testExecuteEventHandler_ListenerInvocation_value = true />
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

	<cfset listener2.target = this />
	<cfset listener2.listenerFunction = "listener2_testExecuteEventHandler_ResultQueueing" />
	<cfset msg2.name = "message2" />

	<cfset listener3.target = this />
	<cfset listener3.listenerFunction = "listener3_testExecuteEventHandler_ResultQueueing" />
	<cfset msg3.name = "message3" />
	
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

<cffunction name="listener1_testExecuteEventHandler_ResultQueueing" access="public" returntype="void">
	<cfargument name="event" />
	<cfset variables.listener1_testExecuteEventHandler_ResultQueueing_value = true />

	<cfset event.addResult("result1") />
</cffunction>

<cffunction name="listener2_testExecuteEventHandler_ResultQueueing" access="public" returntype="void">
	<cfset variables.listener2_testExecuteEventHandler_ResultQueueing_value = true />
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = variables.testExecuteEventHandler_ResultQueueing_order & "explicit" />
</cffunction>

<cffunction name="listener3_testExecuteEventHandler_ResultQueueing" access="public" returntype="void">
	<cfset variables.testExecuteEventHandler_ResultQueueing_order = variables.testExecuteEventHandler_ResultQueueing_order & "implicit" />
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


</cfcomponent>