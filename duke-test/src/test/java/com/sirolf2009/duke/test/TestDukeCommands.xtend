package com.sirolf2009.duke.test

import com.sirolf2009.duke.core.Duke
import org.junit.Test

class TestDukeCommands {
	
	@Test
	def void testSimpleCommand() {
		val bean1 = new PrimitiveBean(1, 2, 3, 4 as byte, 5 as short)
		val bean2 = new PrimitiveBean(2, 2, 3, 4 as byte, 5 as short)
		val bean3 = new PrimitiveBean(3, 2, 3, 4 as byte, 5 as short)
		val bean4 = new PrimitiveBean(4, 2, 3, 4 as byte, 5 as short)
		val bean5 = new PrimitiveBean(5, 2, 3, 4 as byte, 5 as short)
		val bean6 = new PrimitiveBean(6, 2, 3, 4 as byte, 5 as short)
		val duke = new Duke("src/test/resources/testPrimitiveBeanOverwriting", "com.sirolf2009.duke.test")
		duke.saveAll(#[bean1, bean2, bean3, bean4, bean5, bean6])
		println(duke.all(PrimitiveBean).filter[it.intNumber == 6].get(0))
	}
	
}