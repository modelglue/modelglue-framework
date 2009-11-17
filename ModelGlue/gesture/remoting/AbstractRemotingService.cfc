<cfcomponent output="false" hint="Exposes Model-Glue application to remote clients.">

<cfset variables.locator = createObject("component", "ModelGlue.Util.ModelGlueFrameworkLocator") />

<cffunction name="getModelGlue" output="false">
	<cfset var mg = "" />
	
	<!--- Bootstrap MG by invoking the main template but blocking event execution. --->
	<cfset request._modelglue.bootstrap.blockEvent = 1 />
	
	<cfmodule template="#template#" />
	
	<cfset mg = variables.locator.findInScope(application, request._modelglue.bootstrap.appKey) />
	
	<cfif not arrayLen(mg)>
		<cfthrow message="Can't locate Model-Glue instance named #request._modelglue.bootstrap.appKey# in application scope!" />
	</cfif>
	
	<cfreturn mg[1] />
</cffunction>


<cffunction name="executeEvent" output="false" access="remote" returntype="struct">
	<cfargument name="eventName" type="string" required="true" />
	<cfargument name="values" type="struct" required="false" default="#StructNew()#"/>
	<cfargument name="returnValues" type="string" required="false" default="" />
	
	<cfset var local = StructNew()/>
	
	<!--- For Javascript post calls to the service --->
	<cfif structIsEmpty(form) is false>
		<cfset arguments.values = duplicate(form) />
	<!--- For Javascript get calls to the service --->
	<cfelseif structIsEmpty(url) is false>
		<cfset arguments.values = duplicate(url) />
	</cfif>
	
	<cfset local.event = getModelGlue().executeEvent(argumentCollection=arguments) />
	
	<cfloop list="#arguments.returnValues#" index="local.i">
		<cfset local.result[local.i] = local.event.getValue(local.i) />
	</cfloop>
	
	<cfset resetCFHtmlHead() />
	<cfreturn local.result />
</cffunction>

<!--- 
Based on original function by Elliot Sprehn, found here
http://livedocs.adobe.com/coldfusion/7/htmldocs/wwhelp/wwhimpl/common/html/wwhelp.htm?context=ColdFusion_Documentation&file=00000271.htm
BlueDragon and Railo by Chris Blackwell
--->
<cffunction name="resetCFHtmlHead" output="false" access="public" returntype="void">
	<cfset var my = structnew() />

	<cfswitch expression="#trim(server.coldfusion.productname)#">

		<cfcase value="ColdFusion Server">
			<cfset my.out = getPageContext().getOut() />

			<!--- It's necessary to iterate over this until we get to a coldfusion.runtime.NeoJspWriter --->
			<cfloop condition="getMetaData(my.out).getName() is 'coldfusion.runtime.NeoBodyContent'">
				<cfset my.out = my.out.getEnclosingWriter() />
			</cfloop>

			<cfset my.method = my.out.getClass().getDeclaredMethod("initHeaderBuffer", arrayNew(1)) />
			<cfset my.method.setAccessible(true) />
			<cfset my.method.invoke(my.out, arrayNew(1)) />

		</cfcase>

		<cfcase value="BlueDragon">

			<cfset my.resp = getPageContext().getResponse() />

			<cfloop condition="true">
				<cfset my.parentf = my.resp.getClass().getDeclaredField('parent') />
				<cfset my.parentf.setAccessible(true) />
				<cfset my.parent = my.parentf.get(my.resp) />

				<cfif isObject(my.parent) AND getMetaData(my.parent).getName() is 'com.naryx.tagfusion.cfm.engine.cfHttpServletResponse'>
					<cfset my.resp = my.parent />
				<cfelse>
					<cfbreak />
				</cfif>
			</cfloop>

			<cfset my.writer = my.resp.getClass().getDeclaredField('writer') />
			<cfset my.writer.setAccessible(true) />
			<cfset my.writer = my.writer.get(my.resp) />

			<cfset my.headbuf = my.writer.getClass().getDeclaredField('headElement') />
			<cfset my.headbuf.setAccessible(true) />
			<cfset my.headbuf.get(my.writer).setLength(0) />

		</cfcase>

		<cfcase value="Railo">

			<cfset my.out = getPageContext().getOut() />

			<cfloop condition="getMetaData(my.out).getName() is 'railo.runtime.writer.BodyContentImpl'">
				<cfset my.out = my.out.getEnclosingWriter() />
			</cfloop>

			<cfset my.headData = my.out.getClass().getDeclaredField("headData") />
			<cfset my.headData.setAccessible(true) />
			<cfset my.headData.set(my.out, createObject("java", "java.lang.String").init("")) />

		</cfcase>

	</cfswitch>

</cffunction>

</cfcomponent>