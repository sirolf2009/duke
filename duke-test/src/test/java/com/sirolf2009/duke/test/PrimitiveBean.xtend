package com.sirolf2009.duke.test

import com.sirolf2009.duke.core.DBEntity
import com.sirolf2009.duke.core.ID

@DBEntity class PrimitiveBean {
	
	@ID var int intNumber
	var long longNumber
	var double doubleNumber
	var byte byteNumber
	var short shortNumber
	
	override equals(Object object) {
		if(object instanceof PrimitiveBean) {
			val other = object as PrimitiveBean
			return intNumber == other.intNumber && longNumber == other.longNumber && doubleNumber == other.doubleNumber && byteNumber == other.byteNumber && shortNumber == other.shortNumber
		}
		return false
	}
	
}