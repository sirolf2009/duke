package com.sirolf2009.duke.core

import com.esotericsoftware.kryo.Kryo
import java.util.ArrayList
import java.util.LinkedList
import java.util.List
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.BlockingQueue
import java.util.function.Function
import org.eclipse.xtend.lib.annotations.Data
import org.reflections.Reflections

public class Connection implements Runnable {

	static Connection instance;
	Kryo kryo;
	Duke database
	@SuppressWarnings("rawtypes")
	LinkedList<MethodRequest<?>> callbacks;

	new(Duke database) {
		this.database = database
	}

	override void run() {
		kryo = new Kryo()
		getRegisterable(database.getPackagePrefix()).forEach[kryo.register(it)]
		callbacks = new LinkedList()
		while(true) {
			synchronized(this) {
				while(callbacks.isEmpty()) {
					try {
						this.wait();
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
				}
				for(MethodRequest<?> method : callbacks) {
					try {
						method.result.add(method.function.apply(kryo));
					} catch(Exception e) {
						e.printStackTrace();
					}
				}
				callbacks.clear();
			}
		}
	}

	def <R> R execute(Function<Kryo, R> function) {
		val queue = new ArrayBlockingQueue<R>(1);
		synchronized(this) {
			callbacks.add(new MethodRequest(queue as BlockingQueue<Object>, function));
			this.notifyAll();
		}
		try {
			return queue.take();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return null;
	}

	def getRegisterable(String packagePrefix) {
		val entities = new Reflections(packagePrefix).getTypesAnnotatedWith(DBEntity)
		val List<Class<?>> register = new ArrayList();
		entities.forEach[getRegisterable(it, register)]
		return register
	}

//	def List<Class<?>> getRegisterable(Class<?> clazz, List<Class<?>> register) {
//		if(Object.isAssignableFrom(clazz)) {
	//		return Arrays.stream(clazz.getDeclaredFields()).map[getRegisterable(it.type)].collect(Collectors.toList())
//		}
//		return newArrayList()
//	}
	
	def void getRegisterable(Class<?> clazz, List<Class<?>> register) {
		if(Object.isAssignableFrom(clazz) && !register.contains(clazz)) {
			register.add(clazz)
			clazz.declaredFields.forEach[getRegisterable(type, register)]
		}
	}

	def static Connection getInstance(Duke database) {
		if(instance == null) {
			instance = new Connection(database);
			new Thread(instance).start();
		}
		return instance;
	}

	@Data static class MethodRequest<R> {

		private BlockingQueue<Object> result;
		private Function<Kryo, R> function;

	}

}
