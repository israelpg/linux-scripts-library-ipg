package eu.europa.ec.rdg.eris.ws.impl.document_management.v4;

import java.sql.Timestamp;
import java.util.List;

import javax.annotation.Resource;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlType;
import javax.xml.ws.BindingType;
import javax.xml.ws.WebServiceContext;
import javax.xml.ws.soap.SOAPBinding;

import org.apache.log4j.Logger;

import weblogic.jws.Policy;
import eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType;
import eu.europa.ec.research.fp.model.document.v5.DocumentAttachmentRefType;
import eu.europa.ec.research.fp.model.document.v5.DocumentMetaDataType;
import eu.europa.ec.research.fp.model.document.v5.LinkTypeType;
import eu.europa.ec.research.fp.model.document.v5.SendersRecipients;
import eu.europa.ec.research.fp.model.document_ref.v3.DocumentRefType;
import eu.europa.ec.research.fp.model.header.v1.HeaderType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.AttachmentDocumentLinkType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.BooleanMessageWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CopyZipAttachmentsToDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CreateDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CreateFileParamsType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CreateFileResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.EcasSignatureType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.FileDocumentType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.FileIdentificatorType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetDocumentHistoryResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetFiledDocumentsResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetformalNotificationAccessLogHistoryResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.LinkAttachmentToDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.NotarizeDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.RegisterDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.RemoveDocumentAttachmentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.ReplacementType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.SealSignatureResponse;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.SearchDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.SendersRecipientsToDeleteType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.ServiceDocumentRefType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.StampDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.SynchronizeDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.TagDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.TagType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.UpdateAttachmentTypeResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.v4.DocumentFault;
import eu.europa.ec.research.fp.services.document_management.v4.IDocumentManagementService;

@BindingType(value = SOAPBinding.SOAP11HTTP_BINDING)
@WebService(portName = "IDocumentManagementService_soaphttp", serviceName = "DocumentManagementService", targetNamespace = "http://ec.europa.eu/research/fp/services/document-management/V4", endpointInterface = "eu.europa.ec.research.fp.services.document_management.v4.IDocumentManagementService", wsdlLocation = "/resources/services/document-management/V4/DocumentManagementService.wsdl")
@Policy(uri = "policy:digestUsernameToken2007.xml")
public class DocumentManagementServiceImpl implements IDocumentManagementService {

	@Resource
	WebServiceContext wsContext;

	Logger logger = Logger.getLogger(DocumentManagementServiceImpl.class);

	@Override
	public CreateDocumentResponseWrapperType createDocument(HeaderType header, CodeRefType documentType, List<DocumentMetaDataType> metadata,
			SendersRecipients sendersRecipients) throws DocumentFault {

		log(header, documentType, metadata, sendersRecipients);

		return FakeXmlUtil.getCreateDocumentResponseWrapperType(documentType, metadata, sendersRecipients);
	}

