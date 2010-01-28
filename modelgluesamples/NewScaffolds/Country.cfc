component persistent="true"
{
	property name="CountryId" fieldtype="id" generator="increment" type="numeric";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="SortSequence" notnull="true" ormtype="integer";
	property name="Provinces" fieldtype="one-to-many" cfc="Province" type="array" singularname="Province" fkcolumn="CountryId" inverse="true";
	property name="Languages" fieldtype="many-to-many" cfc="Language" type="struct" structkeycolumn="LanguageName" structkeytype="string" linktable="CountryLanguage" singularname="Language" fkcolumn="CountryId";
}
