
<cfsilent>
<<cfoutput>>
	<cfset event.copyToScope( variables, "myself,%Metadata.alias%Record,xe.commit,xe.edit,xe.list,%Metadata.primaryKeyList%" )/>
	<cfset variables.commitEvent = myself & xe.commit />
	<cfset variables.editEvent = myself & xe.edit  />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.hasErrors = false />
	<cfset variables.validation = event.getValue("%Metadata.alias%Validation", structNew() ) />
	<cfset variables.isNew = true />
	<cfif NOT structIsEmpty( validation ) >
		<cfset variables.hasErrors = true />
	</cfif>	
	<cfif  %makePrimaryKeyCheckForIsNew( Metadata.alias, Metadata.primaryKeyList )% >
		<cfset variables.isNew = false />
	</cfif>
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
	
<cfoutput>
<div id="breadcrumb">
	<a href="#listEvent#">%spaceCap( Metadata.alias )%</a> / <cfif isNew>Add New<cfelse>Edit</cfif> %spaceCap( Metadata.alias )%
</div>
<cfif hasErrors IS true>
<h2>Submission Errors</h2>
<ul>
	<cfloop collection="#validation#" item="variables.field">
	<li>##arrayToList(validation[field])##</li>
	</cfloop>
</ul>
</cfif>
<br />
<form action="#commitEvent#" method="post" class="edit">
<fieldset>
	%makePrimaryKeyHiddenFields( Metadata.alias, Metadata.primaryKeyList )%
    <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>

		<<cfif %isDisplayProperty(thisProp,Metadata)%>>
			<mg:scaffold_property name="%thisProp%" label="%Metadata.properties[thisProp].label%" type="%Metadata.properties[thisProp].cfdatatype%"
				value="#%Metadata.alias%Record.get%thisProp%()#" length="%Metadata.properties[thisProp].length%" event="#event#" />

		<<cfelseif Metadata.properties[thisProp].relationshiptype IS "many-to-one" >>
			<mg:scaffold_manytoone name="%Metadata.properties[thisProp].sourceKey%" label="%Metadata.properties[thisProp].label%"
				valueQuery="#event.getValue('%Metadata.properties[thisProp].sourceobject%List')#"
				childDescProperty="%Metadata.properties[thisProp].sourcecolumn%"
				value="#variables.ormAdapter.getSourceValue(%Metadata.alias%Record,'%Metadata.properties[thisProp].alias%','%Metadata.properties[thisProp].sourcekey%',event)#"
				nullable="%getIsNullable(Metadata.properties[thisProp])%" objectName="%Metadata.alias%" validation="#validation#" />

		<<cfelseif Metadata.properties[thisProp].relationshiptype IS "one-to-one">>
			<<!--- do a one-to-one --->>
			<<cfset otoMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
			<<cfset otoMetadata.primaryKeyList = arrayToList(otoMetadata.primaryKeys) />>
			<<cfset otoMetadata.alias = thisProp />>
			<cfset %otoMetadata.alias%Record = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%() />
		    <<cfloop list="%otoMetadata.orderedPropertyList%"  index="otoProp">>
				<<cfif %isDisplayProperty(otoProp,otoMetadata)%>>
					<mg:scaffold_property name="%otoProp%" label="%Metadata.properties[otoProp].label%" type="%Metadata.properties[otoProp].cfdatatype%"
						value="#%Metadata.alias%Record.get%otoProp%()#" length="%Metadata.properties[otoProp].length%" event="#event#" />
				<<cfelseif otoMetadata.properties[otoProp].relationshiptype IS "many-to-one">>
					<mg:scaffold_manytoone name="%otoMetadata.properties[otoProp].sourceKey%" label="%otoMetadata.properties[otoProp].label%"
						valueQuery="#event.getValue('%otoMetadata.properties[otoProp].sourceobject%List')#"
						childDescProperty="%otoMetadata.properties[otoProp].sourcecolumn%"
						value="#variables.ormAdapter.getSourceValue(%otoMetadata.alias%Record,'%otoMetadata.properties[otoProp].alias%','%otoMetadata.properties[otoProp].sourcekey%',event)#"
						nullable="%getIsNullable(otoMetadata.properties[otoProp])%" objectName="%otoMetadata.alias%" validation="#validation#" />
				<<cfelseif otoMetadata.properties[otoProp].relationshiptype IS "one-to-one">>
					<<!--- its a one-to-one - skip it --->>
				<<cfelseif otoMetadata.properties[otoProp].relationship IS true AND otoMetadata.properties[otoProp].pluralrelationship IS true >>
					<<!--- this is for one-to-many and many-to-many - *** todo ***
					<<cfset childotoMetadata = %findOrmAdapter().getObjectotoMetadata(otoMetadata.properties[otoProp].sourceObject)% />>
					<<cfset childotoMetadata.primaryKeyList = arrayToList(childotoMetadata.primaryKeys) />>
					<mg:scaffold_list name="%otoProp%" label="%otoMetadata.properties[otoProp].label%" 
						displayPropertyList="%getDisplayPropertyList(structKeyList(childotoMetadata.properties),childotoMetadata)%"
						primaryKeyList="%childotoMetadata.primaryKeyList%"
						theList="#variables.ormAdapter.getChildCollection(%otoMetadata.alias%Record,'%otoProp%')#"
						viewEvent="#myself#%otoMetadata.properties[otoProp].sourceObject%.View" editEvent="#myself#%otoMetadata.properties[otoProp].sourceObject%.Edit" deleteEvent="#myself#%otoMetadata.properties[otoProp].sourceObject%.Delete"
						record="#%otoMetadata.alias%Record#" parentPKList="%otoMetadata.primarykeylist%" />
					--->>
				<</cfif>>  
			<</cfloop>>

		<<cfelseif Metadata.properties[thisProp].relationshiptype IS "one-to-many" >>
			<<cfset childMetadata = %findOrmAdapter().getObjectMetadata(Metadata.properties[thisProp].sourceObject)% />>
			<<cfset childMetadata.primaryKeyList = arrayToList(childMetadata.primaryKeys) />>
			<mg:scaffold_list name="%thisProp%" label="%Metadata.properties[thisProp].label%" 
				displayPropertyList="%getDisplayPropertyList(structKeyList(childMetadata.properties),childMetadata)%"
				primaryKeyList="%childMetadata.primaryKeyList%"
				theList="#variables.ormAdapter.getChildCollection(%Metadata.alias%Record,'%thisProp%')#"
				viewEvent="#myself#%Metadata.properties[thisProp].sourceObject%.View" editEvent="#myself#%Metadata.properties[thisProp].sourceObject%.Edit" deleteEvent="#myself#%Metadata.properties[thisProp].sourceObject%.Delete"
				record="#%Metadata.alias%Record#" parentPKList="%Metadata.primarykeylist%" onEditForm="true" />

		<<cfelseif Metadata.properties[thisProp].relationshiptype IS "many-to-many" >>
			<mg:scaffold_manytomany name="%Metadata.properties[thisProp].sourceKey%" label="%Metadata.properties[thisProp].label%"
				valueQuery="#event.getValue('%Metadata.properties[thisProp].sourceobject%List')#"
				selectedList="#variables.ormAdapter.getSelectedList(event,%Metadata.alias%Record,'%thisProp%','%Metadata.properties[thisProp].sourceKey%')#"
				childDescProperty="%Metadata.properties[thisProp].sourcecolumn%"
				objectName="%Metadata.alias%" />
		<</cfif>>  
	<</cfloop>>
	<div class="formfield">
		<input type="submit" name="submit" value=" Save %Metadata.alias% ">
	</div>
</fieldset>
</form>
</cfoutput>

<</cfoutput>>
