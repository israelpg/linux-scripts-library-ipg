package eu.europa.ec.rdg.eris.ws.impl.document_management.v4;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import eu.europa.ec.research.fp.model.code_ref.v3.CodeRefType;
import eu.europa.ec.research.fp.model.document.v5.AttachmentIdType;
import eu.europa.ec.research.fp.model.document.v5.DocumentMetaDataType;
import eu.europa.ec.research.fp.model.document.v5.EntityType;
import eu.europa.ec.research.fp.model.document.v5.InternalEntityType;
import eu.europa.ec.research.fp.model.document.v5.LocalDocumentType;
import eu.europa.ec.research.fp.model.document.v5.LocalFileType;
import eu.europa.ec.research.fp.model.document.v5.MetaDataValueType;
import eu.europa.ec.research.fp.model.document.v5.PersonType;
import eu.europa.ec.research.fp.model.document.v5.RecipientType;
import eu.europa.ec.research.fp.model.document.v5.SenderType;
import eu.europa.ec.research.fp.model.document.v5.SendersRecipients;
import eu.europa.ec.research.fp.model.document.v5.StringType;
import eu.europa.ec.research.fp.model.document.v5.TransmitType;
import eu.europa.ec.research.fp.model.document_ref.v3.DocumentRefType;
import eu.europa.ec.research.fp.model.header.v1.HeaderType;
import eu.europa.ec.research.fp.model.service_context.v2.ResultContextType;
import eu.europa.ec.research.fp.model.service_context.v2.ResultContextType.ServiceInformationList;
import eu.europa.ec.research.fp.model.service_context.v2.ServiceInformationType;
import eu.europa.ec.research.fp.model.service_context.v2.ServiceInformationType.StatusDetailList;
import eu.europa.ec.research.fp.model.service_context.v2.StatusDetailType;
import eu.europa.ec.research.fp.model.service_context.v2.StatusType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.AttachmentDocumentLinkType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.BooleanMessageWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CopyZipAttachmentsToDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CreateDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.CreateFileResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetDocumentHistoryResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetDocumentHistoryResponseWrapperType.DocumentList;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.GetDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.LinkAttachmentToDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.NotarizeDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.RegisterDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.RemoveDocumentAttachmentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.SearchDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.StampDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.SynchronizeDocumentResponseWrapperType;
import eu.europa.ec.research.fp.services.document_management.interfaces.v4.TagDocumentResponseWrapperType;

public class FakeXmlUtil {

	private static final String FAKE_ARES_REF = "fakeAresRef";

	static protected BooleanMessageWrapperType getFakeBooleanMessage() {
		BooleanMessageWrapperType booleanMessage = new BooleanMessageWrapperType();
		booleanMessage.setIsSuccess(true);
		booleanMessage.setMessage("fake message");
		return booleanMessage;
	}

	static protected CodeRefType getGenericDocumentType() {
		CodeRefType code = new CodeRefType();
		code.setId("31047688");
		code.setAbbreviation("Document");
		return code;
	}

	static protected CodeRefType getMetaDataTitleCode() {
		CodeRefType code = new CodeRefType();
		code.setId("31047661");
		code.setAbbreviation("Title");
		return code;
	}
	
	static protected LocalDocumentType getFakeDocument(CodeRefType documentType, List<DocumentMetaDataType> metadata, SendersRecipients sendersRecipients) {

		LocalDocumentType document = new LocalDocumentType();
		if (metadata == null) {
			metadata = new ArrayList<DocumentMetaDataType>();
			DocumentMetaDataType data = new DocumentMetaDataType();
			data.setMetaDataRef(getMetaDataTitleCode());
			MetaDataValueType value = new MetaDataValueType();
			StringType s = new StringType();
			s.setValue("A very nice document");
			value.setStringOrDateOrBoolean(s);
			data.setValue(value);

			metadata.add(data);

		}
		document.getMetaData().addAll(metadata);
		if (sendersRecipients != null) {
//			sendersRecipients = new SendersRecipients();
//			sendersRecipients.getRecipients().add(getFakeRecipient());
//			sendersRecipients.getRecipients().add(getFakeRecipient());
//			sendersRecipients.getSenders().add(getFakeSender());
//			sendersRecipients.getSenders().add(getFakeSender());
			SendersRecipients senderRecipients = new SendersRecipients();
			senderRecipients.getRecipients().addAll(sendersRecipients.getRecipients());
			senderRecipients.getSenders().addAll(sendersRecipients.getSenders());
			document.setSendersRecipients(senderRecipients);
		}
		document.setExternalized(false);
		document.setMaster("HERMES");
		document.setMasterID(UUID.randomUUID().toString());
		if (documentType == null) {
			document.setType(getGenericDocumentType());
		} else {
			document.setType(documentType);
		}
		return document;
	}

