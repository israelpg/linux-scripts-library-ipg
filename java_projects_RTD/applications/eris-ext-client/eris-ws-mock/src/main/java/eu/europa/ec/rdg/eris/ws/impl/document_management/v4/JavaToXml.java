package eu.europa.ec.rdg.eris.ws.impl.document_management.v4;

//TODO move to ejb module
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.Writer;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.sun.org.apache.xml.internal.serialize.OutputFormat;
import com.sun.org.apache.xml.internal.serialize.XMLSerializer;

public class JavaToXml {

	public JavaToXml() {

	}

	public static String toXml(Object t) {

		try {
			JAXBContext jc = JAXBContext.newInstance(t.getClass().getPackage().getName());

			Marshaller marshallerObj = jc.createMarshaller();
			marshallerObj.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

			JAXBElement<Object> je2 = new JAXBElement<Object>(new QName(t.getClass().getSimpleName()), (Class<Object>) t.getClass(), t);

			StringWriter writer = new StringWriter();
			marshallerObj.marshal(je2, writer);

			String r = writer.toString();
			return r;
		} catch (Exception e) {
			return e.getMessage();

		}
	}

	public static String format(String unformattedXml) {
		try {
			final Document document = parseXmlFile(unformattedXml);

			OutputFormat format = new OutputFormat(document);
			format.setLineWidth(65);
			format.setIndenting(true);
			format.setIndent(2);
			Writer out = new StringWriter();
			XMLSerializer serializer = new XMLSerializer(out, format);
			serializer.serialize(document);

			return out.toString();
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	private static Document parseXmlFile(String in) {
		try {
			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			DocumentBuilder db = dbf.newDocumentBuilder();
			InputSource is = new InputSource(new StringReader(in));
			return db.parse(is);
		} catch (ParserConfigurationException e) {
			throw new RuntimeException(e);
		} catch (SAXException e) {
			throw new RuntimeException(e);
		} catch (IOException e) {
			throw new RuntimeException(e);
		}
	}

	public static <T> T getXmlPart(String xml, Class<T> class_) throws JAXBException, SAXException {

		JAXBContext jc = JAXBContext.newInstance(class_);
		Unmarshaller u = jc.createUnmarshaller();
		@SuppressWarnings("unchecked")
		StreamSource source = new StreamSource(new ByteArrayInputStream(xml.getBytes()));
		JAXBElement<T> elem = (JAXBElement<T>) u.unmarshal(source, class_);
		return elem.getValue();

	}
}
