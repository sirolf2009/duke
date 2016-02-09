package com.sirolf2009.duke.bean

import com.sirolf2009.duke.core.ID
import com.sirolf2009.duke.core.DBEntity
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.EqualsHashCode

@DBEntity
@Accessors
@EqualsHashCode
class SimpleBean {
	
	@ID
	int integerValue
	double doubleValue
	short shortValue
	long longValue
	byte byteValue
	float floatValue
	boolean booleanValue
	char charValue
	
}