	static protected SenderType getFakeSender() {
		SenderType sender = new SenderType();
		sender.setEntity(getFakeEntity());
		return null;
	}

	static protected EntityType getFakeEntity() {

		EntityType ent = new EntityType();
		InternalEntityType internal = new InternalEntityType();
		PersonType person = new PersonType();
		person.setEcasId("ecasUserId");
		internal.setPersonOrOrganisation(person);
		ent.setInternalOrExternal(internal);
		return ent;
	}

	static protected RecipientType getFakeRecipient() {

		RecipientType rec = new RecipientType();
		rec.setCode(TransmitType.TO);
		rec.setEntity(getFakeEntity());
		return rec;
	}

	public static AttachmentDocumentLinkType getFakeAttDocLink() {
		AttachmentDocumentLinkType link = new AttachmentDocumentLinkType();
		DocumentRefType ref = new DocumentRefType();
		ref.setMasterID(UUID.randomUUID().toString());
		ref.setMaster("fakeMaster");
		ref.setTag("faketag");
		link.setDocumentId(ref);
		return link;
	}

	public static ResultContextType getSuccessServiceInformationList() {
		ResultContextType result = new ResultContextType();
		result.setGlobalStatus(StatusType.OK);
		ServiceInformationList serviceInfoList = new ServiceInformationList();
		ServiceInformationType serviceInfoType = new ServiceInformationType();
		serviceInfoType.setDgName("RDG");
		serviceInfoType.setITSystemName("ERIS");
		serviceInfoType.setServiceVersion("v4");
		StatusDetailList statusDetail = new StatusDetailList();
		StatusDetailType statusDetailType = new StatusDetailType();
		statusDetailType.setCode("");
		statusDetailType.setDescription("");
		statusDetailType.setDetailStatus(StatusType.OK);

		statusDetail.getStatusDetail().add(statusDetailType);
		serviceInfoType.setStatusDetailList(statusDetail);
		serviceInfoList.getServiceInformation().add(serviceInfoType);
		result.setServiceInformationList(serviceInfoList);
		return result;

	}

	public static CreateDocumentResponseWrapperType getCreateDocumentResponseWrapperType(CodeRefType documentType, List<DocumentMetaDataType> metadata,
			SendersRecipients sendersRecipients) {
		CreateDocumentResponseWrapperType result = new CreateDocumentResponseWrapperType();
		result.setHeader(new HeaderType());
		result.setResultContext(getSuccessServiceInformationList());
		result.setDocument(getFakeDocument(documentType, metadata, sendersRecipients));
		return result;
	}

	public static GetDocumentResponseWrapperType getDocumentResponseWrapperType() {
		GetDocumentResponseWrapperType response = new GetDocumentResponseWrapperType();
		response.setDocument(FakeXmlUtil.getFakeDocument(null, null, null));
		response.setHeader(new HeaderType());
		response.setResultContext(getSuccessServiceInformationList());
		return response;
	}

	public static GetDocumentHistoryResponseWrapperType getDocumentHistoryResponseWrapperType() {
		GetDocumentHistoryResponseWrapperType result = new GetDocumentHistoryResponseWrapperType();
		result.setResultContext(getSuccessServiceInformationList());
		DocumentList list = new DocumentList();
		result.setHeader(new HeaderType());
		list.getDocument().add(getFakeDocument(null, null, null));
		list.getDocument().add(getFakeDocument(null, null, null));
		result.setDocumentList(list);
		return result;
	}

