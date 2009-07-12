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
<cfset WidgetRecord = viewstate.getValue("WidgetRecord") />
<cfset keyString = "&widgetId=#urlEncodedFormat(WidgetRecord.getwidgetId())#" />
<cfset commitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.commit") & keyString />
<cfset validation = viewstate.getValue("WidgetValidation", structNew()) />

<cfset isNew = true />
		

		<cfif (not isNumeric(WidgetRecord.getwidgetId()) and len(WidgetRecord.getwidgetId())) or (isNumeric(WidgetRecord.getwidgetId()) and WidgetRecord.getwidgetId())>
			<cfset isNew = false />
		</cfif>
	
		
<cfoutput>
<div id="breadcrumb">
		<a href="#listEvent#">Widgets</a> / 
		<cfif isNew>
			Add New Widget
		<cfelse>
			#WidgetRecord.getname()#
		</cfif>
</div>
</cfoutput>
<br />


								
<cfform action="#commitEvent#" class="edit">
    
<fieldset>
    

    <cfoutput>
    <input type="hidden" name="widgetId" value="#WidgetRecord.getwidgetId()#" />
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
									
										value="#WidgetRecord.getname()#" 
									
						/>
		      
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="name" validation="#validation#" />
        </div>
    
        <div class="formfield">
	        <label for="widgetTypeId" <cfif structKeyExists(validation, "WidgetType")>class="error"</cfif>><b>Widget Type:</b>
	        </label>
	        <cfset valueQuery = viewstate.getValue("WidgetTypeList") />
	        <div>
        
						<cfset sourceValue = "" />

						<cftry>
							<cfif structKeyExists(WidgetRecord, "getwidgetTypeId")>
								<cfset sourceValue = WidgetRecord.getwidgetTypeId() />
							<cfelseif structKeyExists(WidgetRecord, "getParentwidgetTypeId")>
								<cfset sourceValue = WidgetRecord.getParentwidgetTypeId() />
							</cfif>
							<cfcatch>
							</cfcatch>
						</cftry>
				
						<cfif isObject(sourceValue)>
							<cfset sourceValue = sourceValue.getWidgetTypeId() />
						</cfif>
	
          <select name="widgetTypeId" id="widgetTypeId" >
            
				
            <cfoutput query="valueQuery">
              <option value="#valueQuery.WidgetTypeId#" <cfif sourceValue eq valueQuery.WidgetTypeId>selected</cfif>>#valueQuery.name#</option>
            </cfoutput>
          </select>
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="WidgetType" validation="#validation#" />
        </div>
      
        <div class="formfield">
	        <label for="isActive" <cfif structKeyExists(validation, "isActive")>class="error"</cfif>><b>Is Active:</b></label>
	        <div>
					
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="isActive" validation="#validation#" />
        </div>
    
        <div class="formfield">
        	<label <cfif structKeyExists(validation, "WidgetCategory")>class="error"</cfif>><b>Widget Category(s):</b></label>
          <cfset valueQuery = viewstate.getValue("WidgetCategoryList") />
				

					<cfif viewstate.exists("WidgetCategory|WidgetCategoryId")>
						<cfset selectedList = viewstate.getValue("WidgetCategory|WidgetCategoryId")/>
					<cfelse>
						<!--- This XSL supports both Reactor and Transfer --->
						<cfif structKeyExists(WidgetRecord, "getWidgetCategoryStruct")>
							<cfset selected = WidgetRecord.getWidgetCategoryStruct() />
						<cfelseif structKeyExists(WidgetRecord, "getWidgetCategoryArray")>
							<cfset selected = WidgetRecord.getWidgetCategoryArray() />
						<cfelse>
							<cfset selected = WidgetRecord.getWidgetCategoryIterator().getQuery() />
						</cfif>

						<cfif isQuery(selected)>
							<cfset selectedList = valueList(selected.WidgetCategoryId) />
						<cfelseif isStruct(selected)>
							<cfset selectedList = structKeyList(selected)>
						<cfelseif isArray(selected)>
							<cfset selectedList = "" />
							<cfloop from="1" to="#arrayLen(selected)#" index="i">
								<cfset selectedList = listAppend(selectedList, selected[i].getWidgetCategoryId()) />
							</cfloop>
						</cfif>
					</cfif>
				            
          <!--- 
            hidden makes the field always defined.  if this wasn't here, and you deleted this whole field
            from the control, you'd wind up deleting all child records during a genericCommit...
          --->
          <input type="hidden" name="WidgetCategory|WidgetCategoryId" value="" />
	        <div class="formfieldinputstack">
          <cfoutput query="valueQuery">
            <label for="WidgetCategory_#valueQuery.WidgetCategoryId#"><input type="checkbox" name="WidgetCategory|WidgetCategoryId" id="WidgetCategory_#valueQuery.WidgetCategoryId#" value="#valueQuery.WidgetCategoryId#"<cfif listFindNoCase(selectedList, "#valueQuery.WidgetCategoryId#")> checked</cfif>/>#valueQuery.name#</label><br />
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
    
	
