package eu.europa.ec.rdg.eris.document.common;

/**
 * The Class ErisClientAuthenticationException used for authentication errors (HTTP-401) in Eris client.
 */
public class ErisClientAuthenticationException extends ErisClientSecurityException {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	public static final String MESSAGE = "Username and/or password not valid";
	
	/**
	 * Instantiates a new eris client authentication exception.
	 * 
	 * @param cause the cause
	 */
	public ErisClientAuthenticationException(Throwable cause) {
		super(MESSAGE, cause);
	}

	/**
	 * Instantiates a new eris client authentication exception.
	 * 
	 */
	public ErisClientAuthenticationException() {
		super(MESSAGE);
	}

}