	@Override
	public BooleanMessageWrapperType externalizeDocument(HeaderType header, ServiceDocumentRefType documenRef) throws DocumentFault {
		log(header, documenRef);

		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType fileDocument(HeaderType header, FileDocumentType documentRef) throws DocumentFault {

		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public GetDocumentResponseWrapperType getDocument(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {

		return FakeXmlUtil.getDocumentResponseWrapperType();
	}

	@Override
	public GetDocumentHistoryResponseWrapperType getDocumentHistory(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {

		log(header, documentRef);

		return FakeXmlUtil.getDocumentHistoryResponseWrapperType();
	}

	@Override
	public RegisterDocumentResponseWrapperType registerDocument(HeaderType header, String documentId, Timestamp documentDate, Timestamp sentDate,
			SendersRecipients sendersRecipients) throws DocumentFault {

		log(header, documentId, documentDate, sentDate, sendersRecipients);

		return FakeXmlUtil.getRegisterDocumentResponseWrapperType();
	}

	@Override
	public RegisterDocumentResponseWrapperType registerDocumentById(HeaderType header, DocumentRefType documentId) throws DocumentFault {

		log(header, documentId);

		return FakeXmlUtil.getRegisterDocumentResponseWrapperType();
	}

	@Override
	public RemoveDocumentAttachmentResponseWrapperType removeDocumentAttachment(HeaderType header, List<DocumentAttachmentRefType> attachmentRef)
			throws DocumentFault {

		log(header, attachmentRef);

		return FakeXmlUtil.getRemoveDocumentAttachmentResponseWrapperType();
	}

	@Override
	public SearchDocumentResponseWrapperType searchDocument(HeaderType header, String query) throws DocumentFault {

		log(header, query);

		return getSearchDocumentResponseWrapperType();
	}

	private SearchDocumentResponseWrapperType getSearchDocumentResponseWrapperType() {

		return FakeXmlUtil.getSearchDocumentResponseWrapperType();
	}

	@Override
	public SynchronizeDocumentResponseWrapperType synchronizeDocument(HeaderType header, ServiceDocumentRefType documenRef) throws DocumentFault {

		log(header, documenRef);

		return FakeXmlUtil.getSynchronizeDocumentResponseWrapperType();
	}

	@Override
	public TagDocumentResponseWrapperType tagDocument(HeaderType header, ServiceDocumentRefType documenRef, TagType tag) throws DocumentFault {

		log(header, documenRef, tag);

		return FakeXmlUtil.getTagDocumentResponseWrapperType();
	}

	@Override
	public BooleanMessageWrapperType updateDocument(HeaderType header, String masterID, CodeRefType documentType, List<DocumentMetaDataType> metadata,
			SendersRecipients sendersRecipientsToAdd, SendersRecipientsToDeleteType sendersRecipientsToDelete) throws DocumentFault {
		log(header, masterID, documentType, metadata, sendersRecipientsToAdd, sendersRecipientsToDelete);

		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public CopyZipAttachmentsToDocumentResponseWrapperType copyZipAttachmentsToDocument(HeaderType header, DocumentRefType documentId,
			List<DocumentAttachmentRefType> attachments) throws DocumentFault {

		log(header, documentId, attachments);

		return FakeXmlUtil.getCopyZipAttachmentsToDocumentResponseWrapperType();
	}

	private void log(Object... objs) {

		for (int i = 0; i < objs.length; i++) {
			StringBuilder sb = new StringBuilder();
			Object param = objs[i];
			sb.append(i).append(" - ");
			if (param == null) {
				sb.append(" null");
			} else if (param.getClass().isAnnotationPresent(XmlType.class)) {
				sb.append(JavaToXml.toXml(param));
//				sb.append(JaxbUtils.generateXML(param));
			} else {
				sb.append(param.toString());
			}
			logger.debug(sb.toString());
		}
	}

	@Override
	public LinkAttachmentToDocumentResponseWrapperType linkAttachmentsToDocument(HeaderType header, AttachmentDocumentLinkType requestedLink)
			throws DocumentFault {

		log(header, requestedLink);

		return FakeXmlUtil.getLinkAttachmentToDocumentResponseWrapperType();

	}

	@Override
	public StampDocumentResponseWrapperType stampDocument(HeaderType header, DocumentAttachmentRefType downloadAttachmentRef, List<ReplacementType> replacements)
			throws DocumentFault {
		log(header, downloadAttachmentRef);

		return FakeXmlUtil.getStampDocumentResponseWrapperType();
	}

	@Override
	public NotarizeDocumentResponseWrapperType notarizeDocument(HeaderType header, ServiceDocumentRefType documenRef) throws DocumentFault {
		log(header, documenRef);

		return FakeXmlUtil.getNotarizeDocumentResponseWrapperType();
	}

	@Override
	public CreateFileResponseWrapperType createFile(HeaderType header, CreateFileParamsType createFileParams) throws DocumentFault {
		log(header, createFileParams);

		return FakeXmlUtil.getCreateFileResponseWrapperType();
	}

	@Override
	public CreateFileResponseWrapperType automaticFileCreation(HeaderType header, String filePlan, String fileType, String fileTitle, String specificCode,
			String chefDeFile) throws DocumentFault {
		log(header, filePlan, fileType, specificCode, chefDeFile);

		return FakeXmlUtil.getCreateFileResponseWrapperType();
	}

	@Override
	public BooleanMessageWrapperType unfileDocument(HeaderType header, FileIdentificatorType fileIdentificator, String documentId) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public GetFiledDocumentsResponseWrapperType getFiledDocuments(HeaderType header, FileIdentificatorType fileIdentificator) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public UpdateAttachmentTypeResponseWrapperType updateAttachmentType(HeaderType header, DocumentAttachmentRefType attachmentRef, CodeRefType type)
			throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public NotarizeDocumentResponseWrapperType notarizeDocumentWithoutRegistration(HeaderType header, ServiceDocumentRefType documenRef) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BooleanMessageWrapperType automaticDocumentFiling(HeaderType header, String filePlan, String fileType, String fileSpecificCode, String subfileType,
			DocumentRefType documentId) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType registerContactPersonFormalNotification(HeaderType header, String projectId, String projectResponsiblePic,
			ServiceDocumentRefType documentRef, Integer daysBeforeExpiring) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType registerPersonalFormalNotification(HeaderType header, List<String> users, ServiceDocumentRefType documentRef)
			throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType registerLearFormalNotification(HeaderType header, String organisationPic, ServiceDocumentRefType documentRef)
			throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public GetformalNotificationAccessLogHistoryResponseWrapperType getFormalNotificationAccessLogHistory(HeaderType header, String documentAresId)
			throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SealSignatureResponse sealSignatureWithEcasSigner(HeaderType header, String documentId, String attachmentName, String correlationId,
			String signaturePlaceholder, EcasSignatureType ecasSigner) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SealSignatureResponse sealSignatureWithSignatureText(HeaderType header, String documentId, String attachmentName, String correlationId,
			String signaturePlaceholder, String signatureText) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BooleanMessageWrapperType linkDocuments(HeaderType header, ServiceDocumentRefType sourceDocumenRef, ServiceDocumentRefType targetDocumenRef,
			LinkTypeType linkType) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType partialExternalizeDocument(HeaderType header, ServiceDocumentRefType documenRef,
			List<DocumentAttachmentRefType> attachmentRef) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType unexternalizeDocument(HeaderType header, ServiceDocumentRefType documenRef) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType deleteDocument(HeaderType header, ServiceDocumentRefType documenRef) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

	@Override
	public BooleanMessageWrapperType unlinkDocuments(HeaderType header, ServiceDocumentRefType sourceDocumentRef, ServiceDocumentRefType targetDocumentRef,
			LinkTypeType linkType) throws DocumentFault {
		return FakeXmlUtil.getFakeBooleanMessage();
	}

}
