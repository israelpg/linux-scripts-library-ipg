package eu.europa.ec.rdg.eris.ws.impl.document_management.v5;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.SchemaOutputResolver;
import javax.xml.bind.Unmarshaller;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.apache.log4j.Logger;
import org.xml.sax.SAXException;

public abstract class MockXmlFileLoader {

	private static final Logger LOGGER = Logger.getLogger(MockXmlFileLoader.class);

	public abstract String getMockXmlPath();

	public File getAbsolutePath(String fileName) throws URISyntaxException {
		URL xmlPathUrl = MockXmlFileLoader.class.getClassLoader().getResource(getMockXmlPath());
		return new File(new File(xmlPathUrl.toURI()), fileName);
	}

	/**
	 * Convention: file will be searched using <code>typeClass.getSimpleName()</code> + <code>suffix</code> XML file
	 * 
	 * @param typeClass
	 * @param classesToBeBound
	 * @return
	 */
	public <T> T getType(Class<T> typeClass, String suffix, Class<?>... classesToBeBound) throws IOException, JAXBException, SAXException, URISyntaxException {
		Unmarshaller unmarshaller = getUnmarshaller(true, classesToBeBound);

		return getType(typeClass, suffix, unmarshaller);
	}

	public <T> List<T> getTypes(Class<T> typeClass, Class<?>... classesToBeBound) throws IOException, JAXBException, SAXException, URISyntaxException {
		List<T> types = new ArrayList<T>();

		URL xmlPathUrl = MockXmlFileLoader.class.getClassLoader().getResource(getMockXmlPath());
		File xmlPathFile = new File(xmlPathUrl.toURI());
		File[] xmlChildFiles = xmlPathFile.listFiles();

		Unmarshaller unmarshaller = getUnmarshaller(true, classesToBeBound);

		for (File xmlChildFile : xmlChildFiles) {
			String name = xmlChildFile.getName();
			if (name.startsWith(typeClass.getSimpleName()) && name.endsWith(".xml")) {
				String suffix = name.substring(typeClass.getSimpleName().length(), name.lastIndexOf(".xml"));
				try {
					T type = getType(typeClass, suffix, unmarshaller);
					types.add(type);
				} catch (IOException | JAXBException | SAXException | URISyntaxException | RuntimeException e) {
					LOGGER.error("problem with file: " + name, e);
					throw e;
				}

			}
		}

		return types;
	}

	/*
	 * TODO: Remove the validate parameter when all the XML types will be valid
	 */
	@Deprecated
	public <T> T getTypeFromXml(Class<T> typeClass, String xml, boolean validate, Class<?>... classesToBeBound) throws IOException, JAXBException,
			SAXException, URISyntaxException {
		return getUnmarshaller(validate, classesToBeBound).unmarshal(new StreamSource(new StringReader(xml)), typeClass).getValue();
	}

	public <T> void setType(Class<T> typeClass, Object jaxbElement, String suffix, Class<?>... classesToBeBound) throws IOException, JAXBException,
			SAXException, URISyntaxException {
		getMarshaller(classesToBeBound).marshal(jaxbElement, getAbsolutePath(typeClass.getSimpleName() + suffix + ".xml"));
	}

	private <T> T getType(Class<T> typeClass, String suffix, Unmarshaller unmarshaller) throws IOException, JAXBException, SAXException, URISyntaxException {
		InputStream inputStream = null;
		try {
			String resource = getMockXmlPath() + "/" + typeClass.getSimpleName() + suffix + ".xml";
			inputStream = MockXmlFileLoader.class.getClassLoader().getResourceAsStream(resource);
			if (inputStream == null) {
				return null;
			}
			Source source = new StreamSource(inputStream);
			return unmarshaller.unmarshal(source, typeClass).getValue();

		} finally {
			if (inputStream != null) {
				try {
					inputStream.close();
				} catch (IOException ignore) {
				}
			}
		}
	}

	private Marshaller getMarshaller(Class<?>... classesToBeBound) throws IOException, JAXBException, SAXException, URISyntaxException {
		JAXBContext context = JAXBContext.newInstance(classesToBeBound);
		Schema schema = generateSchema(context);

		Marshaller marshaller = context.createMarshaller();
		marshaller.setSchema(schema);
		marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
		return marshaller;
	}

