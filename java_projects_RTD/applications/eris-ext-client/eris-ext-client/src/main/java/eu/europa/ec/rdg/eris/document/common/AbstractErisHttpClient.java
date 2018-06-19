package eu.europa.ec.rdg.eris.document.common;

import java.io.InputStream;
import java.io.StringWriter;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.apache.commons.io.IOUtils;
import org.apache.http.*;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.InputStreamBody;
import org.apache.http.entity.mime.content.StringBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;

import eu.europa.ec.rdg.framework.encryption.EncryptionException;
import eu.europa.ec.rdg.framework.encryption.EncryptionHandler;
import eu.europa.ec.rdg.framework.encryption.EncryptionScheme;

/**
 * @author CRAVIAL
 *
 */
public abstract class AbstractErisHttpClient {

	/** The url part for Eris download servlet. */
	public static final String SUFFIX_DOWNLOAD = "/downloadDocAttachment";

	/** The url part for Eris download zip servlet. */
	protected static final String SUFFIX_DOWNLOAD_ZIP = "/downloadDocZip";

	/** The url part for Eris upload servlet. */
	public static final String SUFFIX_UPLOAD = "/uploadDocAttachment";

	protected final Logger logger;

	protected Map<Class<?>, JAXBContext> jaxbContextMap = new HashMap<Class<?>, JAXBContext>();

	protected String erisServletBaseURL;

	protected ErisEcasProxyTicketGenerator ticketGenerator;

	protected boolean ecasAuthIsActive = false;

	public static final String DOWNLOAD_PARAM_ORIGINAL = "original";

	/**
	 * The Enum PARAMS.
	 */
	public enum PARAMS {
		// order is important in Eris server side, at least attachment
		// inputstream should be the last
		xml, pt, attachment;

		public boolean isEqual(String s) {
			return this.toString().equalsIgnoreCase(s);
		}
	}

	protected AbstractErisHttpClient(String servletBaseUrl, String user,
			String password, boolean ecasAuthIsActive) {

		logger = Logger.getLogger(this.getClass());

		final String toReplace = "http://";
		String descryptedPassword = password;
		EncryptionHandler encHandler;

		try {
			encHandler = new EncryptionHandler(EncryptionScheme.BLOWFISH);
		} catch (EncryptionException e) {
			throw new ErisClientSecurityException(
					"Could not instantiate encryption handler", e);
		}
		try {
			descryptedPassword = encHandler.decrypt(password);
		} catch (EncryptionException e) {
			logger.warn("The provided password for the user ["
					+ user
					+ "] cannot be descrypted. It will be treated as plain text.");
		}

		String replacement = toReplace + user + ":" + descryptedPassword + "@";
		String url = servletBaseUrl.replace(toReplace, replacement);
		if (url.endsWith("/")) {
			url = url.substring(0, url.length() - 1);
		}
		this.erisServletBaseURL = url;

		this.ecasAuthIsActive = ecasAuthIsActive;
	}

	protected AttachmentDownloadWrapper doDownloadAttachment(String xml,
			boolean original, boolean isZip) throws ErisClientException {

		HttpClient client = new DefaultHttpClient();

		String targetUrl = erisServletBaseURL
				+ (isZip ? SUFFIX_DOWNLOAD_ZIP : SUFFIX_DOWNLOAD);
		logger.debug("Targeting url: " + targetUrl);
		URIBuilder builder;
		try {

			logger.debug("Sending xml: " + xml);
			builder = new URIBuilder(targetUrl);

			if (ecasAuthIsActive) {
				String ticket = getErisEcasProxyTicketGenerator()
						.getEcasTicket();
				logger.debug("Sending ticket: " + xml);
				builder.setParameter(PARAMS.pt.toString(), ticket);
			}
			if (original) {
				builder.setParameter(DOWNLOAD_PARAM_ORIGINAL, "true");
			}

			URI uri = builder.build();

			HttpPost httpPost = new HttpPost(uri);
			StringEntity entity = new StringEntity(xml, ContentType.create(
					"application/xml", Charset.forName("UTF-8")));
			httpPost.setEntity(entity);

			logger.debug("Executing download request");
			HttpResponse res = client.execute(httpPost);

			logger.debug("Response status line: "
					+ res.getStatusLine().toString());
			int responseCode = res.getStatusLine().getStatusCode();

			AttachmentDownloadWrapper attHttpWrapper = new AttachmentDownloadWrapper();

			if (responseCode == HttpStatus.SC_OK) {
				if (res.getEntity().getContentType() != null) {
					attHttpWrapper.setContentType(res.getEntity()
							.getContentType().getValue());
				}

				attHttpWrapper.setInputstream(res.getEntity().getContent());
				Header header = res.getFirstHeader("Content-Disposition");
				if (header != null) {
					String contentDisposition = header.getValue();
					String fileName = ContentDispositionUtil
							.getFileName(contentDisposition);
					attHttpWrapper.setName(fileName);
				}

				header = res.getFirstHeader("Source-Content-Length");
				if (header != null) {
					String contentLength = header.getValue();
					attHttpWrapper.setContentLength(Integer
							.parseInt(contentLength));
				}

				logger.debug("Returning AttachmentDownloadWrapper:"
						+ attHttpWrapper);
				return attHttpWrapper;
			} else {
				String errorMsg = EntityUtils.toString(res.getEntity());
				logger.debug(errorMsg);
				throw ExceptionMapper.mapStatusCode(responseCode, errorMsg);
			}

		} catch (ErisClientException ce) {
			logger.error(ce);
			throw ce;
		} catch (Exception e) {
			logger.error(e);
			throw new ErisClientException(
					"Eris client error downloading attachment", e,
					ErisClientErrorCode.ERROR_DOWNLOADING_ATTACHMENT);
		}
	}

