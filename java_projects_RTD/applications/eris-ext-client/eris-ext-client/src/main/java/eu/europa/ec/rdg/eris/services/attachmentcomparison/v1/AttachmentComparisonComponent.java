package eu.europa.ec.rdg.eris.services.attachmentcomparison.v1;


public class AttachmentComparisonComponent {

	public AttachmentComparisonComponent() {
	}

	public IErisAttachmentComparisonClient getAttachmentComparisonClient(String baseUrl) {
		return new ErisAttachmentComparisonClientImpl(baseUrl);
	}

}