	public static LinkAttachmentToDocumentResponseWrapperType getLinkAttachmentToDocumentResponseWrapperType() {
		LinkAttachmentToDocumentResponseWrapperType result = new LinkAttachmentToDocumentResponseWrapperType();
		AttachmentDocumentLinkType link = getFakeAttDocLink();
		result.setResultingLink(link);
		result.setHeader(new HeaderType());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	public static RegisterDocumentResponseWrapperType getRegisterDocumentResponseWrapperType() {
		RegisterDocumentResponseWrapperType result = new RegisterDocumentResponseWrapperType();
		result.setRegistrationDate(new Timestamp(System.currentTimeMillis()));
		result.setRegistrationNumber(FAKE_ARES_REF);
		result.setHeader(new HeaderType());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	public static RemoveDocumentAttachmentResponseWrapperType getRemoveDocumentAttachmentResponseWrapperType() {
		RemoveDocumentAttachmentResponseWrapperType result = new RemoveDocumentAttachmentResponseWrapperType();
		result.setResultContext(getSuccessServiceInformationList());
		result.setHeader(new HeaderType());
		return result;
	}

	public static SearchDocumentResponseWrapperType getSearchDocumentResponseWrapperType() {
		SearchDocumentResponseWrapperType result = new SearchDocumentResponseWrapperType();
		SearchDocumentResponseWrapperType.DocumentList list = new SearchDocumentResponseWrapperType.DocumentList();

		list.getDocument().add(getFakeDocument(null, null, null));
		list.getDocument().add(getFakeDocument(null, null, null));
		result.setDocumentList(list);
		result.setHeader(new HeaderType());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	public static StampDocumentResponseWrapperType getStampDocumentResponseWrapperType() {
		StampDocumentResponseWrapperType result = new StampDocumentResponseWrapperType();
		result.setNewAttachmentId(UUID.randomUUID().toString());
		result.setHeader(new HeaderType());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	public static SynchronizeDocumentResponseWrapperType getSynchronizeDocumentResponseWrapperType() {
		SynchronizeDocumentResponseWrapperType result = new SynchronizeDocumentResponseWrapperType();
		result.setDocument(FakeXmlUtil.getFakeDocument(null, null, null));
		result.setResultContext(getSuccessServiceInformationList());
		result.setHeader(new HeaderType());
		return result;
	}

	public static TagDocumentResponseWrapperType getTagDocumentResponseWrapperType() {
		TagDocumentResponseWrapperType result = new TagDocumentResponseWrapperType();
		result.setResultContext(getSuccessServiceInformationList());
		result.setHeader(new HeaderType());
		return result;
	}

	public static CopyZipAttachmentsToDocumentResponseWrapperType getCopyZipAttachmentsToDocumentResponseWrapperType() {
		CopyZipAttachmentsToDocumentResponseWrapperType result = new CopyZipAttachmentsToDocumentResponseWrapperType();
		AttachmentIdType atttype = new AttachmentIdType();
		atttype.setValue("123456789");
		result.setAttachmentId(atttype);
		result.setHeader(new HeaderType());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	public static NotarizeDocumentResponseWrapperType getNotarizeDocumentResponseWrapperType() {
		NotarizeDocumentResponseWrapperType result = new NotarizeDocumentResponseWrapperType();
		result.setHeader(new HeaderType());
		result.setResult(UUID.randomUUID().toString());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	public static CreateFileResponseWrapperType getCreateFileResponseWrapperType() {
		CreateFileResponseWrapperType result = new CreateFileResponseWrapperType();
		result.setHeader(new HeaderType());
		result.setFile(getLocalFileType());
		result.setResultContext(getSuccessServiceInformationList());
		return result;
	}

	private static LocalFileType getLocalFileType() {
		LocalFileType fileType = new LocalFileType();
		//TODO implement me
		return fileType;
	}

}
