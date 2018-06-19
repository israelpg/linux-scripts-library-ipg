package eu.europa.ec.rdg.eris.document.v4.util;

import org.junit.Test;

import eu.europa.ec.rdg.eris.document.common.ErisClientException;
import eu.europa.ec.research.fp.model.document_ref.v3.DocumentRefType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v3.UploadDocAttachmentType;

public class AttachmentUtilTest {

	@Test
	public void shouldValidateValidFileName() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}

	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_1() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_\\_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}

	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_2() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_<_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}

	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_3() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_*_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_4() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_>_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_5() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_:_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	

	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_6() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_\"_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_7() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_/_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_8() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_|_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_9() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_?_");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
	@Test(expected = ErisClientException.class)
	public void shouldNotValidateInvalidFileName_10() throws Exception {
		
		UploadDocAttachmentType attType = new UploadDocAttachmentType();
		attType.setAttachmentName("test_valid_._");
		DocumentRefType docRefType = new DocumentRefType();
		docRefType.setMasterID("test");
		attType.setDocumentRef(docRefType);
		AttachmentUtil.validateAttachment(attType);
		
	}
	
}
