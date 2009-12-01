<cfcomponent name="PigLatinTranslator" output="false">

<cffunction name="init" returntype="any" access="public" output="false">
<cfargument name="vowels" type="string" required="true" />

<cfset variables.vowels = arguments.vowels />

<cfreturn this />
</cffunction>

<cffunction name="translate" returntype="string" access="public" output="false">
	<cfargument name="phrase" />
 
	<cfset var result = "" />
	<cfset var word = "" />
	
	<cfloop list="#arguments.phrase#" delimiters=" " index="word">
		<cfset result = result & translateWord(word) & " " /> 
	</cfloop>
	
	<cfreturn result />
</cffunction>

<cffunction name="translateWord" returntype="string" access="public" output="false">
<cfargument name="phrase" />
 
<cfset var firstVowel = reFindNoCase("[#variables.vowels#]", arguments.phrase) - 1/>
<cfset var result = trim(arguments.phrase) />
 
<!--- We started with a consonant --->
<cfif len(result) and firstVowel gt 0>
<cfset result = right(arguments.phrase, len(arguments.phrase) - firstVowel) & left(arguments.phrase, firstVowel) & "ay" />
<!--- We started with a vowel --->
<cfelseif len(result)>
<cfset result = result & "ay" />
</cfif>
 
<cfreturn result />
</cffunction>

 

</cfcomponent>