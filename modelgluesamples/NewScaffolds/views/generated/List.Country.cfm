
<cfsilent>
	<cfset event.copyToScope( variables, "CountryId,CountryQuery,myself,xe.delete,xe.edit,xe.list,xe.view" )/>
	<cfset editEvent = myself & xe.edit />
</cfsilent>
<cfoutput>
<div id="breadcrumb"> Country / <a href="#editEvent#">Add New  Country</a></div>
<br />
<cf_scaffold_list displayPropertyList="countrycode^Country Code,countryname^Country Name,sortsequence^Sort Sequence" primaryKeyList="CountryId" theList="#CountryQuery#"
	viewEvent="#myself & xe.view#" editEvent="#editEvent#" deleteEvent="#myself & xe.delete#" />
</cfoutput>
