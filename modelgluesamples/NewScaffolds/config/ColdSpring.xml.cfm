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
		<!-- Mappings of custom tag prefixes to locations for importing into generated views -->
		<property name="scaffoldCustomTagMappings">
			<map>
				<entry key="mg">
					<value>/ModelGlue/gesture/modules/scaffold/customtags/fancy/</value>
				</entry>
				<entry key="uform">
					<value>/modelglueextensions/cfuniform/tags/forms/cfUniForm/</value>
				</entry>
			</map>
		</property>
		<!-- See documentation or ModelGlueConfiguration.cfc for additional options. -->
	</bean>
		
	<!-- 
		If you need your own configuration values (datasource names, etc), put them here.
		
		See modelgluesamples/simpleconfiguration/controller/Controller for an example of how to get to the values.
		
		Advanced users who are used to ColdSpring will probably delete this bean in favor of their own approach.
	-->
	<bean id="CFUniFormConfigBean" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="jQuery">
					<value>www/js/jquery-1.3.2.min.js</value>
				</entry>
				<entry key="renderer">
					<value>/NewScaffolds/views/customtags/forms/renderValidationErrors.cfm</value>
				</entry>
				<entry key="uniformCSS">
					<value>www/css/uni-form.css</value>
				</entry>
				<entry key="uniformCSSie">
					<value>www/css/uni-form-ie.css</value>
				</entry>
				<entry key="uniformJS">
					<value>www/js/uni-form.jquery.js</value>
				</entry>
				<entry key="validationJS">
					<value>www/js/jquery.validate-1.5.1.min.js</value>
				</entry>
				<entry key="dateCSS">
					<value>www/cfuniform/css/jquery.ui.datepicker.css</value>
				</entry>
				<entry key="dateJS">
					<value>www/js/ui.datepicker.packed.js</value>
				</entry>
				<entry key="timeCSS">
					<value>www/css/jquery.timeentry.css</value>
				</entry>
				<entry key="timeJS">
					<value>www/js/jquery.timeentry-1.4.2.min.js</value>
				</entry>
				<entry key="maskJS">
					<value>www/cfuniform/js/jquery.maskedinput-1.2.1.pack.js</value>
				</entry>
				<entry key="textareaJS">
					<value>www/jquery.prettyComments-1.4.js</value>
				</entry>
				<entry key="dateSetup">
					<map>
						<entry key="buttonImage">
							<value>www/images/calendar.png</value>
						</entry>
					</map>
				</entry>
				<entry key="textareaSetup">
					<map>
						<entry key="maxHeight">
							<value>800</value>
						</entry>
						<entry key="animate">
							<value>true</value>
						</entry>
						<entry key="animationSpeed">
							<value>slow</value>
						</entry>
					</map>
				</entry>
				<entry key="timeSetup">
					<map>
						<entry key="show24Hours">
							<value>true</value>
						</entry>
						<entry key="showSeconds">
							<value>false</value>
						</entry>
					</map>
				</entry>
			</map>
		</property>
	</bean>

	<bean id="ScaffoldTemplate.Grid" factory-bean="modelglue.scaffoldManager" factory-method="addScaffoldTemplate" lazy-init="false">  
		<constructor-arg name="scaffoldBeanRegistry">  
			<map>
				<entry key="Grid"><ref bean="newScaffold.Grid" /></entry>
			</map>
		</constructor-arg>
	</bean>
	
	<bean id="newScaffold.Grid" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="class"><value>beans.Grid</value></entry>
				<event key="hasXMLGeneration"><value>true</value></event>
				<event key="hasViewGeneration"><value>true</value></event>
				<entry key="prefix"><value>Grid.</value></entry>
				<entry key="suffix"><value>.cfm</value></entry>
			</map>
		</property>
	</bean> 

	<!-- Override default scaffolds -->
	<bean id="modelglue.scaffoldType.Edit" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="class"><value>ModelGlue.gesture.modules.scaffold.beans.fancy.Edit</value></entry>
				<event key="hasXMLGeneration"><value>true</value></event>
				<event key="hasViewGeneration"><value>true</value></event>
				<entry key="prefix"><value>Form.</value></entry>
				<entry key="suffix"><value>.cfm</value></entry>
			</map>
		</property>
	</bean>	

	<bean id="modelglue.scaffoldType.List" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="class"><value>ModelGlue.gesture.modules.scaffold.beans.fancy.List</value></entry>
				<event key="hasXMLGeneration"><value>true</value></event>
				<event key="hasViewGeneration"><value>true</value></event>
				<entry key="prefix"><value>List.</value></entry>
				<entry key="suffix"><value>.cfm</value></entry>
			</map>
		</property>
	</bean>

	<bean id="modelglue.scaffoldType.View" class="coldspring.beans.factory.config.MapFactoryBean">
		<property name="SourceMap">
			<map>
				<entry key="class"><value>ModelGlue.gesture.modules.scaffold.beans.fancy.View</value></entry>
				<event key="hasXMLGeneration"><value>true</value></event>
				<event key="hasViewGeneration"><value>true</value></event>
				<entry key="prefix"><value>Display.</value></entry>
				<entry key="suffix"><value>.cfm</value></entry>
			</map>
		</property>
	</bean>
	
	<!-- CF9/ORM adapter/service -->
	<alias alias="ormAdapter" name="ormAdapter.cfORM" />
	<alias alias="ormService" name="ormService.cfORM" />
	
</beans>
