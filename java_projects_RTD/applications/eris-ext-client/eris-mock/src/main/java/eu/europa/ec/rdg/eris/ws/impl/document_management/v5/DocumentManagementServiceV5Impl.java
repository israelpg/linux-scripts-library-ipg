package eu.europa.ec.rdg.eris.ws.impl.document_management.v5;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.jws.WebService;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.ws.BindingType;
import javax.xml.ws.soap.SOAPBinding;

import eu.europa.ec.research.fp.services.document_management.interfaces.v5.*;
import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

import weblogic.jws.Policy;
import eu.europa.ec.rdg.eris.utils.Ccm2CodeUtil;
import eu.europa.ec.rdg.eris.utils.CcmConstants;
import eu.europa.ec.rdg.eris.utils.SerializingCaches;
import eu.europa.ec.rdg.framework.cache.Cache;
import eu.europa.ec.rdg.framework.cache.CacheManager;
import eu.europa.ec.rdg.framework.util.DateUtils;
import eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType;
import eu.europa.ec.research.fp.model.document.v5.AssignmentTaskListType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentAttributeListType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentNameType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentType;
import eu.europa.ec.research.fp.model.document.v5.DateTimeType;
import eu.europa.ec.research.fp.model.document.v5.DocumentAttachmentRefType;
import eu.europa.ec.research.fp.model.document.v5.DocumentMetaDataType;
import eu.europa.ec.research.fp.model.document.v5.ExternalizationType;
import eu.europa.ec.research.fp.model.document.v5.LinkTypeType;
import eu.europa.ec.research.fp.model.document.v5.LocalDocumentType;
import eu.europa.ec.research.fp.model.document.v5.LocalFileType;
import eu.europa.ec.research.fp.model.document.v5.MailTypeType;
import eu.europa.ec.research.fp.model.document.v5.MetaDataValueType;
import eu.europa.ec.research.fp.model.document.v5.SendersRecipients;
import eu.europa.ec.research.fp.model.document.v5.StringType;
import eu.europa.ec.research.fp.model.document_ref.v3.DocumentRefType;
import eu.europa.ec.research.fp.model.header.v1.HeaderType;
import eu.europa.ec.research.fp.model.service_context.v2.ResultContextType;
import eu.europa.ec.research.fp.model.service_context.v2.ResultContextType.ServiceInformationList;
import eu.europa.ec.research.fp.model.service_context.v2.ServiceInformationType;
import eu.europa.ec.research.fp.model.service_context.v2.ServiceInformationType.StatusDetailList;
import eu.europa.ec.research.fp.model.service_context.v2.StatusDetailType;
import eu.europa.ec.research.fp.model.service_context.v2.StatusType;
import eu.europa.ec.research.fp.model.service_fault.v1.BusinessFaultInfoType;
import eu.europa.ec.research.fp.services.document_management.v5.DocumentFault;
import eu.europa.ec.research.fp.services.document_management.v5.IDocumentManagementService;

@WebService(portName = "IDocumentManagementService_soaphttp", serviceName = "DocumentManagementService", targetNamespace = "http://ec.europa.eu/research/fp/services/document-management/V5", endpointInterface = "eu.europa.ec.research.fp.services.document_management.v5.IDocumentManagementService", name = "XXXServ")
@BindingType(SOAPBinding.SOAP11HTTP_BINDING)
@Policy(uri = "policy:digestUsernameToken.xml")
public class DocumentManagementServiceV5Impl extends ErisMockXmlFileLoader implements IDocumentManagementService {

	private static final Logger LOGGER = Logger.getLogger(DocumentManagementServiceV5Impl.class);

	private static final Pattern DOCUMENT_TYPE_PATTERN = Pattern.compile(".*#document type\\s*in\\s*\\(\\s*(\\d+)\\s*\\).*", Pattern.CASE_INSENSITIVE);

	protected BooleanMessageWrapperType getBooleanResponseMessage(String message) {
		BooleanMessageWrapperType booleanMessage = new BooleanMessageWrapperType();
		booleanMessage.setIsSuccess(true);
		booleanMessage.setMessage(message);
		return booleanMessage;
	}

