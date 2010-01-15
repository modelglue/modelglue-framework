<cfcomponent extends="ModelGlue.gesture.modules.scaffold.beans.AbstractScaffold" output="false" hint="I am used whever type=""edit"" is used in a scaffold tag.">

<cffunction name="makeModelGlueXMLFragment" output="false" access="public" returntype="string" hint="I make an instance of a modelglue xml fragment for this event">
	<cfargument name="advice" type="struct" required="true"/>
	<cfargument name="alias" type="string" required="true"/>
	<cfargument name="class" type="string" required="true"/>
	<cfargument name="eventtype" type="string" required="true"/>
	<cfargument name="orderedpropertylist" type="string" required="true"/>
	<cfargument name="prefix" type="string" required="true"/>
	<cfargument name="primarykeylist" type="string" required="true"/>
	<cfargument name="properties" type="struct" required="true"/>
	<cfargument name="propertylist" type="string" required="true"/>
	<cfargument name="suffix" type="string" required="true"/>
	
	<cfset var relationshipMessages = "" />
	<cfset var thisProp = "" />
	<cfset var knownRelationships = "" />
	<cfset var xml = "" />
	
	<cfloop collection="#arguments.properties#" item="thisProp">
		<cfif arguments.properties[thisProp].relationship IS true AND listfind( knownRelationships, thisProp ) IS false>
			<cfset relationshipMessages = '#relationshipMessages#
				<message name="ModelGlue.genericList">
					<argument name="object" value="#arguments.properties[thisProp].sourceObject#" />
					<argument name="queryName" value="#arguments.properties[thisProp].sourceObject#List" />
					<argument name="criteria" value="" />
				</message>'>
		<cfset knownRelationships = listAppend(knownRelationships, thisProp) />
		</cfif>
	</cfloop>
	
	<cfset xml = '
		<event-handler name="#arguments.alias#.Edit" access="public"' />
	
	<cfif len(arguments.eventtype)>
		<cfset xml = xml & ' type="#arguments.eventtype#"' />
	</cfif>
	
	<cfset xml = xml & '>
			<broadcasts>
				<message name="ModelGlue.genericRead">
					<argument name="criteria" value="#arguments.primaryKeyList#" />
					<argument name="object" value="#arguments.alias#" />
					<argument name="recordName" value="#arguments.alias#Record" />
				</message>#relationshipMessages#
			</broadcasts>
			<views>
				<view name="body" template="#arguments.prefix##arguments.alias##arguments.suffix#" append="true">
					<value name="xe.commit" value="#arguments.alias#.Commit" overwrite="true" />
					<value name="xe.list" value="#arguments.alias#.List" overwrite="true" />
				</view>
			</views>
			<results>
			</results>
		</event-handler>
'>
	
	<cfreturn xml />
</cffunction>	

