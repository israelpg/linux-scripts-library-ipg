package eu.europa.ec.rdg.eris.document.v5;

import java.io.InputStream;

import eu.europa.ec.rdg.eris.document.common.AttachmentDownloadWrapper;
import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.DownloadDocAttachmentType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.DownloadDocZipType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.UploadDocAttachmentType;

/**
 * The Interface IErisHttpClient.
 */
public interface IErisHttpClient {

	/**
	 * Downloads an attachment.
	 * 
	 * @param attRef DownloadDocAttachmentType object containing attachment info
	 * @return AttachmentDownloadWrapper containing http download info
	 * @throws ErisClientException any exception in client side
	 */
	AttachmentDownloadWrapper downloadAttachment(DownloadDocAttachmentType attRef) throws ErisClientException;

	/**
	 * Downloads an attachment.
	 * 
	 * @param attRef DownloadDocAttachmentType object containing attachment info
	 * @param original when true downloads the original otherwise downloads the stamped
	 * @return AttachmentDownloadWrapper containing http download info
	 * @throws ErisClientException any exception in client side
	 */
	AttachmentDownloadWrapper downloadAttachment(DownloadDocAttachmentType attRef, boolean original) throws ErisClientException;

	/**
	 * Uploads an attachment.
	 * 
	 * @param attType the att type
	 * @param in the in
	 * @param contentType the content type
	 * @param fileExtension the extension associated with the file that is created in the remote repository
	 * @return the string
	 * @throws ErisClientException the eris client exception
	 */
	String uploadAttachment(UploadDocAttachmentType attType, InputStream in, String contentType, String fileExtension) throws ErisClientException;

	/**
	 * Downloads a zip containing all the attachments in their original version of the given document.
	 * 
	 * @param downloadDocZipRef DownloadDocZipType object containing document info
	 * @return AttachmentDownloadWrapper containing http download info
	 * @throws ErisClientException any exception in client side
	 */
	AttachmentDownloadWrapper downloadDocZip(DownloadDocZipType downloadDocZipRef) throws ErisClientException;

	/**
	 * Downloads a zip containing all the attachments in their original/renditioned of the given document.
	 * 
	 * @param downloadDocZipRef DownloadDocZipType object containing document info
	 * @param original when true downloads the original otherwise downloads the renditioned (if available)
	 * @return AttachmentDownloadWrapper containing http download info
	 * @throws ErisClientException any exception in client side
	 */
	AttachmentDownloadWrapper downloadDocZip(DownloadDocZipType downloadDocZipRef, boolean original) throws ErisClientException;

}