	@Override
	public CreateDocumentResponseWrapperType createDocument(HeaderType header, CodeRefType documentType, DocumentMetaDataListType metadata,
			SendersRecipients sendersRecipients) throws DocumentFault {
		LOGGER.info("Execute createDocument with parameters : [header] = " + header + ", [documentType] = " + documentType + ", [metadata] = " + metadata
				+ ", [sendersRecipients] = " + sendersRecipients);

		String masterId = Long.toString(new Date().getTime());

		LocalDocumentType localDocumentType = new LocalDocumentType();
		localDocumentType.setExternalized(false);
		localDocumentType.setMailType(MailTypeType.INTERNAL);
		localDocumentType.setMaster("HERMES");
		localDocumentType.setMasterID(masterId);
		localDocumentType.getMetaData().addAll(metadata.getDocumentMetaData());
		localDocumentType.setSendersRecipients(sendersRecipients);
		localDocumentType.setType(documentType);

		CreateDocumentResponseWrapperType createDocumentResponseWrapperType = new CreateDocumentResponseWrapperType();
		createDocumentResponseWrapperType.setDocument(localDocumentType);
		createDocumentResponseWrapperType.setHeader(header);
		createDocumentResponseWrapperType.setResultContext(createResultContextType(StatusType.OK));

		try {
			GetDocumentResponseWrapperType getDocumentResponseWrapperType = new GetDocumentResponseWrapperType();
			getDocumentResponseWrapperType.setDocument(localDocumentType);
			getDocumentResponseWrapperType.setHeader(new HeaderType());
			getDocumentResponseWrapperType.setResultContext(createResultContextType(StatusType.OK));

			GetDocumentResponseType getDocumentResponseType = new GetDocumentResponseType();
			getDocumentResponseType.setResponse(getDocumentResponseWrapperType);

			JAXBElement<GetDocumentResponseType> jaxbElement = new ObjectFactory().createGetDocumentResponse(getDocumentResponseType);
			setType(GetDocumentResponseType.class, jaxbElement, "_" + masterId, ObjectFactory.class);

		} catch (IOException | JAXBException | SAXException | URISyntaxException exception) {
			throw new DocumentFault("Error creating the Document", getBusinessFaultInfoType("1001"), exception);
		}

		return createDocumentResponseWrapperType;
	}

	@Override
	public CreateFileResponseWrapperType createFile(HeaderType header, CreateFileParamsType createFileParams) throws DocumentFault {
		LocalFileType file = new LocalFileType();
		file.setSpecificCode(createFileParams.getSpecificCode());
		file.setChefDeFile(createFileParams.getChefDeFile());

		CreateFileResponseWrapperType response = new CreateFileResponseWrapperType();
		response.setResultContext(createResultContextType(StatusType.OK));
		response.setFile(file);
		return response;
	}

	@Override
	public BooleanMessageWrapperType externalizeDocument(HeaderType header, ServiceDocumentRefType documentRef, Integer externalPartitionId)
			throws DocumentFault {

		try {
			GetDocumentResponseWrapperType document = getDocument(header, documentRef, false);
			GetDocumentResponseType getDocumentResponseType = new GetDocumentResponseType();
			getDocumentResponseType.setResponse(document);

			LocalDocumentType localDocumentType = getDocumentResponseType.getResponse().getDocument();
			localDocumentType.setExternalized(true);
			localDocumentType.setExternalizationType(ExternalizationType.FULL);

			JAXBElement<GetDocumentResponseType> jaxbElement = new ObjectFactory().createGetDocumentResponse(getDocumentResponseType);
			setType(GetDocumentResponseType.class, jaxbElement, "_" + localDocumentType.getMasterID(), ObjectFactory.class);

			BooleanMessageWrapperType booleanMessageWrapperType = new BooleanMessageWrapperType();
			booleanMessageWrapperType.setHeader(header);
			booleanMessageWrapperType.setIsSuccess(true);
			booleanMessageWrapperType.setMessage("OK");
			booleanMessageWrapperType.setResultContext(createResultContextType(StatusType.OK));

			return booleanMessageWrapperType;

		} catch (IOException | JAXBException | SAXException | URISyntaxException exception) {
			throw new DocumentFault("Error when externalize Document !", getBusinessFaultInfoType("1005"), exception);
		}
	}

