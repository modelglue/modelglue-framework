component persistent="true" table="Lang"
{
	property name="LanguageId" fieldtype="id" generator="increment" type="numeric";
	property name="LanguageName" notnull="true";
	property name="Countries" fieldtype="many-to-many" cfc="Country" type="struct" structkeycolumn="countrycode" structkeytype="string" linktable="CountryLanguage" inverse="true" singularname="Country" fkcolumn="LanguageId";
	
}
