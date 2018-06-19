package eu.europa.ec.rdg.eris.utils;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import eu.europa.ec.rdg.ccm2.Ccm2CacheHelper;
import eu.europa.ec.rdg.ccm2.domain.Ccm2Context;
import eu.europa.ec.rdg.ccm2.domain.Ccm2Type;
import eu.europa.ec.rdg.ccm2.domain.CcmCode;
import eu.europa.ec.rdg.ccm2.exception.CcmCodeNotFoundException;
import eu.europa.ec.rdg.ccm2.exception.TransformerException;
import eu.europa.ec.rdg.framework.errorhandling.exception.IllegalArgumentException;
import eu.europa.ec.rdg.framework.errorhandling.exception.base.RdgError;
import eu.europa.ec.rdg.framework.errorhandling.exception.base.RdgExceptionLayer;
import eu.europa.ec.rdg.framework.util.MapperUtils;
import eu.europa.ec.rdg.framework.util.ValidateUtils;
import eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType;

public abstract class Ccm2CodeUtil {

	public static final String SUPPLEMENTARY_PROPERTY_HIERARCHY_TYPE = "ECHierarchy.HierarchyType";
	public static final String SUPPLEMENTARY_PROPERTY_HIERARCHY_TYPE_DG = "DG";
	public static final String SUPPLEMENTARY_PROPERTY_HIERARCHY_TYPE_DIR = "DIR";
	public static final String SUPPLEMENTARY_PROPERTY_HIERARCHY_TYPE_UNIT = "UNIT";

	private static final Ccm2CacheHelper ccm2 = new Ccm2CacheHelper();

	public static Integer getCcmCode(final eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType c) throws TransformerException {
		if (c == null || c.getId() == null || "0".equals(c.getId())) {
			return null;
		}
		return Integer.valueOf(c.getId());
	}

	public static Integer getCcmCode(final eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType c) throws TransformerException {
		if (c == null || c.getId() == null || "0".equals(c.getId())) {
			return null;
		}
		return Integer.valueOf(c.getId());
	}

	public static CcmCode getCcmCodeFull(final eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType c) throws TransformerException {
		if (c == null || c.getId() == null || "0".equals(c.getId())) {
			return null;
		}

		CcmCode ccmCode = new CcmCode();
		ccmCode.setId(MapperUtils.getInteger(c.getId()));
		ccmCode.setDescription(c.getDescription());
		ccmCode.setAbbreviation(c.getAbbreviation());
		return ccmCode;
	}

	public static CcmCode convertToCcmCode(final String idOrAbbr) {
		if (idOrAbbr == null) {
			return null;
		}
		try {
			Integer ccmId = Integer.valueOf(idOrAbbr);
			return new CcmCode(ccmId);
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException(RdgError.ILLEGAL_ARGUMENT, RdgExceptionLayer.BUSINESS, "Invalid CcmCode");
		}
	}

	public static CcmCode convertToValidCcmCode(final Ccm2Context ctx, final Ccm2Type type, final String idOrAbbr) {
		if (idOrAbbr == null) {
			return null;
		}
		try {
			Integer ccmId = Integer.valueOf(idOrAbbr);
			return new CcmCode(ccmId);
		} catch (NumberFormatException e) {
			try {
				return ccm2.getCodeByTypeAndAbbreviation(ctx, type, idOrAbbr);
			} catch (CcmCodeNotFoundException e1) {
				throw new IllegalArgumentException(RdgError.ILLEGAL_ARGUMENT, RdgExceptionLayer.BUSINESS, "Invalid CcmCode");
			}
		}
	}

	public static eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType getCodeRefV2(final CcmCode c) throws TransformerException {
		if (c == null || c.getId() == null || Integer.valueOf(0).equals(c.getId())) {
			return null;
		}
		eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType code = getV2CodeRefType();
		code.setId(c.getId().toString());
		code.setAbbreviation(c.getAbbreviation());
		code.setDescription(c.getDescription());
		if (c.getType() != null) {
			code.setType(c.getType().toString());
		}
		return code;
	}

	public static Collection<eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType> getCollectionOfCodeRefV3(final Collection<CcmCode> ccmCodes)
			throws TransformerException {
		if (!ValidateUtils.validateCollection(ccmCodes)) {
			return null;
		}

		List<eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType> listOfCodeRefs = new ArrayList<>();
		for (CcmCode c : ccmCodes) {
			listOfCodeRefs.add(getCodeRefV3(c));
		}

		return listOfCodeRefs;
	}

	public static Set<CcmCode> getCollectionOfCcmCodes(final Collection<eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType> codeRefs)
			throws TransformerException {
		if (!ValidateUtils.validateCollection(codeRefs)) {
			return null;
		}

		Set<CcmCode> setCcmCodes = new HashSet<>();
		Integer ccmId;
		for (CodeRefType c : codeRefs) {
			ccmId = getCcmCode(c);
			if (ccmId != null) {
				setCcmCodes.add(new CcmCode(ccmId));
			}
		}

		return setCcmCodes;
	}

	public static Collection<eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType> getCollectionOfCodeRefV2(final Collection<CcmCode> ccmCodes)
			throws TransformerException {
		if (!ValidateUtils.validateCollection(ccmCodes)) {
			return null;
		}

		List<eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType> listOfCodeRefs = new ArrayList<>();
		for (CcmCode c : ccmCodes) {
			listOfCodeRefs.add(getCodeRefV2(c));
		}

		return listOfCodeRefs;
	}

	public static eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType getCodeRefV3(final CcmCode c) throws TransformerException {
		if (c == null || c.getId() == null || Integer.valueOf(0).equals(c.getId())) {
			return null;
		}
		eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType code = getV3CodeRefType();
		code.setId(c.getId().toString());
		code.setAbbreviation(c.getAbbreviation());
		code.setDescription(c.getDescription());
		if (c.getType() != null) {
			code.setClassId(c.getType().toString());
		}
		return code;
	}

	public static eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType getCodeRefV2(final String id) throws TransformerException {
		if (id == null || "0".equals(id)) {
			return null;
		}
		eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType code = getV2CodeRefType();
		code.setId(id);
		return code;
	}

	public static eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType getCodeRefV3(final String id) throws TransformerException {
		if (id == null || "0".equals(id)) {
			return null;
		}
		eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType code = getV3CodeRefType();
		code.setId(id);
		return code;
	}

	private static final eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType getV2CodeRefType() {
		return new eu.europa.ec.research.fp.model.code_ref.v2.CodeRefType();
	}

	private static final eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType getV3CodeRefType() {
		return new eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType();
	}

}