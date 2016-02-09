package com.sirolf2009.duke

import org.junit.Test
import com.sirolf2009.duke.bean.SimpleBean
import com.sirolf2009.duke.core.Duke

class TestSimpleBean {
	
	@Test
	def test() {
		val duke = new Duke("src/test/resources/TestSimpleBean", "com.sirolf2009.duke")
		val bean = new SimpleBean => [
			integerValue = 1
			doubleValue = 2 as double
			shortValue = 3 as short
			longValue = 4 as long
			byteValue = 5 as byte
			floatValue = 6 as float
			booleanValue = true
			charValue = 'a'
		]
		duke.save(duke)
		duke.read(1, SimpleBean).equals(bean)
	}
	
}