<cfcomponent extends="org.cfcunit.framework.TestCase">
	
<cffunction name="createBootstrapper" access="private">
	<cfreturn createObject("component", "ModelGlue.gesture.loading.ColdSpringBootstrapper") />
</cffunction>

<cffunction name="testCreateBeanFactory" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var bf = "" />
	<cfset var mg = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset bf = boot.createBeanFactory() />
	<cfset mg = bf.getBean("modelglue.ModelGlue") />
	
	<cfset assertTrue(getMetadata(mg).name eq "ModelGlue.gesture.ModelGlue", "ModelGlue instance not created from bean factory.") />
</cffunction>

<cffunction name="testCreateBeanFactory_WithParent" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var parentBeanFactory = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
	<cfset var bf = "" />
	<cfset var bean = "" />
	
	<cfset parentBeanFactory.loadBeans(expandPath("/ModelGlue/gesture/loading/test/ParentBeans.xml")) />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	<cfset boot.parentBeanFactory = parentBeanFactory />
	
	<cfset bf = boot.createBeanFactory() />
	<cfset bean = bf.getBean("beanFromParentFactory") />
	
	<cfset assertTrue(getMetadata(bean).name eq "ModelGlue.gesture.collections.MapCollection", "MapCollection instance not created from bean factory.") />
</cffunction>

<cffunction name="testCreateModelGlue" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset assertTrue(getMetadata(mg).name eq "ModelGlue.gesture.ModelGlue", "ModelGlue instance not created from bean factory.") />
</cffunction>

<cffunction name="testInternalBeanFactory" returntype="void" access="public">
	<cfset var boot = createBootstrapper() />
	<cfset var mg = "" />
	<cfset var cfg = "" />
	
	<cfset boot.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml" />
	
	<cfset mg = boot.createModelGlue() />
	
	<cfset cfg = mg.getInternalBean("modelglue.ModelGlueConfiguration") />
	
	<cfset assertTrue(getMetadata(cfg).name eq "ModelGlue.gesture.configuration.ModelGlueConfiguration", "Configuration instance not created from bean factory.") />
</cffunction>

</cfcomponent>