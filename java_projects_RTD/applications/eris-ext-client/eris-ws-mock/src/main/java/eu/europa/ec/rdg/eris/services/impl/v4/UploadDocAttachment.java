package eu.europa.ec.rdg.eris.services.impl.v4;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPathExpressionException;

import eu.europa.ec.rdg.eris.document.common.ErisClientErrorCode;
import org.apache.commons.fileupload.FileItemIterator;
import org.apache.commons.fileupload.FileItemStream;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.rdg.eris.document.v5.ErisHttpClientImpl;
import eu.europa.ec.research.fp.services.document_management.interfaces.v3.UploadDocAttachmentType;

@WebServlet(value = ErisHttpClientImpl.SUFFIX_UPLOAD, loadOnStartup = 0)
public class UploadDocAttachment extends HttpServlet {

	public static final String ID_SEPARATOR = ":";
	private static final long serialVersionUID = 2365400156187248386L;

	Logger logger = Logger.getLogger(UploadDocAttachment.class);

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			ParametersWrapper parametersWrapper = readParameters(request);

			mergeFileNameAndAttName(parametersWrapper);

			UploadDocAttachmentType uploadDocAttachmentType = parametersWrapper.getUploadDocAttachmentType();

			String composedId = uploadDocAttachmentType.getDocumentRef().getMasterID() + ID_SEPARATOR + parametersWrapper.getPreUploadedId();
			byte[] bytes = composedId.getBytes();
			response.setContentLength(bytes.length);
			response.setContentType("text/plain");
			response.getOutputStream().write(bytes);

		} catch (XPathExpressionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SAXException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JAXBException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			response.getOutputStream().flush();
			response.getOutputStream().close();

		}

	}

	private void mergeFileNameAndAttName(ParametersWrapper parametersWrapper) {

		String attName = parametersWrapper.getUploadDocAttachmentType().getAttachmentName();

		String binaryFileNameExtension = stripFileExtension(parametersWrapper.getBinaryFileName());

		if (binaryFileNameExtension != null) {
			parametersWrapper.setFileName(attName + "." + binaryFileNameExtension);
		} else {
			parametersWrapper.setFileName(attName);
		}

	}

	public static String stripFileExtension(String fileName) {
		int dotInd = fileName.lastIndexOf('.');
		return (dotInd > 0) ? fileName.substring(dotInd + 1) : null;
	}

	private ParametersWrapper readParameters(HttpServletRequest request) throws SAXException, FileUploadException, IOException, JAXBException,
			XPathExpressionException, ParserConfigurationException {

		ParametersWrapper paramsWrapper = new ParametersWrapper();

		ServletFileUpload upload = new ServletFileUpload();

		FileItemIterator fileItemIterator = upload.getItemIterator(request);
		while (fileItemIterator.hasNext()) {

			FileItemStream item = fileItemIterator.next();

			if (item.isFormField() && ErisHttpClientImpl.PARAMS.xml.isEqual(item.getFieldName())) {
				InputStream xmlInputStream = item.openStream();
				JAXBContext jc = JAXBContext.newInstance(UploadDocAttachmentType.class.getPackage().getName());

				StringWriter writer = new StringWriter();
				IOUtils.copy(xmlInputStream, writer, "UTF8");
				String theString = writer.toString();
				System.out.println(theString);

				xmlInputStream = new ByteArrayInputStream(theString.getBytes());

				Unmarshaller u = jc.createUnmarshaller();
				JAXBElement<?> elem = (JAXBElement<?>) u.unmarshal(xmlInputStream);
				UploadDocAttachmentType attType = (UploadDocAttachmentType) elem.getValue();

				if (attType.getAttachmentName().indexOf(".") > 0) {
					throw new ErisClientException("character '.' is not allowed in attachmentName", ErisClientErrorCode.ATTACHMENT_NAME_CONTAINS_ILLEGAL_CHARACTERS);
				}

				//logger.debug(JavaToXml.toXml(attType));

				paramsWrapper.setUploadDocAttachmentType(attType);

			} else if (ErisHttpClientImpl.PARAMS.attachment.isEqual(item.getFieldName())) {
				if (StringUtils.isNotBlank(item.getName())) {
					paramsWrapper.setBinaryFileName(item.getName());
					InputStream binInputStream = item.openStream();
					if (binInputStream == null) {
						throw new IllegalArgumentException("binary not found");
					}
					paramsWrapper.setPreUploadedId("fakeId");
				}
			} else if (ErisHttpClientImpl.PARAMS.pt.isEqual(item.getFieldName())) {

				throw new IllegalArgumentException("proxy ticket not implemented for the eris mock");
				//validatePT(request, item);

			}
		}

		doValidation(paramsWrapper);
		return paramsWrapper;

	}

	private void doValidation(ParametersWrapper paramsWrapper) {
		if (paramsWrapper.getUploadDocAttachmentType() == null) {
			throw new ErisClientException("Part not found: " + ErisHttpClientImpl.PARAMS.xml, ErisClientErrorCode.INVALID_PARAMETERS);
		}
		if (paramsWrapper.getPreUploadedId() == null) {
			throw new ErisClientException("Part not found: " + ErisHttpClientImpl.PARAMS.attachment, ErisClientErrorCode.INVALID_PARAMETERS);
		}
		if (StringUtils.isEmpty(paramsWrapper.getUploadDocAttachmentType().getAttachmentName())) {
			paramsWrapper.getUploadDocAttachmentType().setAttachmentName(paramsWrapper.getBinaryFileName());
		}
	}

	class ParametersWrapper {
		private UploadDocAttachmentType uploadDocAttachmentType;
		private String binaryFileName;
		private String preUploadedId;

		private String fileName;
		private boolean returnId = false;

		public String getBinaryFileName() {
			return binaryFileName;
		}

		public void setBinaryFileName(String binaryFileName) {
			this.binaryFileName = binaryFileName;
		}

		public UploadDocAttachmentType getUploadDocAttachmentType() {
			return uploadDocAttachmentType;
		}

		public void setUploadDocAttachmentType(UploadDocAttachmentType uploadDocAttachmentType) {
			this.uploadDocAttachmentType = uploadDocAttachmentType;
		}

		public boolean isReturnId() {
			return returnId;
		}

		public void setReturnId(boolean b) {
			this.returnId = b;
		}

		public String getFileName() {
			return fileName;
		}

		public void setFileName(String fileName) {
			this.fileName = fileName;
		}

		public String getPreUploadedId() {
			return preUploadedId;
		}

		public void setPreUploadedId(String preUploadedId) {
			this.preUploadedId = preUploadedId;
		}

	}
}