	@Override
	public BooleanMessageWrapperType fileDocument(HeaderType header, FileDocumentType documentRef) throws DocumentFault {
		return getBooleanResponseMessage("OK");
	}

	@Override
	public BooleanMessageWrapperType unfileDocument(HeaderType header, FileIdentificatorType fileIdentificator, String documentId) throws DocumentFault {
		return getBooleanResponseMessage("OK");
	}

	@Override
	public GetFiledDocumentsResponseWrapperType getFiledDocuments(HeaderType header, FileIdentificatorType fileIdentificator) throws DocumentFault {
		throw new DocumentFault("Not implemented by mock", getBusinessFaultInfoType("1005"));
	}

	@Override
	public GetDocumentResponseWrapperType getDocument(HeaderType header, ServiceDocumentRefType documentRef, Boolean returnAttachmentAttributes)
			throws DocumentFault {
		LOGGER.info("Execute getDocument with parameters : [header] = " + header + ", [documentRef] = " + documentRef);

		try {
			if (documentRef.getDocumentVersionRefOrAresRef() != null) {
				if (documentRef.getDocumentVersionRefOrAresRef() instanceof DocumentRefType) {
					// we have a document version reference search
					DocumentRefType refType = (DocumentRefType) documentRef.getDocumentVersionRefOrAresRef();
					GetDocumentResponseType documentResponseType = getType(GetDocumentResponseType.class, "_" + refType.getMasterID(), ObjectFactory.class);
					if (documentResponseType != null) {
						return documentResponseType.getResponse();
					}
				} else if (documentRef.getDocumentVersionRefOrAresRef() instanceof String) {
					// we have an ares reference search
					String registrationNumber = (String) documentRef.getDocumentVersionRefOrAresRef();
					List<GetDocumentResponseType> allDocumentResponseTypes = getTypes(GetDocumentResponseType.class, ObjectFactory.class);
					for (GetDocumentResponseType documentResponseType : allDocumentResponseTypes) {
						for (DocumentMetaDataType metaDataType : documentResponseType.getResponse().getDocument().getMetaData()) {
							if (CcmConstants.DOCGEN_METADATA_DOC_REGISTRATION_NUMBER.getId().toString().equals(metaDataType.getMetaDataRef().getId())
									&& metaDataType.getValue().getStringOrDateOrBoolean() instanceof StringType
									&& registrationNumber.equals(((StringType) metaDataType.getValue().getStringOrDateOrBoolean()).getValue())) {
								return documentResponseType.getResponse();
							}
						}
					}
				}
			}
		} catch (IOException | JAXBException | SAXException | URISyntaxException exception) {
			throw new DocumentFault("Error getting the Document", getBusinessFaultInfoType("1002"), exception);
		}

		GetDocumentResponseWrapperType getDocumentResponseWrapperType = new GetDocumentResponseWrapperType();
		getDocumentResponseWrapperType.setHeader(header);
		getDocumentResponseWrapperType.setResultContext(createResultContextType(StatusType.ERROR));

		return getDocumentResponseWrapperType;
	}

