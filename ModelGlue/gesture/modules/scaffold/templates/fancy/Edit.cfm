<!---
LICENSE INFORMATION:

Copyright 2011, Joe Rinehart, Dan Wilson

Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of @versionLabel@ (@versionNumber@).

The version number in parentheses is in the format versionNumber.subversion.revisionNumber.

If the version number appears as 'versionNumber' surrounded by @ symbols
then this file is a working copy and not part of a release build.
--->


<cfsilent>
<<cfoutput>>
	<cfset event.copyToScope( variables, "myself,%Metadata.alias%Record,CFUniformConfig,xe.commit,xe.edit,xe.list,%Metadata.primaryKeyList%" )/>
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
	
	<cfset event.addCSSAssetFile( "ui/css/smoothness/jquery-ui-1.8.custom.css" ) />
	<cfset event.addCSSAssetFile( "multiSelect/css/jquery.multiselect.css" ) />
	<cfset event.addCSSAssetFile( "scaffold/css/edit.css" ) />
	
	<cfset event.addJSAssetFile( "core/jquery-1.4.2.min.js" ) />
	<cfset event.addJSAssetFile( "ui/js/jquery-ui-1.8.custom.min.js" ) />
	<cfset event.addJSAssetFile( "multiSelect/js/jquery.multiselect.min.js" ) />
	<cfset event.addJSAssetFile( "scaffold/js/edit.js" ) />
</cfsilent>
	
<cfoutput>
<div id="breadcrumb">
	<a href="#listEvent#">%spaceCap( Metadata.alias )%</a> / <cfif isNew>Add New<cfelse>Edit</cfif> %spaceCap( Metadata.alias )%
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
	<uform:form action="#commitEvent#" id="frmMain" attributecollection="#CFUniformConfig#" submitValue=" Save %Metadata.alias% " cssLoadVar="uformCSS" jsLoadVar="uformJS">
	%makePrimaryKeyHiddenFields( Metadata.alias, Metadata.primaryKeyList )%
		<uform:fieldset legend="">
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
		</uform:fieldset>
	</uform:form>
	
	<cfset event.addCSSAssetCode( uformCSS ) />
	<cfset event.addJSAssetCode( uformJS ) />
</div>
</cfoutput>

<</cfoutput>>
