package eu.europa.ec.rdg.eris.document.common;

import junit.framework.Assert;

import org.junit.Test;

public class StringUtilTest {

	@Test
	public void shouldGetValidString() {
		
		String inputString = "test.middle/earth\"";
		
		String validString = "test_middle_earth_";
		
		String result = StringUtil.convertToValidString(inputString);
		
		Assert.assertEquals(validString, result);
		
	}
	
	@Test
	public void shouldNotChangeValidString() {
		
		String inputString = "test middle_earth";
		
		String validString = "test middle_earth";
		
		String result = StringUtil.convertToValidString(inputString);
		
		Assert.assertEquals(validString, result);
		
	}

	@Test
	public void shouldConvertToValidStringWithEmptyString() {
		
		String inputString = "";
		
		String validString = "";
		
		String result = StringUtil.convertToValidString(inputString);
		
		Assert.assertEquals(validString, result);
		
	}

	@Test(expected = IllegalArgumentException.class)
	public void shouldConvertToValidStringNotAcceptNull() {
		
		StringUtil.convertToValidString(null);
		
	}
	
	@Test
	public void shouldHasIllegalCharactersReturnFalseWithEmptyString() {
		boolean result = StringUtil.hasIllegalCharacters("");
		
		Assert.assertFalse(result);
	}

	@Test
	public void shouldHasIllegalCharactersReturnFalseForValidString() {
		
		String inputString = "test middle_earth";
		
		boolean result = StringUtil.hasIllegalCharacters(inputString);
		
		Assert.assertFalse(result);
		
	}

	@Test
	public void shouldHasIllegalCharactersReturnTrueForInvalidString() {
		
		String inputString = "test.middle/earth\"";
		
		boolean result = StringUtil.hasIllegalCharacters(inputString);
		
		Assert.assertTrue(result);
		
	}
	
	@Test(expected = IllegalArgumentException.class)
	public void shoulHasIllegalCharactersdNotAcceptNull() {
		
		StringUtil.hasIllegalCharacters(null);
		
	}

	
}
