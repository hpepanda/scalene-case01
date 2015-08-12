package hpsa.persist.repository;

import hpsa.persist.entity.Receipt;

import org.springframework.data.repository.PagingAndSortingRepository;

public interface ReceiptRepository extends PagingAndSortingRepository<Receipt, Long> {

}
