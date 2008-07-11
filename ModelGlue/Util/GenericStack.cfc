<cfcomponent displayname="GenericStack" output="false" hint="I am a generic stack.  FIFO by default, FILO through constructor.">
	<cffunction name="init" access="public" returntype="any" output="false" hint="I build a new GenericStack">
    <cfargument name="fifo" type="any" default="true" hint="TRUE - DEFAULT - First in, first out.  FALSE - First in, last out." />
    <cfset variables.fifo = arguments.fifo />
  	<cfset variables.stack = ArrayNew(1) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="Put" access="public" returnType="void" output="false" hint="I add an item to the stack.">
		<cfargument name="item" type="any" hint="I am the item to put." />
		<cfset ArrayAppend(variables.stack, arguments.item) />
	</cffunction>
	
	<cffunction name="Get" access="public" returnType="any" output="false"  hint="I bring out (and remove) the next item in the stack.">
 		<cfset var result = variables.stack[1] />
		<cfif variables.fifo>
		  <cfset ArrayDeleteAt(variables.stack, 1) />
		<cfelse>
  		<cfset result = variables.stack[arrayLen(variables.stack)] />
		  <cfset ArrayDeleteAt(variables.stack, arrayLen(variables.stack)) />
		</cfif>
		<cfreturn result />
	</cffunction>
	
	<cffunction name="Next" access="public" returnType="any" output="false"	hint="I return next item in the stack without removing it.">
		<cfreturn variables.stack[1] />
	</cffunction>
	
	<cffunction name="Empty" access="public" returnType="void" output="false" hint="I empty the stack.">
		<cfset ArrayClear(variables.stack) />
	</cffunction>
	
	<cffunction name="IsEmpty" access="public" returnType="boolean" output="true" hint="I return whether or not the stack is empty.">
		<cfreturn not count() />
	</cffunction>
	
	<cffunction name="Count" access="public" returnType="numeric" output="false" hint="I return the size of the stack.">
		<cfreturn ArrayLen(variables.stack) />
	</cffunction>
  
  <cffunction name="Dump" access="public" returnType="array" output="false" hint="I return the contents of the stack.">
    <cfreturn variables.stack />
  </cffunction>
</cfcomponent>