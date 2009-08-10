<cfcomponent extends="modelglue.gesture.test.ModelGlueAbstractTestCase">
		
	<cfset this.coldspringPath = "/ModelGlue/gesture/loading/test/ColdSpring.xml">

	<cffunction name="setUp">
		<cfset createModelGlueIfNotDefined() />	
	</cffunction>

	<cffunction name="testCreateBeanFactory" returntype="void" access="public">
		<cfset assertEquals("ModelGlue.gesture.ModelGlue", getMetadata(mg).name, "ModelGlue instance not created from bean factory.") />
	</cffunction>
	
	<cffunction name="testCreateBeanFactory_WithParent" returntype="void" access="public">
		<cfset var boot = createBootstrapper(this.coldspringPath) />
		<cfset var parentBeanFactory = createObject("component", "coldspring.beans.DefaultXmlBeanFactory").init() />
		<cfset var bf = "" />
		<cfset var bean = "" />
		
		<cfset parentBeanFactory.loadBeans(expandPath("/ModelGlue/gesture/loading/test/ParentBeans.xml")) />
		<cfset boot.parentBeanFactory = parentBeanFactory />
		
		<cfset bf = boot.createBeanFactory() />
		<cfset bean = bf.getBean("beanFromParentFactory") />
		
		<cfset assertEquals("ModelGlue.gesture.collections.MapCollection", getMetadata(bean).name, "MapCollection instance not created from bean factory.") />
	</cffunction>
	
	<cffunction name="testInternalBeanFactory" returntype="void" access="public">
		<cfset var cfg = mg.getInternalBean("modelglue.ModelGlueConfiguration") />
		<cfset assertEquals("ModelGlue.gesture.configuration.ModelGlueConfiguration",getMetadata(cfg).name, "Configuration instance not created from bean factory.") />
	</cffunction>
		
	<cffunction name="testDefaultDynamicProperties" returntype="void" access="public">
		<cfset var boot = createBootstrapper(this.coldspringPath) />
		<cfset var bf = "" />
		<cfset var bean = "" />
		<cfset var dynProps = structNew() >
		<cfset dynProps.AValueOriginatingOutside = "Dynamic">
		<cfset boot.defaultColdSpringProperties = dynProps />
		<cfset bf = boot.createBeanFactory() />
		<cfset bean = bf.getBean("DynamicPropertyContainer") />
		
		<cfset assertEquals(bean.MyValueWillBeDynamic, "Dynamic", "Dynamic Property not set in bean") />
	</cffunction>

</cfcomponent>