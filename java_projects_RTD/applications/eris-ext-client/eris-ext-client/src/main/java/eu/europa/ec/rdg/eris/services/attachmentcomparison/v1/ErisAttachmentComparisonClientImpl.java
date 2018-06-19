package eu.europa.ec.rdg.eris.services.attachmentcomparison.v1;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;

import eu.europa.ec.rdg.eris.document.common.ErisClientErrorCode;
import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;

import eu.europa.ec.rdg.eris.attachmentcomparison.v1.AttachmentComparisonRequestType;
import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.rdg.framework.encryption.EncryptionException;
import eu.europa.ec.rdg.framework.encryption.EncryptionHandler;
import eu.europa.ec.rdg.framework.encryption.EncryptionScheme;
import eu.europa.ec.research.fp.model.document.v5.AttachmentIdType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentNameType;

public final class ErisAttachmentComparisonClientImpl implements IErisAttachmentComparisonClient {

	private static final Logger LOGGER = Logger.getLogger(ErisAttachmentComparisonClientImpl.class);

	private final String baseUrl;

	protected ErisAttachmentComparisonClientImpl(String baseUrl) {

		String url = baseUrl;
		if (url.endsWith("/")) {
			url = url.substring(0, url.length() - 1);
		}
		this.baseUrl = url;

	}

	@Override
	public String getAttachmentsComparisonPageUrl(AttachmentComparisonRequestType request) throws ErisClientException {

		String targetUrl = baseUrl.toString() + SUFFIX_COMPARISON_PAGE;

		LOGGER.debug("Targeting url: " + targetUrl);

		URIBuilder builder;

		try {

			validateParameters(request);

			List<NameValuePair> params = this.createUrlParameters(request);
			String parameterSuffix = URLEncodedUtils.format(params, "utf-8");

			builder = new URIBuilder(targetUrl + "?" + parameterSuffix);

			URI uri = builder.build();

			return uri.toString();

		} catch (Exception e) {
			LOGGER.error(e);
			throw new ErisClientException("Eris client error comparing attachments", e, ErisClientErrorCode.ERROR_COMPARING_ATTACHMENTS);
		}
	}

	private List<NameValuePair> createUrlParameters(AttachmentComparisonRequestType attachmentComparisonRequestType) throws EncryptionException {

		EncryptionHandler encryptionHandler = new EncryptionHandler(EncryptionScheme.BLOWFISH);

		List<NameValuePair> params = new ArrayList<NameValuePair>();

		//Previous attachment

		params.add(new BasicNameValuePair("previousAttachmentDocumentId", encryptionHandler.encrypt(attachmentComparisonRequestType.getFirstAttachmentRef()
				.getMasterID())));

		if (attachmentComparisonRequestType.getFirstAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType) {
			params.add(new BasicNameValuePair("previousAttachmentName", encryptionHandler.encrypt(((AttachmentNameType) attachmentComparisonRequestType
					.getFirstAttachmentRef().getAttachmentIdOrAttachmentName()).getValue())));
		} else {
			params.add(new BasicNameValuePair("previousAttachmentId", encryptionHandler.encrypt(((AttachmentIdType) attachmentComparisonRequestType
					.getFirstAttachmentRef().getAttachmentIdOrAttachmentName()).getValue())));
		}
		String previousTagEncryptedValue = null;
		if (attachmentComparisonRequestType.getFirstAttachmentRef().getTag() != null) {
			previousTagEncryptedValue = encryptionHandler.encrypt(attachmentComparisonRequestType.getFirstAttachmentRef().getTag());
			params.add(new BasicNameValuePair("previousAttachmentTag", previousTagEncryptedValue));
		}

		//Current attachment

		params.add(new BasicNameValuePair("currentAttachmentDocumentId", encryptionHandler.encrypt(attachmentComparisonRequestType.getSecondAttachmentRef()
				.getMasterID())));

		if (attachmentComparisonRequestType.getSecondAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType) {
			params.add(new BasicNameValuePair("currentAttachmentName", encryptionHandler.encrypt(((AttachmentNameType) attachmentComparisonRequestType
					.getSecondAttachmentRef().getAttachmentIdOrAttachmentName()).getValue())));
		} else {
			params.add(new BasicNameValuePair("currentAttachmentId", encryptionHandler.encrypt(((AttachmentIdType) attachmentComparisonRequestType
					.getSecondAttachmentRef().getAttachmentIdOrAttachmentName()).getValue())));
		}
		String currentTagEncryptedValue = null;
		if (attachmentComparisonRequestType.getSecondAttachmentRef().getTag() != null) {
			currentTagEncryptedValue = encryptionHandler.encrypt(attachmentComparisonRequestType.getSecondAttachmentRef().getTag());
			params.add(new BasicNameValuePair("currentAttachmentTag", currentTagEncryptedValue));
		}

		return params;

	}

