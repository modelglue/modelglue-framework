<beans default-autowire="byName">
	
	<!-- This is your Model-Glue configuration -->
	<bean id="modelglue.modelGlueConfiguration" class="ModelGlue.gesture.configuration.ModelGlueConfiguration">
	
		<!-- Be sure to change these to false when you go to production! -->
		<property name="reload"><value>true</value></property>
		<property name="debug"><value>false</value></property>
		
		<!-- Name of the URL variable that states which event-handler to run -->
		<property name="eventValue"><value>event</value></property>
		<!-- Default event-handler -->
		<property name="defaultEvent"><value>country.list</value></property>
		<!-- Execute this event when the requested event is missing. Won't work if generationEnabled=true and in development mode! -->
		<property name="missingEvent"><value>page.missing</value></property>
		<!-- Execute this event when an error occurs. -->
		<property name="defaultExceptionHandler"><value>page.error</value></property>
		
		<!-- Controls reloading -->
		<property name="reloadPassword"><value>true</value></property>
		<property name="reloadKey"><value>reload</value></property>
		
		<!-- Where to find necessary files -->
		<property name="configurationPath"><value>config/ModelGlue.xml.cfm</value></property>
		<property name="applicationMapping"><value>/modelgluesamples/NewScaffolds</value></property>
		<property name="viewMappings"><value>/modelgluesamples/NewScaffolds/views,/modelgluesamples/NewScaffolds/views/customized,/modelglueextensions/modelglue</value></property>
		<property name="helperMappings"><value>/modelgluesamples/NewScaffolds/helpers</value></property>
		<property name="assetMappings"><value>/modelglueextensions/jQuery,/modelglueextensions/modelglue,/modelgluesamples/NewScaffolds/css</value></property>
		
		<!-- Generate unknown events when in development mode?  (reload=false) -->
		<property name="generationEnabled"><value>true</value></property>
		
		<!-- Set the default cache timeout in seconds -->
		<property name="defaultCacheTimeout"><value>60</value></property>
		
		<!-- Scaffolding config -->
		<!-- Turning this off will disable any scaffold generation. Turning this on requires the reload setting above to also be on.-->
		<property name="rescaffold"><value>true</value></property>
		<!-- Where do you want generated views to be saved to? -->
		<property name="generatedViewMapping"><value>/modelgluesamples/NewScaffolds/views/generated</value></property>
		<!--This directory structure should already exists. ModelGlue will create the Scaffolds.xml file and overwrite as needed.-->
		<property name="scaffoldPath"><value>config/scaffolds/Scaffolds.xml</value></property>
		<!-- What scaffold generation patterns should ModelGlue use if you do not specify in the <scaffold type=""> attribute? .-->
		<property name="defaultScaffolds"><value>list,edit,view,commit,delete</value></property>
		<!-- See documentation or ModelGlueConfiguration.cfc for additional options. -->
	</bean>
	
	<!-- Override the plain scaffold manager with fancy settings -->
	<bean id="modelglue.scaffoldManager" parent="modelglue.scaffoldManager.fancy" />
	
	<!-- CF9/ORM adapter/service -->
	<alias alias="ormAdapter" name="ormAdapter.cfORM" />
	<alias alias="ormService" name="ormService.cfORM" />
	
	<!-- Transfer ORM adapter/service
	<alias alias="ormAdapter" name="ormAdapter.Transfer" />
	<alias alias="ormService" name="ormService.Transfer" />
	<bean id="transferConfiguration" class="transfer.com.config.Configuration">
		<constructor-arg name="datasourcePath"><value>/modelgluesamples/NewScaffolds/config/transfer/Datasource.xml</value></constructor-arg>
		<constructor-arg name="configPath"><value>/modelgluesamples/NewScaffolds/config/transfer/Transfer.xml</value></constructor-arg>
		<constructor-arg name="definitionPath"><value>/modelgluesamples/NewScaffolds/config/transfer/data</value></constructor-arg>
	</bean> -->
	
</beans>
