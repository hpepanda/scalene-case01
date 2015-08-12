package hpsa.service;

import hpsa.persist.entity.Vendor;

public interface VendorService {

	public Iterable<Vendor> findAll();

	public Vendor find(Vendor vendor);

	public Vendor save(Vendor vendor);

}
