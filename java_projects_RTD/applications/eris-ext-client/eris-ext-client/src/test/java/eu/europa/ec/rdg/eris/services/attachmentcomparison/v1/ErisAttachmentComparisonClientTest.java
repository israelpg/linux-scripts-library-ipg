/**
 * 
 */
package eu.europa.ec.rdg.eris.services.attachmentcomparison.v1;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;

import eu.europa.ec.rdg.eris.document.common.ErisClientErrorCode;
import junit.framework.TestCase;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.junit.Test;

import eu.europa.ec.rdg.eris.attachmentcomparison.v1.AttachmentComparisonRequestType;
import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.rdg.framework.encryption.EncryptionException;
import eu.europa.ec.rdg.framework.encryption.EncryptionHandler;
import eu.europa.ec.rdg.framework.encryption.EncryptionScheme;
import eu.europa.ec.research.fp.model.document.v5.AttachmentNameType;
import eu.europa.ec.research.fp.model.document.v5.DocumentAttachmentRefType;

/**
 * @author goncand
 * 
 */
public class ErisAttachmentComparisonClientTest {

	private static final String BASE_URL = "http://localhost:7001/eris-pdf-comparison/ws/v1";

	private static final String BASE_URL_V2 = BASE_URL + "/";

	private static final String PREVIOUS_DOCUMENT_ID = "080166e481a382ba";

	private static final String PREVIOUS_ATTACHMENT_NAME = "Previous Annex 1 - Description Of Action (part B)";

	private static final String PREVIOUS_TAG = "previousTag";

	private static final String CURRENT_DOCUMENT_ID = "080166e481a380a7";

	private static final String CURRENT_ATTACHMENT_NAME = "Current Annex 1 - Description Of Action (part B)";

