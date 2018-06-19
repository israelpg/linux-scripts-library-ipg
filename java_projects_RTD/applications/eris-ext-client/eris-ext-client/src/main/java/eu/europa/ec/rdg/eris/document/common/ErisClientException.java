package eu.europa.ec.rdg.eris.document.common;

/**
 * The Class ErisClientException used for errors in Eris client.
 */
public class ErisClientException extends RuntimeException {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/**
	 * Instantiates a new eris client exception.
	 * 
	 * @param message the message
	 * @param cause the cause
     * @param errorCode the errorCode
	 */
	public ErisClientException(String message, Throwable cause, ErisClientErrorCode errorCode) {
        super(message + ". errorCode: " + errorCode.getCode(), cause);
	}

	/**
	 * Instantiates a new eris client exception.
	 * 
	 * @param string the string
     * @param errorCode the errorCode
	 */
	public ErisClientException(String string, ErisClientErrorCode errorCode) {
		super(string + ". errorCode: " + errorCode.getCode());
	}
}
