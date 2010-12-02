<<cfoutput>>
<cfsilent>
	<cfset event.copyToScope( variables, "myself,%Metadata.alias%Query,xe.delete,xe.edit,xe.list,xe.view,%Metadata.primaryKeyList%" )/>
	<cfset editEvent = myself & xe.edit />
</cfsilent>
<cfoutput>
<div id="breadcrumb">%spaceCap( Metadata.alias )% / <a href="#editEvent#">Add New %spaceCap( Metadata.alias )%</a></div>
<br />
<mg:scaffold_list name="%Metadata.alias%" displayPropertyList="%getDisplayPropertyList(Metadata.orderedpropertylist,Metadata)%" primaryKeyList="%Metadata.primaryKeyList%" theList="#%Metadata.alias%Query#"
	viewEvent="#myself & xe.view#" editEvent="#editEvent#" deleteEvent="#myself & xe.delete#" />
</cfoutput>
<</cfoutput>>