	protected String doUploadAttachment(String attachmentXML, InputStream in,
			String contentType, String fileName) throws ErisClientException {

		HttpClient client = new DefaultHttpClient();

		try {

			client.getParams().setParameter(
					CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
			String targetUrl = erisServletBaseURL + SUFFIX_UPLOAD;
			logger.debug("Targeting url: " + targetUrl);
			HttpPost post = new HttpPost(targetUrl);
			MultipartEntity entity = new MultipartEntity(
					HttpMultipartMode.BROWSER_COMPATIBLE);

			for (PARAMS param : PARAMS.values()) {
				if (param == PARAMS.xml) {
					logger.debug("Adding xml part " + attachmentXML);
					entity.addPart(
							PARAMS.xml.toString(),
							new StringBody(attachmentXML, "text/plain", Charset
									.forName("UTF-8")));
				} else if (param == PARAMS.pt && ecasAuthIsActive) {
					String ticket = getErisEcasProxyTicketGenerator()
							.getEcasTicket();
					entity.addPart(PARAMS.pt.toString(), new StringBody(ticket));
					logger.debug("Adding ticket part " + ticket);
				} else if (param == PARAMS.attachment) {
					// in some cases contentType parameter will arrive as
					// content type proper, like "application/pdf;UTF-8" and in
					// some other cases it'll contain only the mime type, say
					// "application/pdf".
					// some versions of InputStreamBody will throw an exception
					// if the mime type contains reserved characters like the
					// ';', so we clean that bit.
					String mimeType;
					if (contentType.contains(";")) {
						mimeType = contentType.split(";")[0];
					} else {
						mimeType = contentType;
					}
					entity.addPart(PARAMS.attachment.toString(),
							new InputStreamBody(in, mimeType, fileName));
				}
			}

			post.setEntity(entity);
			logger.debug("Executing upload request");
			HttpResponse respo = client.execute(post);
			HttpEntity respEntity = respo.getEntity();
			logger.debug("Received status line: "
					+ respo.getStatusLine().toString());
			String result = EntityUtils.toString(respEntity);

			int statusCode = respo.getStatusLine().getStatusCode();
			if (statusCode != HttpStatus.SC_OK) {
				throw ExceptionMapper.mapStatusCode(statusCode, result);
			}

			logger.debug("Received docId:attid->" + result);
			return result;

		} catch (ErisClientException ce) {
			logger.error(ce);
			throw ce;
		} catch (Exception e) {
			logger.error(e);
			throw new ErisClientException("Error uploading attachment", e,
					ErisClientErrorCode.ERROR_UPLOADING_ATTACHMENT);
		} finally {
			client.getConnectionManager().shutdown();
			IOUtils.closeQuietly(in);
		}

	}

	protected Marshaller getMarshaller(Class<?> type) throws JAXBException {
		JAXBContext jaxbContext = jaxbContextMap.get(type);
		if (jaxbContext == null) {
			jaxbContext = JAXBContext.newInstance(type);
			jaxbContextMap.put(type, jaxbContext);
		}
		Marshaller marshaller = jaxbContext.createMarshaller();
		marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
		// marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT,
		// Boolean.TRUE);
		return marshaller;
	}

	private ErisEcasProxyTicketGenerator getErisEcasProxyTicketGenerator() {
		if (ticketGenerator == null) {
			ticketGenerator = new ErisEcasProxyTicketGenerator();
		}
		return ticketGenerator;
	}

	/**
	 * Returns the xml representation of a JAXB object. It is handling directly
	 * the common types and demanding to the specific classes, via the
	 * getJAXBElement() method, the types that are version dependent.
	 * 
	 * @param t
	 *            The object to be marshalled.
	 * @return The xml representation of the object given in input.
	 * @throws JAXBException
	 *             If there is an error marshalling the object.
	 */
	protected <T> String getXML(T t) throws JAXBException {

		JAXBElement<?> jax = getJAXBElement(t);

		StringWriter writer = new StringWriter();
		getMarshaller(t.getClass()).marshal(jax, writer);
		return writer.toString();
	}

	protected abstract <T> JAXBElement<?> getJAXBElement(T t)
			throws JAXBException;
}
