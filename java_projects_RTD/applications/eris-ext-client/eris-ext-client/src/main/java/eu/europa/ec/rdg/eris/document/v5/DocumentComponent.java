package eu.europa.ec.rdg.eris.document.v5;

import eu.europa.ec.rdg.framework.service.AbstractComponent;
import eu.europa.ec.research.fp.services.document_management.v5.DocumentManagementService;
import eu.europa.ec.research.fp.services.document_management.v5.IDocumentManagementService;

public class DocumentComponent extends AbstractComponent<DocumentManagementService, IDocumentManagementService, IDocumentManagementServiceRemote> {

	public static final String JNDI_DOCUMENT_SERVICE_V5 = "eris/ejb/DocumentService/v5";
	public static final String DOCUMENT_SERVICE_EJB_NAME = "DocumentServiceBean_v5";

	public DocumentComponent() {
		super(IDocumentManagementServiceRemote.class);
	}

	@Override
	public String getServiceJndi() {
		return JNDI_DOCUMENT_SERVICE_V5;
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
