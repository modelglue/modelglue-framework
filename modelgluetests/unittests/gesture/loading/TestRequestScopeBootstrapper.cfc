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


<cfcomponent extends="modelgluetests.unittests.gesture.ModelGlueAbstractTestCase">
	
<cfset this.coldspringPath = "/modelgluetests/unittests/gesture/loading/ColdSpring.xml">

<cffunction name="testStoreModelGlue" returntype="void" access="public">
	<cfset var boot = createBootstrapper(this.coldspringPath) />
	<cfset var mg = createObject("component", "ModelGlue.gesture.MemoizedModelGlue") />
	
	<cfset boot.storeModelGlue(mg) />
	<cfset assertTrue(getMetadata(request._modelglue.bootstrap.framework).name eq "ModelGlue.gesture.MemoizedModelGlue", "ModelGlue instance not stored in request scope.") />
</cffunction>

</cfcomponent>


