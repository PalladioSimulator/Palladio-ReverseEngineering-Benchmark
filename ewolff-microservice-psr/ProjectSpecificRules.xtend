package org.palladiosimulator.retriever.extraction.rules

import java.nio.file.Path
import java.util.Set
import org.eclipse.jdt.core.dom.CompilationUnit
import org.palladiosimulator.retriever.services.blackboard.RetrieverBlackboard
import org.palladiosimulator.retriever.services.Rule
import org.palladiosimulator.retriever.extraction.commonalities.CompUnitOrName
import org.palladiosimulator.retriever.extraction.engine.PCMDetector
import org.palladiosimulator.retriever.extraction.commonalities.RESTName

class ProjectSpecificRules implements Rule {
	public static final String RULE_ID = "org.palladiosimulator.retriever.extraction.rules.ewolff"
	public static final String JAVA_DISCOVERER_ID = "org.palladiosimulator.retriever.extraction.discoverers.java";
	public static final String SPRING_RULE_ID = "org.palladiosimulator.retriever.extraction.rules.spring";
	public static final String ECMASCRIPT_RULE_ID = "org.palladiosimulator.retriever.extraction.rules.ecmascript"
	public static final String ECMASCRIPT_ROUTES_ID = "org.palladiosimulator.retriever.extraction.rules.ecmascript.routes"
	public static final String ECMASCRIPT_HOSTNAMES_ID = "org.palladiosimulator.retriever.extraction.rules.ecmascript.hostnames"

	override processRules(RetrieverBlackboard blackboard, Path path) {
		val unit = blackboard.getDiscoveredFiles(JAVA_DISCOVERER_ID, CompilationUnit).get(path)
		if (unit === null) {
			return
		}
		
		val identifier = new CompUnitOrName(unit);
		val pcmDetector = blackboard.PCMDetector as PCMDetector;
		if (identifier.name.endsWith("Client")) {
			val lastSegment = identifier.name.lastIndexOf('.') + 1;
			val target = identifier.name.substring(lastSegment, identifier.name.length - "Client".length)
			pcmDetector.detectCompositeRequiredInterface(identifier, new RESTName(target.toLowerCase, "/*.html"))
		}
	}

	override isBuildRule() {
		return false
	}

	override getConfigurationKeys() {
		return Set.of
	}

	override getID() {
		return RULE_ID
	}

	override getName() {
		return "Ewolff Rules"
	}

	override getRequiredServices() {
		return Set.of(JAVA_DISCOVERER_ID, ECMASCRIPT_RULE_ID)
	}

	override getDependentServices() {
		Set.of(SPRING_RULE_ID)
	}
}
