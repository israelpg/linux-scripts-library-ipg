package eu.europa.ec.rdg.eris.services.impl.v4;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import eu.europa.ec.rdg.eris.document.common.ErisClientErrorCode;
import org.apache.commons.io.IOUtils;
import org.apache.http.HttpStatus;

import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.rdg.eris.document.v4.ErisHttpClientImpl;
import eu.europa.ec.research.fp.model.document.v5.DocumentAttachmentRefType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v3.DownloadDocAttachmentType;

@WebServlet(value = ErisHttpClientImpl.SUFFIX_DOWNLOAD, loadOnStartup = 0)
//@ServletSecurity(@HttpConstraint(rolesAllowed = { "all", "*" }))
public class DownloadDocAttachment extends HttpServlet {

	private static final String PARAM_XML = "xml";

	private static final long serialVersionUID = 2365400156187248386L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String xml = request.getParameter(PARAM_XML);
		DownloadDocAttachmentType downloadDocAtt;
		try {
			downloadDocAtt = getXmlPart(xml, DownloadDocAttachmentType.class);
		} catch (JAXBException e) {
			// TODO Auto-generated catch block
			throw new ServletException(e);
		}
		DocumentAttachmentRefType attachref = downloadDocAtt.getAttachmentRef();
		response.setStatus(HttpStatus.SC_OK);
		response.reset();
		response.setContentType("application/pdf");
		String contentDispositionHeaderName = "Content-Disposition";
		response.setHeader(contentDispositionHeaderName, "Content-Disposition: attachment; filename=fakeFile.pdf;");
		InputStream in = this.getClass().getResourceAsStream("/sample.pdf");
		IOUtils.copy(in, response.getOutputStream());
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}

	public static <T> T getXmlPart(String xml, Class<T> class_) throws JAXBException {

		JAXBContext jc = JAXBContext.newInstance(class_.getPackage().getName());
		Unmarshaller u = jc.createUnmarshaller();
		@SuppressWarnings("unchecked")
		JAXBElement<T> elem;
		try {
			elem = (JAXBElement<T>) u.unmarshal(new StringReader(xml));
		} catch (JAXBException e) {
			throw new ErisClientException("Failed to unmarshall input xml " + e.getMessage(), e, ErisClientErrorCode.INVALID_PARAMETERS);
		}
		return elem.getValue();

	}

}
