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


<cfcomponent displayname="SampleController" output="false" hint="I am a sample model-glue controller." extends="ModelGlue.Core.Controller">

<cffunction name="Init" access="Public" returnType="Controller" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue">
  <cfset super.Init(arguments.ModelGlue) />
  <cfset variables.dateTimeFormat = GetModelGlue().GetConfigBean("DateTimeFormat.xml") />

  <cfreturn this />
</cffunction>

<cffunction name="OnRequestStart" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

	<cfset var currentTime = timeFormat(now(), variables.dateTimeFormat.getTimeFormat()) />
	<cfset var currentDateLong = dateFormat(now(), variables.dateTimeFormat.getDateFormat().long) />
	<cfset var currentDateShort = dateFormat(now(), variables.dateTimeFormat.getDateFormat().short) />

	<cfset arguments.event.setValue("currentTime", currentTime) />
	<cfset arguments.event.setValue("currentDateLong", currentDateLong) />
	<cfset arguments.event.setValue("currentDateShort", currentDateShort) />

  <cfreturn arguments.event />
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  <cfreturn arguments.event />
</cffunction>

</cfcomponent>

