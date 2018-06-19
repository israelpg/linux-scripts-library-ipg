package eu.europa.ec.rdg.eris.document.common;

import eu.europa.ec.research.fp.model.header.v1.HeaderType;
import eu.europa.ec.research.fp.model.header.v1.HeaderType.SecurityContext;

public class HeaderUtil {

	public static HeaderType getHeader(boolean isEcasAuthActivated) {
		if (isEcasAuthActivated) {
			HeaderType header = new HeaderType();
			SecurityContext securityContext = new SecurityContext();
			String ticket;
			try {
				ticket = getTicketGenerator().getEcasTicket();
			} catch (Exception e) {
				throw new ErisClientException("Error generating proxy ticket", e, ErisClientErrorCode.ERROR_GENERATING_PROXY_TICKET);
			}
			securityContext.setSystemId(ticket);
			header.setSecurityContext(securityContext);
			return header;
		} else {
			return new HeaderType();
		}

	}
	
	private static ErisEcasProxyTicketGenerator getTicketGenerator() {
		return new ErisEcasProxyTicketGenerator();
	}
}
