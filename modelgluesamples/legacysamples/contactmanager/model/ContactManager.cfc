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


<cfcomponent hint="ContactManager" output="false">

	<cfset variables.contacts = StructNew() />
	
  <cffunction name="newContact">
    <cfreturn createObject("component", "modelgluesamples.legacysamples.contactmanager.model.Contact").init() />
  </cffunction>

  <cffunction name="commitContact">
    <cfargument name="contact">
    
    <cfset var validator = createObject("component", "modelgluesamples.legacysamples.contactmanager.model.ContactValidator") />
    <cfset var val = "" />
    
    <cfset val = validator.validate(arguments.contact) />
    
    <cfif not val.hasErrors()>
      <cfif not len(arguments.contact.getId())>
        <cfset arguments.contact.setId(createUuid())>
      </cfif>
      <cfset variables.contacts[arguments.contact.getId()] = contact />
    </cfif>
    
    <cfreturn val />
  </cffunction>
  
	<cffunction name="getContact" returntype="modelgluesamples.legacysamples.contactmanager.model.Contact">
		<cfargument name="id" type="string" required="true" />
		
		<cfif StructKeyExists(variables.contacts, arguments.id)>
			<cfreturn variables.contacts[arguments.id] />
		<cfelse>
			<cfthrow message="Contact with ID #arguments.id# does not exist." />
		</cfif>
	</cffunction>

	<cffunction name="getAllContacts" returntype="struct">
		<cfreturn variables.contacts />
	</cffunction>
</cfcomponent>