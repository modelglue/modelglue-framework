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

  <!--- 
    Load a simple config bean from the /Beans folder.
    The bean loaded has a getConfigValue(name) method to get at
    its settings.  You'll see it used in DoHomepage()
  --->
    
  <cfset variables.config = getModelGlue().getConfigBean("SampleConfig.xml") />
  
  <cfreturn this />
</cffunction>

<cffunction name="OnRequestStart" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  
  <!--- You can put stuff here that may be needed by all events --->
  <cfset arguments.event.SetValue("datasourceName", "myDatasource") />
  
  <!--- Show off the IoC config beans a little --->
  <cfset arguments.event.SetValue("complexConfigSetting", variables.config.getConfigSetting("complexConfigSetting")) />
  
  <cfreturn arguments.event />
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  
  <!--- 
    You can do stuff here, but it won't affect what the user sees.
    By the time you've gotten here, the views have been rendered.
  --->
  
  <cfreturn arguments.event />
</cffunction>

<cffunction name="DoHomepage" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  
  <!--- Show that arguments get passed along nicely --->
  <cfset arguments.event.SetValue("argValue", arguments.event.getArgument("SampleArg")) />

  <cfreturn arguments.event />
</cffunction>

<cffunction name="DoUpper" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  
  <!--- 
    Get the name from the event's state collection:
    Syntax: arguments.event.SetValue(name, [optional] default value)
  --->  
  <cfset var name = arguments.event.GetValue("name", variables.config.getConfigSetting("defaultName")) />

  <!---
    Upper-case the name and put it in the state collection as "uppername"
    Syntax: arguments.event.GetValue(name, value)
  --->
  <cfif name eq "Doug">     
    <cfthrow message="Doug causes more work!" />
  <cfelseif name eq "Joe">
    <cfthrow message="Joe? We don't need no stinking Joe!" />
  <cfelse>
    <cfset arguments.event.SetValue("uppername", ucase(name)) />
  </cfif>
         
  <cfreturn arguments.event />
</cffunction>

</cfcomponent>

