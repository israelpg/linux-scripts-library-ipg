package eu.europa.ec.rdg.eris.document.v5.util;

import eu.europa.ec.rdg.eris.document.common.AbstractAttachmentUtil;
import eu.europa.ec.rdg.eris.document.common.SchemaUtil;
import eu.europa.ec.research.fp.model.header.v1.HeaderType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.UploadDocAttachmentType;

public class AttachmentUtil extends AbstractAttachmentUtil {

	/**
	 * Validates the attachment to be uploaded. Validation will fail if illegal characters are used, if the UploadDocAttachmentType object has no document
	 * reference or if the MasterID of the document reference is empty
	 * 
	 * @param attType Object that contains all information of the attachment to be uploaded
	 */
	public static void validateAttachment(UploadDocAttachmentType attType) {
		validateAttachmentName(attType.getAttachmentName());

		SchemaUtil.fix(attType.getAttachmentType());
		if (attType.getHeader() == null) {
			attType.setHeader(new HeaderType());
		}
		
		validateAndFixAttachmentDocumentRef(attType.getDocumentRef());

	}
}
