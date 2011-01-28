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

<cfset variables.System = createObject("java", "java.lang.System") />

<cffunction name="testCreateByTypeName" returntype="void" access="public">
	<cfset var fac = createObject("component", "ModelGlue.gesture.factory.TypeDefaultingMapBasedFactory").init() />
	<cfset var inst = fac.create("modelgluetests.unittests.gesture.factory.ImplOne") />

	<cfset assertTrue(getMetadata(inst).name eq "modelgluetests.unittests.gesture.factory.ImplOne", "correct type not instantiated") />	
</cffunction>

<cffunction name="testCreateByAlias" returntype="void" access="public">
	<cfset var fac = createObject("component", "ModelGlue.gesture.factory.TypeDefaultingMapBasedFactory") />
	<cfset var map = structNew() />
	<cfset var inst1 = ""/>
	<cfset var inst2 = ""/>

	<cfset map.implOne = {class="modelgluetests.unittests.gesture.factory.ImplOne"} />
	<cfset map.implTwo = {class="modelgluetests.unittests.gesture.factory.ImplTwo"} />
	
	<cfset fac.init(map) />
	
	<cfset inst1 = fac.create("implOne") />
	<cfset inst2 = fac.create("implTwo") />
	
	<cfset assertTrue(getMetadata(inst1).name eq "modelgluetests.unittests.gesture.factory.ImplOne", "correct type not instantiated") />	
	<cfset assertTrue(getMetadata(inst2).name eq "modelgluetests.unittests.gesture.factory.ImplTwo", "correct type not instantiated") />	
</cffunction>

<cffunction name="testSingleton" returntype="void" access="public">
	<cfset var fac = createObject("component", "ModelGlue.gesture.factory.TypeDefaultingMapBasedFactory").init() />
	<cfset var inst1 = fac.create("modelgluetests.unittests.gesture.factory.ImplOne") />
	<cfset var inst2 = fac.create("modelgluetests.unittests.gesture.factory.ImplOne") />

	<cfset assertTrue(System.identityHashCode(inst1) eq System.identityHashCode(inst2), "Two refs should be same instance!") />	
</cffunction>

<cffunction name="testConstructorArgs" returntype="void" access="public">
	<cfset var fac = createObject("component", "ModelGlue.gesture.factory.TypeDefaultingMapBasedFactory") />
	<cfset var args = structNew() />
	<cfset var inst = "" />
	
	<cfset args.arg = "argValue" />
	
	<cfset fac.init(constructorArgs=args) />
	
	<cfset inst = fac.create("modelgluetests.unittests.gesture.factory.ImplOne") />

	<cfset assertTrue(inst.arg eq "argValue", "constructor arg not set!") />	
</cffunction>

</cfcomponent>
