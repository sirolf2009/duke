package com.sirolf2009.duke.test

import com.sirolf2009.duke.core.Duke
import com.sirolf2009.duke.core.exception.CreationException
import org.junit.Test

class TestDukeExceptions {
	
	@Test(expected=CreationException)
	def void testUnanotatedBean() {
		val bean = new UnannotatedBean()
		val duke = new Duke("src/test/resources/testUnannotatedBean", "com.sirolf2009.duke.test")
		duke.save(bean)
	}
	
}