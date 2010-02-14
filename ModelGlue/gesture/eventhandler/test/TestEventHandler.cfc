<cfcomponent extends="mxunit.framework.TestCase" hint="Tests EventHandler, Message, View, and Result CFCs.">

<cffunction name="createEventHandler" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.EventHandler") />
</cffunction>

<cffunction name="createMessage" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.eventhandler.Message") />
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

<!--- EVENTHANDLER TESTS --->
<cffunction name="testEventHandler_defaultProperties" returntype="void" access="public">
	<cfset var eh = createEventHandler() />
	
	<cfset assertTrue(eh.access eq "public", "access should default to ""public""") />
	<cfset assertTrue(eh.cache eq false) />
	<cfset assertTrue(eh.cacheKey eq "") />
	<cfset assertTrue(eh.cacheKeyValues eq "") />
	<cfset assertTrue(eh.cacheTimeout eq 0) />
</cffunction>

<!--- MESSAGE TESTS --->
<cffunction name="testMessage_defaultProperties" returntype="void" access="public">
	<cfset var message = createMessage() />
	
	<cfset assertTrue(getMetadata(message.arguments).name eq "ModelGlue.gesture.collections.MapCollection", "arguments should be a MapCollection on instantiation") />
</cffunction>

<cffunction name="testEventHandler_AddHasMessage" returntype="void" access="public">
	<cfset var eh = createEventHandler() />
	<cfset var message = createMessage() />
	
	<cfset message.name = "message" />

	<cfset assertFalse(eh.hasMessage("message"), "hasMessage returned true before adding message!") />

	<cfset eh.addMessage(message) />

	<cfset assertTrue(arrayLen(eh.messages), "messages should have a length after add")>	
	<cfset assertTrue(eh.hasMessage("message"), "hasMessage returned false after adding message!") />
</cffunction>

<!--- RESULT TESTS --->
<cffunction name="testEventHandler_AddHasResult" returntype="void" access="public">
	<cfset var eh = createEventHandler() />
	<cfset var result = createResult() />
	
	<cfset result.name = "result" />
	<cfset assertFalse(eh.hasResult("result"), "hasResult returned true before adding result!") />

	<cfset eh.addResult(result) />
	
	<cfset assertTrue(structCount(eh.results), "results should have length after add")>	
	<cfset assertTrue(eh.hasResult("result"), "hasResult returned false after adding result!") />
</cffunction>

<!--- VIEW TESTS --->
<cffunction name="testView_defaultProperties" returntype="void" access="public">
	<cfset var view = createView() />
	
	<cfset assertFalse(view.append, "view should have append=true by default")>	
	<cfset assertTrue(view.cache eq false) />
	<cfset assertTrue(view.cacheKey eq "") />
	<cfset assertTrue(view.cacheKeyValues eq "") />
	<cfset assertTrue(view.cacheTimeout eq 0) />
</cffunction>

<cffunction name="testEventHandler_AddView" returntype="void" access="public">
	<cfset var eh = createEventHandler() />
	<cfset var view = createView() />
	
	<cfset view.name = "view" />

	<cfset eh.addView(view) />
	
	<cfset assertTrue(arrayLen(eh.views), "views should have length before add")>	
</cffunction>

<cffunction name="testView_AddValue" returntype="void" access="public">
	<cfset var view = createView() />
	<cfset var value = createValue() />
	<cfset var value2 = createValue() />
	
	<cfset value.name = "value" />
	<cfset value.value = "val" />

	<cfset value2.name = "value" />
	<cfset value2.value = "val2" />
	
	<cfset assertFalse(structCount(view.values), "values should have no length before add")>	
	<cfset assertFalse(structKeyExists(view.values, "value"), "value found before adding value!") />

	<cfset view.addValue(value) />
	
	<cfset assertTrue(structCount(view.values), "values should have length after add")>	
	<cfset assertTrue(structKeyExists(view.values, "value"), "value not found after adding value!") />
	<cfset assertTrue(view.values.value.value eq "val", "value had incorrect value after add") />
	
	<cfset view.addValue(value2) />

	<cfset assertTrue(view.values.value.value eq "val2", "second value did not overwrite first") />
</cffunction>

<!--- VALUE TESTS --->
<cffunction name="testValue_defaultProperties" returntype="void" access="public">
	<cfset var value = createValue() />
	
	<cfset assertTrue(value.overwrite, "value should have overwrite=true by default")>	
</cffunction>


</cfcomponent>