component output="false" hint="I am the ColdFusion ORM service." {
	function init() {
		return this;
	}

	function getPropertyNames(entityName) {
		return ORMGetSessionFactory().getClassMetadata(arguments.entityName).getPropertyNames();
	}

}
