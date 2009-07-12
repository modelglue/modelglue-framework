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

<!--- WARNING

The following are "reserved" terms, used by the base
ModelGlue.Core.Controller.

Do not name functions any of the following:

GetModelGlue
GetControllerName
AddToCache
ExistsInCache
GetFromCache
RemoveFromCache

Do not declare variables in the variables scope named the following:

variables.ModelGlue


		 /WARNING --->


<!--- Constructor --->
<cffunction name="Init" access="Public" returnType="Controller" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue" required="true" type="ModelGlue.ModelGlue" />
  <cfargument name="InstanceName" required="true" type="string" />
  <cfset super.Init(arguments.ModelGlue) />

	<!--- Controllers are in the application scope:  Put any application startup code here. --->
  <cfreturn this />
</cffunction>

<!--- Functions specified by <message-listener> tags --->
<cffunction name="OnRequestStart" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  
  <cfset var tf = getModelGlue().getConfigBean("timeFormat") />
  
  <cfset arguments.event.setValue("timeFormat", tf.getTimeFormat()) />
  
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returntype="void" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
</cffunction>

</cfcomponent>

