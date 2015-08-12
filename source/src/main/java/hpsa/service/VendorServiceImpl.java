package hpsa.service;

import hpsa.persist.entity.Vendor;
import hpsa.persist.repository.VendorRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class VendorServiceImpl implements VendorService {

	@Autowired
	private VendorRepository vendorRepository;

	@Override
	public Iterable<Vendor> findAll() {
		return vendorRepository.findAll();
	}

	@Override
	public Vendor save(Vendor vendor) {
		return vendorRepository.save(vendor);
	}

	@Override
	public Vendor find(Vendor vendor) {
		return vendorRepository.findFirstByIdOrName(vendor.getId(), vendor.getName());
	}

}
