package eu.europa.ec.rdg.eris.document.common;

/**
 * The Class ErisClientAuthorizationException used for authorization errors (ex. HTTP-403) in Eris client.
 */
public class ErisClientAuthorizationException extends ErisClientSecurityException {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	public static final String MESSAGE = "No authorization to access to the requested resource";
	
	/**
	 * Instantiates a new eris client authorization exception.
	 * 
	 * @param cause the cause
	 */
	public ErisClientAuthorizationException(Throwable cause) {
		super(MESSAGE, cause);
	}

	/**
	 * Instantiates a new eris client authorization exception.
	 */
	public ErisClientAuthorizationException() {
		super(MESSAGE);
	}

}
