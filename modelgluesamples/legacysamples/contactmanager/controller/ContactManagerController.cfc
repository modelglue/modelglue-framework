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


<cfcomponent displayname="SampleController" output="false" hint="I am a sample model-glue controller." extends="ModelGlue.Core.Controller">

<cffunction name="Init" access="Public" returnType="ContactManagerController" output="false" hint="I build a new SampleController">
  <cfargument name="ModelGlue">
  <cfset super.Init(arguments.ModelGlue) />

  <!--- Since we're not really using a database, we treat our managers as stateful containers --->
  <cfset variables.ContactManager = createObject("component", "modelgluesamples.legacysamples.contactmanager.model.ContactManager") />
  <cfset variables.RecentContactsManager = createObject("component", "modelgluesamples.legacysamples.contactmanager.model.RecentContactsManager") />
  <cfreturn this />
</cffunction>

<!--- Message Listeners --->
<cffunction name="OnRequestStart" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

  <!--- This'll probably get used in more than one place. --->
  <cfset arguments.event.setValue("recentContacts", getRecentContactsManager().getRecentContacts()) />
  <cfreturn arguments.event />
</cffunction>

<cffunction name="OnRequestEnd" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  <cfreturn arguments.event />
</cffunction>

<cffunction name="ListContacts" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">
  <cfset arguments.event.setValue("contacts", GetContactManager().GetAllContacts()) />
  <cfreturn arguments.event />
</cffunction>

<cffunction name="GetContact" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

  <cfset var id = arguments.event.getValue("id") />

  <cfif len(id)>
    <cfset arguments.event.setValue("contact", GetContactManager().GetContact(id)) />
    <cfset arguments.event.addResult("success") />
  <cfelse>
    <cfset arguments.event.setValue("contact", GetContactManager().NewContact()) />
    <cfset arguments.event.addResult("success") />
  </cfif>


  <cfreturn arguments.event />
</cffunction>

<cffunction name="ShowContactForm" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

  <cfset var id = arguments.event.getValue("contact").getId() />

  <cfif len(id)>
    <cfset arguments.event.setValue("submitLabel", "Update Contact") />
  <cfelse>
    <cfset arguments.event.setValue("submitLabel", "Add Contact") />
  </cfif>

  <cfreturn arguments.event />
</cffunction>

<cffunction name="CommitContact" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

  <cfset var contact = GetContactManager().NewContact() />
  <cfset var validation = "" />

  <!--- The makeEventBean() feature (line 83) replaces all of this!
  <cfif len(arguments.event.getValue("id"))>
    <cfset contact.setId(arguments.event.getValue("id")) />
  </cfif>
  <cfset contact.setFirstname(arguments.event.getValue("firstname")) />
  <cfset contact.setLastname(arguments.event.getValue("lastname")) />
  <cfset contact.setStreet(arguments.event.getValue("street")) />
  <cfset contact.setCity(arguments.event.getValue("city")) />
  <cfset contact.setState(arguments.event.getValue("state")) />
  <cfset contact.setZip(arguments.event.getValue("zip")) />
	--->

	<!--- makeEventBean() can take either a type (e.g., "com.myBean") or an instance --->
	<!---
				Example using type:
	<cfset contact = arguments.event.makeEventBean("modelgluesamples.legacysamples.contactmanager.model.Contact", "id,firstname,lastname,street,city,state,zip") />
	--->
	<!---
				Example using instance:
	--->
	<cfset contact = arguments.event.makeEventBean(contact, "id,firstname,lastname,street,city,state,zip") />

  <cfset validation = GetContactManager().CommitContact(contact) />

  <cfif validation.hasErrors()>
    <cfset arguments.event.addResult("invalid") />
    <cfset arguments.event.setValue("contactValidation", validation.getErrors()) />
    <cfset arguments.event.setValue("contact", contact) />
  <cfelse>
    <cfset getRecentContactsManager().addRecentContact(contact) />
    <cfset arguments.event.addResult("success") />
  </cfif>

  <cfreturn arguments.event />
</cffunction>

<cffunction name="CancelEditContact" access="Public" returnType="ModelGlue.Core.Event" output="false" hint="I am an event handler.">
  <cfargument name="event" type="ModelGlue.Core.Event" required="true">

  <cflocation url="index.cfm?event=listContacts" addToken="no">
  <cfreturn arguments.event />
</cffunction>

	<!--- Util --->
	<cffunction name="GetContactManager" access="private">
		<cfreturn variables.ContactManager>
	</cffunction>

	<cffunction name="GetRecentContactsManager" access="private">
		<cfreturn variables.RecentContactsManager>
	</cffunction>
</cfcomponent>