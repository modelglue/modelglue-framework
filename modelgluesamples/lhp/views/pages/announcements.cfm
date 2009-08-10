<cfset event.setValue("title", "Announcements")>
<cfset announcements = event.getValue("announcements")>
<cfset root = event.getValue("myself")>

<cfoutput>
<h2 class="red">Announcements</h2>
<p>
Use the form below to select an announcement to edit. You may also create or delete an announcement.
</p>
</cfoutput>

<cf_datatable data="#announcements#" queryString="event=#event.getValue(event.getValue("eventValue"))#" editlink="#root#page.announcement" deletelink="#root#action.announcementdelete" label="Announcement" linkcol="title">
	<cf_datacol colname="title" label="Title" />
	<cf_datacol colname="posted" label="Posted" format="datetime"/>
</cf_datatable>

