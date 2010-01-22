component persistent="true" output="false"
{
	property name="CountryId" fieldtype="id" generator="increment" type="numeric";
	property name="CountryCode" length="2" notnull="true";
	property name="CountryName" notnull="true";
	property name="SortSequence" notnull="true" ormtype="integer";
	property name="Provinces" fieldtype="one-to-many" cfc="Province" type="array" singularname="Province" fkcolumn="CountryId" inverse="true";
}
