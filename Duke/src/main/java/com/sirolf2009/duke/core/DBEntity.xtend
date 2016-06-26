package com.sirolf2009.duke.core

import org.eclipse.xtend.lib.macro.AbstractClassProcessor
import org.eclipse.xtend.lib.macro.Active
import org.eclipse.xtend.lib.macro.TransformationContext
import org.eclipse.xtend.lib.macro.declaration.MutableClassDeclaration

@Active(DBEntityProcessor)
annotation DBEntity {
	
	static class DBEntityProcessor extends AbstractClassProcessor {
		
		override doTransform(MutableClassDeclaration annotatedClass, extension TransformationContext context) {
			annotatedClass => [
				addConstructor [ // No args constructor
					primarySourceElement = it
					body = ''''''
				]
				if(annotatedClass.declaredFields.size > 0) {
					addConstructor[ cons | // All args constructor
						cons.primarySourceElement = it
						annotatedClass.declaredFields.forEach [ field |
							if(!field.isStatic && !field.final) {
								cons.addParameter(field.simpleName, field.type)
							}
						]
						cons.body = '''
							«FOR field : annotatedClass.declaredFields»
								this.«field.simpleName» = «field.simpleName»;
							«ENDFOR»
						'''
					]
				}
				declaredFields.forEach [ field | // Getters and setters
					val prefix = if(field.type.simpleName == "boolean" || field.type.simpleName == "Boolean") if(field.type.simpleName.startsWith("is")) "" else "is" else "get"
					addMethod(prefix + field.simpleName.toFirstUpper) [
						primarySourceElement = field
						returnType = field.type
						body = '''return «field.simpleName»;'''
					]
					addMethod("set" + field.simpleName.toFirstUpper) [
						primarySourceElement = field
						addParameter(field.simpleName, field.type)
						body = '''this.«field.simpleName» = «field.simpleName»;'''
					]
				]
				if(declaredMethods.filter[simpleName.equals("toString")].size == 0) {
					addMethod("toString") [ // toString
						primarySourceElement = it
						returnType = String.newTypeReference()
						body = '''
							org.eclipse.xtext.xbase.lib.util.ToStringBuilder b = new org.eclipse.xtext.xbase.lib.util.ToStringBuilder(this);
							«FOR field : annotatedClass.declaredFields»
								b.add("«field.simpleName»", «field.simpleName»);
							«ENDFOR»
							return b.toString();
						'''
					]
				}
			]
		}
		
	}
	
}