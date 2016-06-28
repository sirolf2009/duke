package com.sirolf2009.duke.test

import org.junit.Test
import com.sirolf2009.duke.core.Duke
import junit.framework.Assert

class TestDuke {
	
	@Test
	def void testPrimitiveBeanWriting() {
		val bean = new PrimitiveBean(1, 2, 3, 4 as byte, 5 as short)
		val duke = new Duke("src/test/resources/testPrimitiveBeanWriting", "com.sirolf2009.duke.test")
		duke.save(bean)
	}
	
	@Test
	def void testPrimitiveBean() {
		val bean = new PrimitiveBean(1, 2, 3, 4 as byte, 5 as short)
		val duke = new Duke("src/test/resources/testPrimitiveBean", "com.sirolf2009.duke.test")
		duke.save(bean)
		val newBean = duke.read(1, PrimitiveBean)
		Assert.assertEquals(bean, newBean)
	}
	
	@Test
	def void testPrimitiveBeanOverwriting() {
		val bean = new PrimitiveBean(1, 2, 3, 4 as byte, 5 as short)
		val duke = new Duke("src/test/resources/testPrimitiveBeanOverwriting", "com.sirolf2009.duke.test")
		duke.save(bean)
		val newBean = duke.read(1, PrimitiveBean)
		newBean.doubleNumber = 6
		duke.save(newBean)
		val newestBean = duke.read(1, PrimitiveBean)
		Assert.assertEquals(newBean, newestBean)
	}
	
	@Test
	def void testPrimitiveArrayBeanWriting() {
		val bean = new PrimitiveArrayBean("ID", #[1], #[2, 3], #[3, 4, 5], #[4 as byte], #[])
		val duke = new Duke("src/test/resources/testPrimitiveBeanArrayWriting", "com.sirolf2009.duke.test")
		duke.save(bean)
	}
	
	@Test
	def void testPrimitiveArrayBean() {
		val bean = new PrimitiveArrayBean("ID", #[1], #[2, 3], #[3, 4, 5], #[4 as byte], #[])
		val duke = new Duke("src/test/resources/testPrimitiveArrayBean", "com.sirolf2009.duke.test")
		duke.save(bean)
		val newBean = duke.read("ID", PrimitiveArrayBean)
		Assert.assertEquals(bean, newBean)
	}
	
	@Test
	def void testPrimitiveArrayBeanOverwriting() {
		val bean = new PrimitiveArrayBean("ID", #[1], #[2, 3], #[3, 4, 5], #[4 as byte], #[])
		val duke = new Duke("src/test/resources/testPrimitiveArrayBeanOverwriting", "com.sirolf2009.duke.test")
		duke.save(bean)
		val newBean = duke.read("ID", PrimitiveArrayBean)
		newBean.doubleArray = #[]
		duke.save(newBean)
		val newestBean = duke.read("ID", PrimitiveArrayBean)
		Assert.assertEquals(newBean, newestBean)
	}
	
}