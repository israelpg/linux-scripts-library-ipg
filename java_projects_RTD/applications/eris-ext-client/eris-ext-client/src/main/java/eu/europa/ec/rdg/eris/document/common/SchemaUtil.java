package eu.europa.ec.rdg.eris.document.common;

import org.apache.commons.lang.StringUtils;

import eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType;
import eu.europa.ec.research.fp.model.document_ref.v3.DocumentRefType;

public class SchemaUtil {

	public static final String HERMES = "HERMES";
	public static final String ZERO = "0";

	public static void fix(CodeRefType paramCodeRefType) {
		if (paramCodeRefType != null && StringUtils.isBlank(paramCodeRefType.getId())) {
			paramCodeRefType.setId(ZERO);
		}
	}

	public static void fix(DocumentRefType paramDocumentRefType) {
		if (paramDocumentRefType != null && StringUtils.isEmpty(paramDocumentRefType.getMaster())) {
			paramDocumentRefType.setMaster(HERMES);
		}
	}

}
