<beans default-autowire="byName">
	
	<!-- This is your Model-Glue configuration -->
	<bean id="modelglue.modelGlueConfiguration" class="ModelGlue.gesture.configuration.ModelGlueConfiguration">
	
		<!-- Be sure to change these to false when you go to production! -->
		<property name="reload"><value>false</value></property>
		<property name="debug"><value>true</value></property>
		
		<!-- Name of the URL variable that states which event-handler to run -->
		<property name="eventValue"><value>event</value></property>
		<!-- Default event-handler -->
		<property name="defaultEvent"><value>province.list</value></property>
		<!-- Execute this event when the requested event is missing. Won't work if generationEnabled=true and in development mode! -->
		<property name="missingEvent"><value>page.missing</value></property>
		<!-- Execute this event when an error occurs. -->
		<property name="defaultExceptionHandler"><value>page.error</value></property>
		
		<!-- Controls reloading -->
		<property name="reloadPassword"><value>true</value></property>
		<property name="reloadKey"><value>reload</value></property>
	
		<!-- Where to find necessary files -->
		<property name="configurationPath"><value>config/ModelGlue.xml.cfm</value></property>
		<property name="applicationMapping"><value>/</value></property>
		<property name="viewMappings"><value>/views,/views/customized,/views/generated</value></property>
		<property name="helperMappings"><value>/helpers</value></property>
		
		<!-- Generate unknown events when in development mode?  (reload=false) -->
		<property name="generationEnabled"><value>false</value></property>
		
		<!-- Set the default cache timeout in seconds -->
		<property name="defaultCacheTimeout"><value>60</value></property>  	
		
		<!-- Scaffolding config -->
		<!-- Turning this off will disable any scaffold generation. Turning this on requires the reload setting above to also be on.-->	
		<property name="rescaffold"><value>true</value></property>
		<!-- Where do you want generated views to be saved to? -->
		<property name="generatedViewMapping"><value>/views/generated</value></property>
		<!--This directory structure should already exists. ModelGlue will create the Scaffolds.xml file and overwrite as needed.-->
		<property name="scaffoldPath"><value>config/scaffolds/Scaffolds.xml</value></property>
		<!-- What scaffold generation patterns should ModelGlue use if you do not specify in the <scaffold type=""> attribute? .-->
		<property name="defaultScaffolds"><value>list,edit,view,commit,delete</value></property>
		
		<!-- See documentation or ModelGlueConfiguration.cfc for additional options. -->
	</bean>
		
	<!-- 
		If you need your own configuration values (datasource names, etc), put them here.
		
		See modelgluesamples/simpleconfiguration/controller/Controller for an example of how to get to the values.
		
		Advanced users who are used to ColdSpring will probably delete this bean in favor of their own approach.
	-->

	<!-- Override default scaffolds -->
	<bean id="modelglue.scaffoldType.Edit" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="class"><value>beans.Edit_cfU</value></entry>
				<event key="hasXMLGeneration"><value>true</value></event>
				<event key="hasViewGeneration"><value>true</value></event>
				<entry key="prefix"><value>Form.</value></entry>
				<entry key="suffix"><value>.cfm</value></entry>
			</map>
		</property>
	</bean>	
		
	<!-- CF9/ORM adapter/service -->
	<alias alias="ormAdapter" name="ormAdapter.cfORM" />
	<alias alias="ormService" name="ormService.cfORM" />
	
</beans>
