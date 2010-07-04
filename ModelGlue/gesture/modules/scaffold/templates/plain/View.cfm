
<<cfoutput>>
<cfsilent>
	<cfset event.copyToScope( variables, "myself,%Metadata.alias%record,xe.list") />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
<cfoutput>
<div id="breadcrumb"><a href="#listEvent#">%spaceCap( Metadata.alias )%</a> / View %spaceCap( Metadata.alias )%</div>
<br />
<form class="edit"> 
<fieldset>
    <<cfloop list="%Metadata.orderedPropertyList%"  index="thisProp">>
		<<cfif %isDisplayProperty(thisProp,Metadata)%>>
			<mg:scaffold_property_view name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
				value="#%Metadata.alias%Record.get%thisProp%()#" />
		<<cfelseif Metadata.properties[thisProp].relationshiptype IS "many-to-one">>
			<mg:scaffold_property_view name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
				value="#variables.ormAdapter.getSourceValue(%Metadata.alias%Record,'%Metadata.properties[thisProp].alias%','%Metadata.properties[thisProp].sourcecolumn%')#" />
		<<cfelseif Metadata.properties[thisProp].relationshiptype IS "one-to-one">>
			<<!--- do a one-to-one --->>
			<<cfset otoMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
			<<cfset otoMetadata.primaryKeyList = arrayToList(otoMetadata.primaryKeys) />>
			<<cfset otoMetadata.alias = thisProp />>
			<cfset %otoMetadata.alias%Record = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%() />
		    <<cfloop list="%otoMetadata.orderedPropertyList%"  index="otoProp">>
				<<cfif %isDisplayProperty(otoProp,otoMetadata)%>>
					<mg:scaffold_property_view name="%otoProp%" label="%otoMetadata.properties[otoProp].label%" type="%otoMetadata.properties[otoProp].cfdatatype%"
						value="#%otoMetadata.alias%Record.get%otoProp%()#" />
				<<cfelseif otoMetadata.properties[otoProp].relationshiptype IS "many-to-one">>
					<mg:scaffold_property_view name="%otoProp%" label="%otoMetadata.properties[otoProp].label%" type="%otoMetadata.properties[otoProp].cfdatatype%"
						value="#variables.ormAdapter.getSourceValue(%otoMetadata.alias%Record,'%otoMetadata.properties[otoProp].alias%','%otoMetadata.properties[otoProp].sourcecolumn%')#" />
				<<cfelseif otoMetadata.properties[otoProp].relationshiptype IS "one-to-one">>
					<<!--- its a one-to-one - skip it --->>
				<<cfelseif otoMetadata.properties[otoProp].relationship IS true AND otoMetadata.properties[otoProp].pluralrelationship IS true >>
					<<cfset childotoMetadata = %findOrmAdapter().getObjectotoMetadata(otoMetadata.properties[otoProp].sourceObject)% />>
					<<cfset childotoMetadata.primaryKeyList = arrayToList(childotoMetadata.primaryKeys) />>
					<mg:scaffold_list name="%otoProp%" label="%otoMetadata.properties[otoProp].label%" 
						displayPropertyList="%getDisplayPropertyList(structKeyList(childotoMetadata.properties),childotoMetadata)%"
						primaryKeyList="%childotoMetadata.primaryKeyList%"
						theList="#variables.ormAdapter.getChildCollection(%otoMetadata.alias%Record,'%otoProp%')#"
						viewEvent="#myself#%otoMetadata.properties[otoProp].sourceObject%.View" editEvent="#myself#%otoMetadata.properties[otoProp].sourceObject%.Edit" deleteEvent="#myself#%otoMetadata.properties[otoProp].sourceObject%.Delete"
						record="#%otoMetadata.alias%Record#" parentPKList="%otoMetadata.primarykeylist%" />
				<</cfif>>  
			<</cfloop>>
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS true >>
			<<cfset childMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
			<<cfset childMetadata.primaryKeyList = arrayToList(childMetadata.primaryKeys) />>
			<mg:scaffold_list name="%thisProp%" label="%Metadata.properties[thisProp].label%" 
				displayPropertyList="%getDisplayPropertyList(structKeyList(childMetadata.properties),childMetadata)%"
				primaryKeyList="%childMetadata.primaryKeyList%"
				theList="#variables.ormAdapter.getChildCollection(%Metadata.alias%Record,'%thisProp%')#"
				viewEvent="#myself#%Metadata.properties[thisProp].sourceObject%.View" editEvent="#myself#%Metadata.properties[thisProp].sourceObject%.Edit" deleteEvent="#myself#%Metadata.properties[thisProp].sourceObject%.Delete"
				record="#%Metadata.alias%Record#" parentPKList="%Metadata.primarykeylist%" />
		<</cfif>>  
	<</cfloop>>
</fieldset>
</form>
</cfoutput>
<</cfoutput>>
