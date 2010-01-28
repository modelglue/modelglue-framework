
<cfsilent>
	<cfset event.copyToScope( variables, "LanguageId,LanguageQuery,myself,xe.delete,xe.edit,xe.list,xe.view" )/>
	<cfset editEvent = myself & xe.edit />
</cfsilent>
<cfoutput>
<div id="breadcrumb"> Language / <a href="#editEvent#">Add New  Language</a></div>
<br />
<cf_scaffold_list displayPropertyList="LanguageName^Language Name" primaryKeyList="LanguageId" theList="#LanguageQuery#"
	viewEvent="#myself & xe.view#" editEvent="#editEvent#" deleteEvent="#myself & xe.delete#" />
</cfoutput>
