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


<cfcomponent output="false" hint="I represent a value that can be set as part of a view's inclusion.">

<cfproperty name="name" type="string" hint="The name of the value." />
<cfproperty name="value" type="any" hint="The value to be set." />
<cfproperty name="overwrite" type="boolean" hint="If an existing value exists, should it be overwritten?" />

<cfset this.name = "" />
<cfset this.value = "" />
<cfset this.overwrite = true />

</cfcomponent>
