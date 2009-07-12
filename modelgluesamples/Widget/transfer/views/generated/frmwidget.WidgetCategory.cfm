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
<cfset widget.WidgetCategoryRecord = viewstate.getValue("widget.WidgetCategoryRecord") />
<cfset keyString = "&widgetCategoryId=#urlEncodedFormat(widget.WidgetCategoryRecord.getwidgetCategoryId())#" />
<cfset commitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.commit") & keyString />
<cfset validation = viewstate.getValue("widget.WidgetCategoryValidation", structNew()) />

<cfset isNew = true />
		

		<cfif (not isNumeric(widget.WidgetCategoryRecord.getwidgetCategoryId()) and len(widget.WidgetCategoryRecord.getwidgetCategoryId())) or (isNumeric(widget.WidgetCategoryRecord.getwidgetCategoryId()) and widget.WidgetCategoryRecord.getwidgetCategoryId())>
			<cfset isNew = false />
		</cfif>
	
		
<cfoutput>
<div id="breadcrumb">
		<a href="#listEvent#">Widget Categorys</a> / 
		<cfif isNew>
			Add New Widget Category
		<cfelse>
			#widget.WidgetCategoryRecord.getname()#
		</cfif>
</div>
</cfoutput>
<br />


								
<cfform action="#commitEvent#" class="edit">
    
<fieldset>
    

    <cfoutput>
    <input type="hidden" name="widgetCategoryId" value="#widget.WidgetCategoryRecord.getwidgetCategoryId()#" />
    </cfoutput>
  
        <div class="formfield">
	        <label for="name" <cfif structKeyExists(validation, "name")>class="error"</cfif>><b>Name:</b></label>
	        <div>
					
		        <cfinput 
									type="text" 
									class="input" 
									 
									id="name" 
									name="name" 
									
										value="#widget.WidgetCategoryRecord.getname()#" 
									
						/>
		      
	        </div>
	        <cfmodule template="/ModelGlue/customtags/validationErrors.cfm" property="name" validation="#validation#" />
        </div>
    
        <div class="formfield">
        	<label <cfif structKeyExists(validation, "Widget")>class="error"</cfif>><b>Widget(s):</b></label>
          <cfset valueQuery = viewstate.getValue("widget.WidgetList") />
				

					<cfif viewstate.exists("Widget|widgetId")>
						<cfset selectedList = viewstate.getValue("Widget|widgetId")/>
					<cfelse>
						<!--- This XSL supports both Reactor and Transfer --->
						<cfif structKeyExists(widget.WidgetCategoryRecord, "getWidgetStruct")>
							<cfset selected = widget.WidgetCategoryRecord.getWidgetStruct() />
						<cfelseif structKeyExists(widget.WidgetCategoryRecord, "getWidgetArray")>
							<cfset selected = widget.WidgetCategoryRecord.getWidgetArray() />
						<cfelse>
							<cfset selected = widget.WidgetCategoryRecord.getWidgetIterator().getQuery() />
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
    
	
