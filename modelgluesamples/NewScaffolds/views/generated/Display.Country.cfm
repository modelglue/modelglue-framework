
<cfsilent>
	<cfset event.copyToScope( variables, "myself,Countryrecord,xe.list") />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
<cfoutput>
<div id="breadcrumb"><a href="#listEvent#"> Country</a> / View  Country</div>
<br />
<form class="edit"> 
<fieldset>
    
			<cf_scaffold_property_view name="countrycode" label="Country Code" type="string"
				value="#CountryRecord.getcountrycode()#" />
		
			<cf_scaffold_property_view name="countryname" label="Country Name" type="string"
				value="#CountryRecord.getcountryname()#" />
		
			<cf_scaffold_property_view name="sortsequence" label="Sort Sequence" type="numeric"
				value="#CountryRecord.getsortsequence()#" />
		
			<cf_scaffold_list name="provinces" label="Provinces" 
				displayPropertyList="ProvinceName^Province Name,SortSequence^Sort Sequence"
				primaryKeyList="ProvinceId"
				theList="#variables.ormAdapter.getChildCollection(CountryRecord,'provinces')#"
				viewEvent="#myself#Province.View" editEvent="#myself#Province.Edit" deleteEvent="#myself#Province.Delete" />
		
			<cf_scaffold_list name="languages" label="Languages" 
				displayPropertyList="LanguageName^Language Name"
				primaryKeyList="LanguageId"
				theList="#variables.ormAdapter.getChildCollection(CountryRecord,'languages')#"
				viewEvent="#myself#Language.View" editEvent="#myself#Language.Edit" deleteEvent="#myself#Language.Delete" />
		
</fieldset>
</form>
</cfoutput>
