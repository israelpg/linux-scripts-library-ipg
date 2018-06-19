package eu.europa.ec.rdg.eris.services.attachmentcomparison.v1;

import eu.europa.ec.rdg.eris.attachmentcomparison.v1.AttachmentComparisonRequestType;
import eu.europa.ec.rdg.eris.document.common.ErisClientException;

public interface IErisAttachmentComparisonClient {

	/** The url part for Eris comparison page. */
	public static final String SUFFIX_COMPARISON_PAGE = "/compareattachments";

	/**
	 * @param request The request object
	 * @return the url of the comparison to be called in Eris
	 * @throws ErisClientException If anything goes wrong
	 */
	String getAttachmentsComparisonPageUrl(AttachmentComparisonRequestType request) throws ErisClientException;

}
