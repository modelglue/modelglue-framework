<cfcomponent output="false" extends="ModelGlue.gesture.controller.Controller">

<cffunction name="onRequestStart" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var onRequestStartCount = arguments.event.getValue("onRequestStartCount", 0)>
	<cfset onRequestStartCount = onRequestStartCount + 1>
	
	<cfset arguments.event.setValue("onRequestStart", "Internal onRequestStart invoked") />
	<cfset arguments.event.setValue("onRequestStartCount", onRequestStartCount) />
</cffunction>

<cffunction name="onQueueComplete" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var onQueueCompleteCount = arguments.event.getValue("onQueueCompleteCount", 0)>
	<cfset onQueueCompleteCount = onQueueCompleteCount + 1>
	
	<cfset arguments.event.setValue("onQueueComplete", "Internal onQueueComplete invoked") />
	<cfset arguments.event.setValue("onQueueCompleteCount", onQueueCompleteCount) />
</cffunction>

<cffunction name="onRequestEnd" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset var onRequestEndCount = arguments.event.getValue("onRequestEndCount", 0)>
	<cfset onRequestEndCount = onRequestEndCount + 1>
	
	<cfset arguments.event.setValue("onRequestEnd", "Internal onRequestEnd invoked") />
	<cfset arguments.event.setValue("onRequestEndCount", onRequestEndCount) />
</cffunction>

<cffunction name="customOnRequestStart" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("customOnRequestStart", "Custom onRequestStart invoked") />
</cffunction>

<cffunction name="caseTest" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("caseTest", "caseTest invoked") />
</cffunction>

<cffunction name="testMessage" access="public" output="false" returntype="void">
	<cfargument name="event" type="any" required="true" />
	
	<cfset arguments.event.setValue("testMessage", "testMessage invoked") />
</cffunction>

</cfcomponent>