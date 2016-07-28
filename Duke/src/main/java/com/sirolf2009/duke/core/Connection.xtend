package com.sirolf2009.duke.core

import com.esotericsoftware.kryo.Kryo
import com.esotericsoftware.kryo.Kryo.DefaultInstantiatorStrategy
import com.esotericsoftware.kryo.io.Input
import com.esotericsoftware.kryo.serializers.CollectionSerializer
import com.google.common.base.Function
import com.sirolf2009.duke.core.Connection.MethodRequest
import java.util.ArrayList
import java.util.Arrays
import java.util.Collection
import java.util.LinkedList
import java.util.List
import java.util.concurrent.ArrayBlockingQueue
import java.util.concurrent.BlockingQueue
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.Data
import org.objenesis.strategy.StdInstantiatorStrategy
import org.reflections.Reflections

public class Connection implements Runnable {

	static Connection instance
	@Accessors Kryo kryo
	Duke database
	LinkedList<MethodRequest<?>> callbacks

	new(Duke database) {
		this.database = database
		callbacks = new LinkedList()
	}

	override void run() {
		kryo = new Kryo()
		(kryo.getInstantiatorStrategy() as DefaultInstantiatorStrategy).setFallbackInstantiatorStrategy(new StdInstantiatorStrategy())
		kryo.register(Arrays.asList().getClass(), new CollectionSerializer() {
			override Collection create(Kryo kryo, Input input, Class<Collection> type) {
				return new ArrayList()
			}
		});
		getRegisterable(database.getPackagePrefix()).forEach[kryo.register(it)]
		while(true) {

			synchronized(this) {
				while(callbacks.isEmpty()) {
					try {
						this.wait()
					} catch(InterruptedException e) {
						e.printStackTrace()
					}
				}
				for (MethodRequest<?> method : callbacks) {
					try {
						method.result.add(method.function.apply(kryo))
					} catch(Exception e) {
						e.printStackTrace()
					}
				}
				callbacks.clear()
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
		} catch(InterruptedException e) {
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

		BlockingQueue<Object> result
		Function<Kryo, R> function

	}

}
