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


<cfcomponent output="false" hint="I'm a bootstrapper that loads an instance of ModelGlue.cfc into a named position in the Request scope.">

<cfproperty name="applicationKey" type="string" hint="The name of the variable in application scope in which Model-Glue should eventually be stored." />
<cfproperty name="modelglueVersionIndicator" type="string" hint="Indicator of which version of Model-Glue is loading.  Set to a value in this.versionIndicators." />
<cfproperty name="primaryModulePath" type="string" hint="In order to support legacy applications, we allow primary application module to be defined in the bootstrapper rather than in a proper configuation." />

<cfset this.applicationKey = "modelglue" />
<cfset this.primaryModulePath = "" />
<cfset this.versionIndicators = structNew() />
<cfset this.versionIndicators.legacy = "LEGACY" />
<cfset this.versionIndicators.unity = "UNITY" />
<cfset this.versionIndicators.gesture = "GESTURE" />

<cfset this.modelglueVersionIndicator = this.versionIndicators.gesture />

<cffunction name="storeModelGlue" output="false" hint="Stores the framework and the bootstrapper in request._modelGlue.bootstrapper.">
	<cfargument name="framework" />

	<cfset request._modelGlue.bootstrap.framework = arguments.framework />
	<cfset request._modelGlue.bootstrap.bootstrapper = this />
	
	<cfreturn arguments.framework />
</cffunction>

</cfcomponent>
