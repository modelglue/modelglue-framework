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
  <cfset var temp = "" />

  <cfset super.Init(arguments.ModelGlue) />
  
  <!--- Load the config params for the Tartan app we're talking to --->
  <cfset temp = getModelGlue().getConfigBean("Tartan.xml") />
  
  <!--- Load the Tartan proxy --->
  <cfset variables.tartanProxy = createObject("component", "ModelGlue.Util.TartanProxy").init(temp) />
  
  <!--- We're going to need the HelloWorld service universally --->
  <cfset variables.hwService = getTartan().CreateService("helloWorld") />  
  
  <cfreturn this />
</cffunction>


<cffunction name="GetHelloService" access="private" output="false">
  <cfreturn variables.hwService  />
</cffunction>

<cffunction name="GetTartan" access="private" output="false">
  <cfreturn variables.tartanProxy  />
</cffunction>

<cffunction name="OnRequestStart" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  <cfreturn arguments.event />
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  <cfreturn arguments.event />
</cffunction>

<cffunction name="GetGreeting" access="Public" returnType="ModelGlue.Core.Event" output="false">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

  <cfset var proxy = GetTartan() />
  <cfset var service = getHelloService() />
  <cfset var args = structNew() />
  <cfset var greeting = "" />
  <cfset args.lang = arguments.event.getValue("lang", "English") />
  
  <cfset greeting = proxy.invokeCommand(service, "GetGreeting", args) />
  <cfset arguments.event.setValue("greeting", greeting) />
  <cfreturn arguments.event />
</cffunction>

</cfcomponent>

