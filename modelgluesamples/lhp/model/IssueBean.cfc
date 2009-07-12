<cfcomponent output="false" displayName="User Bean" hint="Manages an Issue.">

	<cfset variables.instance = structNew() />
	<cfset variables.instance.id = 0 />
	<cfset variables.instance.projectidfk = "" />
	<cfset variables.instance.created = "" />
	<cfset variables.instance.updated = "" />
	<cfset variables.instance.name = "" />
	<cfset variables.instance.useridfk = "" />
	<cfset variables.instance.creatoridfk = "" />
	<cfset variables.instance.description = "" />
	<cfset variables.instance.history = "" />
	<cfset variables.instance.locusidfk = "" />
	<cfset variables.instance.severityidfk = "" />
	<cfset variables.instance.statusidfk = "" />
	<cfset variables.instance.relatedurl = "" />
	<cfset variables.instance.publicid = "" />
	<cfset variables.instance.duedate = "" />
	<cfset variables.instance.issuetypeidfk = "" />
	<cfset variables.instance.milestoneidfk = "" />
		
	<cffunction name="setID" returnType="void" access="public" output="false">
		<cfargument name="id" type="string" required="true">
		<cfset variables.instance.id = arguments.id>
	</cffunction>

	<cffunction name="getID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.id>
	</cffunction>

	<cffunction name="setProjectIDFK" returnType="void" access="public" output="false">
		<cfargument name="projectidfk" type="string" required="true">
		<cfset variables.instance.projectidfk = arguments.projectidfk>
	</cffunction>
  
	<cffunction name="getProjectIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.projectidfk>
	</cffunction>

	<cffunction name="setCreated" returnType="void" access="public" output="false">
		<cfargument name="created" type="string" required="true">
		<cfset variables.instance.created = arguments.created>
	</cffunction>
  
	<cffunction name="getCreated" returnType="string" access="public" output="false">
		<cfreturn variables.instance.created>
	</cffunction>
	
	<cffunction name="setUpdated" returnType="void" access="public" output="false">
		<cfargument name="updated" type="string" required="true">
		<cfset variables.instance.updated = arguments.updated>
	</cffunction>
  
	<cffunction name="getUpdated" returnType="string" access="public" output="false">
		<cfreturn variables.instance.updated>
	</cffunction>
	
	<cffunction name="setName" returnType="void" access="public" output="false">
		<cfargument name="name" type="string" required="true">
		<cfset variables.instance.name = arguments.name>
	</cffunction>
  
	<cffunction name="getName" returnType="string" access="public" output="false">
		<cfreturn variables.instance.name>
	</cffunction>
	
	<cffunction name="setUserIDFK" returnType="void" access="public" output="false">
		<cfargument name="useridfk" type="string" required="true">
		<cfset variables.instance.useridfk = arguments.useridfk>
	</cffunction>
  
	<cffunction name="getUserIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.useridfk>
	</cffunction>
	
	<cffunction name="setCreatorIDFK" returnType="void" access="public" output="false">
		<cfargument name="creatoridfk" type="string" required="true">
		<cfset variables.instance.creatoridfk = arguments.creatoridfk>
	</cffunction>
	
	<cffunction name="getCreatorIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.creatoridfk>
	</cffunction>
	
	<cffunction name="setDescription" returnType="void" access="public" output="false">
		<cfargument name="description" type="string" required="true">
		<cfset variables.instance.description = arguments.description>
	</cffunction>
  
	<cffunction name="getDescription" returnType="string" access="public" output="false">
		<cfreturn variables.instance.description>
	</cffunction>

	<cffunction name="setHistory" returnType="void" access="public" output="false">
		<cfargument name="history" type="string" required="true">
		<cfset variables.instance.history = arguments.history>
	</cffunction>
  
	<cffunction name="getHistory" returnType="string" access="public" output="false">
		<cfreturn variables.instance.history>
	</cffunction>

	<cffunction name="setLocusIDFK" returnType="void" access="public" output="false">
		<cfargument name="locusidfk" type="string" required="true">
		<cfset variables.instance.locusidfk = arguments.locusidfk>
	</cffunction>
  
	<cffunction name="getLocusIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.locusidfk>
	</cffunction>

	<cffunction name="setSeverityIDFK" returnType="void" access="public" output="false">
		<cfargument name="severityIDFK" type="string" required="true">
		<cfset variables.instance.severityIDFK = arguments.severityIDFK>
	</cffunction>
  
	<cffunction name="getSeverityIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.severityIDFK>
	</cffunction>

	<cffunction name="setStatusIDFK" returnType="void" access="public" output="false">
		<cfargument name="statusIDFK" type="string" required="true">
		<cfset variables.instance.statusIDFK = arguments.statusIDFK>
	</cffunction>
  
	<cffunction name="getStatusIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.statusIDFK>
	</cffunction>

	<cffunction name="setRelatedURL" returnType="void" access="public" output="false">
		<cfargument name="relatedURL" type="string" required="true">
		<cfset variables.instance.relatedURL = arguments.relatedURL>
	</cffunction>
  
	<cffunction name="getRelatedURL" returnType="string" access="public" output="false">
		<cfreturn variables.instance.relatedURL>
	</cffunction>
	
	<cffunction name="setPublicID" returnType="void" access="public" output="false">
		<cfargument name="publicid" type="string" required="true">
		<cfset variables.instance.publicid = arguments.publicid>
	</cffunction>
	
	<cffunction name="getPublicID" returnType="string" access="public" output="false">
		<cfreturn variables.instance.publicid>
	</cffunction>
	
	<cffunction name="setDueDate" returnType="void" access="public" output="false">
		<cfargument name="duedate" type="string" required="true">
		<cfset variables.instance.duedate = arguments.duedate>
	</cffunction>
	
	<cffunction name="getDueDate" returnType="string" access="public" output="false">
		<cfreturn variables.instance.duedate>
	</cffunction>

	<cffunction name="setIssueTypeIDFK" returnType="void" access="public" output="false">
		<cfargument name="issuetypeidfk" type="string" required="true">
		<cfset variables.instance.issuetypeidfk = arguments.issuetypeidfk>
	</cffunction>
  
	<cffunction name="getIssueTypeIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.issuetypeidfk>
	</cffunction>

	<cffunction name="setMilestoneIDFK" returnType="void" access="public" output="false">
		<cfargument name="milestoneidfk" type="string" required="true">
		<cfset variables.instance.milestoneidfk = arguments.milestoneidfk>
	</cffunction>
  
	<cffunction name="getMilestoneIDFK" returnType="string" access="public" output="false">
		<cfreturn variables.instance.milestoneidfk>
	</cffunction>

	<cffunction name="validate" returnType="array" access="public" output="false">
		<cfset var errors = arrayNew(1)>

		<cfif not len(trim(getProjectIDFK()))>
			<cfset arrayAppend(errors,"ProjectIDFK cannot be blank.")>
		</cfif>

		<cfif not len(trim(getCreated())) or not isDate(getCreated())>
			<cfset arrayAppend(errors,"Created cannot be blank and must be a valid date.")>
		</cfif>

		<cfif not len(trim(getUpdated())) or not isDate(getUpdated())>
			<cfset arrayAppend(errors,"Updated cannot be blank and must be a valid date.")>
		</cfif>
				
		<cfif not len(trim(getName()))>
			<cfset arrayAppend(errors,"Name cannot be blank.")>
		</cfif>

		<cfif not len(trim(getUserIDFK()))>
			<cfset arrayAppend(errors,"UserIDFK cannot be blank.")>
		</cfif>

		<!---
		<cfif not len(trim(getCreatorIDFK()))>
			<cfset arrayAppend(errors,"CreatorIDFK cannot be blank.")>
		</cfif>
		--->
		
		<cfif not len(trim(getDescription()))>
			<cfset arrayAppend(errors,"Description cannot be blank.")>
		</cfif>

		<cfif not len(trim(getIssueTypeIDFK()))>
			<cfset arrayAppend(errors,"IssueTypeIDFK cannot be blank.")>
		</cfif>


		<cfif not len(trim(getLocusIDFK()))>
			<cfset arrayAppend(errors,"LocusIDFK cannot be blank.")>
		</cfif>

		<cfif not len(trim(getSeverityIDFK()))>
			<cfset arrayAppend(errors,"SeverityIDFK cannot be blank.")>
		</cfif>

		<cfif not len(trim(getStatusIDFK()))>
			<cfset arrayAppend(errors,"StatusIDFK cannot be blank.")>
		</cfif>

		<cfif len(getRelatedURL()) and not isValid("url", getRelatedURL())>
			<cfset arrayAppend(errors,"Related URL must be a valid URL.")>
		</cfif>

		<cfif len(getDueDate()) and not isDate(getDueDate())>
			<cfset arrayAppend(errors, "Due date is not a valid date.")>
		</cfif>
		
		<cfreturn errors>
	</cffunction>
	
	<cffunction name="getInstance" returnType="struct" access="public" output="false">
		<cfreturn duplicate(variables.instance)>
	</cffunction>

	<cffunction name="addAttachment" access="public" returnType="void" output="false">
		<cfargument name="attachment" type="string" required="true">
		<cfargument name="filename" type="string" required="true">
		
		<cfquery datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
		insert into lh_attachments(id, issueidfk, attachment, filename)
		values(
			<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#createUUID()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#getId()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#arguments.attachment#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="255" value="#arguments.filename#">
			)			
		</cfquery>
				
	</cffunction>
	
	<cffunction name="getAttachments" access="public" returnType="query" output="false"
				hint="Returns all attachments assigned to an issue.">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
		select	id, issueidfk, attachment, filename
		from	lh_attachments
		where	issueidfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#getId()#">
		</cfquery>

		<cfreturn q>
	</cffunction>
	
	<cffunction name="removeAttachment" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">
		
		<cfquery datasource="#variables.config.dsn#" username="#variables.config.username#" password="#variables.config.password#">
		delete 	from lh_attachments
		where	issueidfk = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#getId()#">
		and		id = <cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#arguments.id#">		
		</cfquery>
		
	</cffunction>
	
	<cffunction name="setConfig" returnType="void" access="public" output="false" hint="Used to let me inject settings.">
		<cfargument name="config" type="any" required="true">
		<cfset variables.config = arguments.config>
	</cffunction>

</cfcomponent>	