	@Override
	public GetDocumentHistoryResponseWrapperType getDocumentHistory(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {
		throw new DocumentFault("Not implemented by mock", getBusinessFaultInfoType("1005"));
	}

	@Override
	public LinkAttachmentToDocumentResponseWrapperType linkAttachmentsToDocument(HeaderType header, AttachmentDocumentLinkType requestedLink)
			throws DocumentFault {
		throw new DocumentFault("Not implemented by mock", getBusinessFaultInfoType("1005"));
	}

	@Override
	public RegisterDocumentResponseWrapperType registerDocument(HeaderType header, String documentId, Timestamp documentDate, Timestamp sentDate,
			SendersRecipients sendersRecipients) throws DocumentFault {
		LOGGER.info("Execute registerDocument with parameters : [header] = " + header + ", [documentId] = " + documentId + ", [documentDate] = " + documentDate
				+ ", [sentDate] = " + sentDate + ", [sendersRecipients] = " + sendersRecipients);

		try {
			GetDocumentResponseType getDocumentResponseType = getType(GetDocumentResponseType.class, "_" + documentId, ObjectFactory.class);
			if (getDocumentResponseType != null) {
				LocalDocumentType localDocumentType = getDocumentResponseType.getResponse().getDocument();
				for (DocumentMetaDataType documentMetaDataType : localDocumentType.getMetaData()) {
					if (CcmConstants.DOCGEN_METADATA_DOC_REGISTRATION_NUMBER.getId().toString().equals(documentMetaDataType.getMetaDataRef().getId())) {
						StringType stringType = (StringType) documentMetaDataType.getValue().getStringOrDateOrBoolean();
						throw new DocumentFault("Document with id " + documentId + " is already registred with Registration Number " + stringType.getValue(),
								getBusinessFaultInfoType("1003"));
					}
				}

				StringType stringType = new StringType();
				stringType.setValue("Ares(" + new GregorianCalendar().get(Calendar.YEAR) + ")" + System.currentTimeMillis());

				MetaDataValueType registrationNumberMetaDataValueType = new MetaDataValueType();
				registrationNumberMetaDataValueType.setStringOrDateOrBoolean(stringType);

				DocumentMetaDataType registrationNumberDocumentMetaDataType = new DocumentMetaDataType();
				registrationNumberDocumentMetaDataType.setMetaDataRef(Ccm2CodeUtil.getCodeRefV3(CcmConstants.DOCGEN_METADATA_DOC_REGISTRATION_NUMBER));
				registrationNumberDocumentMetaDataType.setValue(registrationNumberMetaDataValueType);

				DateTimeType dateTimeType = new DateTimeType();
				dateTimeType.setValue(documentDate);

				MetaDataValueType registrationDateMetaDataValueType = new MetaDataValueType();
				registrationDateMetaDataValueType.setStringOrDateOrBoolean(dateTimeType);

				DocumentMetaDataType registrationDateDocumentMetaDataType = new DocumentMetaDataType();
				registrationDateDocumentMetaDataType.setMetaDataRef(Ccm2CodeUtil.getCodeRefV3("31053053"));
				registrationDateDocumentMetaDataType.setValue(registrationDateMetaDataValueType);

				localDocumentType.getMetaData().add(registrationNumberDocumentMetaDataType);
				localDocumentType.getMetaData().add(registrationDateDocumentMetaDataType);

				JAXBElement<GetDocumentResponseType> jaxbElement = new ObjectFactory().createGetDocumentResponse(getDocumentResponseType);
				setType(GetDocumentResponseType.class, jaxbElement, "_" + documentId, ObjectFactory.class);

				RegisterDocumentResponseWrapperType registerDocumentResponseWrapperType = new RegisterDocumentResponseWrapperType();
				registerDocumentResponseWrapperType.setHeader(header);
				registerDocumentResponseWrapperType.setRegistrationDate(DateUtils.getTimestamp());
				registerDocumentResponseWrapperType.setRegistrationNumber(documentId);
				registerDocumentResponseWrapperType.setResultContext(createResultContextType(StatusType.OK));

				return registerDocumentResponseWrapperType;

			} else {
				throw new DocumentFault("Document with id " + documentId + " not found !", getBusinessFaultInfoType("1003"));
			}

		} catch (IOException | JAXBException | SAXException | URISyntaxException exception) {
			throw new DocumentFault("Error registering Document id " + documentId, getBusinessFaultInfoType("1003"), exception);
		}
	}

	@Override
	public RegisterDocumentResponseWrapperType registerDocumentById(HeaderType header, DocumentRefType documentId) throws DocumentFault {

		return null;
	}

	@Override
	public SearchDocumentResponseWrapperType searchDocument(HeaderType header, String query) throws DocumentFault {
		LOGGER.info("Execute searchDocument with parameters : [header] = " + header + ", [query] = " + query);

		List<GetDocumentResponseType> getDocumentResponseTypes;
		try {
			getDocumentResponseTypes = getTypes(GetDocumentResponseType.class, ObjectFactory.class);
		} catch (IOException | JAXBException | SAXException | URISyntaxException exception) {
			throw new DocumentFault("Error searching Documents", getBusinessFaultInfoType("1004"), exception);
		}

		Matcher matcher = DOCUMENT_TYPE_PATTERN.matcher(query);
		if (matcher.matches()) {
			String documentTypeCcmCodeId = matcher.group(1);

			for (Iterator<GetDocumentResponseType> iterator = getDocumentResponseTypes.iterator(); iterator.hasNext();) {
				GetDocumentResponseType getDocumentResponseType = iterator.next();
				LocalDocumentType localDocumentType = getDocumentResponseType.getResponse().getDocument();
				if (!localDocumentType.getType().getId().equals(documentTypeCcmCodeId)) {
					iterator.remove();
				}
			}
		}

		LocalDocumentListType localDocumentListType = new LocalDocumentListType();
		for (GetDocumentResponseType getDocumentResponseType : getDocumentResponseTypes) {
			localDocumentListType.getDocument().add(getDocumentResponseType.getResponse().getDocument());
		}

		SearchDocumentResponseWrapperType searchDocumentResponseWrapperType = new SearchDocumentResponseWrapperType();
		searchDocumentResponseWrapperType.setDocumentList(localDocumentListType);
		searchDocumentResponseWrapperType.setHeader(header);
		searchDocumentResponseWrapperType.setResultContext(createResultContextType(StatusType.OK));

		return searchDocumentResponseWrapperType;
	}

	@Override
	public BooleanMessageWrapperType updateDocument(HeaderType header, String masterID, CodeRefType documentType, DocumentMetaDataListType metadata,
			SendersRecipients sendersRecipientsToAdd, SendersRecipients sendersRecipientsToDelete, Boolean forceDocTypeChange) throws DocumentFault {
		LOGGER.info("Execute updateDocument with parameters : [header] = " + header + ", [masterID] = " + masterID + ", [documentType] = " + documentType
				+ ", [metadata] = " + metadata + ", [sendersRecipientsToAdd] = " + sendersRecipientsToAdd + ", [sendersRecipientsToDelete] = "
				+ sendersRecipientsToDelete);

		// TODO: ADD BUSINESS LOGIC !!!

		BooleanMessageWrapperType booleanMessageWrapperType = new BooleanMessageWrapperType();
		booleanMessageWrapperType.setHeader(header);
		booleanMessageWrapperType.setIsSuccess(true);
		booleanMessageWrapperType.setMessage("");
		booleanMessageWrapperType.setResultContext(createResultContextType(StatusType.OK));

		return booleanMessageWrapperType;
	}

	@Override
	public RemoveDocumentAttachmentResponseWrapperType removeDocumentAttachment(HeaderType header, DocumentAttachmentRefListType attachmentRefs)
			throws DocumentFault {
		LOGGER.info("Processing removeDocumentAttachment Request:");
		for (DocumentAttachmentRefType documentAttachmentRefType : attachmentRefs.getAttachmentRef()) {
			LOGGER.info("documentAttachmentRefType.getMasterID:" + documentAttachmentRefType.getMasterID());
			String attachementName = ((AttachmentNameType) documentAttachmentRefType.getAttachmentIdOrAttachmentName()).getValue();
			LOGGER.info("documentAttachmentRefType.getAttachmentIdOrAttachmentName:" + attachementName);

			GetDocumentResponseWrapperType getDocumentResponseWrapperType = load(header, documentAttachmentRefType);
			String attachementFilename = findAttachmentFilenameOnLocalHostAndRemoveItFromXML(getDocumentResponseWrapperType, attachementName);
			try {
				File attachmentFile = getAbsolutePath(ErisMockServlet.ATTACHMENT_PREFIX + attachementFilename);
				LOGGER.info(attachmentFile.getAbsolutePath());
				boolean deleted = attachmentFile.delete();
				LOGGER.info("File " + attachmentFile.getAbsolutePath() + " deleted : " + deleted);

				GetDocumentResponseType getDocumentResponseType = new GetDocumentResponseType();
				getDocumentResponseType.setResponse(getDocumentResponseWrapperType);

				JAXBElement<GetDocumentResponseType> jaxbElement = new ObjectFactory().createGetDocumentResponse(getDocumentResponseType);
				String masterId = documentAttachmentRefType.getMasterID();
				LOGGER.info("Attachement was removed");

				Cache cache = CacheManager.getInstance().getCache(SerializingCaches.ERIS_DOCUMENTS_BY_ARES_REF.toString());
				cache.removeAll();
				cache = CacheManager.getInstance().getCache(SerializingCaches.ERIS_DOCUMENTS_BY_ID.toString());
				cache.removeAll();
				LOGGER.info("Eris cache refreshed");
				setType(GetDocumentResponseType.class, jaxbElement, "_" + masterId, ObjectFactory.class);
			} catch (URISyntaxException | IOException | JAXBException | SAXException e) {
				LOGGER.error("Exception", e);
			}
		}
		return null;
	}

	private GetDocumentResponseWrapperType load(HeaderType header, DocumentAttachmentRefType documentAttachmentRefType) {
		DocumentRefType documentRefType = new DocumentRefType();
		documentRefType.setMaster(documentAttachmentRefType.getMaster());
		documentRefType.setMasterID(documentAttachmentRefType.getMasterID());
		documentRefType.setTag(documentAttachmentRefType.getTag());

		ServiceDocumentRefType serviceDocumentRefType = new ServiceDocumentRefType();
		serviceDocumentRefType.setDocumentVersionRefOrAresRef(documentRefType);

		GetDocumentResponseWrapperType getDocumentResponseWrapperType = null;
		try {
			getDocumentResponseWrapperType = getDocument(header, serviceDocumentRefType, true);
		} catch (DocumentFault e) {
			LOGGER.error("DocumentFault", e);
		}
		return getDocumentResponseWrapperType;
	}

	private String findAttachmentFilenameOnLocalHostAndRemoveItFromXML(GetDocumentResponseWrapperType getDocumentResponseWrapperType, String attachementName) {
		if (getDocumentResponseWrapperType != null && getDocumentResponseWrapperType.getDocument() != null
				&& getDocumentResponseWrapperType.getDocument().getAttachments() != null) {
			for (AttachmentType attachmentType : getDocumentResponseWrapperType.getDocument().getAttachments()) {
				if (attachmentType.getAttachmentName() != null && attachmentType.getAttachmentName().equals(attachementName)) {
					LOGGER.info("Attachment found for name <" + attachementName + "> with id: " + attachmentType.getId());
					getDocumentResponseWrapperType.getDocument().getAttachments().remove(attachmentType);
					return attachmentType.getId();
				}
			}
		}
		return null;
	}

	@Override
	public UpdateAttachmentTypeResponseWrapperType updateAttachmentType(HeaderType header, DocumentAttachmentRefType attachmentRef, CodeRefType type)
			throws DocumentFault {

		return null;
	}

	@Override
	public SynchronizeDocumentResponseWrapperType synchronizeDocument(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {

		return null;
	}

	@Override
	public TagDocumentResponseWrapperType tagDocument(HeaderType header, ServiceDocumentRefType documentRef, TagType tag) throws DocumentFault {

		return null;
	}

	@Override
	public CopyZipAttachmentsToDocumentResponseWrapperType copyZipAttachmentsToDocument(HeaderType header, DocumentRefType documentId,
			DocumentAttachmentRefListType attachmentRefs) throws DocumentFault {

		return null;
	}

	@Override
	public CreateFileResponseWrapperType automaticFileCreation(HeaderType header, String filePlan, String fileType, String fileTitle, String specificCode,
			String chefDeFile) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType automaticDocumentFiling(HeaderType header, String filePlan, String fileType, String fileSpecificCode, String subfileType,
			DocumentRefType documentId) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType registerContactPersonFormalNotification(HeaderType header, String projectId, String projectResponsiblePic,
			ServiceDocumentRefType documentRef, Integer daysBeforeExpiring) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType registerPersonalFormalNotification(HeaderType header, UserListType users, ServiceDocumentRefType documentRef)
			throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType registerLearFormalNotification(HeaderType header, String organisationPic, ServiceDocumentRefType documentRef)
			throws DocumentFault {

		return null;
	}

	@Override
	public GetformalNotificationAccessLogHistoryResponseWrapperType getFormalNotificationAccessLogHistory(HeaderType header, String documentAresId)
			throws DocumentFault {

		return null;
	}

	@Override
	public SealSignatureResponseWrapperType sealSignatureWithEcasSigner(HeaderType header, String documentId, String attachmentName, String correlationId,
			String signaturePlaceholder, EcasSignatureType ecasSigner) throws DocumentFault {

		return null;
	}

	@Override
	public SealSignatureResponseWrapperType sealSignatureWithSignatureText(HeaderType header, String documentId, String attachmentName, String correlationId,
			String signaturePlaceholder, String signatureText) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType linkDocuments(HeaderType header, ServiceDocumentRefType sourceDocumentRef, ServiceDocumentRefType targetDocumentRef,
			LinkTypeType linkType) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType partialExternalizeDocument(HeaderType header, ServiceDocumentRefType documentRef,
			DocumentAttachmentRefListType attachmentRefs) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType unexternalizeDocument(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType deleteDocument(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {
		LOGGER.info("Processing deleteDocument Request:");
		return null;
	}

	@Override
	public BooleanMessageWrapperType unlinkDocuments(HeaderType header, ServiceDocumentRefType sourceDocumentRef, ServiceDocumentRefType targetDocumentRef,
			LinkTypeType linkType) throws DocumentFault {

		return null;
	}

	@Override
	public GetDocumentsResponseWrapperType getDocuments(HeaderType header, ServiceDocumentRefListType documentRefs) throws DocumentFault {

		return null;
	}

	@Override
	public CreateVirtualAttachmentsResponseWrapperType createVirtualAttachments(HeaderType header, DocumentRefType targetDocumentRef,
			VirtualAttachmentRefListType virtualAttachmentRefs) throws DocumentFault {

		return null;
	}

	@Override
	public AddAssignmentsResponseWrapperType addAssignments(HeaderType header, String documentId, AssignmentTaskListType assignmentTasks) throws DocumentFault {

		return null;
	}

	@Override
	public NotarizeResponseWrapperType notarize(HeaderType header, NotarizeRequestType notarizeRequest) throws DocumentFault {

		return null;
	}

	@Override
	public CreateAttachmentAttributesResponseWrapperType createAttachmentAttributes(HeaderType header, DocumentAttachmentRefType attachmentRef,
			AttachmentAttributeListType attributes) throws DocumentFault {

		return null;
	}

	@Override
	public UpdateAttachmentAttributesResponseWrapperType updateAttachmentAttributes(HeaderType header, DocumentAttachmentRefType attachmentRef,
			AttachmentAttributeListType attributes) throws DocumentFault {

		return null;
	}

	@Override
	public DeleteAttachmentAttributesResponseWrapperType deleteAttachmentAttributes(HeaderType header, DocumentAttachmentRefType attachmentRef,
			AttachmentAttributeListType attributes) throws DocumentFault {
		LOGGER.info("Processing deleteAttachmentAttributes Request:");
		return null;
	}

	@Override
	public GetAttachmentAttributesResponseWrapperType getAttachmentAttributes(HeaderType header, DocumentAttachmentRefType attachmentRef,
			AttachmentAttributeListType attributes) throws DocumentFault {
		return null;
	}

	@Override
	public BooleanMessageWrapperType updateFile(HeaderType header, UpdateFileRequestType updateFileRequest) throws DocumentFault {

		return null;
	}

	@Override
	public BooleanMessageWrapperType stampAttachment(HeaderType header, StampAttachmentRequestType stampAttachmentRequest) throws DocumentFault {

		return null;
	}

	@Override
	public NotarizeDocumentResponseWrapperType notarizeDocument(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {

		return null;
	}

	@Override
	public NotarizeDocumentResponseWrapperType notarizeDocumentWithoutRegistration(HeaderType header, ServiceDocumentRefType documentRef) throws DocumentFault {

		return null;
	}

	@Override
	public SealAttachmentResponseWrapperType sealAttachment(HeaderType header, String documentId, String attachmentName, String correlationId)
			throws DocumentFault {

		return null;
	}

	@Override
	public UpdateDocumentRestrictionLevelResponseWrapperType updateDocumentRestrictionLevel(HeaderType header, ServiceDocumentRefType documentRef,
			boolean isRestricted) throws DocumentFault {

		UpdateDocumentRestrictionLevelResponseWrapperType updateDocumentRestrictionLevelResponseWrapperType = new UpdateDocumentRestrictionLevelResponseWrapperType();
		updateDocumentRestrictionLevelResponseWrapperType.setHeader(header);
		updateDocumentRestrictionLevelResponseWrapperType.setResultContext(createResultContextType(StatusType.OK));

		return updateDocumentRestrictionLevelResponseWrapperType;
	}

	@Override
	public CloseFileResponseWrapperType closeFile(HeaderType header, String filingPlanOrHeading, String fileType, String specificCode, Boolean forceClosure)
			throws DocumentFault {
		return null;
	}

	@Override
	public ReplicateFilingResponseWrapperType replicateFiling(HeaderType header, String documentId, ServiceDocumentRefType existingDocumentRef)
			throws DocumentFault {
		return null;
	}

	private ResultContextType createResultContextType(StatusType statusType) {
		StatusDetailType statusDetailType = new StatusDetailType();
		statusDetailType.setCode("1000");
		statusDetailType.setDescription("");
		statusDetailType.setDetailStatus(statusType);

		StatusDetailList statusDetailList = new StatusDetailList();
		statusDetailList.getStatusDetail().add(statusDetailType);

		ServiceInformationType serviceInformationType = new ServiceInformationType();
		serviceInformationType.setComplete(true);
		serviceInformationType.setDgName("RDG");
		serviceInformationType.setITSystemName("ERIS-MOCK");
		serviceInformationType.setServiceVersion("5.0");
		serviceInformationType.setStatusDetailList(statusDetailList);

		ServiceInformationList serviceInformationList = new ServiceInformationList();
		serviceInformationList.getServiceInformation().add(serviceInformationType);

		ResultContextType resultContextType = new ResultContextType();
		resultContextType.setComplete(true);
		resultContextType.setGlobalStatus(statusType);
		resultContextType.setResultNumber(1);
		resultContextType.setServiceInformationList(serviceInformationList);

		return resultContextType;
	}

	private BusinessFaultInfoType getBusinessFaultInfoType(String code) {
		BusinessFaultInfoType businessFaultInfoType = new BusinessFaultInfoType();
		businessFaultInfoType.setCode(code);
		return businessFaultInfoType;
	}

	@Override
	public GetAttachmentHistoryResponseWrapperType getAttachmentHistory(HeaderType header, AttachmentNameRefType attachmentNameRef) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public RevertDocumentResponseWrapperType revertDocument(HeaderType header, String documentId, TagType tag) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public CheckServiceHealthResponseType checkServiceHealth(CheckServiceHealthRequestType request) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public PopulateAttachmentFieldWithTextResponseWrapperType populateAttachmentFieldWithText(HeaderType header, String documentId, String attachmentName,
			String placeholderId, String text) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public SearchFilesResponseWrapperType searchFiles(HeaderType header, String criteria) throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public GetAttachmentTaggedChangesResponseWrapperType getAttachmentTaggedChanges(HeaderType header, AttachmentNameRefType attachmentNameRef, String tagFilter)
			throws DocumentFault {
		// TODO Auto-generated method stub
		return null;
	}

    @Override
    public TagDocumentsByCriteriaResponseWrapperType tagDocumentsByCriteria(HeaderType headerType, String s, TagType tagType, Boolean aBoolean) throws DocumentFault {
        return null;
    }

    @Override
    public CompareDocumentVersionsResponseWrapperType compareDocumentVersions(HeaderType headerType, ServiceDocumentRefType serviceDocumentRefType, String s, String s1) throws DocumentFault {
        return null;
    }

    @Override
    public TagDocumentsResponseWrapperType tagDocuments(HeaderType headerType, ServiceDocumentRefListType serviceDocumentRefListType, TagType tagType, Boolean aBoolean) throws DocumentFault {
        return null;
    }

    @Override
    public RemoveTagsResponseWrapperType removeTags(HeaderType headerType, TagListType tagListType) throws DocumentFault {
        return null;
    }

    @Override
    public CloseFileByCriteriaResponseWrapperType closeFileByCriteria(HeaderType headerType, String s, Boolean aBoolean) throws DocumentFault {
        return null;
    }
}
