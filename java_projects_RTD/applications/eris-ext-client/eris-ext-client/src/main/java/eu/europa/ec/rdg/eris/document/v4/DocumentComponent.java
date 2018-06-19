package eu.europa.ec.rdg.eris.document.v4;

import eu.europa.ec.rdg.framework.service.AbstractComponent;
import eu.europa.ec.research.fp.services.document_management.v4.DocumentManagementService;
import eu.europa.ec.research.fp.services.document_management.v4.IDocumentManagementService;

public class DocumentComponent extends AbstractComponent<DocumentManagementService, IDocumentManagementService, IDocumentManagementServiceRemote> {

	
	public static final String JNDI_DOCUMENT_SERVICE_V4 = "eris/ejb/DocumentService/v4";
	public static final String DOCUMENT_SERVICE_EJB_NAME = "DocumentServiceBean_v4";

	public DocumentComponent() {
		super(IDocumentManagementServiceRemote.class);
	}

	@Override
	public String getServiceJndi() {
		return JNDI_DOCUMENT_SERVICE_V4;
	}
	
	//HTTP SERVICE
	/**
	 * Gets the HTTP client needed to upload/downloads attachments
	 * 
	 * @param servletBaseUrl Base Url of eris services for ex. http://naiad.cc.cec.eu.int:2329/eris-ws/v3
	 * @param username the username
	 * @param password the password
	 * @param useEcasLoggedUser true if eris should impersonate the user logged in client side
	 * @return the http client
	 */
	public IErisHttpClient getHttpClient(String servletBaseUrl, String username, String password, boolean useEcasLoggedUser) {
		return new ErisHttpClientImpl(servletBaseUrl, username, password, useEcasLoggedUser);
	}

}
