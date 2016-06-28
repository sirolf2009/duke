package com.sirolf2009.duke.test

import com.sirolf2009.duke.core.DBEntity
import com.sirolf2009.duke.core.ID
import static extension java.util.Arrays.equals

@DBEntity class PrimitiveArrayBean {
	
	@ID var String ID
	var int[] intArray
	var long[] longArray
	var double[] doubleArray
	var byte[] byteArray
	var short[] shortArray
	
	override equals(Object object) {
		if(object instanceof PrimitiveArrayBean) {
			val other = object as PrimitiveArrayBean
			return ID.equals(other.ID) && intArray.equals(other.intArray) && longArray.equals(other.longArray) && doubleArray.equals(other.doubleArray) && byteArray.equals(other.byteArray) && shortArray.equals(other.shortArray)
		}
		return false
	}
	
}