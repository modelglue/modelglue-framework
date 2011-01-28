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


<cfsilent>
<!---
	If you want to run multiple MG applications under the same
	application name, change this value to something unique
	to this application to prevent them from colliding in the 
	application scope.
	
	<cfset ModelGlue_APP_KEY = "mySubapplication" />
--->

<!---
	**CUSTOM APPLICATION CONFIGURATION**
	
  If your path to ColdSpring.xml is custom, change it here.  Otherwise,
  it will default to Config/ColdSpring.xml
	
	<cfset ModelGlue_LOCAL_COLDSPRING_PATH = expandPath(".") & "/config/ColdSpring.xml" />
--->

<!---
	**CUSTOM CORE CONFIGURATION**

  If your path to ModelGlueConfiguration.xml is custom, change it here.  Otherwise,
  it will default to /ModelGlue/gesture/configuration/ModelGlueConfiguration.xml

	<cfset ModelGlue_CORE_COLDSPRING_PATH = "/ModelGlue/gesture/configuration/ModelGlueConfiguration.xml" />
--->

<!---
	**HIERARCHIAL BEAN FACTORY SUPPORT**

	If you'd like to designate a parent bean factory for the one that powers Model-Glue,
	simply do whatever you need to do to set the following value to the parent bean factory 
	instance:
	
	<cfset ModelGlue_PARENT_BEAN_FACTORY = ??? />
--->


<!--- If your path to ModelGlue.cfm is different, you'll need to change this line. --->
</cfsilent><cfinclude template="/ModelGlue/gesture/ModelGlue.cfm" />
