package eu.europa.ec.rdg.eris.document.common;

import org.apache.commons.lang.StringUtils;

import eu.europa.ec.research.fp.model.document.v5.DocumentAttachmentRefType;
import eu.europa.ec.research.fp.model.document_ref.v3.DocumentRefType;

public abstract class AbstractAttachmentUtil {
	
	protected static final String HERMES = "HERMES";

	protected static final void validateAttachmentName(final String attachmentName) {
		if (StringUtils.isBlank(attachmentName)) {
			throw new ErisClientException("Attachment name cannot be empty", ErisClientErrorCode.ATTACHMENT_NAME_CANNOT_BE_EMPTY);
		}
		if (StringUtil.hasIllegalCharacters(attachmentName)) {
			throw new ErisClientException("Attachment name contains one or more of the following illegal characters: " + StringUtil.ILLEGAL_CHARACTERS, ErisClientErrorCode.ATTACHMENT_NAME_CONTAINS_ILLEGAL_CHARACTERS);
		}
	}

	protected static final void validateAndFixAttachmentDocumentRef(final DocumentRefType documentRef) {
		if (documentRef == null) {
			throw new ErisClientException("DocumentRef cannot be null", ErisClientErrorCode.DOCUMENT_REF_CANNOT_BE_EMPTY);
		}
		SchemaUtil.fix(documentRef);
		if (StringUtils.isBlank(documentRef.getMasterID())) {
			throw new ErisClientException("MasterID cannot be empty", ErisClientErrorCode.MASTER_ID_CANNOT_BE_EMPTY);
		}
	}

	public static final void validateAndFixDownloadAttachmentType(final DocumentAttachmentRefType attachmentRef) {
		if (attachmentRef.getAttachmentIdOrAttachmentName() == null) {
			throw new ErisClientException("Invalid DownloadDocAttachmentType, getAttachmentRef().getAttachmentIdOrAttachmentName() is null", ErisClientErrorCode.DOWNLOADDOCATTACHMENTTYPE_IS_INVALID);
		}

		if (StringUtils.isBlank(attachmentRef.getMaster())) {
			attachmentRef.setMaster(HERMES);
		}
		if (StringUtils.isBlank(attachmentRef.getMasterID())) {
			throw new ErisClientException("MasterID cannot be empty", ErisClientErrorCode.MASTER_ID_CANNOT_BE_EMPTY);
		}
	}
	
	public static final String buildFileNameWithExtension(final String attachmentName, final String extension) {
		String fileNameWithExtension = null;
		if (StringUtils.isBlank(extension)) {
			fileNameWithExtension = attachmentName;
		} else {
			fileNameWithExtension = attachmentName + "." + extension;
		}
		return fileNameWithExtension;
	}

}
