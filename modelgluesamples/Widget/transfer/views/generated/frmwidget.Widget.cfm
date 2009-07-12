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
<cfset widget.WidgetRecord = viewstate.getValue("widget.WidgetRecord") />
<cfset keyString = "&widgetId=#urlEncodedFormat(widget.WidgetRecord.getwidgetId())#" />
<cfset commitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.commit") & keyString />
<cfset validation = viewstate.getValue("widget.WidgetValidation", structNew()) />

<cfset isNew = true />
		

		<cfif (not isNumeric(widget.WidgetRecord.getwidgetId()) and len(widget.WidgetRecord.getwidgetId())) or (isNumeric(widget.WidgetRecord.getwidgetId()) and widget.WidgetRecord.getwidgetId())>
			<cfset isNew = false />
		</cfif>
	
		
<cfoutput>
<div id="breadcrumb">
		<a href="#listEvent#">Widgets</a> / 
		<cfif isNew>
			Add New Widget
		<cfelse>
			#widget.WidgetRecord.getname()#
		</cfif>
</div>
</cfoutput>
<br />


								
<cfform action="#commitEvent#" class="edit">
    
<fieldset>
    

    <cfoutput>
    <input type="hidden" name="widgetId" value="#widget.WidgetRecord.getwidgetId()#" />
    </cfoutput>
  
        <div class="formfield">
	        <label for="name" <cfif structKeyExists(validation, "name")>class="error"</cfif>><b>Name:</b></label>
	        <div>
					
		        <cfinput 
									type="text" 
									class="input" 
									 
									id="name" 
									name="name" 
									
										value="#widget.WidgetRecord.getname()#" 
									
						/>
		      
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="name" validation="#validation#" />
        </div>
    
        <div class="formfield">
	        <label for="isActive" <cfif structKeyExists(validation, "isActive")>class="error"</cfif>><b>Is Active:</b></label>
	        <div>
					
		        <div class="formfieldinputstack">
		        <input 
									type="radio" 
									id="isActive_true" 
									name="isActive" 
									value="true" 
									<cfif isBoolean(widget.WidgetRecord.getisActive()) and widget.WidgetRecord.getisActive()>checked</cfif>
						/>
						<label for="isActive_true"> Yes</label>
		        <input 
									type="radio" 
									id="isActive_false" 
									name="isActive" 
									value="false" 
									<cfif isBoolean(widget.WidgetRecord.getisActive()) and not widget.WidgetRecord.getisActive()>checked</cfif>
						/>
						<label for="isActive_false"> No</label>
						</div>
					
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="isActive" validation="#validation#" />
        </div>
    
        <div class="formfield">
	        <label for="WidgetType" <cfif structKeyExists(validation, "WidgetType")>class="error"</cfif>><b>Widget Type:</b>
	        </label>
	        <cfset valueQuery = viewstate.getValue("widget.WidgetTypeList") />
	        <div>
        
						<cfset sourceValue = "" />

						<cftry>
							<cfif structKeyExists(widget.WidgetRecord, "getWidgetType")>
								<cfset sourceValue = widget.WidgetRecord.getWidgetType() />
							<cfelseif structKeyExists(widget.WidgetRecord, "getParentWidgetType")>
								<cfset sourceValue = widget.WidgetRecord.getParentWidgetType() />
							</cfif>
							<cfcatch>
							</cfcatch>
						</cftry>
				
						<cfif isObject(sourceValue)>
							<cfset sourceValue = sourceValue.getwidgetTypeId() />
						</cfif>
	
          <select name="WidgetType" id="WidgetType" >
            
              <option value=""></option>
            
				
            <cfoutput query="valueQuery">
              <option value="#valueQuery.widgetTypeId#" <cfif sourceValue eq valueQuery.widgetTypeId>selected</cfif>>#valueQuery.name#</option>
            </cfoutput>
          </select>
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="WidgetType" validation="#validation#" />
        </div>
      
        <div class="formfield">
        	<label <cfif structKeyExists(validation, "WidgetCategory")>class="error"</cfif>><b>Widget Category(s):</b></label>
          <cfset valueQuery = viewstate.getValue("widget.WidgetCategoryList") />
				

					<cfif viewstate.exists("WidgetCategory|widgetCategoryId")>
						<cfset selectedList = viewstate.getValue("WidgetCategory|widgetCategoryId")/>
					<cfelse>
						<!--- This XSL supports both Reactor and Transfer --->
						<cfif structKeyExists(widget.WidgetRecord, "getWidgetCategoryStruct")>
							<cfset selected = widget.WidgetRecord.getWidgetCategoryStruct() />
						<cfelseif structKeyExists(widget.WidgetRecord, "getWidgetCategoryArray")>
							<cfset selected = widget.WidgetRecord.getWidgetCategoryArray() />
						<cfelse>
							<cfset selected = widget.WidgetRecord.getWidgetCategoryIterator().getQuery() />
						</cfif>

						<cfif isQuery(selected)>
							<cfset selectedList = valueList(selected.widgetCategoryId) />
						<cfelseif isStruct(selected)>
							<cfset selectedList = structKeyList(selected)>
						<cfelseif isArray(selected)>
							<cfset selectedList = "" />
							<cfloop from="1" to="#arrayLen(selected)#" index="i">
								<cfset selectedList = listAppend(selectedList, selected[i].getwidgetCategoryId()) />
							</cfloop>
						</cfif>
					</cfif>
				            
          <!--- 
            hidden makes the field always defined.  if this wasn't here, and you deleted this whole field
            from the control, you'd wind up deleting all child records during a genericCommit...
          --->
          <input type="hidden" name="WidgetCategory|widgetCategoryId" value="" />
	        <div class="formfieldinputstack">
          <cfoutput query="valueQuery">
            <label for="WidgetCategory_#valueQuery.widgetCategoryId#"><input type="checkbox" name="WidgetCategory|widgetCategoryId" id="WidgetCategory_#valueQuery.widgetCategoryId#" value="#valueQuery.widgetCategoryId#"<cfif listFindNoCase(selectedList, "#valueQuery.widgetCategoryId#")> checked</cfif>/>#valueQuery.name#</label><br />
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
    
	
