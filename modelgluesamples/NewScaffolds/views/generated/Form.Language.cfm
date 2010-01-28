<cfsilent>

	<cfimport taglib="/views/customtags/forms/cfUniForm/" prefix="uform" />
	<cfset event.copyToScope( variables, "CFUniformConfig,LanguageId,LanguageRecord,myself,xe.commit,xe.edit,xe.list" )/>
	<cfset variables.commitEvent = "#myself##xe.commit#" />
	<cfset variables.editEvent = myself & xe.edit  />
	<cfset variables.listEvent = myself & xe.list  />
	<cfset variables.hasErrors = false />
	<cfset variables.validation = event.getValue("LanguageValidation", structNew() ) />
	<cfset variables.isNew = true />
	<cfif NOT structIsEmpty( validation ) >
		<cfset variables.hasErrors = true />
	</cfif>	
	<cfif  len( trim(LanguageRecord.getLanguageId()) ) >
		<cfset variables.isNew = false />
	</cfif>
	<cfset variables.ormAdapter = event.getModelGlue().getOrmAdapter() />
</cfsilent>
	
<cfoutput>
<div id="breadcrumb">
	<a href="#listEvent#"> Language</a> / <cfif isNew>Add New<cfelse>Edit</cfif>  Language
</div>
<cfif hasErrors IS true>
<h2>Submission Errors</h2>
<ul>
	<cfloop collection="#validation#" item="variables.field">
	<li>#arrayToList(validation[field])#</li>
	</cfloop>
</ul>
</cfif>
<br />
<div class="cfUniForm-form-container">
	<uform:form action="#commitEvent#" id="frmMain" config="#CFUniformConfig#" submitValue=" Save Language ">
	
				<cfif event.valueExists("LanguageId")>
					<input type="hidden" name="LanguageId" value="#LanguageRecord.getLanguageId()#">
				</cfif>
		<uform:fieldset legend="">
		    
					<cf_scaffold_property name="LanguageName" label="Language Name" type="string"
						value="#LanguageRecord.getLanguageName()#" length="1" />
				
				<cf_scaffold_manytomany name="CountryId" label="Countries"
					valueQuery="#event.getValue('CountryList')#"
					selectedList="#variables.ormAdapter.getSelectedList(event,LanguageRecord,'Countries','CountryId')#"
					childDescProperty="CountryCode"
					value="#variables.ormAdapter.getSourceValue(event,LanguageRecord,'Countries','CountryId')#"
					nullable="YES" objectName="Language" />
				
		</uform:fieldset>
	</uform:form>
</div>
</cfoutput>

