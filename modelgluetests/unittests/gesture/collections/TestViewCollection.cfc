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

<cffunction name="createViewCollectionNoInit" access="private" hint="Creates a basic ViewCollection to test without running init().">
	<cfreturn createObject("component", "ModelGlue.gesture.collections.ViewCollection") />
</cffunction>

<cffunction name="createViewCollection" access="private" hint="Creates a basic ViewCollection to test.  Extend this test class and override this method to test other implementations.">
	<cfreturn createViewCollectionNoInit().init() />
</cffunction>

<cffunction name="testAddRenderedView" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContent", "renderedContent not returned") />
	
	<cfset col.addRenderedView("content", "appendedContent", true) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContentappendedContent", "renderedContentappendedContent not returned") />
</cffunction>

<cffunction name="testGetView" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset assertTrue(col.getView("content") eq "renderedContent", "renderedContent not returned") />
</cffunction>

<cffunction name="testExists" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset assertFalse(col.exists("content"), "exists returned true before rendering") />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset assertTrue(col.exists("content"), "exists returned false after rendering") />
</cffunction>

<cffunction name="testGetAll" returntype="void" access="public">
	<cfset var col = createViewCollection() />
	<cfset var colRef = "" />
	
	<cfset col.addRenderedView("content", "renderedContent", false) />
	
	<cfset colRef = col.getAll() />
	
	<cfset colRef.content = "alteredContent" />
	
	<cfset assertTrue(col.getView("content") neq colRef.content, "modifying getAll() result modified internal content!") />
</cffunction>

<cffunction name="testGetFinalView" returntype="void" access="public">
	<cfset var col = createViewCollection() />

	<cfset col.addRenderedView("content", "renderedContent", false) />
	<cfset assertTrue(col.getFinalView() eq "renderedContent", "getFinalView failed first check") />

	<cfset col.addRenderedView("content2", "renderedContent2", false) />
	<cfset assertTrue(col.getFinalView() eq "renderedContent2", "getFinalView failed second check") />
</cffunction>


</cfcomponent>
