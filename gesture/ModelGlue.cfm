<cfset boot = createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper") />

<cfset request._modelglue.bootstrapper.bootstrapper = boot />

<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
<cfset boot.initialModulePath = "/modelgluesamples/legacysamples/eventforwarding/config/ModelGlue.xml" />

<cfset mg = boot.createModelGlue() />

<cfset request._modelglue.bootstrapper.framework = mg />


<!---
<cfset loader = mg.getInternalBean("modelglue.ModuleLoaderFactory").create("XML") />

<cfset loader.load(mg, "./config/ModelGlue.xml") />
--->

<cfset ec = mg.handleRequest() />


<cfoutput>#ec.getLastRendereredView()#</cfoutput>

<cfoutput>
#mg.renderContextLog(ec)#
</cfoutput>
