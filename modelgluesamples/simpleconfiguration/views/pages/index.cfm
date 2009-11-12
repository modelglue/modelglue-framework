<h3>Proof it works:</h3>

<p><em>This application is using an XML file to configure its datasource name and default date format:</em></p>
 
<cfoutput>
My datasource name is #event.getValue("datasourceName")#, and a formatted date is #dateFormat(now(), event.getValue("dateFormat"))#.
</cfoutput>

<h3>How does it work?</h3>

<p>Going the full OO-route and configuring applications with ColdSpring may not be your cup of tea.</p>

<p>However, we all understand why it's important to keep configuration information, like datasource names,
outside of our source code.</p>

<p>To help out, the Model-Glue 3 application template has a bit of XML (around line 30) 
that outlines a convenient place for you to put configuration information.  For this sample application,
it looks like this:</p>

<pre>
&lt;!-- 
	If you need your own configuration values (datasource names, etc), put them here.
	
	See modelgluesamples/simpleconfiguration/controller/Controller for an example of how to get to the values.
-->
&lt;bean id="modelglue.applicationConfiguration" class="ModelGlue.Bean.CommonBeans.SimpleConfig">
	&lt;property name="config">
		&lt;map>
			&lt;entry key="myDatasource">&lt;value>myDatasource&lt;/value>&lt;/entry>
			&lt;entry key="dateFormat">&lt;value>mmmm d, yyyy&lt;/value>&lt;/entry>
		&lt;/map>
	&lt;/property>
&lt;/bean>
</pre>

<p>
When you want to access a value from your configuration, you'll need to use a Controller.  It's handy
to have configuration values accessed and set into your event when the request starts.
</p>

<p>
This application does this by:
</p>

<ol>
<li>Wiring the "modelglue.applicationConfiguration" bean to its Controller.cfc using the "beans" attribute of &lt;cfcomponent>

<pre>
&lt;cfcomponent 
  output="false" 
  extends="ModelGlue.gesture.controller.Controller"
  beans="modelglue.applicationConfiguration"
>
</pre>

</li>
<li>Writing a listener function called loadConfiguration() in Controller.cfc:

<pre>
&lt;cffunction name="loadConfiguration" output="false" hint="Sets configuration values into the event.">
	&lt;cfargument name="event" />
	
	&lt;cfset event.setValue("datasourceName", beans.modelglueApplicationConfiguration.getConfigSetting("myDatasource")) />
	&lt;cfset event.setValue("dateFormat", beans.modelglueApplicationConfiguration.getConfigSetting("dateFormat")) />
&lt;/cffunction>
</pre>

</li>
<li>Telling the listener function to run when the request starts, in ModelGlue.xml:

<pre>
&lt;controllers>
	&lt;controller id="Controller" type="modelgluesamples.simpleconfiguration.controller.Controller">
		&lt;message-listener message="onRequestStart" function="loadConfiguration" />
	&lt;/controller>
&lt;/controllers>
</pre>

</li>
</ol>

<h3>Going Further</h3>

If you need configuration that's not just simple strings, each entry in the &lt;map&gt; can
be a string, array, or structure.  Beyond that, if you need to configure CFCs for use in your
application as "beans," ColdSpring can help you out there as well.  Check out the framework
at <a href="http://www.coldspringframework.org">http://www.coldspringframework.org</a> - it's
how Model-Glue is built! 