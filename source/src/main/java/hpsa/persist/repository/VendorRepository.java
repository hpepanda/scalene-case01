package hpsa.persist.repository;

import hpsa.persist.entity.Vendor;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface VendorRepository extends PagingAndSortingRepository<Vendor, Long> {

	public Vendor findFirstByIdOrName(Long id, String name);

}
