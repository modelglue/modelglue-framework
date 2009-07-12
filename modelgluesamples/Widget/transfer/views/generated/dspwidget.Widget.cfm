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
<cfset commitEvent = viewstate.getValue("myself") & viewstate.getValue("xe.commit") & "&widget.WidgetId=" & urlEncodedFormat(viewstate.getValue("widget.WidgetId")) />
<cfset widget.WidgetRecord = viewstate.getValue("widget.WidgetRecord") />
<cfset validation = viewstate.getValue("widget.WidgetValidation", structNew()) />

<cfoutput>
<div id="breadcrumb"><a href="#listEvent#">Widgets</a> / View Widget</div>
</cfoutput>
<br />
  
<cfform class="edit">
    
<fieldset>
    

        <div class="formfield">
          <cfoutput>
	        <label for="name"><b>Name:</b></label>
	        <span class="input">#widget.WidgetRecord.getname()#</span>
	        </cfoutput>
        </div>
    
        <div class="formfield">
          <cfoutput>
	        <label for="isActive"><b>Is Active:</b></label>
	        <span class="input">#widget.WidgetRecord.getisActive()#</span>
	        </cfoutput>
        </div>
    
        <div class="formfield">
          <cfoutput>
	        <label for="WidgetType"><b>Widget Type:</b>
	        </label>

					<cfif structKeyExists(widget.WidgetRecord, "getWidgetType")>
						<cfset targetObject = widget.WidgetRecord.getWidgetType() />
					<cfelseif structKeyExists(widget.WidgetRecord, "getParentWidgetType")>
						<cfset targetObject = widget.WidgetRecord.getParentWidgetType() />
					</cfif>
				
	        <div>
	       		#targetObject.getname()#
	        </div>
	        </cfoutput>
        </div>
      
        <div class="formfield">
        	<label><b>name(s):</b></label>

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
						<div class="formfieldinputstack">
						<cfoutput query="selected">
							#selected.name#<br />
						</cfoutput>
						</div>
					<cfelseif isStruct(selected)>
						<cfoutput>
						<div class="formfieldinputstack">
						<cfloop collection="#selected#" item="i">
							#selected[i].getname()#<br />
						</cfloop>
						</div>
						</cfoutput>
					<cfelseif isArray(selected)>
						<cfoutput>
						<div class="formfieldinputstack">
						<cfloop from="1" to="#arrayLen(selected)#" index="i">
							#selected[i].getname()#<br />
						</cfloop>
						</div>
						</cfoutput>
					</cfif>

        </div>
          
      
</fieldset>
</div>
</cfform>
    
	
