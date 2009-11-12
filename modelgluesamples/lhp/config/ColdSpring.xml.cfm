<beans>
	
<!-- This is your Model-Glue configuration -->
<bean id="modelglue.modelGlueConfiguration" class="ModelGlue.gesture.configuration.ModelGlueConfiguration">

	<!-- Be sure to change these to false when you go to production! -->
	<property name="reload"><value>false</value></property>
	<property name="debug"><value>false</value></property>
	
	<!-- Name of the URL variable that states which event-handler to run -->
	<property name="eventValue"><value>event</value></property>
	<!-- Default event-handler -->
	<property name="defaultEvent"><value>page.index</value></property>
	<!-- Execute this event when the requested event is missing. Won't work if generationEnabled=true and in development mode! -->
	<property name="missingEvent"><value>page.missing</value></property>
	<!-- Execute this event when an error occurs. -->
	<property name="defaultExceptionHandler"><value>page.error</value></property>
	
	<!-- Controls reloading -->
	<property name="reloadPassword"><value>true</value></property>
	<property name="reloadKey"><value>init</value></property>

	<!-- Where to find necessary files -->
	<property name="configurationPath"><value>config/ModelGlue.xml</value></property>
	<property name="applicationMapping"><value>/lhp</value></property>
	<property name="viewMappings"><value>/lhp/views</value></property>
	<property name="helperMappings"><value>/lhp/helpers</value></property>
	
	<!-- Generate unknown events when in development mode?  (reload=false) -->
	<property name="generationEnabled"><value>false</value></property>
	
	<!-- Scaffolding config -->
	<!-- Turning this off will disable any scaffold generation. Turning this on requires the reload setting above to also be on.-->	
	<property name="rescaffold"><value>false</value></property>
	<!-- Where do you want generated views to be saved to? -->
	<property name="generatedViewMapping"><value>views</value></property>
	<!--This directory structure should already exists. ModelGlue will create the Scaffolds.xml file and overwrite as needed.-->
	<property name="scaffoldPath"><value>config/scaffolds/Scaffolds.xml</value></property>
	<!-- What scaffold generation patterns should ModelGlue use if you do not specify in the <scaffold type=""> attribute? .-->
	<property name="defaultScaffolds"><value>list,edit,view,commit,delete</value></property>
	
</bean>
	
<bean id="applicationSettings" class="ModelGlue.Bean.CommonBeans.SimpleConfig">
	<property name="config">
		<map>
			<entry key="dsn"><value>lighthousepro</value></entry>
			<entry key="adminemail"><value>admin@localhost.com</value></entry>
			<entry key="username"><value></value></entry>
			<entry key="password"><value></value></entry>
			<entry key="dbtype"><value>mysql</value></entry>
			<entry key="secretkey"><value>wef320949879032dfhjhlds%^#</value></entry>
			<entry key="mailusername"><value></value></entry>
			<entry key="mailpassword"><value></value></entry>
			<entry key="mailserver"><value></value></entry>
			<entry key="mailpassword"><value></value></entry>
			<entry key="plaintextpassword"><value>true</value></entry>
			<entry key="rssfeedsenabled"><value>true</value></entry>
			<entry key="version"><value>2.6.1.003</value></entry>
		</map>
	</property>
</bean>

<bean id="announcementService" class="lhp.model.AnnouncementService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="announcementGateway"><ref bean="announcementGateway" /></constructor-arg>
</bean>		
<bean id="announcementGateway" class="lhp.model.AnnouncementGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="issueService" class="lhp.model.IssueService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="issueGateway"><ref bean="issueGateway" /></constructor-arg>
</bean>		
<bean id="issueGateway" class="lhp.model.IssueGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="issueTypeService" class="lhp.model.IssueTypeService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="issueTypeGateway"><ref bean="issueTypeGateway" /></constructor-arg>
</bean>		
<bean id="issueTypeGateway" class="lhp.model.IssueTypeGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>	

<bean id="mailService" class="lhp.model.MailService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="milestoneService" class="lhp.model.MilestoneService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="milestoneGateway"><ref bean="milestoneGateway" /></constructor-arg>
</bean>		
<bean id="milestoneGateway" class="lhp.model.MilestoneGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="projectAreaService" class="lhp.model.ProjectAreaService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="projectAreaGateway"><ref bean="projectAreaGateway" /></constructor-arg>
</bean>		
<bean id="projectAreaGateway" class="lhp.model.ProjectAreaGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="projectService" class="lhp.model.ProjectService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="projectGateway"><ref bean="projectGateway" /></constructor-arg>
</bean>		
<bean id="projectGateway" class="lhp.model.ProjectGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="severityService" class="lhp.model.SeverityService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="severityGateway"><ref bean="severityGateway" /></constructor-arg>
</bean>		
<bean id="severityGateway" class="lhp.model.SeverityGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		

<bean id="statusService" class="lhp.model.StatusService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="statusGateway"><ref bean="statusGateway" /></constructor-arg>
</bean>		
<bean id="statusGateway" class="lhp.model.StatusGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>	
	
<bean id="userService" class="lhp.model.UserService">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
	<constructor-arg name="userGateway"><ref bean="userGateway" /></constructor-arg>
</bean>		
<bean id="userGateway" class="lhp.model.UserGateway">
	<constructor-arg name="settings"><ref bean="applicationSettings" /></constructor-arg>
</bean>		
	

</beans>