package eu.europa.ec.rdg.eris.ws.impl.document_management.v5;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URISyntaxException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;

import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.util.Streams;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import eu.europa.ec.research.fp.model.document.v5.AttachmentIdType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentNameType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentType;
import eu.europa.ec.research.fp.model.document.v5.KindType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.DownloadDocAttachmentType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.GetDocumentResponseType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.ObjectFactory;
import eu.europa.ec.research.fp.services.document_management.interfaces.v5.UploadDocAttachmentType;

@WebServlet({ "/v5/downloadDocAttachment", "/v5/uploadDocAttachment" })
public class ErisMockServlet extends HttpServlet {

	protected static final String ATTACHMENT_PREFIX = "attachment_";

	private static final long serialVersionUID = -9079043360315832235L;

	private static final Logger LOGGER = Logger.getLogger(ErisMockServlet.class);

	private static final ErisMockServletXmlFileLoader LOADER = new ErisMockServletXmlFileLoader();

	/**
	 * Convention: GET = DOWNLOAD
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LOGGER.info("Processing Get Request:");

		try {
			String downloadDocAttachmentXml = request.getParameter("xml");
			if (downloadDocAttachmentXml != null) {
				// TODO: remove the validate parameter when the XML will be valid !!!
				DownloadDocAttachmentType downloadDocAttachmentType = LOADER.getTypeFromXml(DownloadDocAttachmentType.class, downloadDocAttachmentXml, false,
						ObjectFactory.class);
				if (downloadDocAttachmentType.getAttachmentRef().getAttachmentIdOrAttachmentName() != null) {
					File attachmentFile = null;
					String attachmentContentType = null;
					if (downloadDocAttachmentType.getAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentIdType) {
						AttachmentIdType attachmentIdType = (AttachmentIdType) downloadDocAttachmentType.getAttachmentRef().getAttachmentIdOrAttachmentName();
						attachmentFile = LOADER.getAbsolutePath(ATTACHMENT_PREFIX + attachmentIdType.getValue());
					} else if (downloadDocAttachmentType.getAttachmentRef().getAttachmentIdOrAttachmentName() instanceof AttachmentNameType) {
						AttachmentNameType attachmentNameType = (AttachmentNameType) downloadDocAttachmentType.getAttachmentRef()
								.getAttachmentIdOrAttachmentName();
						// 1) Find the document with id
						GetDocumentResponseType getDocumentResponseType = LOADER.getType(GetDocumentResponseType.class, "_"
								+ downloadDocAttachmentType.getAttachmentRef().getMasterID(), ObjectFactory.class);
						if (getDocumentResponseType != null) {
							for (AttachmentType attachmentType : getDocumentResponseType.getResponse().getDocument().getAttachments()) {
								if (attachmentType.getAttachmentName().equals(attachmentNameType.getValue())) {
									attachmentFile = LOADER.getAbsolutePath(ATTACHMENT_PREFIX + attachmentType.getId() + "." + attachmentType.getExtension());
									attachmentContentType = attachmentType.getContentType();
								}
							}
						}
					}
					if (attachmentFile != null) {
						if (attachmentContentType != null) {
							response.setContentType(attachmentContentType);
						}
						LOGGER.info("Returning attachment file : " + attachmentFile);
						BufferedInputStream bufferedInputStream = new BufferedInputStream(new FileInputStream(attachmentFile));
						byte[] readBytes = new byte[10 * 1024];
						int readSize;
						while ((readSize = bufferedInputStream.read(readBytes)) != -1) {
							response.getOutputStream().write(readBytes, 0, readSize);
						}
						bufferedInputStream.close();
					}
				}
			}
		} catch (JAXBException | SAXException | URISyntaxException exception) {
			LOGGER.error("Error Reading Attachment", exception);
			throw new ServletException("Error processing the request", exception);
		}
	}

	/**
	 * Convention: POST = UPLOAD
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LOGGER.info("Processing Post Request:");

		try {
			if (ServletFileUpload.isMultipartContent(request)) {
				LOGGER.info("Received Multipart Content");
				String attachmentId = Long.toString(new Date().getTime());
				String uploadDocAttachmentXml = null;
				String uploadDocAttachmentContentType = null;
				String uploadDocAttachmentName = null;

				ServletFileUpload servletFileUpload = new ServletFileUpload();
				FileItemIterator fileItemIterator = servletFileUpload.getItemIterator(request);

				String fieldValue = null;
				while (fileItemIterator.hasNext()) {
					FileItemStream fileItemStream = fileItemIterator.next();
					InputStream inputStream = fileItemStream.openStream();
					if (fileItemStream.isFormField()) {
						fieldValue = Streams.asString(inputStream);
						LOGGER.info("Field name : " + fileItemStream.getFieldName());
						LOGGER.info("Field value : " + fieldValue);
						if ("xml".equals(fileItemStream.getFieldName())) {
							uploadDocAttachmentXml = fieldValue;
						}
					} else {
						uploadDocAttachmentName = fileItemStream.getName();
						LOGGER.info("Name : " + uploadDocAttachmentName);
						uploadDocAttachmentContentType = fileItemStream.getContentType();
						LOGGER.info("Content Type : " + uploadDocAttachmentContentType);
						writeAttachment(inputStream, attachmentId, getExtension(uploadDocAttachmentName));
					}
				}

				if (uploadDocAttachmentXml != null) {
					// TODO: remove the validate parameter when the XML will be valid !!!
					UploadDocAttachmentType uploadDocAttachmentType = LOADER.getTypeFromXml(UploadDocAttachmentType.class, uploadDocAttachmentXml, false,
							ObjectFactory.class);
					String masterId = uploadDocAttachmentType.getDocumentRef().getMasterID();
					LOGGER.info("Adding attachment to document " + masterId);

					GetDocumentResponseType getDocumentResponseType = LOADER.getType(GetDocumentResponseType.class, "_" + masterId, ObjectFactory.class);
					if (getDocumentResponseType == null) {
						throw new ServletException("Document with id " + masterId + " not found !!!");
					} else {
						AttachmentType attachmentType = new AttachmentType();

						attachmentType.setAttachmentName(uploadDocAttachmentType.getAttachmentName());
						attachmentType.setAttachmentType(uploadDocAttachmentType.getAttachmentType());
						attachmentType.setContentType(uploadDocAttachmentContentType);
						attachmentType.setExtension(getExtension(uploadDocAttachmentName));
						attachmentType.setId(attachmentId);
						// Work around for null kind
						if (uploadDocAttachmentType.getKind() != null) {
							attachmentType.setKind(KindType.valueOf(uploadDocAttachmentType.getKind()));
						} else {
							attachmentType.setKind(KindType.MAIN);
						}
						attachmentType.setLanguage(uploadDocAttachmentType.getLanguage());
						attachmentType.setUserReadableName(uploadDocAttachmentType.getUserReadableName());

						getDocumentResponseType.getResponse().getDocument().getAttachments().add(attachmentType);
					}

					JAXBElement<GetDocumentResponseType> jaxbElement = new ObjectFactory().createGetDocumentResponse(getDocumentResponseType);
					LOADER.setType(GetDocumentResponseType.class, jaxbElement, "_" + masterId, ObjectFactory.class);
				}
			}
			response.getWriter().write("ok");

		} catch (FileUploadException | JAXBException | SAXException | URISyntaxException exception) {
			LOGGER.error("Error Writting Attachment", exception);
			throw new ServletException("Error processing the request", exception);
		}
	}

	@Override
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		LOGGER.info("Processing Delete Request:");
	}

	private void writeAttachment(InputStream inputStream, String attachmentId, String extension) throws IOException, URISyntaxException {
		BufferedOutputStream bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(LOADER.getAbsolutePath(ATTACHMENT_PREFIX + attachmentId
				+ ((extension != null && extension.length() > 0) ? "." + extension : ""))));
		byte[] bytes = new byte[1024];
		int readBytes = -1;
		while ((readBytes = inputStream.read(bytes)) != -1) {
			bufferedOutputStream.write(bytes, 0, readBytes);
		}
		bufferedOutputStream.flush();
		bufferedOutputStream.close();
	}

	private String getExtension(String fileName) {
		if (fileName != null) {
			int dotIndex = fileName.lastIndexOf(".");
			if (dotIndex != -1) {
				return fileName.substring(dotIndex + 1);
			} else {
				return "";
			}
		} else {
			return null;
		}
	}

	private static class ErisMockServletXmlFileLoader extends ErisMockXmlFileLoader {
	}
}
