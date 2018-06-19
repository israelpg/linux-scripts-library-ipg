package eu.europa.ec.rdg.eris.utils;

import eu.europa.ec.rdg.framework.cache.CacheManager;
import eu.europa.ec.rdg.framework.cache.SerializingCache;

/**
 * Caches which need to Serialize their data in order to avoid class cast exceptions.
 * <p/>
 * If multiple exercises use the same cache (either directly or through a shared library) and the class cached is from the application rather than the system
 * class loaded then a serializable cache is required. If a 'normal' cache is used you will get strange looking exceptions like:
 * <i>eu.europa.ec.rdg.sygma.domain.business.to.partner.HierarchyDataDetail cannot be cast to
 * eu.europa.ec.rdg.sygma.domain.business.to.partner.HierarchyDataDetail</i>
 * 
 * @author moodypa
 */
public enum SerializingCaches {

	/**
	 * ERIS caches
	 */
	ERIS_DOCUMENTS_BY_ID("SygmaErisDocumentsById", null, null),
	ERIS_DOCUMENTS_BY_ARES_REF("SygmaErisDocumentsByAresRef", null, null);

	private String cacheName;
	private Integer timeToLive;
	private CacheManager.evictionPolicy evictionPolicy;

	/**
	 * 
	 * @param cacheName Name of the cache as defined in ehcache.xml
	 * @param timeToLive If null, default value will be taken from default cache in ehcache.xml
	 * @param evictionPolicy If null, default value will be taken from default cache in ehcache.xml
	 */
	private SerializingCaches(String cacheName, Integer timeToLive, CacheManager.evictionPolicy evictionPolicy) {
		this.cacheName = cacheName;
	}

	@Override
	public String toString() {
		return cacheName;
	}

	public SerializingCache getCache() {
		return CacheManager.getInstance().getSerializingCache(this.cacheName, this.timeToLive, this.evictionPolicy);
	}
}