<cffunction name="loadViewTemplate" output="false" access="public" returntype="string" hint="I load the CFtemplate formatted representation for this view">
	<!--- Each of these parameters is also available for the second pass of generation under the metadata scope, 
			On the First Pass, use #arguments#
			On the Second Pass use %metadata.advice% 
			--->
	<cfargument name="advice" type="struct" required="true"/>
	<cfargument name="alias" type="string" required="true"/>
	<cfargument name="class" type="string" required="true"/>
	<cfargument name="orderedpropertylist" type="string" required="true"/>
	<cfargument name="prefix" type="string" required="true"/>
	<cfargument name="primarykeylist" type="string" required="true"/>
	<cfargument name="properties" type="struct" required="true"/>
	<cfargument name="propertylist" type="string" required="true"/>
	<cfargument name="suffix" type="string" required="true"/> 
	<cfset var copyToScopeList = listSort(listAppend("myself,#arguments.alias#Record,xe.commit,xe.edit,xe.list", arguments.primaryKeyList ),  "textnocase" ) />
	<cfreturn  ('<cfsilent>
<<cfoutput>>
	<cfset event.copyToScope( variables, "#copyToScopeList#" )/>
	<cfset variables.commitEvent = "##myself####xe.commit##%makeBeanSourcedPrimaryKeyURLString( Metadata.alias, Metadata.primaryKeyList )%" />
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
</cfsilent>
	
<cfoutput>
<div id="breadcrumb">
	<a href="##listEvent##">%spaceCap( Metadata.alias )%</a> / <cfif isNew>Add New<cfelse>Edit</cfif> %spaceCap( Metadata.alias )%
</div>
<cfif hasErrors IS true>
<h2>Submission Errors</h2>
<ul>
	<cfloop collection="##validation##" item="variables.field">
	<li>##arrayToList(validation[field])##</li>
	</cfloop>
</ul>
</cfif>
<br />
<cfform action="##commitEvent##" class="edit">
<table>
%makePrimaryKeyHiddenFields( Metadata.alias, Metadata.primaryKeyList )%
    <<cfloop list="%Metadata.orderedPropertyList%"  index="variables.thisProp">>
		<<cfif listFindNoCase( Metadata.primaryKeyList, thisProp ) IS false AND Metadata.properties[thisProp].relationship IS false >>
			<tr>	
        		<td><label for="%thisProp%">%spaceCap( thisProp )%</label>	</td>
				<td>
			<<cfif Metadata.properties[thisProp].cfdatatype IS "boolean">>
					<input type="radio" id="%thisProp%_true" name="%thisProp%" value="true"  <cfif isBoolean(%Metadata.alias%Record.get%thisProp%()) and %Metadata.alias%Record.get%thisProp%() IS true>checked</cfif>/>
					<label for="%thisProp%_true"> Yes</label>
	        		<input type="radio" id="%thisProp%_false" name="%thisProp%" value="false" <cfif isBoolean(%Metadata.alias%Record.get%thisProp%()) and %Metadata.alias%Record.get%thisProp%() IS false>checked</cfif>/>
					<label for="%thisProp%_false"> No</label>		
			<<cfelseif Metadata.properties[thisProp].length LTE 65535>>
					<input type="text" class="input" id="%thisProp%" name="%thisProp%" value="<<cfif Metadata.properties[thisProp].cfdatatype IS  "date">>##dateFormat( %Metadata.alias%Record.get%thisProp%(), "m/d/yyyy")## ##timeFormat(%Metadata.alias%Record.get%thisProp%(), "h:mm TT")##<<cfelse>>##%Metadata.alias%Record.get%thisProp%()##<</cfif>>">
			<<cfelseif Metadata.properties[thisProp].length GT 65535>>
					<textarea class="input" id="%thisProp%" name="%thisProp%">##%Metadata.alias%Record.get%thisProp%()##</textarea>
			<</cfif>>
				</td>
			</tr>
		<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS false >>
			<tr>	
        		<td>
	        		<label for="%Metadata.properties[thisProp].name%" <cfif structKeyExists(validation, "%Metadata.properties[thisProp].alias%")>class="error"</cfif><b>%Metadata.properties[thisProp].label%:</b></label>
	        	</td>
	        	<td>
	        <cfset variables.valueQuery = event.getValue("%Metadata.properties[thisProp].sourceobject%List") />
			<cfset variables.sourceValue = "" />
						<cftry>
							<cfif structKeyExists(%Metadata.alias%Record, "get%Metadata.properties[thisProp].alias%")>
								<cfset variables.sourceValue = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%() />
							<cfelseif structKeyExists(%Metadata.alias%Record, "getParent%Metadata.properties[thisProp].alias%")>
								<cfset variables.sourceValue = %Metadata.alias%Record.getParent%Metadata.properties[thisProp].alias%() />
							</cfif>
							<cfcatch>
							</cfcatch>
						</cftry>
				
						<cfif isObject(variables.sourceValue)>
							<cfset variables.sourceValue = sourceValue.get%Metadata.properties[thisProp].sourcekey%() />
						</cfif>
	
          <select name="%Metadata.properties[thisProp].name%" id="%Metadata.properties[thisProp].name%" >
            <<cfif %Metadata.properties[thisProp].nullable% IS true OR %Metadata.properties[thisProp].nullable% IS 1>>
			  <option value=""></option>
			 <</cfif>>
            <cfloop query="valueQuery">
              <option value="##valueQuery.%Metadata.properties[thisProp].sourcekey%##"<cfif sourceValue eq valueQuery.%Metadata.properties[thisProp].sourcekey%> selected</cfif> >##valueQuery.%Metadata.properties[thisProp].sourcecolumn%##</option>
            </cfloop>
          </select>
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="%Metadata.alias%" validation="##validation##" />
        </div>
			</td>
		</tr>
	<<cfelseif Metadata.properties[thisProp].relationship IS true AND Metadata.properties[thisProp].pluralrelationship IS true >>
		<tr>	
        	<td>
	        	<label <cfif structKeyExists(validation, "%Metadata.properties[thisProp].alias%")>class="error"</cfif>><b>%Metadata.properties[thisProp].label%(s):</b></label>
	        </td>
	        <td>  
			<cfset variables.valueQuery = event.getValue("%Metadata.properties[thisProp].sourceobject%List") />
			
			<cfif event.exists("%Metadata.properties[thisProp].alias%|%Metadata.properties[thisProp].sourcekey%")>
				<cfset variables.selectedList = event.getValue("%Metadata.properties[thisProp].alias%|%Metadata.properties[thisProp].sourcekey%")/>
			<cfelse>
				<!--- This should support both transfer and reactor. Add more ORM specific stuff here --->
				<cfif structKeyExists(%Metadata.alias%Record, "get%Metadata.properties[thisProp].alias%Struct")>
					<cfset variables.selected = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%Struct() />
				<cfelseif structKeyExists(%Metadata.alias%Record, "get%Metadata.properties[thisProp].alias%Array")>
					<cfset variables.selected = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%Array() />
				<cfelse>
					<cfset variables.selected = %Metadata.alias%Record.get%Metadata.properties[thisProp].alias%Iterator().getQuery() />
				</cfif>

				<cfif isQuery(variables.selected)>
					<cfset variables.selectedList = valueList(selected.%Metadata.properties[thisProp].sourcekey%) />
				<cfelseif isStruct(variables.selected)>
					<cfset variables.selectedList = structKeyList(selected)>
				<cfelseif isArray(variables.selected)>
					<cfset variables.selectedList = "" />
					<cfloop from="1" to="##arrayLen(variables.selected)##" index="variables.i">
						<cfset variables.selectedList = listAppend(variables.selectedList, variables.selected[variables.i].get%Metadata.properties[thisProp].sourcekey%()) />
					</cfloop>
				</cfif>
			</cfif>
				            	
          <!--- 
            hidden makes the field always defined.  if this was not here, and you deleted this whole field
            from the control, you would wind up deleting all child records during a genericCommit...
          --->
          <input type="hidden" id="%Metadata.properties[thisProp].alias%|%Metadata.properties[thisProp].sourcekey%" name="%Metadata.properties[thisProp].alias%|%Metadata.properties[thisProp].sourcekey%" value="" />
	        <div class="formfieldinputstack">
          <cfloop query="valueQuery">
            <label for="%Metadata.properties[thisProp].alias%_##valueQuery.%Metadata.properties[thisProp].sourcekey%##"><input type="checkbox" name="%Metadata.properties[thisProp].alias%|%Metadata.properties[thisProp].sourcekey%" id="%Metadata.properties[thisProp].alias%_##valueQuery.%Metadata.properties[thisProp].sourcekey%##" value="##valueQuery.%Metadata.properties[thisProp].sourcekey%##"<cfif listFindNoCase(selectedList, "##valueQuery.%Metadata.properties[thisProp].sourcekey%##")> checked</cfif>/>##valueQuery.%Metadata.properties[thisProp].sourcecolumn%##</label><br />
		 </cfloop>
	        </div>
        </div>
        	</td>
		</tr>
		<</cfif>>  
	<</cfloop>>
		<tr>
			<td colspan="2"><input type="submit" name="submit" value=" Save %Metadata.alias% "></td>
		</tr>
</table>
</cfform>
</cfoutput>
<</cfoutput>>
')>	
</cffunction>

</cfcomponent>
