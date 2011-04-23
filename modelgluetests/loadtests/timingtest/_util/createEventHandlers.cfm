<cfoutput>
	<cfsaveContent variable="handlers"><?xml version="1.0" encoding="UTF-8"?>
	<modelglue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	    xsi:noNamespaceSchemaLocation="http://www.model-glue.com/schema/gesture/ModelGlue-loose.xsd" >
		<event-handlers>
		<cfloop from="1" to="1000" index="e">
	        <event-handler name="event#e#">
		        <broadcasts />
		        <results>
		            <result do="template.main" />
		        </results>
		        <views>
		            <view name="body" template="pages/index.cfm" />
		        </views>
		    </event-handler>
		</cfloop>
		</event-handlers>
	</modelglue>
	</cfsavecontent>
</cfoutput>

<cffile action="write" file="#expandPath('/config/EventHandlers.xml')#" output="#handlers#" />