	private void validateParameters(AttachmentComparisonRequestType attachmentComparisonRequestType) {

		String errorMessage = null;

		if (attachmentComparisonRequestType == null) {
			errorMessage = "The attachmentComparisonRequestType parameter is null";
		} else {

			if (attachmentComparisonRequestType.getFirstAttachmentRef() == null) {
				errorMessage = "The attachmentComparisonRequestType.firstAttachmentRef variable is null";
			} else if (attachmentComparisonRequestType.getFirstAttachmentRef().getMasterID() == null) {
				errorMessage = "The attachmentComparisonRequestType.firstAttachmentRef.masterId variable is null";
			} else if (attachmentComparisonRequestType.getFirstAttachmentRef().getAttachmentIdOrAttachmentName() == null) {
				errorMessage = "The attachmentComparisonRequestType.firstAttachmentRef.attachmentIdOrName variable is null";
			} else if ((attachmentComparisonRequestType.getFirstAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentIdType && ((AttachmentIdType) attachmentComparisonRequestType
					.getFirstAttachmentRef().getAttachmentIdOrAttachmentName()).getValue() == null)
					|| (attachmentComparisonRequestType.getFirstAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType && ((AttachmentNameType) attachmentComparisonRequestType
							.getFirstAttachmentRef().getAttachmentIdOrAttachmentName()).getValue() == null)) {
				errorMessage = "The attachmentComparisonRequestType.firstAttachmentRef.attachmentIdOrName.value variable is null";
			} else if (!(attachmentComparisonRequestType.getFirstAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentIdType)
					&& !(attachmentComparisonRequestType.getFirstAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType)) {
				errorMessage = "The attachmentComparisonRequestType.firstAttachmentRef.attachmentIdOrName variable is not of type AttachmentIdType or AttachmentNameType";
			}

			if (errorMessage == null) {

				if (attachmentComparisonRequestType.getSecondAttachmentRef() == null) {
					errorMessage = "The attachmentComparisonRequestType.secondAttachmentRef variable is null";
				} else if (attachmentComparisonRequestType.getSecondAttachmentRef().getMasterID() == null) {
					errorMessage = "The attachmentComparisonRequestType.secondAttachmentRef.masterId variable is null";
				} else if (attachmentComparisonRequestType.getSecondAttachmentRef().getAttachmentIdOrAttachmentName() == null) {
					errorMessage = "The attachmentComparisonRequestType.secondAttachmentRef.attachmentIdOrName variable is null";
				} else if ((attachmentComparisonRequestType.getSecondAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentIdType && ((AttachmentIdType) attachmentComparisonRequestType
						.getSecondAttachmentRef().getAttachmentIdOrAttachmentName()).getValue() == null)
						|| (attachmentComparisonRequestType.getSecondAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType && ((AttachmentNameType) attachmentComparisonRequestType
								.getSecondAttachmentRef().getAttachmentIdOrAttachmentName()).getValue() == null)) {
					errorMessage = "The attachmentComparisonRequestType.secondAttachmentRef.attachmentIdOrName.value variable is null";
				} else if (!(attachmentComparisonRequestType.getSecondAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentIdType)
						&& !(attachmentComparisonRequestType.getSecondAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType)) {
					errorMessage = "The attachmentComparisonRequestType.secondAttachmentRef.attachmentIdOrName variable is not of type AttachmentIdType or AttachmentNameType";
				}

			}

		}

		if (errorMessage != null) {
			throw new IllegalArgumentException(errorMessage + ". errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode());
		}

	}

}
