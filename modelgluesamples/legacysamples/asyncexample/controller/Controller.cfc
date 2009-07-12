<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent displayname="Controller" output="false" hint="I am a sample model-glue controller." extends="ModelGlue.Core.Controller">

<cffunction name="Init" access="Public" returnType="Controller" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue">
  <cfset super.Init(arguments.ModelGlue) />
  <cfreturn this />
</cffunction>

<cffunction name="OnRequestStart" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
	
  <cfreturn arguments.event />
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  <cfreturn arguments.event />
</cffunction>

<cffunction name="CountToNumber" access="Public" returnType="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

	<cfset var number = arguments.event.getValue("number") />
	<cfset var i = "" />
	
	<cfif not isNumeric(number) or number LTE 0>
		<cfthrow message="Hey, you need to enter a non-zero number for this to work!" />
	</cfif>
	
	<cfset arguments.event.setValue("count", 0) />	
	
	<cfloop from="1" to="#number#" index="i">
		<cfset arguments.event.setValue("count", i) />	
	</cfloop>
</cffunction>

<cffunction name="GetCountRequests" access="Public" returnType="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

	<cfset var req = getModelGlue().getAsyncRequests("CountToNumber").GetRequests() />
	<cfset arguments.event.setValue("countRequests", req) />
</cffunction>


<cffunction name="RemoveCount" access="Public" returnType="void" output="false" hint="I am an eventhandler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

	<cfset var pos = arguments.event.getValue("pos")>
	<cfset var req = getModelGlue().getAsyncRequests("CountToNumber") />

	<cfset arguments.event.addTraceStatement("RemoveCount", "Removing count #pos# of #arrayLen(req.getRequests())#") />
	<cfif isNumeric(pos)>
		<cfset req.RemoveRequest(pos) />
	</cfif>
</cffunction>

</cfcomponent>

