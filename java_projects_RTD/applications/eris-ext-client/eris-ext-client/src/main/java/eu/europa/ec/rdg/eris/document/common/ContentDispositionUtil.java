package eu.europa.ec.rdg.eris.document.common;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

public class ContentDispositionUtil {

	static final String SEP = ";";
	static final String CONT_DISP_ATTACHMENT = "attachment";
	static final String CONT_DISP_PREFIX = "filename=\"";
	static final String CONT_DISP_PREFIX_UTF8 = "filename*=UTF-8''";
	static final String CONT_DISP_SUFFIX = "\"";
	public static final String CONT_DISP_HEADER_NAME = "Content-Disposition";

	public static String getFileName(String contentDisposition) throws UnsupportedEncodingException {
		String fileName = null;
		if (contentDisposition != null) {

			if (contentDisposition.contains(CONT_DISP_PREFIX_UTF8)) {
				int ini = contentDisposition.indexOf(CONT_DISP_PREFIX_UTF8) + CONT_DISP_PREFIX_UTF8.length();
				fileName = contentDisposition.substring(ini);
				fileName = URLDecoder.decode(fileName, "UTF-8");

			} else if (contentDisposition.contains(CONT_DISP_PREFIX)) {

				int ini = contentDisposition.indexOf(CONT_DISP_PREFIX) + CONT_DISP_PREFIX.length();
				int end = contentDisposition.indexOf(CONT_DISP_SUFFIX, ini);
				fileName = contentDisposition.substring(ini, end);

			} else {
				fileName = "filenameError";
			}
		}
		return fileName;

	}

	public static String getContentDisposition(String attName) throws UnsupportedEncodingException {

		String result = CONT_DISP_ATTACHMENT + SEP + CONT_DISP_PREFIX + attName + CONT_DISP_SUFFIX;
		return result;
	}

	public static String getContentDispositionUTF8(String attName) throws UnsupportedEncodingException {

		String attNameUTF8 = URLEncoder.encode(attName, "UTF-8");
		String result = getContentDisposition(attName) + SEP + CONT_DISP_PREFIX_UTF8 + attNameUTF8;
		return result;
	}

}
