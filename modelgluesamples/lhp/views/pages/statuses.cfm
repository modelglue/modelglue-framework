
<cfset event.setValue("title", "Statuses")>
<cfset statuses = event.getValue("statuses")>
<cfset root = event.getValue("myself")>
	

<h2 class="red">Statuses</h2>	
<p>
Use the form below to select a status to edit. You may also create or delete a status.
</p>

<cf_datatable data="#statuses#" queryString="event=#event.getValue(event.getValue("eventValue"))#" editlink="#root#page.status" deletelink="#root#action.statusdelete" label="Status" linkcol="name">
	<cf_datacol colname="name" label="Name" />
	<cf_datacol colname="rank" label="Rank" />
</cf_datatable>

