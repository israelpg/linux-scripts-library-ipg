
package eu.europa.ec.rdg.eris.attachmentcomparison.v1;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the eu.europa.ec.rdg.eris.attachmentcomparison.v1 package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _AttachmentComparisonRequest_QNAME = new QName("http://ec.europa.eu/rdg/eris/attachmentcomparison/V1", "AttachmentComparisonRequest");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: eu.europa.ec.rdg.eris.attachmentcomparison.v1
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link AttachmentComparisonRequestType }
     * 
     */
    public AttachmentComparisonRequestType createAttachmentComparisonRequestType() {
        return new AttachmentComparisonRequestType();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link AttachmentComparisonRequestType }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "http://ec.europa.eu/rdg/eris/attachmentcomparison/V1", name = "AttachmentComparisonRequest")
    public JAXBElement<AttachmentComparisonRequestType> createAttachmentComparisonRequest(AttachmentComparisonRequestType value) {
        return new JAXBElement<AttachmentComparisonRequestType>(_AttachmentComparisonRequest_QNAME, AttachmentComparisonRequestType.class, null, value);
    }

}