	private static final String CURRENT_TAG = "currentTag";

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenAttachmentComparisonRequestTypeIsNullShouldThrowErisClientException() {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(null);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType parameter is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenFirstAttachmentRefIsNullShouldThrowErisClientException() {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		AttachmentComparisonRequestType attachmentComparisonRequestType = new AttachmentComparisonRequestType();

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(attachmentComparisonRequestType);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.firstAttachmentRef variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenPreviousDocumentIdIsNullShouldThrowErisClientException() {

		AttachmentComparisonRequestType request = this.createRequest(null, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, CURRENT_DOCUMENT_ID,
				CURRENT_ATTACHMENT_NAME, CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.firstAttachmentRef.masterId variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenPreviousAttachmentNameIsNullShouldThrowErisClientException() {

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, null, PREVIOUS_TAG, CURRENT_DOCUMENT_ID, CURRENT_ATTACHMENT_NAME,
				CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.firstAttachmentRef.attachmentIdOrName.value variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenSecondAttachmentRefIsNullShouldThrowErisClientException() {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		AttachmentComparisonRequestType attachmentComparisonRequestType = new AttachmentComparisonRequestType();
		DocumentAttachmentRefType firstAttchmentRef = new DocumentAttachmentRefType();
		firstAttchmentRef.setMasterID(PREVIOUS_DOCUMENT_ID);
		AttachmentNameType attachmentNameType = new AttachmentNameType();
		attachmentNameType.setValue(PREVIOUS_ATTACHMENT_NAME);
		firstAttchmentRef.setAttachmentIdOrAttachmentName(attachmentNameType);
		attachmentComparisonRequestType.setFirstAttachmentRef(firstAttchmentRef);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(attachmentComparisonRequestType);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.secondAttachmentRef variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenCurrentDocumentIdIsNullShouldThrowErisClientException() {

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, null,
				CURRENT_ATTACHMENT_NAME, CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.secondAttachmentRef.masterId variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenCurrentAttachmentNameIsNullShouldThrowErisClientException() {

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, CURRENT_DOCUMENT_ID, null,
				CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.secondAttachmentRef.attachmentIdOrName.value variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test
	public void testComparisonClientWhenAllMandatoryParametersAreOkShouldEncryptThem() throws URISyntaxException, EncryptionException {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		TestCase.assertNotNull(comparisonClient);

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, null, CURRENT_DOCUMENT_ID,
				CURRENT_ATTACHMENT_NAME, null);

		String pageUrl = comparisonClient.getAttachmentsComparisonPageUrl(request);

		TestCase.assertNotNull(pageUrl);

		String startOfTheUrl = BASE_URL + IErisAttachmentComparisonClient.SUFFIX_COMPARISON_PAGE + "?previousAttachmentDocumentId=";

		TestCase.assertTrue(pageUrl.startsWith(startOfTheUrl));

		List<NameValuePair> params = URLEncodedUtils.parse(new URI(pageUrl), "UTF-8");

		TestCase.assertEquals(4, params.size());

		EncryptionHandler encryptionHandler = new EncryptionHandler(EncryptionScheme.BLOWFISH);

		TestCase.assertEquals(PREVIOUS_DOCUMENT_ID, encryptionHandler.decrypt(params.get(0).getValue()));

		TestCase.assertEquals(PREVIOUS_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(1).getValue()));

		TestCase.assertEquals(CURRENT_DOCUMENT_ID, encryptionHandler.decrypt(params.get(2).getValue()));

		TestCase.assertEquals(CURRENT_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(3).getValue()));

	}

	@Test
	public void testComparisonClientWhenAllParametersAreOkShouldEncryptThem() throws URISyntaxException, EncryptionException {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL);

		TestCase.assertNotNull(comparisonClient);

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, CURRENT_DOCUMENT_ID,
				CURRENT_ATTACHMENT_NAME, CURRENT_TAG);

		String pageUrl = comparisonClient.getAttachmentsComparisonPageUrl(request);

		TestCase.assertNotNull(pageUrl);

		String startOfTheUrl = BASE_URL + IErisAttachmentComparisonClient.SUFFIX_COMPARISON_PAGE + "?previousAttachmentDocumentId=";

		TestCase.assertTrue(pageUrl.startsWith(startOfTheUrl));

		List<NameValuePair> params = URLEncodedUtils.parse(new URI(pageUrl), "UTF-8");

		TestCase.assertEquals(6, params.size());

		EncryptionHandler encryptionHandler = new EncryptionHandler(EncryptionScheme.BLOWFISH);

		TestCase.assertEquals(PREVIOUS_DOCUMENT_ID, encryptionHandler.decrypt(params.get(0).getValue()));

		TestCase.assertEquals(PREVIOUS_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(1).getValue()));

		TestCase.assertEquals(PREVIOUS_TAG, encryptionHandler.decrypt(params.get(2).getValue()));

		TestCase.assertEquals(CURRENT_DOCUMENT_ID, encryptionHandler.decrypt(params.get(3).getValue()));

		TestCase.assertEquals(CURRENT_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(4).getValue()));

		TestCase.assertEquals(CURRENT_TAG, encryptionHandler.decrypt(params.get(5).getValue()));

	}

	/****
	 * 
	 * 
	 * 
	 * 
	 * @return
	 */

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenAttachmentComparisonRequestTypeIsNullShouldThrowErisClientExceptionV2() {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(null);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType parameter is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenFirstAttachmentRefIsNullShouldThrowErisClientExceptionV2() {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		AttachmentComparisonRequestType attachmentComparisonRequestType = new AttachmentComparisonRequestType();

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(attachmentComparisonRequestType);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.firstAttachmentRef variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenPreviousDocumentIdIsNullShouldThrowErisClientExceptionV2() {

		AttachmentComparisonRequestType request = this.createRequest(null, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, CURRENT_DOCUMENT_ID,
				CURRENT_ATTACHMENT_NAME, CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.firstAttachmentRef.masterId variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenPreviousAttachmentNameIsNullShouldThrowErisClientExceptionV2() {

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, null, PREVIOUS_TAG, CURRENT_DOCUMENT_ID, CURRENT_ATTACHMENT_NAME,
				CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.firstAttachmentRef.attachmentIdOrName.value variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenSecondAttachmentRefIsNullShouldThrowErisClientExceptionV2() {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		AttachmentComparisonRequestType attachmentComparisonRequestType = new AttachmentComparisonRequestType();
		DocumentAttachmentRefType firstAttchmentRef = new DocumentAttachmentRefType();
		firstAttchmentRef.setMasterID(PREVIOUS_DOCUMENT_ID);
		AttachmentNameType attachmentNameType = new AttachmentNameType();
		attachmentNameType.setValue(PREVIOUS_ATTACHMENT_NAME);
		firstAttchmentRef.setAttachmentIdOrAttachmentName(attachmentNameType);
		attachmentComparisonRequestType.setFirstAttachmentRef(firstAttchmentRef);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(attachmentComparisonRequestType);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.secondAttachmentRef variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenCurrentDocumentIdIsNullShouldThrowErisClientExceptionV2() {

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, null,
				CURRENT_ATTACHMENT_NAME, CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.secondAttachmentRef.masterId variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}

	}

	@Test(expected = ErisClientException.class)
	public void testComparisonClientWhenCurrentAttachmentNameIsNullShouldThrowErisClientExceptionV2() {

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, CURRENT_DOCUMENT_ID, null,
				CURRENT_TAG);

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		try {
			comparisonClient.getAttachmentsComparisonPageUrl(request);
		} catch (ErisClientException e) {
			TestCase.assertEquals(IllegalArgumentException.class, e.getCause().getClass());
			TestCase.assertEquals("The attachmentComparisonRequestType.secondAttachmentRef.attachmentIdOrName.value variable is null. errorCode: " + ErisClientErrorCode.INVALID_PARAMETERS.getCode(), e.getCause().getMessage());
			throw e;
		}
	}

	@Test
	public void testComparisonClientWhenAllMandatoryParametersAreOkShouldEncryptThemV2() throws URISyntaxException, EncryptionException {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		TestCase.assertNotNull(comparisonClient);

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, null, CURRENT_DOCUMENT_ID,
				CURRENT_ATTACHMENT_NAME, null);

		String pageUrl = comparisonClient.getAttachmentsComparisonPageUrl(request);

		TestCase.assertNotNull(pageUrl);

		String startOfTheUrl = BASE_URL + IErisAttachmentComparisonClient.SUFFIX_COMPARISON_PAGE + "?previousAttachmentDocumentId=";

		TestCase.assertTrue(pageUrl.startsWith(startOfTheUrl));

		List<NameValuePair> params = URLEncodedUtils.parse(new URI(pageUrl), "UTF-8");

		TestCase.assertEquals(4, params.size());

		EncryptionHandler encryptionHandler = new EncryptionHandler(EncryptionScheme.BLOWFISH);

		TestCase.assertEquals(PREVIOUS_DOCUMENT_ID, encryptionHandler.decrypt(params.get(0).getValue()));

		TestCase.assertEquals(PREVIOUS_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(1).getValue()));

		TestCase.assertEquals(CURRENT_DOCUMENT_ID, encryptionHandler.decrypt(params.get(2).getValue()));

		TestCase.assertEquals(CURRENT_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(3).getValue()));

	}

	@Test
	public void testComparisonClientWhenAllParametersAreOkShouldEncryptThemV2() throws URISyntaxException, EncryptionException {

		IErisAttachmentComparisonClient comparisonClient = this.createComparisonClient(BASE_URL_V2);

		TestCase.assertNotNull(comparisonClient);

		AttachmentComparisonRequestType request = this.createRequest(PREVIOUS_DOCUMENT_ID, PREVIOUS_ATTACHMENT_NAME, PREVIOUS_TAG, CURRENT_DOCUMENT_ID,
				CURRENT_ATTACHMENT_NAME, CURRENT_TAG);

		String pageUrl = comparisonClient.getAttachmentsComparisonPageUrl(request);

		TestCase.assertNotNull(pageUrl);

		String startOfTheUrl = BASE_URL + IErisAttachmentComparisonClient.SUFFIX_COMPARISON_PAGE + "?previousAttachmentDocumentId=";

		TestCase.assertTrue(pageUrl.startsWith(startOfTheUrl));

		List<NameValuePair> params = URLEncodedUtils.parse(new URI(pageUrl), "UTF-8");

		TestCase.assertEquals(6, params.size());

		EncryptionHandler encryptionHandler = new EncryptionHandler(EncryptionScheme.BLOWFISH);

		TestCase.assertEquals(PREVIOUS_DOCUMENT_ID, encryptionHandler.decrypt(params.get(0).getValue()));

		TestCase.assertEquals(PREVIOUS_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(1).getValue()));

		TestCase.assertEquals(PREVIOUS_TAG, encryptionHandler.decrypt(params.get(2).getValue()));

		TestCase.assertEquals(CURRENT_DOCUMENT_ID, encryptionHandler.decrypt(params.get(3).getValue()));

		TestCase.assertEquals(CURRENT_ATTACHMENT_NAME, encryptionHandler.decrypt(params.get(4).getValue()));

		TestCase.assertEquals(CURRENT_TAG, encryptionHandler.decrypt(params.get(5).getValue()));

	}

	private IErisAttachmentComparisonClient createComparisonClient(String baseUrl) {

		AttachmentComparisonComponent component = new AttachmentComparisonComponent();

		return component.getAttachmentComparisonClient(baseUrl);

	}

	private AttachmentComparisonRequestType createRequest(String previousDocumentId, String previousAttachmentName, String previousTag,
			String currentDocumentId, String currentAttachmentName, String currentTag) {

		AttachmentComparisonRequestType request = new AttachmentComparisonRequestType();
		DocumentAttachmentRefType firstAttchmentRef = new DocumentAttachmentRefType();
		firstAttchmentRef.setMasterID(previousDocumentId);
		AttachmentNameType attachmentNameType = new AttachmentNameType();
		attachmentNameType.setValue(previousAttachmentName);
		firstAttchmentRef.setAttachmentIdOrAttachmentName(attachmentNameType);
		firstAttchmentRef.setTag(previousTag);
		request.setFirstAttachmentRef(firstAttchmentRef);

		DocumentAttachmentRefType secondAttchmentRef = new DocumentAttachmentRefType();
		secondAttchmentRef.setMasterID(currentDocumentId);
		attachmentNameType = new AttachmentNameType();
		attachmentNameType.setValue(currentAttachmentName);
		secondAttchmentRef.setAttachmentIdOrAttachmentName(attachmentNameType);
		secondAttchmentRef.setTag(currentTag);
		request.setSecondAttachmentRef(secondAttchmentRef);

		return request;

	}

}
