package eu.europa.ec.rdg.eris.document.common;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtil {

	public static final String ILLEGAL_CHARACTERS = "<*>:\\\"/\\\\|?.'%";

	/**
	 * Checks if the given String contains not allowed characters (see {@link StringUtil#ILLEGAL_CHARACTERS}).
	 * 
	 * @param s The String to be checked.
	 * @return <code>true</code> if the string contains not allowed characters, <code>false</code> otherwise.
	 * @throws IllegalArgumentException If the input string is <code>null</code>.
	 */
	public static boolean hasIllegalCharacters(final String s) throws IllegalArgumentException {
		if (s != null) {
			Pattern pattern = Pattern.compile("[" + ILLEGAL_CHARACTERS + "]");
			Matcher matcher = pattern.matcher(s);
			return matcher.find();
		} else {
			throw new IllegalArgumentException("Input string cannot be null.");
		}
	}
	
	/**
	 * Converts a given String in a valid one, replacing all the not allowed characters (see {@link StringUtil#ILLEGAL_CHARACTERS}) with '_'.
	 * If the string does not contain any illegal character, the original string will be returned.
	 * 
	 * @param s The string to be converted.
	 * @return A string containing all valid characters.
	 * @throws IllegalArgumentException If the input string is <code>null</code>.
	 */
	public static String convertToValidString(final String s) throws IllegalArgumentException {
		if (s != null) {
			return s.replaceAll("[" + ILLEGAL_CHARACTERS + "]", "_");
		} else {
			throw new IllegalArgumentException("Input string cannot be null.");
		}
	}
}
