package com.sirolf2009.duke.core.exception

class MissingIDException extends Exception {
	
	new(Class<?> clazz) {
		super(clazz+" has no ID field")
	}
	
}