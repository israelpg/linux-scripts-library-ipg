package eu.europa.ec.rdg.eris.document.common;

import java.io.IOException;

import org.apache.log4j.Logger;

import eu.cec.digit.ecas.client.configuration.ClassLoaderLocal;
import eu.cec.digit.ecas.client.configuration.EcasConfigurationIntf;
import eu.cec.digit.ecas.client.jaas.SubjectNotFoundException;
import eu.cec.digit.ecas.client.jaas.SubjectUtil;
import eu.cec.digit.ecas.client.proxy.EcasPgtExpiredException;
import eu.cec.digit.ecas.client.proxy.ProxyTicketProtocolHandler;
import eu.cec.digit.ecas.client.webservices.WebServiceClient;

public class ErisEcasProxyTicketGenerator {

	private static Logger logger = Logger.getLogger(ErisEcasProxyTicketGenerator.class);

	private WebServiceClient webServiceClient;

	public static final String ERIS_SERVICE_URL = "http://eris:2309/DocumentManagementService";

	public ErisEcasProxyTicketGenerator() {

	}

	public String getEcasTicket() throws EcasPgtExpiredException, SubjectNotFoundException, IOException {

		String ticket = null;
		EcasConfigurationIntf ecasConfig = ClassLoaderLocal.getConfiguration();
		if (ecasConfig != null) {

			String pgtId = SubjectUtil.getCurrentEcasUser().getPgtId();
			if (pgtId != null) {
				ticket = new ProxyTicketProtocolHandler(ecasConfig).obtainProxyTicket(pgtId, ERIS_SERVICE_URL);
				String msg = "ErisEcasProxyTicketgenerator Obtained ticket with config:" + ticket;
				logger.debug(msg);
				return ticket;
			}
		}
		String msg = "ErisEcasProxyTicketgenerator, cannot get ticket in normal way, trying webserviceClient:";
		logger.debug(msg);

		ticket = getEcasWebServiceClient().obtainProxyTicket(ERIS_SERVICE_URL);
		msg = "ErisEcasProxyTicketgenerator Obtained ticket no config:" + ticket;
		logger.debug(msg);

		return ticket;

	}

	private WebServiceClient getEcasWebServiceClient() {
		if (webServiceClient == null) {
			webServiceClient = new WebServiceClient();
		}
		return webServiceClient;
	}
}
