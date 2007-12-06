<cfcomponent extends="org.cfcunit.framework.TestCase" hint="Tests EventHandler, Message, View, and Result CFCs.">

<cffunction name="createModelGlueNoInit" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.ModelGlue") />
</cffunction>

<cffunction name="createModelGlue" access="private">
	<cfreturn createModelGlueNoInit().init() />
</cffunction>

<cffunction name="createEventHandler" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.EventHandler") />
</cffunction>

<!--- LISTENER REGISTRATION TESTS --->
<cffunction name="testAddEventListener" returntype="void" access="public">
	<cfset var mg = createModelGlue() />
	<cfset var listeners = "" />
	
	<cfset assertFalse(mg.hasEventListener("message"), "should have no listener for ""message"" before adding listener!") />
	
	<cfset mg.addEventListener("message", this, "stub_listenerFunction") />
	
	<cfset assertTrue(mg.hasEventListener("message"), "no listener for ""message"" after add!") />
	
	<cfset listeners = mg.getEventListeners("message") />
	<cfset assertTrue(arrayLen(listeners) eq 1, "should have 1 listener after add") />
	<cfset assertTrue(getMetadata(listeners[1]).name eq "ModelGlue.gesture.eventhandler.MessageListener", "a MessageListener instance should exist after add") />

	<cfset mg.addEventListener("message", this, "stub_listenerFunction") />
	
	<cfset listeners = mg.getEventListeners("message") />
	<cfset assertTrue(arrayLen(listeners) eq 2, "should have 2 listeners after second add") />
	
</cffunction>

<cffunction name="stub_listenerFunction">
</cffunction>

<!--- EVENT HANDLER REGISTRATION TESTS --->
<cffunction name="testAddEventHandler" returntype="void" access="public">
	<cfset var mg = createModelGlue() />
	<cfset var eh = createEventHandler() />
	
	<cfset eh.name = "eventHandler" />
	
	<cfset mg.addEventHandler(eh) />

	<cfset eh = mg.getEventHandler(eh.name) />
	
	<cfset assertTrue(eh.name eq "eventHandler", "event handler not returned!") />
</cffunction>

<!--- PHASED INVOCATION TESTS --->
<cffunction name="testPhase_Initialization" returntype="void" access="public">
</cffunction>

</cfcomponent>