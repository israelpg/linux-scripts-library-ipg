package eu.europa.ec.rdg.eris.document.common;

import org.apache.http.HttpStatus;

public class ExceptionMapper {

	public static ErisClientException mapStatusCode(int statusCode, String message) {
		switch (statusCode) {
			case HttpStatus.SC_UNAUTHORIZED:
				return new ErisClientAuthenticationException();
			case HttpStatus.SC_FORBIDDEN:
				return new ErisClientAuthorizationException();
			default: 
				return new ErisClientException("Received HTTP status [" + statusCode + "] with message [" + message + "]", ErisClientErrorCode.ERROR_UPLOADING_OR_DOWNLOADING_ATTACHMENT);
		}
	}
}
