<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<cfcomponent extends="mxunit.framework.TestCase">

	<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/ColdSpring.xml" />
	<cfset variables.mg = "">

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	</cffunction>
	
	<cffunction name="createBootstrapper" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		<cfargument name="modelGlueBeanName" default="modelglue.ModelGlue">
		
		<cfset var bootstrapper = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper")>
		
		<cfset bootstrapper.coldspringPath = arguments.coldspringPath>
		<cfset bootstrapper.coreColdspringPath = arguments.coldspringPath>
		<cfset bootstrapper.modelGlueBeanName = arguments.modelGlueBeanName>
		
		<cfset request._modelglue.bootstrap.bootstrapper = bootstrapper />
		<cfset request._modelglue.bootstrap.initializationRequest = true />
		<cfset request._modelglue.bootstrap.initializationLockPrefix = expandPath(".") & "/.modelglue" />
		<cfset request._modelglue.bootstrap.initializationLockTimeout = 60 />
		
		<cfreturn bootstrapper>
	</cffunction>
	
	<cffunction name="createModelGlueIfNotDefined" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		
		<cfif isSimpleValue(mg)>
			<cfset createModelGlue(coldspringPath)>
		</cfif>
		<cfreturn mg>
	</cffunction>
	
	<cffunction name="createModelGlue" access="private">
		<cfargument name="coldspringPath" default="#this.coldspringPath#">
		
		<cfset variables.mg = createBootstrapper(coldspringPath).createModelGlue()>
		
		<cfset request._modelglue.bootstrap.framework = mg />
		
		<cfreturn mg>
	</cffunction>

</cfcomponent>
