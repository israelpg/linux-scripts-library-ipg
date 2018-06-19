package eu.europa.ec.rdg.eris.document.v4;

import java.io.InputStream;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;

import eu.europa.ec.rdg.eris.document.common.AbstractErisHttpClient;
import eu.europa.ec.rdg.eris.document.common.AttachmentDownloadWrapper;
import eu.europa.ec.rdg.eris.document.common.ErisClientErrorCode;
import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.rdg.eris.document.v4.util.AttachmentUtil;
import eu.europa.ec.research.fp.services.document_management.interfaces.v3.DownloadDocAttachmentType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v3.ObjectFactory;
import eu.europa.ec.research.fp.services.document_management.interfaces.v3.UploadDocAttachmentType;

public final class ErisHttpClientImpl extends AbstractErisHttpClient implements IErisHttpClient {

	protected ErisHttpClientImpl(String servletBaseUrl, String user, String password, boolean ecasAuthIsActive) {
		super(servletBaseUrl, user, password, ecasAuthIsActive);
	}

	@Override
	public AttachmentDownloadWrapper downloadAttachment(DownloadDocAttachmentType attRef) throws ErisClientException {
		AttachmentUtil.validateAndFixDownloadAttachmentType(attRef.getAttachmentRef());
		try {
			return doDownloadAttachment(getXML(attRef), false, false);
		} catch (Exception e) {
			logger.error(e);
			throw new ErisClientException("Eris client error downloading attachment", e, ErisClientErrorCode.ERROR_DOWNLOADING_ATTACHMENT);
		}
	}

	@Override
	public AttachmentDownloadWrapper downloadAttachment(DownloadDocAttachmentType attRef, boolean original) throws ErisClientException {
		AttachmentUtil.validateAndFixDownloadAttachmentType(attRef.getAttachmentRef());
		try {
			return doDownloadAttachment(getXML(attRef), original, false);
		} catch (Exception e) {
			logger.error(e);
			throw new ErisClientException("Eris client error downloading attachment", e, ErisClientErrorCode.ERROR_DOWNLOADING_ATTACHMENT);
		}
	}
	
	@Override
	public String uploadAttachment(UploadDocAttachmentType attType, InputStream in, String contentType, String fileExtension) throws ErisClientException {
		AttachmentUtil.validateAttachment(attType);
		try {
			return doUploadAttachment(getXML(attType), in, contentType, AttachmentUtil.buildFileNameWithExtension(attType.getAttachmentName(), fileExtension));
		} catch (Exception e) {
			logger.error(e);
			throw new ErisClientException("Error uploading attachment", e, ErisClientErrorCode.ERROR_UPLOADING_ATTACHMENT);
		}
	}

	@Override
	protected <T> JAXBElement<?> getJAXBElement(T t) throws JAXBException {
		
		JAXBElement<?> jax = null;
		if (t instanceof UploadDocAttachmentType) {
			jax = new ObjectFactory().createUploadDocAttachmentRequest((UploadDocAttachmentType) t);
		} else {
			jax = new ObjectFactory().createDownloadDocAttachmentRequest((DownloadDocAttachmentType) t);
		}
		return jax;
		
	}

}
