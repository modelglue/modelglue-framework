
<cfset event.setValue("title", "Issue Types")>
<cfset issuetypes = event.getValue("issuetypes")>
<cfset root = event.getValue("myself")>
	

<h2 class="red">Issue Types</h2>
<p>
Use the form below to select an issue type to edit. You may also create or delete an issue status.
</p>

<cf_datatable data="#issuetypes#" queryString="event=#event.getValue(event.getValue("eventValue"))#" editlink="#root#page.issuetype" deletelink="#root#action.issuetypedelete" label="Issue Type" linkcol="name">
	<cf_datacol colname="name" label="name" />
</cf_datatable>