	/*
	 * TODO: Remove the validate parameter when all the XML types will be valid
	 */
	@Deprecated
	private Unmarshaller getUnmarshaller(boolean validate, Class<?>... classesToBeBound) throws IOException, JAXBException, SAXException, URISyntaxException {
		JAXBContext context = JAXBContext.newInstance(classesToBeBound);
		Unmarshaller unmarshaller = context.createUnmarshaller();

		if (validate) {
			Schema schema = generateSchema(context);
			unmarshaller.setSchema(schema);
		}
		return unmarshaller;
	}

	private Schema generateSchema(JAXBContext context) throws IOException, JAXBException, SAXException, URISyntaxException {
		final List<String> namespaceUris = new ArrayList<String>();
		final Map<String, String> fileNames = new HashMap<String, String>();
		final Map<String, ByteArrayOutputStream> outputStreams = new HashMap<String, ByteArrayOutputStream>();

		context.generateSchema(new SchemaOutputResolver() {
			@Override
			public Result createOutput(String namespaceUri, String suggestedFileName) throws IOException {
				namespaceUris.add(namespaceUri);
				fileNames.put(namespaceUri, suggestedFileName);
				outputStreams.put(namespaceUri, new ByteArrayOutputStream());

				StreamResult result = new StreamResult(outputStreams.get(namespaceUri));
				result.setSystemId(suggestedFileName);
				return result;
			}
		});

		SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		List<Source> sources = new ArrayList<Source>();
		for (int i = 0; i < namespaceUris.size(); i++) {
			byte[] bytes = outputStreams.get(namespaceUris.get(i)).toByteArray();
			// Print the XSD, could be useful
			if (LOGGER.isTraceEnabled()) {
				LOGGER.trace("******************** " + fileNames.get(namespaceUris.get(i)) + " ********************");
				LOGGER.trace(new String(bytes));
				writeSchemaFileForDebug(fileNames.get(namespaceUris.get(i)), bytes);
			}
			Source source = new StreamSource(new ByteArrayInputStream(bytes));
			source.setSystemId(fileNames.get(namespaceUris.get(i)));
			sources.add(source);
		}

		/*
		 * Found no better way to sort the XSD files but using the import TAG with the file name
		 */
		boolean sorted = false;
		while (!sorted) {
			sorted = true;
			for (int i = 0; i < sources.size() - 1; i++) {
				Source source = sources.get(i);
				for (int j = i + 1; j < sources.size(); j++) {
					Source nextSource = sources.get(j);
					if (depends(source, nextSource, fileNames, outputStreams)) {
						sources.set(i, nextSource);
						sources.set(j, source);
						sorted = false;
						break;
					}
				}
			}
		}

		if (LOGGER.isTraceEnabled()) {
			StringBuilder stringBuilder = new StringBuilder("XSD Order :");
			for (Source source : sources) {
				stringBuilder.append(" " + source.getSystemId());
			}
			LOGGER.trace(stringBuilder.toString());
		}

		Schema schema = schemaFactory.newSchema(sources.toArray(new Source[0]));
		return schema;
	}

	private boolean depends(Source source, Source nextSource, final Map<String, String> fileNames, final Map<String, ByteArrayOutputStream> outputStreams) {
		String systemId = source.getSystemId(), nextSystemId = nextSource.getSystemId();
		String namespaceUri = getKeyForValue(fileNames, systemId);
		String content = outputStreams.get(namespaceUri).toString();

		if (content.contains("schemaLocation=\"" + nextSystemId + "\"")) {
			LOGGER.trace(systemId + " depends on " + nextSystemId);
			return true;
		}
		return false;
	}

	// No API for this kind of operation already in Collections framework ???
	private <K, V> K getKeyForValue(Map<K, V> map, V v) {
		for (Map.Entry<K, V> entry : map.entrySet()) {
			if (entry.getValue().equals(v)) {
				return entry.getKey();
			}
		}
		return null;
	}

	/**
	 * File are written in the same directory from where the mock files are loaded. This can be helpful to validate the XML.
	 * 
	 * @param fileName
	 * @param content
	 * @throws IOException
	 * @throws URISyntaxException
	 */
	private void writeSchemaFileForDebug(String fileName, byte[] content) throws IOException, URISyntaxException {
		File xsdFile = getAbsolutePath(fileName);

		BufferedOutputStream bufferedOutputStream = null;
		try {
			bufferedOutputStream = new BufferedOutputStream(new FileOutputStream(xsdFile));
			bufferedOutputStream.write(content);
			bufferedOutputStream.flush();
			bufferedOutputStream.close();
		} finally {
			if (bufferedOutputStream != null) {
				try {
					bufferedOutputStream.close();
				} catch (IOException ignore) {
				}
			}
		}
	}
}
