<!---
LICENSE INFORMATION:

Copyright 2007, Joe Rinehart
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of Model-Glue Model-Glue: ColdFusion (2.0.304).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


    

<cfset listEvent = viewstate.getValue("myself") & viewstate.getValue("xe.list")  />
<cfset WidgetCategoryRecord = viewstate.getValue("WidgetCategoryRecord") />
<cfset keyString = "&WidgetCategoryId=#urlEncodedFormat(WidgetCategoryRecord.getWidgetCategoryId())#" />
<cfset commitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.commit") & keyString />
<cfset validation = viewstate.getValue("WidgetCategoryValidation", structNew()) />

<cfset isNew = true />
		

		<cfif (not isNumeric(WidgetCategoryRecord.getWidgetCategoryId()) and len(WidgetCategoryRecord.getWidgetCategoryId())) or (isNumeric(WidgetCategoryRecord.getWidgetCategoryId()) and WidgetCategoryRecord.getWidgetCategoryId())>
			<cfset isNew = false />
		</cfif>
	
		
<cfoutput>
<div id="breadcrumb">
		<a href="#listEvent#">Widget Categorys</a> / 
		<cfif isNew>
			Add New Widget Category
		<cfelse>
			#WidgetCategoryRecord.getname()#
		</cfif>
</div>
</cfoutput>
<br />


								
<cfform action="#commitEvent#" class="edit">
    
<fieldset>
    

    <cfoutput>
    <input type="hidden" name="WidgetCategoryId" value="#WidgetCategoryRecord.getWidgetCategoryId()#" />
    </cfoutput>
  
        <div class="formfield">
	        <label for="name" <cfif structKeyExists(validation, "name")>class="error"</cfif>><b>Name:</b></label>
	        <div>
					
		        <cfinput 
									type="text" 
									class="input" 
									maxLength="50" 
									id="name" 
									name="name" 
									
										value="#WidgetCategoryRecord.getname()#" 
									
						/>
		      
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="name" validation="#validation#" />
        </div>
    
        <div class="formfield">
        	<label <cfif structKeyExists(validation, "Widget")>class="error"</cfif>><b>Widget(s):</b></label>
          <cfset valueQuery = viewstate.getValue("WidgetList") />
				

					<cfif viewstate.exists("Widget|widgetId")>
						<cfset selectedList = viewstate.getValue("Widget|widgetId")/>
					<cfelse>
						<!--- This XSL supports both Reactor and Transfer --->
						<cfif structKeyExists(WidgetCategoryRecord, "getWidgetStruct")>
							<cfset selected = WidgetCategoryRecord.getWidgetStruct() />
						<cfelseif structKeyExists(WidgetCategoryRecord, "getWidgetArray")>
							<cfset selected = WidgetCategoryRecord.getWidgetArray() />
						<cfelse>
							<cfset selected = WidgetCategoryRecord.getWidgetIterator().getQuery() />
						</cfif>

						<cfif isQuery(selected)>
							<cfset selectedList = valueList(selected.widgetId) />
						<cfelseif isStruct(selected)>
							<cfset selectedList = structKeyList(selected)>
						<cfelseif isArray(selected)>
							<cfset selectedList = "" />
							<cfloop from="1" to="#arrayLen(selected)#" index="i">
								<cfset selectedList = listAppend(selectedList, selected[i].getwidgetId()) />
							</cfloop>
						</cfif>
					</cfif>
				            
          <!--- 
            hidden makes the field always defined.  if this wasn't here, and you deleted this whole field
            from the control, you'd wind up deleting all child records during a genericCommit...
          --->
          <input type="hidden" name="Widget|widgetId" value="" />
	        <div class="formfieldinputstack">
          <cfoutput query="valueQuery">
            <label for="Widget_#valueQuery.widgetId#"><input type="checkbox" name="Widget|widgetId" id="Widget_#valueQuery.widgetId#" value="#valueQuery.widgetId#"<cfif listFindNoCase(selectedList, "#valueQuery.widgetId#")> checked</cfif>/>#valueQuery.name#</label><br />
          </cfoutput>
	        </div>
        </div>
          
      
<cfoutput>
<div class="controls">
 	<input type="submit" value="Save" />
  <input type="button" value="Cancel" onclick="document.location.replace('#listEvent#')" />
</div>
</cfoutput>
</fieldset>
</cfform>
    
	
