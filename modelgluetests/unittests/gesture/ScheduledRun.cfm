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


<cfparam name="URL.output" default="html">
<cfparam name="url.quiet" default="false">
<cfparam name="url.email" default="false">
<cfparam name="url.recipients" default="????@????.com"> <!--- change this! --->

<cfset configStuff = structNew() >
<cfset structAppend( configStuff, url ) />

<cfsetting requesttimeout="600">

<cfset dir = expandPath(".")>
<cfoutput><h1>#dir#</h1></cfoutput>

<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>
<cfset excludes = "TestSimpleTimedCache">
<cfinvoke component="#DTS#" 
	method="run"
	directory="#dir#" 
	recurse="true" 
	excludes="#excludes#"
	returnvariable="Results"
	componentpath="modelgluetests.unittests.gesture"><!---  <-- Fill this in! This is the root component path for your tests. if your tests are at {webroot}/app1/test, then your componentpath will be app1.test   --->

<cfsetting showdebugoutput="true">

<cfoutput>
<cfsavecontent variable="recenthtml">

<cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
	<cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
</cfif>

#results.getResultsOutput(configStuff.output)#
</cfsavecontent>
</cfoutput> 
<cfif NOT configStuff.quiet>
	<cfoutput>#recenthtml#</cfoutput>
</cfif>

<cfif configStuff.email>
	<!--- change this 'from' email! --->
	<cfmail from="????@????.com" to="#configStuff.recipients#" subject="Test Results : #DateFormat(now(),'short')# @ #TimeFormat(now(),'short')#" type="html">
	#recenthtml#
	</cfmail>
</cfif>
