
<cfsilent>
	<cfset event.copyToScope( variables, "myself,Languagerecord,xe.list") />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
<cfoutput>
<div id="breadcrumb"><a href="#listEvent#"> Language</a> / View  Language</div>
<br />
<form class="edit"> 
<fieldset>
    
			<cf_scaffold_property_view name="LanguageName" label="Language Name" type="string"
				value="#LanguageRecord.getLanguageName()#" />
		
			<cf_scaffold_list name="Countries" label="Countries" 
				displayPropertyList="CountryCode^Country Code,CountryName^Country Name,SortSequence^Sort Sequence"
				primaryKeyList="CountryId"
				theList="#variables.ormAdapter.getChildCollection(LanguageRecord,'Countries')#"
				viewEvent="#myself#Country.View" editEvent="#myself#Country.Edit" deleteEvent="#myself#Country.Delete" />
		
</fieldset>
</form>
</cfoutput>
