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


<cfcomponent>
  <cffunction name="Validate">
    <cfargument name="Contact">
    <cfset var val = createObject("component", "ModelGlue.Util.ValidationErrorCollection").init() />

    <cfif not len(contact.getFirstname())>
      <cfset val.addError("firstname", "First name is required.") />
    </cfif>

    <cfif not len(contact.getLastname())>
      <cfset val.addError("lastname", "Last name is required.") />
    </cfif>

    <cfreturn val>
  </cffunction>
</cfcomponent>