
package eu.europa.ec.rdg.eris.attachmentcomparison.v1;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;
import eu.europa.ec.research.fp.model.document.v5.DocumentAttachmentRefType;


/**
 * <p>Java class for AttachmentComparisonRequestType complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType name="AttachmentComparisonRequestType">
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="FirstAttachmentRef" type="{http://ec.europa.eu/research/fp/model/document/V5}DocumentAttachmentRefType"/>
 *         &lt;element name="SecondAttachmentRef" type="{http://ec.europa.eu/research/fp/model/document/V5}DocumentAttachmentRefType"/>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "AttachmentComparisonRequestType", propOrder = {
    "firstAttachmentRef",
    "secondAttachmentRef"
})
public class AttachmentComparisonRequestType {

    @XmlElement(name = "FirstAttachmentRef", required = true)
    protected DocumentAttachmentRefType firstAttachmentRef;
    @XmlElement(name = "SecondAttachmentRef", required = true)
    protected DocumentAttachmentRefType secondAttachmentRef;

    /**
     * Gets the value of the firstAttachmentRef property.
     * 
     * @return
     *     possible object is
     *     {@link DocumentAttachmentRefType }
     *     
     */
    public DocumentAttachmentRefType getFirstAttachmentRef() {
        return firstAttachmentRef;
    }

    /**
     * Sets the value of the firstAttachmentRef property.
     * 
     * @param value
     *     allowed object is
     *     {@link DocumentAttachmentRefType }
     *     
     */
    public void setFirstAttachmentRef(DocumentAttachmentRefType value) {
        this.firstAttachmentRef = value;
    }

    /**
     * Gets the value of the secondAttachmentRef property.
     * 
     * @return
     *     possible object is
     *     {@link DocumentAttachmentRefType }
     *     
     */
    public DocumentAttachmentRefType getSecondAttachmentRef() {
        return secondAttachmentRef;
    }

    /**
     * Sets the value of the secondAttachmentRef property.
     * 
     * @param value
     *     allowed object is
     *     {@link DocumentAttachmentRefType }
     *     
     */
    public void setSecondAttachmentRef(DocumentAttachmentRefType value) {
        this.secondAttachmentRef = value;
    }

}
