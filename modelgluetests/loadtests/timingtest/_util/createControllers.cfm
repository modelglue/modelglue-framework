<cfoutput>
	<cfsaveContent variable="controllers"><?xml version="1.0" encoding="UTF-8"?>
	<modelglue xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
	    xsi:noNamespaceSchemaLocation="http://www.model-glue.com/schema/gesture/ModelGlue-loose.xsd" >
		<controllers>
		<cfloop from="1" to="1000" index="e">
	        <controller id="Controller#e#" type="controller.Controller">
    		    <message-listener message="needSomething" function="doSomething" />
		    </controller>
		</cfloop>
		</controllers>
	</modelglue>
	</cfsavecontent>
</cfoutput>

<cffile action="write" file="#expandPath('/config/Controllers.xml')#" output="#controllers#" />
