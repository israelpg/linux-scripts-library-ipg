package eu.europa.ec.rdg.eris.document.common;


/**
 * The Class ErisClientSecurityException used for security related errors in Eris client.
 */
public class ErisClientSecurityException extends ErisClientException {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/**
	 * Instantiates a new eris client security exception.
	 * 
	 * @param message the message
	 * @param cause the cause
	 */
	public ErisClientSecurityException(String message, Throwable cause) {
		super(message, cause, ErisClientErrorCode.SECURITY_EXCEPTION);
	}

	/**
	 * Instantiates a new eris client security exception.
	 * 
	 * @param string the string
	 */
	public ErisClientSecurityException(String string) {
		super(string, ErisClientErrorCode.SECURITY_EXCEPTION);
	}

}
