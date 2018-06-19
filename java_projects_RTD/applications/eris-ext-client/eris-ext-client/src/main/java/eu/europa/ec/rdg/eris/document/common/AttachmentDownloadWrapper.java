package eu.europa.ec.rdg.eris.document.common;

import java.io.InputStream;
import java.io.Serializable;

/**
 * The Class AttachmentDownloadWrapper contains all the useful information resulting from an HTTP download.
 */
public class AttachmentDownloadWrapper implements Serializable {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;

	/** The inputstream. */
	InputStream inputstream;

	/** The content type. */
	String contentType;

	/** The name. */
	String name;
	
	/** The content lentght. */
	int contentLength;

	/**
	 * Gets the name.
	 * 
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name.
	 * 
	 * @param fileName the new name
	 */
	public void setName(String fileName) {
		this.name = fileName;
	}

	/**
	 * Gets the content type.
	 * 
	 * @return the content type
	 */
	public String getContentType() {
		return contentType;
	}

	/**
	 * Sets the content type.
	 * 
	 * @param contentType the new content type
	 */
	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	/**
	 * Gets the content length.
	 * 
	 * @return the content length
	 */
	public int getContentLength() {
		return contentLength;
	}

	/**
	 * Sets the content length.
	 * 
	 * @param contentLength The new content length
	 */
	public void setContentLength(int contentLength) {
		this.contentLength = contentLength;
	}

	/**
	 * Gets the inputstream.
	 * 
	 * @return the inputstream
	 */
	public InputStream getInputstream() {
		return inputstream;
	}

	/**
	 * Sets the inputstream.
	 * 
	 * @param inputstream the new inputstream
	 */
	public void setInputstream(InputStream inputstream) {
		this.inputstream = inputstream;
	}

}
